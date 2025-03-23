DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS desempenho_vendedor;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS lojas;
DROP TABLE IF EXISTS roupas;

-- Criação das tabelas
CREATE TABLE roupas (
    id_roupa INT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    tamanho VARCHAR(3) NOT NULL,
    preco FLOAT NOT NULL,
    nome_fornecedor VARCHAR(50) NOT NULL,
    promocao BOOLEAN DEFAULT FALSE
);

CREATE TABLE lojas (
    id_loja VARCHAR(14) PRIMARY KEY,
    nome_loja VARCHAR(50) NOT NULL
);

CREATE TABLE desempenho_vendedor (
    id_loja VARCHAR(14) NOT NULL,
    nome_vendedor VARCHAR(50) NOT NULL,
    qtd_vendas INT NOT NULL,
    qtd_itens_vendidos INT NOT NULL,
    valor_total_vendido FLOAT NOT NULL,
    PRIMARY KEY (id_loja, nome_vendedor),
    FOREIGN KEY (id_loja) REFERENCES lojas(id_loja)
);

CREATE TABLE clientes (
    id_cliente VARCHAR(11) PRIMARY KEY,
    nome_cliente VARCHAR(50) NOT NULL
);

CREATE TABLE compras (
    id_compra INT PRIMARY KEY,
    id_cliente VARCHAR(11) NOT NULL,
    id_loja VARCHAR(14) NOT NULL,
    qtd_itens INT NOT NULL,
    valor_total FLOAT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_loja) REFERENCES lojas(id_loja)
);

CREATE TABLE vendas (
    id_venda INT PRIMARY KEY,
    id_loja VARCHAR(14) NOT NULL,
    metodo_venda VARCHAR(20) NOT NULL,
    id_cliente VARCHAR(11) NOT NULL,
    qtd_itens INT NOT NULL,
    valor_total FLOAT NOT NULL,
    FOREIGN KEY (id_loja) REFERENCES lojas(id_loja),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Inserção de registros nas tabelas
INSERT INTO lojas VALUES 
('11111111000101', 'Renner'),
('22222222000102', 'C&A'),
('33333333000103', 'Riachuelo'),
('44444444000104', 'Marisa'),
('55555555000105', 'Zara'),
('66666666000106', 'Forever 21'),
('77777777000107', 'H&M');

INSERT INTO desempenho_vendedor VALUES 
('11111111000101', 'Matheus', 15, 50, 5000.0),
('11111111000101', 'Gouveia', 20, 60, 6000.0),
('22222222000102', 'Pedro', 10, 40, 4000.0),
('33333333000103', 'Lucas', 18, 55, 5500.0),
('55555555000105', 'Bruna', 17, 65, 6500.0),
('66666666000106', 'Amanda', 12, 45, 4500.0),
('77777777000107', 'João', 9, 30, 3000.0);

INSERT INTO clientes VALUES 
('11122233345', 'Eduardo'),
('22233344456', 'Beatriz'),
('33344455567', 'Marcelo'),
('44455566678', 'Larissa'),
('55566677789', 'Gabriel'),
('66677788890', 'Carolina'),
('77788899901', 'Renato');

INSERT INTO compras VALUES 
(101, '11122233345', '11111111000101', 5, 500.0),
(102, '22233344456', '22222222000102', 3, 300.0),
(103, '33344455567', '33333333000103', 2, 200.0),
(104, '44455566678', '44444444000104', 4, 400.0),
(105, '55566677789', '55555555000105', 1, 100.0),
(106, '11122233345', '22222222000102', 5, 900.0),
(107, '11122233345', '33333333000103', 7, 200.0),
(108, '11122233345', '44444444000104', 12, 1200.0),
(109, '66677788890', '66666666000106', 8, 800.0),
(110, '77788899901', '77777777000107', 10, 1000.0);

INSERT INTO vendas VALUES 
(201, '11111111000101', 'Online', '11122233345', 5, 500.0),
(202, '22222222000102', 'Presencial', '22233344456', 3, 300.0),
(203, '33333333000103', 'Online', '33344455567', 2, 200.0),
(204, '44444444000104', 'Presencial', '44455566678', 4, 400.0),
(205, '55555555000105', 'Online', '55566677789', 1, 100.0),
(206, '66666666000106', 'Online', '66677788890', 8, 800.0),
(207, '77777777000107', 'Presencial', '77788899901', 10, 1000.0);

INSERT INTO roupas VALUES
(001, 'Bermuda', 'M', 199.9,  'Trip Side', TRUE),
(002, 'Camisa', 'M', 240.0,  'SUFGANG', FALSE),
(003, 'Calça', 'GG', 300.0,  'HIGH COMPANY', FALSE),
(004, 'Polo', 'P', 430.5, 'Lacoste', FALSE),
(005, 'Jaqueta', 'G',599.9, 'Yves Saint Laurent', TRUE),
(006, 'Vestido', 'M', 299.9, 'Zara', TRUE),
(007, 'Blusa', 'G', 120.0, 'C&A', FALSE),
(008, 'Shorts', 'P', 180.0, 'Renner', TRUE);

-- Produtos em promoção
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

-- Vendedores com mais de 5 itens vendidos
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

-- Clientes que visitaram e compraram em várias lojas
WITH loja_visitas AS (
    SELECT 
        id_cliente, 
        COUNT(DISTINCT id_loja) AS lojas_visitadas
    FROM 
        compras
    GROUP BY 
        id_cliente
),
lojas_compras AS (
    SELECT 
        id_cliente, 
        COUNT(DISTINCT CASE WHEN qtd_itens > 0 THEN id_loja END) AS lojas_compradas
    FROM 
        compras
    GROUP BY 
        id_cliente
),
cliente_relatorio AS (
    SELECT 
        c.id_cliente, 
        c.nome_cliente, 
        lv.lojas_visitadas, 
        COUNT(cmp.id_compra) AS total_compras, 
        lc.lojas_compradas
    FROM 
        clientes c
    JOIN 
        loja_visitas lv ON c.id_cliente = lv.id_cliente
    JOIN 
        compras cmp ON c.id_cliente = cmp.id_cliente
    JOIN 
        lojas_compras lc ON c.id_cliente = lc.id_cliente
    GROUP BY 
        c.id_cliente, c.nome_cliente, lv.lojas_visitadas, lc.lojas_compradas
)
SELECT 
    nome_cliente, 
    lojas_visitadas, 
    total_compras, 
    lojas_compradas
FROM 
    cliente_relatorio
WHERE 
    lojas_visitadas > 1 
    AND lojas_compradas >= 1
ORDER BY 
    total_compras DESC;

-- Relatório de vendas por loja e método de venda
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
