-- ============================================================
--          RESTAURANTE UNIVERSITÁRIO — POVOAMENTO
-- ============================================================
-- Ordem respeitada para evitar violações de integridade:
--  empresa → universidade → aluno → restaurante → funcionario
--  → setor → equipamentos → zelador → zelador_setor
--  → cozinheiro → refeicao → prepara → brinde
--  → pagamento (dispara TR1: credita saldo)
--  → serve     (dispara TR2: debita saldo)
-- ============================================================


-- ------------------------------------------------------------
-- 1. EMPRESA  (3 empresas terceirizadas de gestão)
-- ------------------------------------------------------------
INSERT INTO empresa VALUES (DEFAULT);   -- id = 1
INSERT INTO empresa VALUES (DEFAULT);   -- id = 2
INSERT INTO empresa VALUES (DEFAULT);   -- id = 3


-- ------------------------------------------------------------
-- 2. UNIVERSIDADE  (3 universidades, algumas com mais de 1 campus)
-- ------------------------------------------------------------
INSERT INTO universidade VALUES ('UFPE', 'Recife');
INSERT INTO universidade VALUES ('UFPB', 'Joao Pessoa');
INSERT INTO universidade VALUES ('UFRN', 'Natal');
INSERT INTO universidade VALUES ('UFC',  'Fortaleza');
INSERT INTO universidade VALUES ('UFAL', 'Maceio');


-- ------------------------------------------------------------
-- 3. ALUNO  (10 alunos)
-- saldo inicial = 0; será creditado via pagamento (TR1)
-- ------------------------------------------------------------
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A001', 'M001', 'Ana Lima',       0, '81', '991110001');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A002', 'M002', 'Bruno Souza',    0, '83', '992220002');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A003', 'M003', 'Carla Melo',     0, '84', '993330003');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A004', 'M004', 'Diego Farias',   0, '85', '994440004');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A005', 'M005', 'Erica Barros',   0, '82', '995550005');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A006', 'M006', 'Felipe Costa',   0, '81', '996660006');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A007', 'M007', 'Gabriela Nunes', 0, '83', '997770007');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A008', 'M008', 'Hugo Rocha',     0, '84', '998880008');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A009', 'M009', 'Iris Vieira',    0, '85', '999990009');
INSERT INTO aluno (cpf, matricula, nome, saldo, tel_ddd, tel_numero)
    VALUES ('A010', 'M010', 'Joao Martins',   0, '82', '900000010');


-- ------------------------------------------------------------
-- 4. RESTAURANTE  (5 restaurantes em universidades distintas)
-- id_restaurante gerado automaticamente: 1..5
-- ------------------------------------------------------------
INSERT INTO restaurante (sigla, id_empresa) VALUES ('UFPE', 1);  -- RU 1
INSERT INTO restaurante (sigla, id_empresa) VALUES ('UFPB', 2);  -- RU 2
INSERT INTO restaurante (sigla, id_empresa) VALUES ('UFRN', 1);  -- RU 3
INSERT INTO restaurante (sigla, id_empresa) VALUES ('UFC',  3);  -- RU 4
INSERT INTO restaurante (sigla, id_empresa) VALUES ('UFAL', 2);  -- RU 5


-- ------------------------------------------------------------
-- 5. FUNCIONARIO  (12 funcionários)
-- Hierarquia: chefes sem cpf_chefe, demais apontam para o chefe
-- Cada restaurante tem pelo menos 1 chefe e 1 subordinado
-- ------------------------------------------------------------
-- Chefes (sem cpf_chefe)
INSERT INTO funcionario VALUES ('F001', 'Marcos Alves',   NULL,  1, 'UFPE');
INSERT INTO funcionario VALUES ('F002', 'Patricia Duarte', NULL, 2, 'UFPB');
INSERT INTO funcionario VALUES ('F003', 'Roberto Leal',   NULL,  3, 'UFRN');
INSERT INTO funcionario VALUES ('F004', 'Sandra Moura',   NULL,  4, 'UFC');
INSERT INTO funcionario VALUES ('F005', 'Tiago Brito',    NULL,  5, 'UFAL');

