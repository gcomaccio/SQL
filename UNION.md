# UNION em SQL

Em SQL, o **UNION** serve para unir dois selects em um sem repetir dados.

## Como funciona

O operador `UNION` combina o resultado de duas ou mais consultas `SELECT` em uma única tabela de resultados, removendo automaticamente quaisquer linhas duplicadas.

### Sintaxe Básica

```sql
SELECT coluna1, coluna2 FROM tabela1
UNION
SELECT coluna1, coluna2 FROM tabela2;
```

### Regras para o uso do UNION

1. **Número de colunas**: Cada consulta `SELECT` envolvida na união deve ter o mesmo número de colunas.
2. **Tipos de dados compatíveis**: As colunas correspondentes devem possuir tipos de dados compatíveis e estar na mesma ordem.
3. **Remoção de duplicatas**: O `UNION` padrão elimina dados repetidos no resultado final (ao contrário do `UNION ALL`, que mantém todas as repetições).

### Exemplo Prático

```sql
SELECT nome, email FROM clientes
UNION
SELECT nome, email FROM fornecedores;
```
