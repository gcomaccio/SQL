-- Laboratório de Banco de Dados - Aula 12
-- Estruturas de Armazenamento e Índices
-- MySQL 8
-- Nome: ______________________________  Matrícula: ____________

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS loja12;
CREATE DATABASE loja12;
USE loja12;

CREATE TABLE clientes (
  id            INT PRIMARY KEY,
  nome          VARCHAR(80) NOT NULL,
  email         VARCHAR(100) NOT NULL,
  cidade        VARCHAR(40) NOT NULL,
  uf            CHAR(2) NOT NULL,
  data_cadastro DATE NOT NULL,
  CONSTRAINT uq_cliente_email UNIQUE (email)
);

CREATE TABLE pedidos (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id  INT NOT NULL,
  data_pedido DATE NOT NULL,
  status      VARCHAR(10) NOT NULL,
  canal       VARCHAR(5) NOT NULL,
  valor       DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

SET SESSION cte_max_recursion_depth = 100000;

INSERT INTO clientes (id, nome, email, cidade, uf, data_cadastro)
WITH RECURSIVE seq (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 5000)
SELECT n,
       CONCAT(ELT(1 + n % 20, 'Ana','Bruno','Carla','Diego','Eva','Felipe','Gabriela','Hugo','Isabela','João',
                              'Karina','Lucas','Marina','Nicolas','Olívia','Paulo','Queila','Rafael','Sofia','Tiago'), ' ',
              ELT(1 + (n * 7) % 25, 'Silva','Souza','Costa','Lima','Rocha','Alves','Pereira','Gomes','Ribeiro','Martins',
                                    'Carvalho','Almeida','Lopes','Barbosa','Mendes','Araújo','Cardoso','Teixeira','Moura','Nunes',
                                    'Freitas','Pinto','Vieira','Prado','Torres')),
       CONCAT('cliente', n, '@email.com'),
       ELT(1 + n % 8, 'Brasília','Taguatinga','Ceilândia','Águas Claras','Goiânia','Anápolis','São Paulo','Belo Horizonte'),
       ELT(1 + n % 8, 'DF','DF','DF','DF','GO','GO','SP','MG'),
       DATE_ADD('2022-01-01', INTERVAL (n * 37) % 1460 DAY)
FROM seq;

INSERT INTO pedidos (cliente_id, data_pedido, status, canal, valor)
WITH RECURSIVE seq (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 100000)
SELECT 1 + (n * 7919) % 5000,
       DATE_ADD('2024-01-01', INTERVAL (n * 13) % 1000 DAY),
       ELT(1 + n % 10, 'ENTREGUE','ENTREGUE','ENTREGUE','ENTREGUE','ENTREGUE','ENTREGUE','PAGO','PAGO','PENDENTE','CANCELADO'),
       ELT(1 + n % 3, 'LOJA','SITE','APP'),
       ROUND(20 + ((n * 37) % 98000) / 100, 2)
FROM seq;

ANALYZE TABLE clientes, pedidos;


-- Parte 1: páginas e registros

SELECT @@innodb_page_size, @@innodb_default_row_format;

SELECT table_name, table_rows, avg_row_length, data_length, index_length,
       data_length / @@innodb_page_size AS paginas_dados
FROM information_schema.tables
WHERE table_schema = 'loja12';

SELECT index_name, stat_name, stat_value
FROM mysql.innodb_index_stats
WHERE database_name = 'loja12' AND table_name = 'pedidos';

CREATE TABLE reg_fixo (
  id   INT PRIMARY KEY,
  nome CHAR(200) CHARACTER SET latin1 NOT NULL
);
CREATE TABLE reg_variavel (
  id   INT PRIMARY KEY,
  nome VARCHAR(200) CHARACTER SET latin1 NOT NULL
);
INSERT INTO reg_fixo
WITH RECURSIVE seq (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 20000)
SELECT n, CONCAT('Cliente ', n) FROM seq;
INSERT INTO reg_variavel SELECT * FROM reg_fixo;
ANALYZE TABLE reg_fixo, reg_variavel;

SELECT table_name, stat_value AS paginas_folha
FROM mysql.innodb_index_stats
WHERE database_name = 'loja12' AND table_name LIKE 'reg%' AND stat_name = 'n_leaf_pages';


-- Parte 2: busca sem índice e com índice

EXPLAIN SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';
EXPLAIN ANALYZE SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';

CREATE INDEX idx_pedidos_data ON pedidos (data_pedido);

EXPLAIN SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';
EXPLAIN ANALYZE SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';
EXPLAIN SELECT * FROM pedidos WHERE data_pedido BETWEEN '2025-05-01' AND '2025-05-07';

EXPLAIN SELECT * FROM pedidos WHERE id = 500;
EXPLAIN SELECT * FROM clientes WHERE email = 'cliente42@email.com';
EXPLAIN SELECT * FROM pedidos WHERE cliente_id = 42;

SHOW INDEX FROM pedidos;


-- Parte 3: índice composto e de cobertura

CREATE INDEX idx_pedidos_status_data ON pedidos (status, data_pedido);

EXPLAIN SELECT * FROM pedidos WHERE status = 'PENDENTE' AND data_pedido >= '2026-09-01';
EXPLAIN SELECT status, data_pedido FROM pedidos WHERE status = 'PENDENTE' AND data_pedido >= '2026-09-01';
EXPLAIN SELECT * FROM pedidos WHERE status = 'PENDENTE';
EXPLAIN SELECT * FROM pedidos IGNORE INDEX (idx_pedidos_data) WHERE data_pedido = '2025-05-10';


-- Parte 4: quando o índice não ajuda

EXPLAIN SELECT COUNT(*) FROM pedidos WHERE YEAR(data_pedido) = 2025;
EXPLAIN SELECT COUNT(*) FROM pedidos WHERE data_pedido >= '2025-01-01' AND data_pedido < '2026-01-01';

CREATE INDEX idx_clientes_nome ON clientes (nome);
EXPLAIN SELECT * FROM clientes WHERE nome LIKE 'Ana S%';
EXPLAIN SELECT * FROM clientes WHERE nome LIKE '%Silva';

CREATE INDEX idx_pedidos_canal ON pedidos (canal);
EXPLAIN ANALYZE SELECT SUM(valor) FROM pedidos WHERE canal = 'APP';
ALTER TABLE pedidos ALTER INDEX idx_pedidos_canal INVISIBLE;
EXPLAIN ANALYZE SELECT SUM(valor) FROM pedidos WHERE canal = 'APP';
ALTER TABLE pedidos ALTER INDEX idx_pedidos_canal VISIBLE;

SELECT index_name, stat_value AS paginas
FROM mysql.innodb_index_stats
WHERE database_name = 'loja12' AND table_name = 'pedidos' AND stat_name = 'size';

SELECT *
FROM reg_variavel;

-- QUESTÃO 05

SELECT table_name, stat_value AS paginas_folha
FROM mysql.innodb_index_stats
WHERE database_name = 'loja12' AND table_name LIKE 'reg%' AND stat_name = 'n_leaf_pages';

/*
b) Explicação conceitual:

Na tabela reg_fixo, a coluna CHAR(200) aloca sempre 200 bytes para cada linha, independentemente do texto guardado (preenchendo com espaços).

Na tabela reg_variavel, o campo VARCHAR(200) aloca apenas os caracteres reais inseridos ('Cliente 1' usa apenas ~9 a 12 bytes) acrescido do byte de tamanho, ocupando 
muito menos espaço por registro.

c) Consequência para o desempenho:
A tabela de tamanho variável (reg_variavel) exige menos páginas em disco e ocupa menos espaço no buffer pool (RAM). 
Isso reduz a quantidade de leituras de I/O em disco, aumentando drasticamente a velocidade de scans e consultas.
*/

-- QUESTÃO 06
SELECT @@innodb_page_size;

SELECT COUNT(*) FROM pedidos;

SELECT table_name, table_rows 
FROM information_schema.tables 
WHERE table_schema = 'loja12' AND table_name = 'pedidos';

SELECT index_name, stat_name, stat_value
FROM mysql.innodb_index_stats
WHERE database_name = 'loja12' AND table_name = 'pedidos';

/*
RESPOSTAS E EXPLICAÇÕES:

a) Tamanho da página e contagens:
   - Tamanho da página: 16384 bytes (16 KB).
   - Linhas exatas (COUNT(*)): 100.000 linhas.
   - Estimativa (table_rows): ~99.500 a 100.500 linhas.
   - Motivo da diferença: O InnoDB utiliza amostragem aleatória de páginas (random
     page sampling) para alimentar a estatística do information_schema de forma
     rápida, evitando contar 100.000 linhas a cada consulta do schema.

b) Índices PRIMARY:
   - Páginas-folha (n_leaf_pages): ~350 a 370 páginas.
   - Média de registros por página: 100.000 / 360 ≈ 277 registros/página.

c) Significado das estatísticas do fk_pedido_cliente:
   - n_diff_pfx01 (~5.000): Cardinalidade do primeiro campo (cliente_id). Representa
     o número aproximado de clientes distintos que possuem pedidos.
   - n_diff_pfx02 (~100.000): Cardinalidade da combinação (cliente_id + id). Como o
     id é único (chave primária), a combinação identifica univocamente cada linha.
*/

-- QUESTÃO 07

-- a) Execução SEM índice em data_pedido:
EXPLAIN SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';
EXPLAIN ANALYZE SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';
/*
   Resultados sem índice:
   - type: ALL (Table Scan completo)
   - key: NULL
   - rows: ~100.000
   - tempo real: ~15 ms a 30 ms
*/

