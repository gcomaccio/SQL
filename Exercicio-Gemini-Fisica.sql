CREATE DATABASE IF NOT EXISTS fisica;

USE fisica;

CREATE TABLE lancamentos (
    id_lancamento INT PRIMARY KEY AUTO_INCREMENT,
    objeto VARCHAR(100) NOT NULL,
    massa_kg FLOAT NOT NULL,
    velocidade_ms FLOAT NOT NULL,
    altura_m FLOAT NOT NULL        
);

CREATE TABLE experimentos (
    id_exp INT PRIMARY KEY AUTO_INCREMENT,
    id_lancamento INT,
    nome_experimento VARCHAR(100) NOT NULL,
    temp_celsius FLOAT NOT NULL,
    distancia_m FLOAT NOT NULL,
    tempo_s FLOAT NOT NULL,
    FOREIGN KEY (id_lancamento) REFERENCES lancamentos(id_lancamento)
);

INSERT INTO lancamentos (objeto, massa_kg, velocidade_ms, altura_m) VALUES
('Bola de Futebol', 0.45, 20.0, 2.5),
('Pedra', 1.20, 15.0, 10.0),
('Dardo', 0.05, 35.0, 1.8),
('Bala de Cahão', 5.00, 50.0, 0.0),
('Pena', 0.005, 2.0, 15.0);

INSERT INTO experimentos (nome_experimento, temp_celsius, distancia_m, tempo_s) VALUES
('Medição de Velocidade do Som', 25.0, 340.0, 1.0),
('Carrinho de Carga A', 20.0, 150.0, 5.0),
('Gota em Queda Livre', 18.5, 45.0, 3.0),
('Carrinho de Carga B', 22.0, 200.0, 4.0);


SELECT objeto, (0.50 *massa_kg * POWER(velocidade_ms,2)) AS energia_cinetica_joules
FROM lancamentos
ORDER BY energia_cinetica_joules desc
;

SELECT nome_experimento, temp_celsius, temp_celsius + 273.15 AS temp_kelvin, (temp_celsius * 9/5) + 32 AS temp_ferenheit
FROM experimentos
WHERE temp_celsius > 20;

SELECT  nome_experimento, distancia_m/tempo_s AS velocidade_ms,
(distancia_m/tempo_s) * 3.6 AS velocidade_kmh
FROM experimentos;

-- 1
SELECT COUNT(*) AS total_objetos, AVG( massa_kg) AS media_massa_kg, AVG(velocidade_ms) AS media_velocidade_ms
FROM lancamentos;

-- 2
SELECT SUM(distancia_m) AS distancia_total_m,AVG(tempo_s) AS tempo_medio_s
FROM experimentos
WHERE nome_experimento LIKE '%Carrinho%';

-- 3
/*Lançamentos com altura_m > 0 (lançados no ar)

Lançamentos com altura_m = 0 (no nível do solo)
*/
SELECT altura_m, COUNT(*) AS qtd_lancamentos, MAX(velocidade_ms) AS velocidade_maxima
FROM lancamentos
GROUP BY altura_m;

SELECT objeto, altura_m, tempo_s
FROM lancamentos
LEFT JOIN experimentos
	ON lancamentos.id_lancamento = experimentos.id_lancamento;
