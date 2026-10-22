Limitando resultados a um subconjunto
Outra cláusula comumente usada junto com a cláusula são as cláusulas e, que são uma otimização útil para indicar ao banco de dados o subconjunto dos resultados que você valoriza.

Selecionar consulta com linhas limitadas
SELECT column, another_column, 
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT 10 OFFSET 20;

O que faz: Pula os primeiros 20 registros (OFFSET 20) e, em seguida, retorna os 10 seguintes (LIMIT 10), ou seja, exibe do registro 21 ao 30.
