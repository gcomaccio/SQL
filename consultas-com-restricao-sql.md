Se existisse uma tabela com milhares e milhares de dados, seria necessário uma forma de poder filtrar esses dados. Para filtrar resultados, é necessario utilizar uma cláusula na consulta. Neste caso, usamo o WHERE. Consulta de seleção com restrição:
SELECT coluna1, coluna2
FROM tabela1
WHERE condição AND/OR outra-condição;  

Consultas mais complexas podem ser construídas juntando vários palavras-chaves lógicas (por exemplo, num_rodas >= 4 AND portas <= 2) Abaixo estão alguns operadores lógicos que auxiliam no filtro de seleção: '=' IGUAL; 
'!=' DIFERENTE; 
'<>' DIFERENTE;
'>=' MAIOR OU IGUAL;
'<=' MENOR OU IGUAL;
'>' MAIOR;
'<' MENOR;
BETWEEN;
AND;
OR;
NOT;
NOT BETWEEN;
IN;
NOT IN;
'%' LIKE
NOT LIKE
