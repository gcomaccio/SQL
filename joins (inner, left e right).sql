CREATE DATABASE IF NOT EXISTS joins;

USE joins;


CREATE TABLE IF NOT EXISTS funcionario_A (
	id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    cargo VARCHAR(100) NOT NULL,
    nome VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS info_funcionario_B(
	id_funcionario INT,
    id_salario INT PRIMARY KEY AUTO_INCREMENT,
    salario FLOAT UNSIGNED,
    departamento VARCHAR(200),
    FOREIGN KEY(id_funcionario) REFERENCES funcionario_A(id_funcionario)
);

INSERT INTO funcionario_A (id_funcionario, cargo, nome) VALUES
(1, 'Desenvolvedor Sênior','Guilherme Comaccio'),
(2, 'Médico', 'Augusto Teixeira'),
(3,'Designer', 'Arthur Campos'),
(4,'Desenvolvedor Pleno', 'Davi Montarroyos'),
(5, 'Marketing', 'Leandro Silva'),
(6, 'Advogado Civil', 'Vinicius Comaccio');

INSERT INTO info_funcionario_B(id_funcionario, salario, departamento) VALUES
(1,20000, 'Tecnologia'),
(2,16000, 'Saúde'),
(3,10000, 'Tecnologia'),
(4,15000, 'Tecnologia'),
(5,10000, 'Marketing'),
(NULL, 17000, 'Direito');

	