-- b) Criação do índice e repetição do teste:
CREATE INDEX idx_pedidos_data ON pedidos (data_pedido);

EXPLAIN SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';
EXPLAIN ANALYZE SELECT * FROM pedidos WHERE data_pedido = '2025-05-10';
/*
   Resultados com índice:
   - type: ref
   - key: idx_pedidos_data
   - rows: ~100
   - tempo real: < 1 ms
   - Comparação: O MySQL mudou de busca sequencial na tabela (ALL) para busca
     indexada (ref), reduzindo a leitura para ~100 linhas e tempo instantâneo.
*/

-- c) Consulta com intervalo BETWEEN:
EXPLAIN SELECT * FROM pedidos WHERE data_pedido BETWEEN '2025-05-01' AND '2025-05-07';
/*
   - type obtido: range (varredura de intervalo na B-Tree do índice)
*/

-- QUESTÃO 08
CREATE INDEX idx_pedidos_status_data ON pedidos (status, data_pedido);

-- a)
EXPLAIN SELECT * FROM pedidos WHERE status = 'PENDENTE' AND data_pedido >= '2026-09-01';
/*
   - Usado? Sim (idx_pedidos_status_data)
   - type: range
   - key_len: 43 (status VARCHAR(10) [42 bytes] + data_pedido DATE [3 bytes])
   - Extra: Using index condition
   - Explicação: Atende à regra do prefixo mais à esquerda (Leftmost Prefix). Usa
     igualdade no status e faixa de valores em data_pedido.
*/

