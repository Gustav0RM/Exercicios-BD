-- 1 Liste todos os clientes (todas as colunas).-- 
SELECT * 
FROM tb_cliente 
WHERE cli_id > 0;

-- 2 Liste cli_id, cli_razao_social, cli_data_cadastro ordenando por cli_data_cadastro--
SELECT cli_id, cli_razao_social, cli_data_cadastro 
FROM tb_cliente  
WHERE cli_id > 0 
ORDER BY cli_data_cadastro;

-- 3 Conte quantos clientes são Pessoa Física e quantos são Pessoa Jurídica (GROUP BY cli_tipo).--
SELECT COUNT(*) 
FROM tb_cliente 
WHERE cli_cpf IS NOT NULL OR cli_cnpj IS NOT NULL 
GROUP BY cli_tipo; 

-- 4 Liste pro_nome e pro_preco dos produtos ativos (pro_ativo = 1).--
SELECT pro_nome, pro_preco 
FROM tb_produto 
WHERE pro_ativo = 1;

-- 5 Liste pro_nome e o nome da categoria (prc_nome) de cada produto.--
SELECT tb_produto.pro_nome, tb_produto_categoria.prc_nome 
FROM tb_produto 
INNER JOIN tb_produto_categoria ON (tb_produto.pro_prc_id = tb_produto_categoria.prc_id);

-- 6 Liste todas as formas de pagamento cadastradas.--
SELECT tb_pagamento.pag_data, tb_pagamento.pag_valor, tb_pagamento_forma.paf_descricao
FROM tb_pagamento 
INNER JOIN tb_pagamento_forma ON (tb_pagamento.pag_paf_id = tb_pagamento_forma.paf_id) 
ORDER BY pag_data;

-- 7 Liste fun_nome, car_nome e fun_admissao de todos os funcionários.
SELECT tb_funcionario.fun_nome, tb_cargo.car_nome, tb_funcionario.fun_admissao 
FROM tb_funcionario  
INNER JOIN tb_cargo ON (tb_funcionario.fun_car_id = tb_cargo.car_id);

-- 8 Liste fornecedores cujo for_cadastro foi há mais de 300 dias.--
SELECT for_id, for_nome, for_cadastro, DATEDIFF(CURRENT_DATE, for_cadastro) 
FROM tb_fornecedor 
WHERE DATEDIFF(CURRENT_DATE, for_cadastro) >= 300 
ORDER BY for_cadastro;

-- 9 Liste clientes cadastrados nos últimos 60 dias.--
SELECT *, DATEDIFF(CURRENT_DATE, cli_data_cadastro) 
FROM tb_cliente 
WHERE DATEDIFF(CURRENT_DATE, cli_data_cadastro) <= 60 
ORDER BY cli_data_cadastro;

-- 10 Liste os 10 produtos mais caros (por pro_preco desc).--
SELECT * 
FROM tb_produto 
ORDER BY pro_preco DESC LIMIT 10;

--Nível2----------------------------------------------------------------------------------------------------------

-- 11 Produtos da categoria "Espelho" com pro_preco entre 100 e 300 (inclusive).--
SELECT pro_nome, pro_prc_id, pro_preco 
FROM tb_produto 
WHERE pro_prc_id = 3 AND pro_preco BETWEEN 100 AND 300;

-- 12 Clientes PJ com CNPJ não nulo, ordenados por cli_fantasia (alfabético).--
SELECT * FROM tb_cliente 
WHERE cli_tipo = 2 AND cli_cnpj IS NOT NULL 
ORDER BY cli_fantasia;

-- 13 Vendas FATURADAS dos últimos 45 dias mostrando ven_id, ven_data, cli_razao_social.--
SELECT tb_venda.ven_id, tb_venda.ven_data, tb_cliente.cli_razao_social
FROM tb_venda 
INNER JOIN tb_cliente ON (tb_venda.ven_cli_id = tb_cliente.cli_id)
WHERE DATEDIFF(CURRENT_DATE, tb_venda.ven_data  ) <= 45
ORDER BY cli_razao_social;