-- Subordinados
INSERT INTO funcionario VALUES ('F006', 'Ubiracy Gomes',  'F001', 1, 'UFPE');
INSERT INTO funcionario VALUES ('F007', 'Vera Santos',    'F001', 1, 'UFPE');
INSERT INTO funcionario VALUES ('F008', 'Wilson Pires',   'F002', 2, 'UFPB');
INSERT INTO funcionario VALUES ('F009', 'Xavier Cunha',   'F003', 3, 'UFRN');
INSERT INTO funcionario VALUES ('F010', 'Yasmin Freitas', 'F004', 4, 'UFC');
INSERT INTO funcionario VALUES ('F011', 'Zelia Campos',   'F004', 4, 'UFC');
INSERT INTO funcionario VALUES ('F012', 'Andre Ribeiro',  'F005', 5, 'UFAL');


-- ------------------------------------------------------------
-- 6. SETOR  (5 setores — id gerado: 1..5)
-- ------------------------------------------------------------
INSERT INTO setor (nome) VALUES ('Cozinha Principal');
INSERT INTO setor (nome) VALUES ('Refeitorio');
INSERT INTO setor (nome) VALUES ('Despensa');
INSERT INTO setor (nome) VALUES ('Limpeza');
INSERT INTO setor (nome) VALUES ('Administracao');


-- ------------------------------------------------------------
-- 7. EQUIPAMENTOS  (múltiplos por setor)
-- ------------------------------------------------------------
INSERT INTO equipamentos VALUES (1, 'Fogao Industrial');
INSERT INTO equipamentos VALUES (1, 'Forno Combinado');
INSERT INTO equipamentos VALUES (1, 'Liquidificador Industrial');
INSERT INTO equipamentos VALUES (2, 'Mesas de Inox');
INSERT INTO equipamentos VALUES (2, 'Bandejas');
INSERT INTO equipamentos VALUES (2, 'Copos e Talheres');
INSERT INTO equipamentos VALUES (3, 'Prateleiras Refrigeradas');
INSERT INTO equipamentos VALUES (3, 'Freezer Horizontal');
INSERT INTO equipamentos VALUES (4, 'Enceradeira');
INSERT INTO equipamentos VALUES (4, 'Aspirador Industrial');
INSERT INTO equipamentos VALUES (5, 'Computador');
INSERT INTO equipamentos VALUES (5, 'Impressora');


-- ------------------------------------------------------------
-- 8. ZELADOR  (3 zeladores — subconjunto de funcionario)
-- ------------------------------------------------------------
INSERT INTO zelador VALUES ('F006');
INSERT INTO zelador VALUES ('F007');
INSERT INTO zelador VALUES ('F012');


-- ------------------------------------------------------------
-- 9. ZELADOR_SETOR  (multivalorado: zelador pode cuidar de vários setores)
-- ------------------------------------------------------------
INSERT INTO zelador_setor VALUES ('F006', 2);   -- F006 → Refeitorio
INSERT INTO zelador_setor VALUES ('F006', 4);   -- F006 → Limpeza
INSERT INTO zelador_setor VALUES ('F007', 1);   -- F007 → Cozinha Principal
INSERT INTO zelador_setor VALUES ('F007', 4);   -- F007 → Limpeza
INSERT INTO zelador_setor VALUES ('F012', 3);   -- F012 → Despensa
INSERT INTO zelador_setor VALUES ('F012', 4);   -- F012 → Limpeza


-- ------------------------------------------------------------
-- 10. COZINHEIRO  (5 cozinheiros — subconjunto de funcionario)
-- ------------------------------------------------------------
INSERT INTO cozinheiro VALUES ('F001', 'Carnes e Grelhados');
INSERT INTO cozinheiro VALUES ('F002', 'Massas e Sopas');
INSERT INTO cozinheiro VALUES ('F003', 'Dietas e Veganos');
INSERT INTO cozinheiro VALUES ('F009', 'Frituras e Lanches');
INSERT INTO cozinheiro VALUES ('F010', 'Doces e Sobremesas');