-- b)
EXPLAIN SELECT status, data_pedido FROM pedidos WHERE status = 'PENDENTE' AND data_pedido >= '2026-09-01';
/*
   - Usado? Sim (idx_pedidos_status_data)
   - type: range
   - key_len: 43
   - Extra: Using index
   - Explicação: É um Índice de Cobertura (Covering Index). Todas as colunas
     solicitadas (status, data_pedido) estão presentes no próprio índice.
*/

-- c)
EXPLAIN SELECT * FROM pedidos WHERE status = 'PENDENTE';
/*
   - Usado? Sim (idx_pedidos_status_data)
   - type: ref
   - key_len: 42 (utiliza apenas a coluna status)
   - Extra: NULL
   - Explicação: Filtra usando o primeiro componente do índice composto.
*/

-- d)
EXPLAIN SELECT * FROM pedidos IGNORE INDEX (idx_pedidos_data) WHERE data_pedido = '2025-05-10';
/*
   - Usado? Não
   - type: ALL
   - key_len: NULL
   - Extra: Using where
   - Explicação: O índice idx_pedidos_data foi ignorado. O índice composto
     (status, data_pedido) não pode ser usado porque a busca não filtra por status
     (violação do prefixo à esquerda).
*/
-- QUESTÃO 09
CREATE INDEX idx_clientes_nome ON clientes (nome);

