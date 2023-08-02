-- Criação do banco de dados para o cenário de e-commerce
CREATE DATABASE ecommerce;
USE ecommerce;

-- Tabela Cliente
CREATE TABLE IF NOT EXISTS Clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10) NOT NULL,
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11),
    CNPJ CHAR(15),
    Address VARCHAR(30),
    IsPJ BOOLEAN,
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT check_pj_pf_client CHECK ((CPF IS NOT NULL AND CNPJ IS NULL) OR (CPF IS NULL AND CNPJ IS NOT NULL))
);

-- Tabela Produto
CREATE TABLE IF NOT EXISTS Product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10) NOT NULL,
    Classification_kids BOOLEAN DEFAULT FALSE,
    Category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    Avaliation FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- Tabela Pagamentos
CREATE TABLE IF NOT EXISTS Payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    TypePayment ENUM('Dinheiro', 'Boleto', 'Cartão de Crédito', 'Cartão de Débito'),
    LimitAvailable FLOAT,
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- Tabela Pedido
CREATE TABLE IF NOT EXISTS Orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    OrderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    OrderDescription VARCHAR(255),
    SendValue FLOAT DEFAULT 10,
    PaymentCash BOOLEAN DEFAULT FALSE,
    DeliveryStatus VARCHAR(255),
    TrackingCode VARCHAR(50),
    CONSTRAINT fk_order_client FOREIGN KEY (idOrderClient) REFERENCES Clients(idClient)
);

-- Tabela ProdutoEstoque
CREATE TABLE IF NOT EXISTS ProductStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    StorageLocation VARCHAR(255),
    Quantity INT DEFAULT 0
);

-- Tabela LocalEstoque
CREATE TABLE IF NOT EXISTS StorageLocation (
    idLProduct INT,
    idLStorage INT,
    Location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLProduct, idLStorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLProduct) REFERENCES Product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLStorage) REFERENCES ProductStorage(idProdStorage)
);

-- Tabela Fornecedor
CREATE TABLE IF NOT EXISTS Supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    Contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Tabela Vendedor
CREATE TABLE IF NOT EXISTS Seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15),
    CPF CHAR(9),
    Location VARCHAR(255),
    Contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_CNPJ_seller UNIQUE (CNPJ),
    CONSTRAINT unique_CPF_seller UNIQUE (CPF)
);

-- Tabela ProdutoVendedor
CREATE TABLE IF NOT EXISTS ProductSeller (
    idPSeller INT,
    idPProduct INT,
    ProdQuantity INT DEFAULT 1,
    PRIMARY KEY (idPSeller, idPProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPSeller) REFERENCES Seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPProduct) REFERENCES Product(idProduct)
);

-- Tabela ProdutoPedido
CREATE TABLE IF NOT EXISTS ProductOrder (
    idPOproduct INT,
    idPOorder INT,
    POquantity INT DEFAULT 1,
    POstatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_seller FOREIGN KEY (idPOproduct) REFERENCES Product(idProduct),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOorder) REFERENCES Orders(idOrder)
);

-- Tabela ProdutoFornecedor
CREATE TABLE IF NOT EXISTS ProductSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    Quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES Supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES Product(idProduct)
);

-- Inserção de dados de exemplo

-- Inserção de Clientes (PF e PJ)
INSERT INTO Clients (Fname, Minit, Lname, CPF, CNPJ, Address, IsPJ)
VALUES
    ('João', 'S', 'Silva', '12345678901', NULL, 'Rua A, 123', false),
    ('Maria', 'C', 'Santos', '98765432101', NULL, 'Rua B, 456', false),
    ('Empresa A', NULL, NULL, NULL, '12345678901234', 'Av. Principal, 789', true),
    ('Empresa B', NULL, NULL, NULL, '56789012345678', 'Av. Secundária, 321', true);

=
-- Inserção de Produtos
INSERT INTO Product (Pname, Classification_kids, Category, Avaliation, size)
VALUES
    ('Celular', false, 'Eletrônico', 4.5, NULL),
    ('Camiseta', true, 'Vestimenta', 3.8, 'M'),
    ('Carrinho', true, 'Brinquedos', 4.2, NULL),
    ('Arroz', false, 'Alimentos', 4.7, NULL),
    ('Sofá', false, 'Móveis', 4.0, 'Grande');