-- ------------------------------------------------------------
-- 11. REFEICAO  (8 refeições variadas — cod gerado: 1..8)
-- tipo: Almoco / Jantar / Lanche
-- ------------------------------------------------------------
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Suco de Laranja', 'Frango Grelhado', 'Arroz e Feijao', 'Salada Verde',    'Almoco', 14.00);
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Agua',            'Carne Assada',    'Pure de Batata', 'Sopa de Legumes',  'Jantar', 12.50);
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Suco de Acerola', 'Peixe Cozido',   'Macarrao',       'Salada de Frutas', 'Almoco', 13.00);
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Cafe',            NULL,              'Tapioca',        'Frutas da Epoca',  'Lanche',  8.00);
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Suco de Goiaba',  'Ovo Mexido',     'Arroz Integral', 'Caldo Verde',      'Almoco', 11.00);
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Leite',           'Omelete',        'Paes e Frios',    NULL,               'Lanche',  7.50);
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Suco de Uva',     'Strogonoff',     'Arroz e Feijao', 'Salada Caesar',    'Jantar', 15.00);
INSERT INTO refeicao (bebida, proteina, guarnicao, entrada, tipo, valor)
    VALUES ('Agua de Coco',    'Frango Xadrez',  'Legumes Salteados','Creme de Abobora','Almoco', 13.50);


-- ------------------------------------------------------------
-- 12. PREPARA  (cozinheiro × refeição — N:N)
-- Cada cozinheiro prepara algumas refeições; algumas são compartilhadas
-- ------------------------------------------------------------
INSERT INTO prepara VALUES ('F001', 1);
INSERT INTO prepara VALUES ('F001', 2);
INSERT INTO prepara VALUES ('F001', 7);
INSERT INTO prepara VALUES ('F002', 3);
INSERT INTO prepara VALUES ('F002', 5);
INSERT INTO prepara VALUES ('F003', 3);   -- F002 e F003 preparam refeição 3 juntos
INSERT INTO prepara VALUES ('F003', 5);
INSERT INTO prepara VALUES ('F003', 8);
INSERT INTO prepara VALUES ('F009', 4);
INSERT INTO prepara VALUES ('F009', 6);
INSERT INTO prepara VALUES ('F010', 6);   -- F009 e F010 preparam refeição 6 juntos
INSERT INTO prepara VALUES ('F010', 7);   -- F001 e F010 preparam refeição 7 juntos


-- ------------------------------------------------------------
-- 13. BRINDE  (4 brindes — cod gerado: 1..4)
-- ------------------------------------------------------------
INSERT INTO brinde (nome) VALUES ('Pudim');
INSERT INTO brinde (nome) VALUES ('Gelatina');
INSERT INTO brinde (nome) VALUES ('Bolo de Chocolate');
INSERT INTO brinde (nome) VALUES ('Sonho de Valse');


-- ============================================================
--  PAGAMENTOS — TR1 credita saldo automaticamente
-- ============================================================
-- Cada INSERT em pagamento dispara fn_adicionar_saldo()
-- Alguns alunos fazem mais de um pagamento (recarga de saldo)
-- ------------------------------------------------------------

-- A001: 2 pagamentos → saldo = 50 + 30 = 80
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (50.00, DATE '2025-01-10', 1, 'UFPE', 'A001');
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (30.00, DATE '2025-02-05', 1, 'UFPE', 'A001');

-- A002: 1 pagamento → saldo = 60
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (60.00, DATE '2025-01-12', 2, 'UFPB', 'A002');

-- A003: 1 pagamento → saldo = 40
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (40.00, DATE '2025-01-15', 3, 'UFRN', 'A003');

-- A004: 2 pagamentos → saldo = 25 + 50 = 75
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (25.00, DATE '2025-01-20', 4, 'UFC',  'A004');
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (50.00, DATE '2025-02-10', 4, 'UFC',  'A004');

-- A005: 1 pagamento → saldo = 20
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (20.00, DATE '2025-01-22', 5, 'UFAL', 'A005');

-- A006: 1 pagamento → saldo = 90
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (90.00, DATE '2025-01-25', 1, 'UFPE', 'A006');

