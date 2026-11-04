CREATE DATABASE IF NOT EXISTS  SqlBolt;
USE SqlBolt;

CREATE TABLE IF NOT EXISTS filmes_pixar (
    id INT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    diretor VARCHAR(100) NOT NULL,
    ano INT NOT NULL,
    length_minutes INT NOT NULL
);

CREATE TABLE IF NOT EXISTS cidades_norte_americanas(
	id INT PRIMARY KEY AUTO_INCREMENT,
    cidade VARCHAR(150) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    populacao INT NOT NULL,
    latitude INT NOT NULL,
    longitude INT NOT NULL
);


CREATE TABLE IF NOT EXISTS bilheteria(
	id_filme INT PRIMARY KEY AUTO_INCREMENT,
    classificacao FLOAT NOT NULL,
    vendas_nativas INT NOT NULL,
    vendas_globais INT NOT NULL
);

CREATE TABLE IF NOT EXISTS edificios(
	nome_edificio VARCHAR(150) NOT NULL,
    capacidade INT unsigned NOT NULL
);

CREATE TABLE IF NOT EXISTS funcionarios(
	funcao VARCHAR(100) NOT NULL,
    nome_func VARCHAR(150) NOT NULL,
    edificio VARCHAR(150) NOT NULL, 
    anos_empregado INT UNSIGNED NOT NULL
);

INSERT INTO cidades_norte_americanas(id, cidade, pais, populacao, latitude, longitude) VALUES
(1, 'Guadalajara', 'México', '15800', '20.659699', '-103.349609'),
(2, 'Toronto', 'Canadá', '2795060', '43.653226', '-79.383184'),
(3, 'Houston', 'Estados Unidos', '2195914', '29.760427', '-95.369803'),
(4, 'Nova York', 'Estados Unidos', '8405837', '40.712784', '-74.005941'),
(5, 'Filadélfia', 'Estados Unidos', '1553165', '39.952584', '-75.165222'),
(6, 'Havana', 'Cuba', '	2106146', '23.05407', '-82.345189'),
(7, 'Cidade do México', 'México', '8555500', '19.432608', '-99.133208'),
(8, 'Phoenix', 'Estados Unidos', '1513367', '33.448377', '-112.074037'),
(9, 'Los Angeles', 'Estados Unidos', '3884307', '34.052234', '-118.243685'),
(10, 'Ecatepec de Morelos', 'México', '1742000', '19.601841', '-99.050674'),
(11, 'Montreal', 'Canadá', '1717767', '45.501689', '-73.567256'),
(12, 'Chicago', 'Estados Unidos', '2718782', '41.878114', '-87.629798');

-- Limpa a tabela para que o script possa ser executado novamente sem duplicar IDs.
DELETE FROM filmes_pixar;

INSERT INTO filmes_pixar (id, titulo, diretor, ano, length_minutes) VALUES
    (1, 'Toy Story', 'John Lasseter', 1995, 81),
    (2, 'A Vida de um Inseto', 'John Lasseter', 1998, 95),
    (3, 'Toy Story 2', 'John Lasseter', 1999, 93),
    (4, 'Monsters, Inc.', 'Pete Docter', 2001, 92),
    (5, 'Procurando Nemo', 'Andrew Stanton', 2003, 107),
    (6, 'Os Incríveis', 'Brad Bird', 2004, 116),
    (7, 'Carros', 'John Lasseter', 2006, 117),
    (8, 'Ratatouille', 'Brad Bird', 2007, 115),
    (9, 'WALL-E', 'Andrew Stanton', 2008, 104),
    (10, 'Para cima', 'Pete Docter', 2009, 101),
    (11, 'Toy Story 3', 'Lee Unkrich', 2010, 103),
    (12, 'Carros 2', 'John Lasseter', 2011, 120),
    (13, 'Corajoso', 'Brenda Chapman', 2012, 102),
    (14, 'Universidade Monstros', 'Dan Scanlon', 2013, 110);
    
INSERT INTO bilheteria (id_filme, classificacao, vendas_nativas, vendas_globais) VALUES
(1, 8.3, 191796233, 170162503),
(2, 7.2, 162798565, 200600000),
(3, 7.9, 245852179, 239163000),
(4, 8.1, 289916256, 272900000),
(5, 8.2, 380843261, 555900000),
(6, 8, 261441092, 370001000),
(7, 7.2, 244082982, 217900167),
(8, 8, 206445654, 417277164),
(9, 8.5, 223808164, 297503696),
(10, 8.3, 293004164, 438338580),
(11, 8.4, 415004880, 648167031),
(12, 6.4, 191452396, 368400000),
(13, 7.2, 237283207, 301700000),
(14, 7.4, 268492764, 475066843);

INSERT INTO edificios (nome_edificio, capacidade) VALUES
('1ª edição', 24),
('1w', 32),
('2e', 16),
('2w', 20);

INSERT INTO funcionarios (funcao, nome_func, edificio, anos_empregado) VALUES
('Engenheiro', 'Becky A.', '1ª edição', 4),
('Engenheiro', 'Dan B.', '1ª edição', 2),
('Engenheiro', 'Sharon F.', '1ª edição', 6),
('Engenheiro', 'Dan M.', '1ª edição', 4),
('Engenheiro', 'Malcolm S.', '1ª edição', 1),
('Artista', 'Tylar S.', '2w', 2),
('Artista', 'Sherman D.', '2w', 8),
('Artista', 'Jakob J.', '2w', 6),
('Artista', 'Lillia A.', '2w', 7),
('Artista', 'Brandon J.', '2w', 7),
('Técnico', 'Scott K.', '1ª edição', 9),
('Técnico', 'Shirlee M.', '1ª edição', 3),
('Técnico', 'Daria O.', '2w', 6);

SELECT titulo
FROM filmes_pixar
ORDER BY titulo asc
limit 5 OFFSET 5;

SELECT *
FROM bilheteria;

SELECT titulo, vendas_nativas, vendas_globais
FROM filmes_pixar
INNER JOIN bilheteria
	ON filmes_pixar.id = bilheteria.id_filme
WHERE vendas_globais > vendas_nativas;

SELECT titulo, classificacao
FROM filmes_pixar
INNER JOIN bilheteria
	ON filmes_pixar.id = bilheteria.id_filme
ORDER BY classificacao desc;

SELECT DISTINCT *
FROM edificios;

SELECT DISTINCT edificio, funcao
FROM edificios
LEFT JOIN funcionarios
	ON nome_edificio = edificio;

SELECT edificio, funcao
FROM funcionarios
WHERE funcao IS NULL;

INSERT INTO funcionarios (funcao, nome_func, edificio, anos_empregado) VALUES
('Engenheiro', 'Yancy I.', '', 0),
('Artista', 'Oliver P.', '', 0);

SELECT *
FROM funcionarios;

SELECT nome_func, funcao, edificio
FROM funcionarios
WHERE edificio = '';

SET SQL_SAFE_UPDATES = 1;

DELETE FROM funcionarios
WHERE anos_empregado = 0;

SELECT DISTINCT nome_edificio
FROM edificios
RIGHT JOIN funcionarios
	ON nome_edificio = edificio
WHERE funcao IS NULL;
-- Apagando as tabelas antigas para recriar com a estrutura correta