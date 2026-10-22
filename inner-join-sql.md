Consultas multi-tabela com JOINs
Tabelas que compartilham informações sobre uma única entidade precisam ter uma chave primária que identifique essa entidade é única em todo o banco de dados. Um tipo comum de chave primária é o auto-incremento inteiro (porque são eficientes em espaço), mas também pode ser uma cadeia de caracteres, valor hashado, desde que é único.

Usando a cláusula em uma consulta, podemos combinar dados de linha em duas tabelas separadas usando isso chave única. A primeira das uniões que vamos introduzir é a .JOININNER JOIN

Selecionar consulta com INNER JOIN em múltiplas tabelas
SELECT column, another_table_column, …
FROM mytable
INNER JOIN another_table 
    ON mytable.id = another_table.id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;
É um processo que faz corresponder as linhas da primeira tabela e da segunda tabela que têm a mesma chave (conforme definida pela restrição) para criar uma linha de resultado com as colunas combinadas Das duas mesas. Depois que as tabelas são unidas, as outras cláusulas que aprendemos anteriormente são então Aplicado.INNER JOINON

Você sabia?
Você pode ver consultas onde o é escrito simplesmente como um . Essas duas são equivalentes, mas continuaremos a nos referir a essas junções como intern-joins porque elas Torne a consulta mais fácil de ler quando você começar a usar outros tipos de junções, que serão introduzidas na lição seguinte. INNER JOIN