-- Inserção de Pedidos
INSERT INTO Orders (idOrderClient, OrderStatus, OrderDescription, SendValue, PaymentCash, DeliveryStatus, TrackingCode)
VALUES
    (1, 'Confirmado', 'Pedido 1', 15.50, false, 'Enviado', 'ABC123'),
    (2, 'Em processamento', 'Pedido 2', 22.00, true, 'Em trânsito', 'XYZ456'),
    (3, 'Em processamento', 'Pedido 3', 10.00, false, 'Aguardando envio', NULL),
    (4, 'Confirmado', 'Pedido 4', 150.00, false, 'Enviado', 'DEF789');

-- Inserção de Produtos em Estoque
INSERT INTO ProductStorage (StorageLocation, Quantity)
VALUES
    ('Estoque A', 100),
    ('Estoque B', 50),
    ('Estoque C', 200),
    ('Estoque D', 300),
    ('Estoque E', 75);

-- Inserção de Locais de Estoque
INSERT INTO StorageLocation (idLProduct, idLStorage, Location)
VALUES
    (1, 1, 'Prateleira 1'),
    (2, 2, 'Prateleira 2'),
    (3, 3, 'Prateleira 1'),
    (4, 4, 'Prateleira 2'),
    (5, 5, 'Prateleira 3');

-- Inserção de Fornecedores
INSERT INTO Supplier (SocialName, CNPJ, Contact)
VALUES
    ('Fornecedor A', '12345678901234', '1111111111'),
    ('Fornecedor B', '56789012345678', '2222222222');

-- Inserção de Vendedores
INSERT INTO Seller (SocialName, CNPJ, CPF, Location, Contact)
VALUES
    ('Vendedor X', NULL, '123456789', 'Loja 1', '3333333333'),
    ('Vendedor Y', NULL, '987654321', 'Loja 2', '4444444444');

-- Inserção de Produtos para Vendedores
INSERT INTO ProductSeller (idPSeller, idPProduct, ProdQuantity)
VALUES
    (1, 1, 10),
    (1, 2, 20),
    (2, 3, 15),
    (2, 4, 25);

-- Inserção de Produtos em Pedidos
INSERT INTO ProductOrder (idPOproduct, idPOorder, POquantity)
VALUES
    (1, 1, 2),
    (2, 1, 3),
    (3, 2, 1),
    (4, 3, 2),
    (1, 4, 5),
    (3, 4, 3);

-- Inserção de Produtos de Fornecedores
INSERT INTO ProductSupplier (idPsSupplier, idPsProduct, Quantity)
VALUES
    (1, 1, 50),
    (1, 2, 100),
    (2, 3, 30),
    (2, 4, 75);

-- Exemplos de Consultas SQL

-- Recuperação simples
SELECT * FROM Clients;
SELECT * FROM Product;
SELECT * FROM Orders;

-- Filtros com WHERE
SELECT * FROM Clients WHERE IsPJ = true;
SELECT * FROM Product WHERE Avaliation > 4.0;
SELECT * FROM Orders WHERE OrderStatus = 'Confirmado';

-- Expressões para atributos derivados
SELECT idProduct, Pname, (Avaliation * 10) AS AvaliationPercent FROM Product;

-- Ordenação com ORDER BY
SELECT * FROM Clients ORDER BY idClient ASC;
SELECT * FROM Product ORDER BY Avaliation DESC;

-- Condições de filtro aos grupos com HAVING
SELECT idOrderClient, COUNT(*) AS TotalOrders FROM Orders GROUP BY idOrderClient HAVING TotalOrders > 1;

-- Junções entre tabelas
SELECT C.Fname, O.OrderStatus FROM Clients C INNER JOIN Orders O ON C.idClient = O.idOrderClient;
SELECT S.SocialName, PS.ProdQuantity FROM Seller S INNER JOIN ProductSeller PS ON S.idSeller = PS.idPSeller;
SELECT P.Pname, PS.Quantity FROM Product P INNER JOIN ProductSupplier PS ON P.idProduct = PS.idPsProduct;