-- 14 Orçamentos APROVADO com orc_validade >= CURDATE().--
SELECT * 
FROM tb_orcamento
WHERE orc_validade >= CURDATE() AND orc_status = "APROVADO";

-- 15 Itens de venda com vei_quantidade > 2, exibindo valor_item = vei_quantidade * vei_preco_unit.--
SELECT tb_produto.pro_nome, vei_quantidade, vei_preco_unit, vei_quantidade * vei_preco_unit AS valor_item 
FROM tb_venda_item VEN
INNER JOIN tb_produto ON (tb_produto.pro_id = VEN.vei_pro_id)
WHERE vei_quantidade > 2;
 
 -- 16 Compras do fornecedor "Alumínios & Ferragens" (com_id, com_data, com_observacao).--
SELECT com_id, com_data, com_observacao 
FROM tb_compra CON
WHERE CON.com_for_id = 3;

-- 17 Produtos cujo pro_nome contém "Porta" ou "Janela".--
SELECT * 
FROM tb_produto PRO
WHERE pro_nome LIKE "%Porta%" OR pro_nome LIKE "%Janela%";

-- 18 Clientes cujo e-mail termina com "@empresa.com".--
SELECT * 
FROM tb_cliente CLI 
WHERE cli_email  NOT LIKE "%@email.com";

-- 19 Orçamentos com status CANCELADO ou ABERTO nos últimos 60 dias.--
SELECT * 
FROM tb_orcamento ORC
WHERE (ORC_status = "ABERTO" OR ORC_status = "CANCELADO") AND DATEDIFF(CURRENT_DATE, ORC_data) <= 60
ORDER BY ORC_status;

-- 20 Estoques com est_quantidade < 30.--
SELECT * FROM tb_estoque EST
WHERE est_quantidade < 30
ORDER BY EST_quantidade DESC;

-- 21 Vendas com nome do cliente e do vendedor (JOIN tb_venda, tb_cliente, tb_funcionario).--
SELECT CLI.cli_razao_social, FUN.fun_nome, VEN.ven_data, VEN.ven_observacao, VEN.ven_status FROM tb_venda VEN
INNER JOIN tb_cliente CLI ON (VEN.ven_cli_id = CLI.cli_id)
INNER JOIN tb_funcionario FUN ON (VEN.ven_fun_id = FUN.fun_id)
ORDER BY CLI.cli_razao_social;

-- 22 Itens de venda com pro_nome, prc_nome (categoria) e umd_sigla (unidade).--
SELECT VEN.vei_id, PRO.pro_nome, PRC.prc_nome, UNI.umd_sigla  FROM tb_venda_item VEN 
INNER JOIN tb_produto PRO ON (VEN.vei_pro_id = PRO.pro_id)
INNER JOIN tb_unidade_medida UNI ON (PRO.pro_umd_id = UNI.umd_id) 
INNER JOIN tb_produto_categoria PRC ON (PRO.pro_prc_id = PRC.prc_id);
-- Outra forma de exibição, contando os registros e agrupando por categoria
SELECT PRC.prc_nome, COUNT(*), UNI.umd_sigla 
FROM tb_venda_item VEN 
INNER JOIN tb_produto PRO ON (VEN.vei_pro_id = PRO.pro_id) 
INNER JOIN tb_produto_categoria PRC ON (PRO.pro_prc_id = PRC.prc_id) 
INNER JOIN tb_unidade_medida UNI ON (PRO.pro_umd_id = UNI.umd_id) 
GROUP BY PRC.prc_nome;

-- 23 Compras com for_nome e a quantidade total de itens por compra.--
SELECT COM.com_id, COM.com_data DATA_COMPRA, COM.com_observacao OBS, FON.for_nome FORNECEDOR, SUM(COI.coi_quantidade) QUANTIDADE_TOTAL_ITENS
FROM tb_compra COM
INNER JOIN tb_fornecedor FON ON (COM.com_for_id = FON.for_id)
INNER JOIN tb_compra_item COI ON (COM.com_id = COI.coi_com_id)
GROUP BY COM.com_id;