-- A007: 1 pagamento → saldo = 35
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (35.00, DATE '2025-02-01', 2, 'UFPB', 'A007');

-- A008: 1 pagamento → saldo = 55
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (55.00, DATE '2025-02-03', 3, 'UFRN', 'A008');

-- A009: 2 pagamentos → saldo = 15 + 40 = 55
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (15.00, DATE '2025-02-06', 4, 'UFC',  'A009');
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (40.00, DATE '2025-02-15', 4, 'UFC',  'A009');

-- A010: 1 pagamento → saldo = 45
INSERT INTO pagamento (valor, data, id_restaurante, sigla, cpf_aluno)
    VALUES (45.00, DATE '2025-02-08', 5, 'UFAL', 'A010');


-- ============================================================
--  SERVIÇÕES — TR2 debita saldo automaticamente
-- ============================================================
-- Saldos antes de servir (pós-pagamentos):
--   A001=80  A002=60  A003=40  A004=75  A005=20
--   A006=90  A007=35  A008=55  A009=55  A010=45
--
-- Valores das refeições:
--   ref1=14  ref2=12.50  ref3=13  ref4=8  ref5=11
--   ref6=7.50  ref7=15  ref8=13.50
-- ============================================================

-- A001 come 4 refeições em dias diferentes (com e sem brinde)
INSERT INTO serve VALUES (1, 'UFPE', 1, 'A001', DATE '2025-01-11', '12:00', 1);  -- saldo: 80-14=66, brinde: Caneca RU
INSERT INTO serve VALUES (1, 'UFPE', 2, 'A001', DATE '2025-01-12', '18:30', NULL); -- saldo: 66-12.50=53.50
INSERT INTO serve VALUES (1, 'UFPE', 5, 'A001', DATE '2025-02-06', '12:15', 4);  -- saldo: 53.50-11=42.50, brinde: Vale Sobremesa
INSERT INTO serve VALUES (1, 'UFPE', 7, 'A001', DATE '2025-02-07', '19:00', NULL); -- saldo: 42.50-15=27.50

-- A002 come 3 refeições em restaurantes diferentes
INSERT INTO serve VALUES (2, 'UFPB', 3, 'A002', DATE '2025-01-13', '12:00', NULL); -- saldo: 60-13=47
INSERT INTO serve VALUES (2, 'UFPB', 1, 'A002', DATE '2025-01-14', '12:30', 2);  -- saldo: 47-14=33, brinde: Camiseta UFPE
INSERT INTO serve VALUES (2, 'UFPB', 6, 'A002', DATE '2025-01-15', '15:00', NULL); -- saldo: 33-7.50=25.50

-- A003 come 2 refeições
INSERT INTO serve VALUES (3, 'UFRN', 3, 'A003', DATE '2025-01-16', '12:00', NULL); -- saldo: 40-13=27
INSERT INTO serve VALUES (3, 'UFRN', 8, 'A003', DATE '2025-01-17', '12:00', 3);  -- saldo: 27-13.50=13.50, brinde: Kit Escolar

-- A004 come 4 refeições (saldo alto)
INSERT INTO serve VALUES (4, 'UFC',  1, 'A004', DATE '2025-01-21', '12:00', NULL); -- saldo: 75-14=61
INSERT INTO serve VALUES (4, 'UFC',  5, 'A004', DATE '2025-02-11', '12:00', 4);  -- saldo: 61-11=50, brinde: Vale Sobremesa
INSERT INTO serve VALUES (4, 'UFC',  7, 'A004', DATE '2025-02-12', '19:00', NULL); -- saldo: 50-15=35
INSERT INTO serve VALUES (4, 'UFC',  4, 'A004', DATE '2025-02-13', '15:30', NULL); -- saldo: 35-8=27

-- A005 come 1 refeição (saldo baixo = 20, só consegue refeições baratas)
INSERT INTO serve VALUES (5, 'UFAL', 6, 'A005', DATE '2025-01-23', '15:00', NULL); -- saldo: 20-7.50=12.50
-- A005 tenta comer refeição de R$14 mas saldo=12.50 → TR2 bloquearia
-- (não inserido para não causar erro; cenário documentado abaixo)

