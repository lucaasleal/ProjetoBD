-- ============================================================
--      RESTAURANTE UNIVERSITÁRIO — CRIAÇÃO DE TABELAS
-- ============================================================

-- ------------------------------------------------------------
-- 1. EMPRESA
-- ------------------------------------------------------------
CREATE TABLE empresa (
    id NUMBER GENERATED ALWAYS AS IDENTITY
);

-- ------------------------------------------------------------
-- 2. UNIVERSIDADE
-- ------------------------------------------------------------
CREATE TABLE universidade (
    sigla  VARCHAR2(4)   NOT NULL,
    campus VARCHAR2(100) NOT NULL-- ============================================================
--  FIM DO SCRIPT
-- ============================================================
);

-- ------------------------------------------------------------
-- 3. ALUNO
-- saldo gerenciado por triggers
-- ------------------------------------------------------------
CREATE TABLE aluno (
    cpf        CHAR(4)        NOT NULL,
    matricula  VARCHAR2(4)    NOT NULL UNIQUE,
    nome       VARCHAR2(100)  NOT NULL,
    saldo      NUMBER(5,2)    DEFAULT 0 NOT NULL,
    tel_ddd    CHAR(2)        NOT NULL,
    tel_numero VARCHAR2(9)    NOT NULL
);

-- ------------------------------------------------------------
-- 4. RESTAURANTE
-- ------------------------------------------------------------
CREATE TABLE restaurante (
    id_restaurante NUMBER GENERATED ALWAYS AS IDENTITY,
    sigla          VARCHAR2(4)  NOT NULL,
    id_empresa     NUMBER       NOT NULL
);

-- ------------------------------------------------------------
-- 5. FUNCIONARIO
-- ------------------------------------------------------------
CREATE TABLE funcionario (
    cpf            CHAR(4)       NOT NULL,
    nome           VARCHAR2(100) NOT NULL,
    cpf_chefe      CHAR(4),
    id_restaurante NUMBER        NOT NULL,
    sigla          VARCHAR2(4)   NOT NULL
);

-- ------------------------------------------------------------
-- 6. PAGAMENTO
-- ------------------------------------------------------------
CREATE TABLE pagamento (
    num_nota_fiscal NUMBER GENERATED ALWAYS AS IDENTITY,
    valor           NUMBER(10,2)  NOT NULL,
    data            DATE          NOT NULL,
    id_restaurante  NUMBER        NOT NULL,
    sigla           VARCHAR2(4)   NOT NULL,
    cpf_aluno       CHAR(4)       NOT NULL
);

-- ------------------------------------------------------------
-- 7. SETOR
-- ------------------------------------------------------------
CREATE TABLE setor (
    cod  NUMBER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR2(100) NOT NULL
);

-- ------------------------------------------------------------
-- 8. EQUIPAMENTOS
-- ------------------------------------------------------------
CREATE TABLE equipamentos (
    cod_setor    NUMBER        NOT NULL,
    equipamentos VARCHAR2(200) NOT NULL
);

-- ------------------------------------------------------------
-- 9. ZELADOR  (especialização de funcionario)
-- ------------------------------------------------------------
CREATE TABLE zelador (
    cpf CHAR(4) NOT NULL
);

-- atributo multivalorado cod_setor → tabela associativa
CREATE TABLE zelador_setor (
    cpf_zelador CHAR(4) NOT NULL,
    cod_setor   NUMBER  NOT NULL
);

-- ------------------------------------------------------------
-- 10. COZINHEIRO  (especialização de funcionario)
-- ------------------------------------------------------------
CREATE TABLE cozinheiro (
    cpf           CHAR(4)      NOT NULL,
    especialidade VARCHAR2(30) NOT NULL
);

-- ------------------------------------------------------------
-- 11. REFEICAO
-- ------------------------------------------------------------
CREATE TABLE refeicao (
    cod       NUMBER GENERATED ALWAYS AS IDENTITY,
    bebida    VARCHAR2(30),
    proteina  VARCHAR2(30),
    guarnicao VARCHAR2(30),
    entrada   VARCHAR2(30),
    tipo      VARCHAR2(30)  NOT NULL,
    valor     NUMBER(5,2)   NOT NULL
);

-- ------------------------------------------------------------
-- 12. PREPARA  (cozinheiro ↔ refeicao)
-- ------------------------------------------------------------
CREATE TABLE prepara (
    cpf_cozinheiro CHAR(4) NOT NULL,
    cod_refeicao   NUMBER  NOT NULL
);

-- ------------------------------------------------------------
-- 13. BRINDE
-- ------------------------------------------------------------
CREATE TABLE brinde (
    cod  NUMBER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR2(30) NOT NULL
);

-- ------------------------------------------------------------
-- 14. SERVE
-- ------------------------------------------------------------
CREATE TABLE serve (
    id_restaurante NUMBER       NOT NULL,
    sigla          VARCHAR2(4)  NOT NULL,
    cod_refeicao   NUMBER       NOT NULL,
    cpf_aluno      CHAR(4)      NOT NULL,
    data           DATE         NOT NULL,
    hora           VARCHAR2(5)  NOT NULL,
    cod_brinde     NUMBER
);


-- ============================================================
--  TRIGGERS — Gerenciamento de saldo do aluno
-- ============================================================

-- ------------------------------------------------------------
-- TR 1 — Adicionar saldo ao inserir um pagamento
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER tr_adicionar_saldo
AFTER INSERT ON pagamento
FOR EACH ROW
BEGIN
    UPDATE aluno
    SET    saldo = saldo + :NEW.valor
    WHERE  cpf   = :NEW.cpf_aluno;
END;
/

-- ------------------------------------------------------------
-- TR 2 — Subtrair saldo ao registrar uma refeição servida
--         Impede o consumo caso o saldo seja insuficiente
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER tr_subtrair_saldo
BEFORE INSERT ON serve
FOR EACH ROW
DECLARE
    v_valor_refeicao NUMBER(5,2);
    v_saldo_atual    NUMBER(5,2);
BEGIN
    SELECT valor INTO v_valor_refeicao
    FROM   refeicao
    WHERE  cod = :NEW.cod_refeicao;

    SELECT saldo INTO v_saldo_atual
    FROM   aluno
    WHERE  cpf = :NEW.cpf_aluno;

    IF v_saldo_atual < v_valor_refeicao THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Saldo insuficiente para o aluno CPF ' || :NEW.cpf_aluno ||
            '. Saldo: R$ ' || v_saldo_atual ||
            ', Valor da refeicao: R$ ' || v_valor_refeicao
        );
    END IF;

    UPDATE aluno
    SET    saldo = saldo - v_valor_refeicao
    WHERE  cpf   = :NEW.cpf_aluno;
END;
/