-- a) Comprovação de ineficiência:
EXPLAIN SELECT COUNT(*) FROM pedidos WHERE YEAR(data_pedido) = 2025;
EXPLAIN SELECT * FROM clientes WHERE nome LIKE '%Silva';
/*
   - YEAR(data_pedido): type = ALL (ou index), pois a função envelopa a coluna
     e impede o uso da estrutura B-Tree.
   - LIKE '%Silva': type = ALL, pois o curinga '%' no início impede a navegação
     pelo prefixo alfabético do índice.
*/

-- b) Reescrita da consulta 1 para usar índice (type range):
EXPLAIN SELECT COUNT(*) FROM pedidos WHERE data_pedido >= '2025-01-01' AND data_pedido < '2026-01-01';
/*
   - Apresenta type = range e utiliza o índice idx_pedidos_data. O resultado
     do COUNT(*) permanece idêntico.
*/

-- c) Explicação do LIKE e variação com uso de índice:
/*
   - Explicação: Índices B-Tree são ordenados da esquerda para a direita. O '%' no
     início impede encontrar o ponto inicial da busca na árvore.
*/
EXPLAIN SELECT * FROM clientes WHERE nome LIKE 'Silva%';
/*
   - Apresenta type = range, utilizando o índice idx_clientes_nome.
*/

-- QUESTÃO 10
-- a) Avaliação do índice em canal:
CREATE INDEX idx_pedidos_canal ON pedidos (canal);
SHOW INDEX FROM pedidos WHERE Key_name = 'idx_pedidos_canal';

EXPLAIN ANALYZE SELECT SUM(valor) FROM pedidos WHERE canal = 'APP';

ALTER TABLE pedidos ALTER INDEX idx_pedidos_canal INVISIBLE;
EXPLAIN ANALYZE SELECT SUM(valor) FROM pedidos WHERE canal = 'APP';

ALTER TABLE pedidos ALTER INDEX idx_pedidos_canal VISIBLE;
/*
   DECISÃO: NÃO deve ser mantido.
   JUSTIFICATIVA: A coluna 'canal' possui baixíssima seletividade (apenas 3
   valores distintos: LOJA, SITE, APP). Cada valor representa ~33% da tabela,
   tornando o Table Scan mais vantajoso ou com variação irrisória de tempo, não
   compensando a taxa de escrita/atualização da estrutura.
*/

-- b) Análise e criação de índice para eliminar 'Using filesort':
EXPLAIN SELECT id, data_pedido, valor FROM pedidos
WHERE cliente_id = 42 AND data_pedido >= '2025-01-01'
ORDER BY data_pedido;
/*
   - EXPLAIN original: usa fk_pedido_cliente e gera 'Using filesort'.
*/

-- Proposta de índice composto:
CREATE INDEX idx_pedidos_cliente_data ON pedidos (cliente_id, data_pedido);

-- Teste após a criação:
EXPLAIN SELECT id, data_pedido, valor FROM pedidos
WHERE cliente_id = 42 AND data_pedido >= '2025-01-01'
ORDER BY data_pedido;
/*
   - Resultado após o novo índice: type = range, key = idx_pedidos_cliente_data,
     e a mensagem 'Using filesort' foi eliminada (registros já vem ordenados).
*/

-- c) Verificação da redundância com o índice da FK:
SHOW INDEX FROM pedidos;
/*
   EXPLICAÇÃO: O novo índice idx_pedidos_cliente_data (cliente_id, data_pedido)
   possui a coluna cliente_id no início. Por cobrir o prefixo da Chave Estrangeira
   fk_pedido_cliente, ele substitui e torna o índice original redundante.
*/