-- A006 come 5 refeições (maior consumidor)
INSERT INTO serve VALUES (1, 'UFPE', 1, 'A006', DATE '2025-01-26', '12:00', 1);  -- saldo: 90-14=76, brinde: Caneca RU
INSERT INTO serve VALUES (1, 'UFPE', 2, 'A006', DATE '2025-01-27', '18:30', NULL); -- saldo: 76-12.50=63.50
INSERT INTO serve VALUES (1, 'UFPE', 3, 'A006', DATE '2025-01-28', '12:00', NULL); -- saldo: 63.50-13=50.50
INSERT INTO serve VALUES (1, 'UFPE', 7, 'A006', DATE '2025-02-01', '19:00', 4);  -- saldo: 50.50-15=35.50, brinde: Vale Sobremesa
INSERT INTO serve VALUES (1, 'UFPE', 8, 'A006', DATE '2025-02-02', '12:00', NULL); -- saldo: 35.50-13.50=22

-- A007 come 2 refeições
INSERT INTO serve VALUES (2, 'UFPB', 4, 'A007', DATE '2025-02-02', '15:00', NULL); -- saldo: 35-8=27
INSERT INTO serve VALUES (2, 'UFPB', 6, 'A007', DATE '2025-02-03', '15:30', 2);  -- saldo: 27-7.50=19.50, brinde: Camiseta UFPE

-- A008 come 3 refeições
INSERT INTO serve VALUES (3, 'UFRN', 1, 'A008', DATE '2025-02-04', '12:00', NULL); -- saldo: 55-14=41
INSERT INTO serve VALUES (3, 'UFRN', 5, 'A008', DATE '2025-02-05', '12:00', 3);  -- saldo: 41-11=30, brinde: Kit Escolar
INSERT INTO serve VALUES (3, 'UFRN', 2, 'A008', DATE '2025-02-06', '18:30', NULL); -- saldo: 30-12.50=17.50

-- A009 come 3 refeições
INSERT INTO serve VALUES (4, 'UFC',  4, 'A009', DATE '2025-02-07', '15:00', NULL); -- saldo: 55-8=47
INSERT INTO serve VALUES (4, 'UFC',  6, 'A009', DATE '2025-02-08', '15:30', NULL); -- saldo: 47-7.50=39.50
INSERT INTO serve VALUES (4, 'UFC',  8, 'A009', DATE '2025-02-16', '12:00', 1);  -- saldo: 39.50-13.50=26, brinde: Caneca RU

-- A010 come 2 refeições
INSERT INTO serve VALUES (5, 'UFAL', 1, 'A010', DATE '2025-02-09', '12:00', NULL); -- saldo: 45-14=31
INSERT INTO serve VALUES (5, 'UFAL', 3, 'A010', DATE '2025-02-10', '12:30', 3);  -- saldo: 31-13=18, brinde: Kit Escolar


-- ============================================================
--  COMMIT
-- ============================================================
COMMIT;

-- ============================================================
--  SALDOS FINAIS ESPERADOS (para conferência)
-- ============================================================
-- A001 → 80.00 - 14.00 - 12.50 - 11.00 - 15.00          = 27.50
-- A002 → 60.00 - 13.00 - 14.00 -  7.50                   = 25.50
-- A003 → 40.00 - 13.00 - 13.50                            = 13.50
-- A004 → 75.00 - 14.00 - 11.00 - 15.00 -  8.00           = 27.00
-- A005 → 20.00 -  7.50                                    = 12.50
-- A006 → 90.00 - 14.00 - 12.50 - 13.00 - 15.00 - 13.50  = 22.00
-- A007 → 35.00 -  8.00 -  7.50                            = 19.50
-- A008 → 55.00 - 14.00 - 11.00 - 12.50                   = 17.50
-- A009 → 55.00 -  8.00 -  7.50 - 13.50                   = 26.00
-- A010 → 45.00 - 14.00 - 13.00                            = 18.00

-- Consulta de verificação:
-- SELECT cpf, nome, saldo FROM aluno ORDER BY cpf;
