Lição de SQL 7: JOINS EXTERNOS
Dependendo de como você quer analisar os dados, a lição que usamos na última pode não ser suficiente porque a tabela resultante contém apenas dados que pertencem a ambas as tabelas.INNER JOIN

Se as duas tabelas tiverem dados assimétricos, o que pode facilmente acontecer quando os dados são inseridos em formas diferentes estágios, então teríamos que usar um , ou em vez disso garantir que Os dados que você precisa não são deixados de fora dos resultados.LEFT JOINRIGHT JOINFULL JOIN

Selecionar consulta com LEFT/RIGHT/FULL JOINs em múltiplas tabelas
SELECT column, another_column, …
FROM mytable
INNER/LEFT/RIGHT/FULL JOIN another_table 
    ON mytable.id = another_table.matching_id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;
Essas três novas junções precisam especificar em qual coluna unir os dados.
Ao unir a tabela A à tabela B, a simplesmente inclui as linhas de A, independentemente de se uma linha correspondente é encontrada em B. O é o mesmo, mas invertido, mantendo as linhas em B independentemente de haver ou não uma correspondência em A. Por fim, um significa simplesmente que se enrolam de ambas as tabelas são mantidas, independentemente de existir uma linha correspondente na outra tabela.INNER JOINLEFT JOINRIGHT JOINFULL JOIN

Ao usar qualquer uma dessas novas junções, provavelmente você terá que escrever lógica adicional para lidar com s no resultado e nas restrições (mais sobre isso na próxima lição).NULL