-- 24 Orçamentos com a quantidade de itens por orçamento e o orc_status.--
SELECT ORC.orc_id, CLI.cli_razao_social CLIENTE, ORC.orc_status SITUACAO, ORC.orc_observacao OBS, SUM(ORI.ori_quantidade) QUANTIDADE_TOTAL_ITENS, UNI.umd_sigla UNIDADE
FROM tb_orcamento ORC
INNER JOIN tb_orcamento_item ORI ON (ORC.orc_id = ORI.ori_orc_id)
INNER JOIN tb_cliente CLI ON (ORC.orc_id = CLI.cli_id)
INNER JOIN tb_produto PRO ON (ORI.ori_pro_id = PRO.pro_id)
INNER JOIN tb_unidade_medida UNI ON (PRO.pro_umd_id = UNI.umd_id)
GROUP BY ORC.orc_id
ORDER BY ORC.orc_status;

-- 25 Produtos com quantidade em estoque e o nome da categoria.--
SELECT EST.est_id, EST.est_pro_id, PRO.pro_nome PRODUTO, EST.est_quantidade, PRI.prc_nome CATEGORIA
FROM tb_estoque EST
INNER JOIN tb_produto PRO ON (PRO.pro_id = EST.est_pro_id)
INNER JOIN tb_produto_categoria PRI ON (PRI.prc_id = PRO.pro_prc_id)
WHERE est_quantidade > 0
ORDER BY EST.est_id;

-- 26 Vendas com valor bruto por ven_id: SUM(vei_quantidade * vei_preco_unit).--
SELECT VEN.ven_id, VEI.vei_ven_id, VEN.ven_observacao PRODUTO, SUM(VEI.vei_quantidade * VEI.vei_preco_unit) VALOR_BRUTO 
FROM tb_venda VEN
INNER JOIN tb_venda_item VEI ON (VEN.ven_id = VEI.vei_ven_id)
GROUP BY VEN.ven_id;

-- 27 Vendas com valor líquido (valor bruto menos ven_desconto).--
SELECT VEN.ven_id, VEI.vei_ven_id, SUM(VEI.vei_quantidade * VEI.vei_preco_unit) - VEN.ven_desconto VALOR_LIQUIDO
FROM tb_venda VEN
INNER JOIN tb_venda_item VEI ON (VEN.ven_id = VEI.vei_ven_id)
GROUP BY VEN.ven_id

-- 28 Pagamentos com forma de pagamento, ven_id e cli_razao_social.-- 
SELECT VEN.ven_id ID_VENDA, CLI.cli_razao_social CLIENTE, PAF.paf_descricao FORMA_DE_PAGAMENTO
FROM tb_pagamento PAG 
INNER JOIN tb_pagamento_forma PAF ON (PAG.pag_paf_id = PAF.paf_id)
INNER JOIN tb_venda VEN ON (VEN.ven_id = PAG.pag_ven_id)
INNER JOIN tb_cliente CLI ON (VEN.ven_cli_id = CLI.cli_id)
ORDER BY CLI.cli_razao_social

-- 29 Clientes PJ e a quantidade de vendas de cada um (mesmo que zero; LEFT JOIN).--
SELECT CLI.cli_id, CLI.cli_razao_social CLIENTE_PJ, COUNT(VEN.ven_id) QTD_VENDAS
FROM tb_cliente CLI
LEFT JOIN tb_venda VEN ON (VEN.ven_cli_id = CLI.cli_id)
WHERE CLI.cli_tipo = 2
GROUP BY CLI.cli_id

-- 30  Vendedores com o total vendido (somatório do valor bruto de vendas FATURADA).--
SELECT FUN.fun_nome VENDEDOR, VEN.ven_status VENDA, SUM(VEI.vei_quantidade * VEI.vei_preco_unit) as VALOR_BRUTO_TOTAL	
FROM tb_funcionario FUN
INNER JOIN tb_venda VEN ON (FUN.fun_id = VEN.ven_fun_id)
INNER JOIN tb_venda_item VEI ON (VEN.ven_id = VEI.vei_ven_id)
WHERE VEN.ven_status = "FATURADA" 
GROUP BY FUN.fun_id;

