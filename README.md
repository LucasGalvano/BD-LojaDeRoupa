# Projeto de Banco de Dados: Loja de Roupas

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13-blue?logo=postgresql&logoColor=white)  
Um projeto de banco de dados que simula uma rede de lojas de roupas, envolvendo empresas, fornecedores, clientes, vendedores e vendas. Desenvolvido em **PostgreSQL**, o sistema permite a gestão de informações sobre roupas, lojas, vendas e muito mais.

---

## 📋 Sobre o Projeto

Este projeto foi desenvolvido como parte da disciplina de **Banco de Dados**, utilizando o **SQL** e tem como objetivo modelar e implementar um sistema de gerenciamento para uma rede de lojas de roupas. O banco de dados gerencia informações sobre:

- **Empresas e Lojas:** Cada empresa possui várias lojas, com informações como nome e localização.
- **Fornecedores:** Responsáveis por produzir e fornecer roupas para as lojas.
- **Roupas:** Informações como tamanho, tecido, preço, tipo e promoções.
- **Clientes:** Podem realizar compras nas lojas, com informações como CPF, nome, endereço e e-mail.
- **Vendedores:** Associados a uma loja, realizam vendas online ou presenciais.
- **Vendas:** Armazenam dados das transações, incluindo método de venda, cliente, vendedor e tipo de pagamento.

---

## 🚀 Funcionalidades

### 1. **Modelagem de Dados**
   - Utilização de **MER (Modelo Entidade-Relacionamento)** e **MR (Modelo Relacional)** para a concepção do banco de dados.
   - Normalização das tabelas até a **3ª Forma Normal (3FN)**.

### 2. **Consultas SQL**
   - Consultas complexas para análise de vendas, desempenho de vendedores e produtos em promoção.
   - Exemplos de consultas:
     - Listar roupas em promoção.
     - Relatório de vendas por loja e método de venda.
     - Vendedores com mais de 5 itens vendidos.

### 3. **Gestão de Dados**
   - Inserção, atualização e exclusão de dados nas tabelas.
   - Relacionamentos entre entidades (1:N, N:N) implementados com chaves primárias e estrangeiras.

---

## 🛠️ Como Executar o Projeto

### Pré-requisitos
- **PostgreSQL** instalado.
- **pgAdmin** (opcional) para gerenciamento do banco de dados.
- **VSCode** (opcional) para gerenciamento do banco de dados.

### Passos para Execução
1. Clone o repositório:
      git clone https://github.com/LucasGalvano/BD-LojaDeRoupa.git
2. Navegue até o diretório do projeto:
      cd BD-LojaDeRoupa
 ---
### 📊 Exemplos de Consultas
As consultas podem não estar perfeitamente formatadas no GitHub, mas devem funcionar corretamente.
1. Listar roupas em promoção:
   SELECT 
    id_roupa, 
    tipo, 
    tamanho, 
    preco, 
    nome_fornecedor
FROM 
    roupas
WHERE 
    promocao = TRUE
ORDER BY 
    preco ASC;
2. Relatório de vendas por loja e método de venda:
   SELECT
    l.nome_loja,
    v.metodo_venda,
    COUNT(*) AS qtd_vendas,
    COUNT(DISTINCT v.id_cliente) AS clientes_unicos,
    SUM(v.qtd_itens) AS qtd_itens_vendidos,
    SUM(v.valor_total) AS valor_total_vendas,
    AVG(v.valor_total) AS media_do_valor 
FROM 
    vendas v
JOIN 
    lojas l ON v.id_loja = l.id_loja
GROUP BY 
    l.nome_loja, v.metodo_venda
ORDER BY 
    l.nome_loja ASC, valor_total_vendas DESC;
3. Vendedores com mais de 5 itens vendidos
  SELECT 
    l.nome_loja as "nome da loja", 
    dv.nome_vendedor as "vendedor", 
    dv.qtd_vendas, 
    dv.qtd_itens_vendidos, 
    dv.valor_total_vendido
FROM 
    desempenho_vendedor dv
JOIN 
    lojas l ON dv.id_loja = l.id_loja
WHERE 
    dv.qtd_itens_vendidos > 5
ORDER BY 
    dv.valor_total_vendido DESC;
### 👨‍💻 Contribuidores
Este projeto foi desenvolvido em equipe pelos seguintes integrantes:

Gustavo Matias Félix: Responsável pela modelagem do banco de dados e implementação das consultas SQL.

Matheus Sarmento: Responsável pela normalização do banco de dados e testes.

Lucas Galvano de Paula: Responsável pela inserção de dados e documentação.
