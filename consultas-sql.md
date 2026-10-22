Para recuperar dados de um banco de dados SQL, é muitas vezes necessário escrever instruções, que são referidas como CONSULTAS.\ Uma consulta em si é apenas uma afirmação que declara quais dados estamos procurando, onde encontrá-lo e como transformá-lo.A sua sintaxe é SELECT.\
Exemplo de uma consulta para selecionar uma coluna específica de uma tabela específica:

SELECT coluna1, coluna2
FROM tabela1;

Este comando retorna a coluna 1 e a coluna 2 da tabela 1

Se quisermos fazer uma consulta e retornar todos os campos de uma tabela, podemos usar o asterísco (*), ao invés de listar todas as colunas da tabela. 

Sintaxe: SELECT * 
FROM tabela1

Este comando retorna todas as colunas da tabela 1