-- 31 Categorias com a média de preço dos produtos (AVG(pro_preco)), da maior para a menor.--
SELECT PRI.prc_id, PRI.prc_nome CATEGORIA, AVG(PRO.pro_preco) MEDIA_VALOR
FROM tb_produto PRO
INNER JOIN tb_produto_categoria PRI ON (PRO.pro_prc_id = PRI.prc_id)
GROUP BY PRO.pro_prc_id
ORDER BY MEDIA_VALOR DESC

-- 32 Produtos com pro_preco acima da média de sua categoria (HAVING).--
SELECT PRI.prc_id, PRI.prc_nome CATEGORIA, AVG(PRO.pro_preco) MEDIA_VALOR_CATEGORIA, MAX(PRO.pro_preco) MAIOR_VALOR_PRODUTO
FROM tb_produto PRO
INNER JOIN tb_produto_categoria PRI ON (PRO.pro_prc_id = PRI.prc_id)
GROUP BY PRI.prc_id
HAVING (MAIOR_VALOR_PRODUTO > MEDIA_VALOR_CATEGORIA)

-- 33 Clientes com mais de 2 vendas nos últimos 120 dias.--
SELECT CLI.cli_id, CLI.cli_razao_social, DATEDIFF(CURRENT_DATE, VEN.ven_data) DATA_APROVADO, COUNT(VEN.ven_id) QTDE_VENDAS
FROM tb_cliente CLI
INNER JOIN tb_venda VEN ON (CLI.cli_id = VEN.ven_cli_id)
GROUP BY CLI.cli_id
HAVING (DATA_APROVADO <= 120 AND QTDE_VENDAS >= 2);

-- 34 Vendedores cujo ticket médio (média por venda) > 900 nos últimos 90 dias.--
SELECT VEN.ven_id, FUN.fun_nome, SUM(VEI.vei_preco_unit) VALOR_TOTAL_VENDA, AVG(VEI.vei_preco_unit) MEDIA_VENDA, DATEDIFF(CURRENT_DATE, VEN.ven_data) DATA_APROVADO
FROM tb_venda VEN 
INNER JOIN tb_funcionario FUN ON (VEN.ven_fun_id = FUN.fun_id)
INNER JOIN tb_venda_item VEI ON (VEN.ven_id = VEI.vei_ven_id)
GROUP BY VEN.ven_id
HAVING (MEDIA_VENDA > 900 AND DATA_APROVADO <= 90)

-- 35 Compras cujo total (SUM(coi_quantidade * coi_custo_unit)) seja > 3.000.--
SELECT COM.com_id, FON.for_nome FORNECEDOR, COM.com_observacao OBSERVACAO, SUM(COI.coi_quantidade * COI.coi_custo_unit) VALOR_TOTAL
FROM tb_compra COM
INNER JOIN tb_fornecedor FON ON (COM.com_for_id = FON.for_id)
INNER JOIN tb_compra_item COI ON (COM.com_id = COI.coi_com_id)
GROUP BY COM.com_id
HAVING (VALOR_TOTAL > 3000)

-- 36 Top 5 produtos por valor vendido nos últimos 120 dias.-- 
SELECT VEN.ven_id, PRO.pro_nome PRODUTO, VEI.vei_preco_unit PRECO_UNITARIO, DATEDIFF(CURRENT_DATE, VEN.ven_data) QTDE_DIAS_APROVADO
FROM tb_venda_item VEI
INNER JOIN tb_venda VEN ON (VEI.vei_ven_id = VEN.ven_id)
INNER JOIN tb_produto PRO ON (vei_pro_id = PRO.pro_id)
WHERE VEN.ven_status = "FATURADA"
GROUP BY PRO.pro_nome
HAVING (QTDE_DIAS_APROVADO <= 120)
ORDER BY PRECO_UNITARIO DESC LIMIT 5 
