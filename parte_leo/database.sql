CREATE DATABASE lactea_sul;

use lactea_sul;

CREATE TABLE usuario(
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    perfil VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE fornecedor(
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    telefone VARCHAR(20),
    cidade VARCHAR(100) NOT NULL
);

CREATE TABLE cliente(
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(18) NOT NULL,
    telefone VARCHAR(20),
    cidade VARCHAR(100) NOT NULL
);

CREATE TABLE produto(
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    unidade_medida VARCHAR(20) NOT NULL,
    validade_dias INT NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE ordem_producao(
    id_ordem INT AUTO_INCREMENT PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_final DATE NOT NULL,
    quantidade_planejada DECIMAL(10,2) NOT NULL,
    quantidade_produzida DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE lote(
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    codigo_lote VARCHAR(30) NOT NULL UNIQUE,
    data_fabricacao DATE NOT NULL,
    data_validade DATE NOT NULL,
    quantidade_inicial DECIMAL(10,2) NOT NULL,
    saldo_atual DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) NOT NULL,
    id_produto INT NOT NULL,
    id_ordem INT NOT NULL,
    id_fornecedor INT NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    FOREIGN KEY (id_ordem) REFERENCES ordem_producao(id_ordem),
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

CREATE TABLE movimentacao(
    id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(30) NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    data_movimentacao DATETIME NOT NULL,
    motivo VARCHAR(200),
    id_usuario INT NOT NULL,
    id_lote INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_lote) REFERENCES lote(id_lote)
);

CREATE TABLE analise_quantidade(
    id_analise INT AUTO_INCREMENT PRIMARY KEY,
    data_analise DATETIME NOT NULL,
    tipo_analise VARCHAR(100) NOT NULL,
    resultado VARCHAR(50) NOT NULL,
    observacao TEXT,
    id_lote INT NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE expedicao(
    id_expedicao INT AUTO_INCREMENT PRIMARY KEY,
    data_expedicao DATETIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE expedicao_item(
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_expedicao INT NOT NULL,
    id_lote INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_expedicao) REFERENCES expedicao(id_expedicao),
    FOREIGN KEY (id_lote) REFERENCES lote(id_lote)
);

INSERT INTO usuario (nome, email, senha_hash, perfil, status) VALUES
('Carlos Mendes', 'carlos@lacteasul.com', 'hash_carlos_123', 'Administrador', 'Ativo'),
('Ana Ribeiro', 'ana@lacteasul.com', 'hash_ana_456', 'Operador', 'Ativo'),
('Joao Martins', 'joao@lacteasul.com', 'hash_joao_789', 'Supervisor', 'Ativo');

INSERT INTO fornecedor (nome, cnpj, telefone, cidade) VALUES
('Fazenda Boa Vista', '12.345.678/0001-90', '(47) 3333-1000', 'Rio do Sul'),
('Cooperativa Leite Forte', '23.456.789/0001-01', '(47) 3333-2000', 'Blumenau'),
('Fazenda Santa Clara', '34.567.890/0001-12', '(47) 3333-3000', 'Ituporanga');

INSERT INTO cliente (nome, cpf_cnpj, telefone, cidade) VALUES
('Mercado Central', '45.678.901/0001-23', '(47) 98811-1000', 'Rio do Sul'),
('Supermercado Econômico', '56.789.012/0001-34', '(47) 98811-2000', 'Blumenau'),
('Padaria Pao Quente', '67.890.123/0001-45', '(47) 98811-3000', 'Ituporanga');

INSERT INTO produto (nome, categoria, unidade_medida, validade_dias, status) VALUES
('Leite Integral', 'Leite', 'Litro', 7, 'Ativo'),
('Queijo Mussarela', 'Queijo', 'Kg', 30, 'Ativo'),
('Iogurte Natural', 'Iogurte', 'Unidade', 15, 'Ativo');

INSERT INTO ordem_producao (data_inicio, data_final, quantidade_planejada, quantidade_produzida, status, id_usuario) VALUES
('2026-10-15', '2026-10-15', 1000.00, 1000.00, 'Concluida', 1),
('2026-10-16', '2026-10-16', 500.00, 450.00, 'Concluida', 2),
('2026-10-20', '2026-10-22', 800.00, 300.00, 'Em andamento', 3);

INSERT INTO lote (codigo_lote, data_fabricacao, data_validade, quantidade_inicial, saldo_atual, status, id_produto, id_ordem, id_fornecedor) VALUES
('LT-2026-001', '2026-10-15', '2026-10-22', 1000.00, 800.00, 'Disponivel', 1, 1, 1),
('LT-2026-002', '2026-10-16', '2026-11-15', 450.00, 300.00, 'Disponivel', 2, 2, 2),
('LT-2026-003', '2026-10-20', '2026-11-04', 300.00, 300.00, 'Em producao', 3, 3, 3);

INSERT INTO movimentacao (tipo, quantidade, data_movimentacao, motivo, id_usuario, id_lote) VALUES
('Saida', 200.00, '2026-10-16 09:30:00', 'Envio para cliente', 1, 1),
('Entrada', 450.00, '2026-10-16 14:00:00', 'Conclusao da producao', 2, 2),
('Saida', 150.00, '2026-10-17 10:15:00', 'Expedicao de produtos', 3, 2);

INSERT INTO analise_quantidade (data_analise, tipo_analise, resultado, observacao, id_lote, id_usuario) VALUES
('2026-10-15 10:00:00', 'Conferencia de estoque', 'Aprovado', 'Quantidade conferida corretamente', 1, 1),
('2026-10-16 15:00:00', 'Verificacao de lote', 'Aprovado', 'Saldo de queijo conferido', 2, 2),
('2026-10-20 11:30:00', 'Controle de quantidade', 'Pendente', 'Aguardando conferencia final', 3, 3);

INSERT INTO expedicao (data_expedicao, status, id_cliente, id_usuario) VALUES
('2026-10-16 10:00:00', 'Concluida', 1, 1),
('2026-10-17 08:30:00', 'Concluida', 2, 2),
('2026-10-21 13:00:00', 'Pendente', 3, 3);

INSERT INTO expedicao_item(id_expedicao, id_lote, quantidade) VALUES
(1, 1, 200.00),
(2, 2, 150.00),
(3, 3, 100.00);