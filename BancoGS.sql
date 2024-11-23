DROP TABLE trocas_recompensas CASCADE CONSTRAINTS;
DROP TABLE historico_pontos CASCADE CONSTRAINTS;
DROP TABLE consumo_energia CASCADE CONSTRAINTS;
DROP TABLE residencia CASCADE CONSTRAINTS;
DROP TABLE recompensas CASCADE CONSTRAINTS;
DROP TABLE tipo_eletrodomestico CASCADE CONSTRAINTS;
DROP TABLE endereco CASCADE CONSTRAINTS;
DROP TABLE usuarios CASCADE CONSTRAINTS;
DROP TABLE auditoria CASCADE CONSTRAINTS;
DROP SEQUENCE SEQ_AUDITORIA;

CREATE TABLE usuarios (
    id_usuarios INTEGER NOT NULL,
    nome        VARCHAR2(50) NOT NULL,
    senha       CHAR(11) NOT NULL,
    telefone    VARCHAR2(14),
    pontos      NUMBER(10, 2) NOT NULL
);

ALTER TABLE usuarios ADD CONSTRAINT usuarios_pk PRIMARY KEY ( id_usuarios );

CREATE TABLE tipo_eletrodomestico (
    id_eletrodomestico   INTEGER NOT NULL,
    nome_eletrodomestico VARCHAR2(50) NOT NULL,
    quantidade           NUMBER(10, 2) NOT NULL
);

ALTER TABLE tipo_eletrodomestico ADD CONSTRAINT tipo_eletrodomestico_pk PRIMARY KEY ( id_eletrodomestico );

CREATE TABLE endereco (
    id_endereco INTEGER NOT NULL,
    cep         CHAR(9) NOT NULL,
    rua         VARCHAR2(100) NOT NULL,
    numero      VARCHAR2(10) NOT NULL,
    complemento VARCHAR2(50)
);

ALTER TABLE endereco ADD CONSTRAINT endereco_pk PRIMARY KEY ( id_endereco );

CREATE TABLE recompensas (
    id_recompensas     INTEGER NOT NULL,
    descricao          VARCHAR2(100),
    pontos_necessarios NUMBER(10, 2)
);

ALTER TABLE recompensas ADD CONSTRAINT recompensas_pk PRIMARY KEY ( id_recompensas );

CREATE TABLE residencia (
    id_residencia             INTEGER NOT NULL,
    dispositivo_monitoramento VARCHAR2(50) NOT NULL,
    quantidade_pessoas        INTEGER NOT NULL,
    media_consumo             NUMBER(10, 2) NOT NULL,
    id_usuarios               INTEGER NOT NULL,
    id_eletrodomestico        INTEGER NOT NULL,
    id_endereco               INTEGER NOT NULL
);

ALTER TABLE residencia ADD CONSTRAINT residencia_pk PRIMARY KEY ( id_residencia );

ALTER TABLE residencia
    ADD CONSTRAINT endereco_fk FOREIGN KEY ( id_endereco )
        REFERENCES endereco ( id_endereco );


ALTER TABLE residencia
    ADD CONSTRAINT tipo_eletrodomestico_fk FOREIGN KEY ( id_eletrodomestico )
        REFERENCES tipo_eletrodomestico ( id_eletrodomestico );

ALTER TABLE residencia
    ADD CONSTRAINT usuarios_fk FOREIGN KEY ( id_usuarios )
        REFERENCES usuarios ( id_usuarios );

CREATE TABLE consumo_energia (
    id_consumo    INTEGER NOT NULL,
    data_consumo  DATE,
    consumo       NUMBER(10, 2),
    id_residencia INTEGER NOT NULL
);

ALTER TABLE consumo_energia ADD CONSTRAINT consumo_energia_pk PRIMARY KEY ( id_consumo );

ALTER TABLE consumo_energia
    ADD CONSTRAINT residencia_fk FOREIGN KEY ( id_residencia )
        REFERENCES residencia ( id_residencia );
        
CREATE TABLE historico_pontos (
    id_historico   INTEGER NOT NULL,
    data_historico DATE,
    quantidade     NUMBER(10, 2),
    id_usuarios    INTEGER NOT NULL
);

ALTER TABLE historico_pontos ADD CONSTRAINT historico_pontos_pk PRIMARY KEY ( id_historico );

ALTER TABLE historico_pontos
    ADD CONSTRAINT hp_usuarios_fk FOREIGN KEY ( id_usuarios )
        REFERENCES usuarios ( id_usuarios );

CREATE TABLE trocas_recompensas (
    id_trocas         INTEGER NOT NULL,
    data_troca        DATE,
    pontos_utilizados NUMBER(10, 2),
    id_recompensas    INTEGER NOT NULL,
    id_usuarios       INTEGER NOT NULL
);

ALTER TABLE trocas_recompensas ADD CONSTRAINT trocas_recompensas_pk PRIMARY KEY ( id_trocas );

ALTER TABLE trocas_recompensas
    ADD CONSTRAINT recompensas_fk FOREIGN KEY ( id_recompensas )
        REFERENCES recompensas ( id_recompensas );

ALTER TABLE trocas_recompensas
    ADD CONSTRAINT tr_usuarios_fk FOREIGN KEY ( id_usuarios )
        REFERENCES usuarios ( id_usuarios );
        
        
/        
SET SERVEROUTPUT ON;
--> 1.Procedures para realizar os inserts no banco de dados  
CREATE OR REPLACE PROCEDURE inserir_usuario(
    p_id_usuarios IN usuarios.id_usuarios%TYPE,
    p_nome IN usuarios.nome%TYPE,
    p_senha IN usuarios.senha%TYPE,
    p_telefone IN usuarios.telefone%TYPE,
    p_pontos IN usuarios.pontos%TYPE
) AS
BEGIN
    INSERT INTO usuarios (id_usuarios, nome, senha, telefone, pontos)
    VALUES (p_id_usuarios, p_nome, p_senha, p_telefone, p_pontos);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe um usuário com este ID.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor inválido foi fornecido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir usuário: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE inserir_tipo_eletrodomestico(
    p_id_eletrodomestico IN tipo_eletrodomestico.id_eletrodomestico%TYPE,
    p_nome_eletrodomestico IN tipo_eletrodomestico.nome_eletrodomestico%TYPE,
    p_quantidade IN tipo_eletrodomestico.quantidade%TYPE
) AS
BEGIN
    INSERT INTO tipo_eletrodomestico (id_eletrodomestico, nome_eletrodomestico, quantidade)
    VALUES (p_id_eletrodomestico, p_nome_eletrodomestico, p_quantidade);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Eletrodoméstico já cadastrado com este ID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir eletrodoméstico: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE inserir_endereco(
    p_id_endereco IN endereco.id_endereco%TYPE,
    p_cep IN endereco.cep%TYPE,
    p_rua IN endereco.rua%TYPE,
    p_numero IN endereco.numero%TYPE,
    p_complemento IN endereco.complemento%TYPE
) AS
BEGIN
    INSERT INTO endereco (id_endereco, cep, rua, numero, complemento)
    VALUES (p_id_endereco, p_cep, p_rua, p_numero, p_complemento);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe um endereço com este ID.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor inválido foi fornecido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir endereço: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE inserir_recompensa(
    p_id_recompensas IN recompensas.id_recompensas%TYPE,
    p_descricao IN recompensas.descricao%TYPE,
    p_pontos_necessarios IN recompensas.pontos_necessarios%TYPE
) AS
BEGIN
    INSERT INTO recompensas (id_recompensas, descricao, pontos_necessarios)
    VALUES (p_id_recompensas, p_descricao, p_pontos_necessarios);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe uma recompensa com este ID.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor inválido para pontos necessários.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir recompensa: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE inserir_residencia(
    p_id_residencia IN residencia.id_residencia%TYPE,
    p_dispositivo_monitoramento IN residencia.dispositivo_monitoramento%TYPE,
    p_quantidade_pessoas IN residencia.quantidade_pessoas%TYPE,
    p_media_consumo IN residencia.media_consumo%TYPE,
    p_id_usuarios IN residencia.id_usuarios%TYPE,
    p_id_eletrodomestico IN residencia.id_eletrodomestico%TYPE,
    p_id_endereco IN residencia.id_endereco%TYPE
) AS
BEGIN
    INSERT INTO residencia (id_residencia, dispositivo_monitoramento, quantidade_pessoas, media_consumo, id_usuarios, id_eletrodomestico, id_endereco)
    VALUES (p_id_residencia, p_dispositivo_monitoramento, p_quantidade_pessoas, p_media_consumo, p_id_usuarios, p_id_eletrodomestico, p_id_endereco);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Residência já cadastrada com este ID.');
     WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor inválido para media.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir residência: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE inserir_consumo_energia(
    p_id_consumo IN consumo_energia.id_consumo%TYPE,
    p_data_consumo IN consumo_energia.data_consumo%TYPE,
    p_consumo IN consumo_energia.consumo%TYPE,
    p_id_residencia IN consumo_energia.id_residencia%TYPE
) AS
BEGIN
    INSERT INTO consumo_energia (id_consumo, data_consumo, consumo, id_residencia)
    VALUES (p_id_consumo, p_data_consumo, p_consumo, p_id_residencia);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe um registro de consumo com este ID.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: consumo não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir consumo de energia: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE inserir_historico_pontos(
    p_id_historico IN historico_pontos.id_historico%TYPE,
    p_data_historico IN historico_pontos.data_historico%TYPE,
    p_quantidade IN historico_pontos.quantidade%TYPE,
    p_id_usuarios IN historico_pontos.id_usuarios%TYPE
) AS
BEGIN
    INSERT INTO historico_pontos (id_historico, data_historico, quantidade, id_usuarios)
    VALUES (p_id_historico, p_data_historico, p_quantidade, p_id_usuarios);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe um histórico com este ID.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Usuário associado não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir histórico de pontos: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE inserir_troca_recompensa(
    p_id_troca IN trocas_recompensas.id_trocas%TYPE,
    p_data_troca IN trocas_recompensas.data_troca%TYPE,
    p_pontos_utilizados IN trocas_recompensas.pontos_utilizados%TYPE,
    p_id_recompensas IN trocas_recompensas.id_recompensas%TYPE,
    p_id_usuarios IN trocas_recompensas.id_usuarios%TYPE
) AS
BEGIN
    INSERT INTO trocas_recompensas (id_trocas, data_troca, pontos_utilizados, id_recompensas, id_usuarios)
    VALUES (p_id_troca, p_data_troca, p_pontos_utilizados, p_id_recompensas, p_id_usuarios);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe uma troca com este ID.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Usuário ou recompensa associada não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir troca de recompensa: ' || SQLERRM);
END;
/

--> gatilho que após ter inserção de dados na tabela de trocas, vai ter verificação de pontos do usuario, e atualização dos seus pontos e do seu histórico de pontos
CREATE OR REPLACE TRIGGER trg_atualizar_pontos_usuarios
AFTER INSERT ON trocas_recompensas
FOR EACH ROW
DECLARE
    v_pontos_usuario NUMBER(10, 2);
BEGIN
    SELECT pontos INTO v_pontos_usuario
    FROM usuarios
    WHERE id_usuarios = :NEW.id_usuarios;

    IF v_pontos_usuario >= :NEW.pontos_utilizados THEN
        UPDATE usuarios
        SET pontos = pontos - :NEW.pontos_utilizados
        WHERE id_usuarios = :NEW.id_usuarios;

        UPDATE historico_pontos
        SET quantidade = v_pontos_usuario - :NEW.pontos_utilizados, 
            data_historico = SYSDATE  
        WHERE id_usuarios = :NEW.id_usuarios;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Pontos insuficientes para realizar a troca.');
    END IF;
END;
/

--> Para cada tabela criar uma trigger de auditoria das transações da tabela
CREATE TABLE auditoria (
    id_auditoria   INTEGER PRIMARY KEY,
    tabela         VARCHAR2(50),
    tipo_acao      VARCHAR2(20),
    data_acao      DATE,
    usuario        VARCHAR2(30), 
    dados_antigos  CLOB,        
    dados_novos    CLOB          
);
/
CREATE SEQUENCE SEQ_AUDITORIA
START WITH 1
INCREMENT BY 1
NOCACHE;
/
CREATE OR REPLACE TRIGGER trg_auditoria_usuarios
AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW
DECLARE
    v_dados_antigos CLOB;
    v_dados_novos   CLOB;
    v_tipo_acao     VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_tipo_acao := 'INSERT';
        v_dados_novos := 'ID: ' || :NEW.id_usuarios || ', Nome: ' || :NEW.nome || ', Senha: ' || :NEW.senha || ', Telefone: ' || :NEW.telefone 
        || ', Pontos: ' || :NEW.pontos;
    ELSIF UPDATING THEN
        v_tipo_acao := 'UPDATE';
        v_dados_antigos := 'ID: ' || :OLD.id_usuarios || ', Nome: ' || :OLD.nome ||', Senha: ' || :OLD.senha || ', Telefone: ' || :OLD.telefone 
        ||', Pontos: ' || :OLD.pontos;
        v_dados_novos := 'ID: ' || :NEW.id_usuarios || ', Nome: ' || :NEW.nome || ', Senha: ' || :NEW.senha || ', Telefone: ' || :NEW.telefone || 
                         ', Pontos: ' || :NEW.pontos;
    ELSIF DELETING THEN
        v_tipo_acao := 'DELETE';
        v_dados_antigos := 'ID: ' || :OLD.id_usuarios || ', Nome: ' || :OLD.nome || ', Senha: ' || :OLD.senha || ', Telefone: ' || :OLD.telefone || 
                           ', Pontos: ' || :OLD.pontos;
    END IF;

    INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
    VALUES ( SEQ_AUDITORIA.NEXTVAL, 'usuarios',  v_tipo_acao, SYSDATE, USER, v_dados_antigos, v_dados_novos);
END;
/

CREATE OR REPLACE TRIGGER trg_auditoria_tipo_eletrodomestico
AFTER INSERT OR UPDATE OR DELETE ON tipo_eletrodomestico
FOR EACH ROW
DECLARE
    v_dados_antigos CLOB;
    v_dados_novos   CLOB;
    v_tipo_acao     VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_tipo_acao := 'INSERT';
        v_dados_novos := 'ID: ' || :NEW.id_eletrodomestico || ', Nome: ' || :NEW.nome_eletrodomestico ||', Quantidade: ' || :NEW.quantidade;
    ELSIF UPDATING THEN
        v_tipo_acao := 'UPDATE';
        v_dados_antigos := 'ID: ' || :OLD.id_eletrodomestico || ', Nome: ' || :OLD.nome_eletrodomestico || ', Quantidade: ' || :OLD.quantidade;
        v_dados_novos := 'ID: ' || :NEW.id_eletrodomestico || ', Nome: ' || :NEW.nome_eletrodomestico || ', Quantidade: ' || :NEW.quantidade;
    ELSIF DELETING THEN
        v_tipo_acao := 'DELETE';
        v_dados_antigos := 'ID: ' || :OLD.id_eletrodomestico || ', Nome: ' || :OLD.nome_eletrodomestico || ', Quantidade: ' || :OLD.quantidade;
    END IF;

    INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
    VALUES (  SEQ_AUDITORIA.NEXTVAL, 'tipo_eletrodomestico', v_tipo_acao, SYSDATE, USER, v_dados_antigos,  v_dados_novos);
END;
/

CREATE OR REPLACE TRIGGER trg_auditoria_endereco
AFTER INSERT OR UPDATE OR DELETE ON endereco
FOR EACH ROW
DECLARE
    v_dados_antigos CLOB;
    v_dados_novos   CLOB;
    v_tipo_acao     VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_tipo_acao := 'INSERT';
        v_dados_novos := 'ID: ' || :NEW.id_endereco || ', CEP: ' || :NEW.cep ||  ', Rua: ' || :NEW.rua || ', Número: ' || :NEW.numero ||  ', Complemento: ' || :NEW.complemento;
    ELSIF UPDATING THEN
        v_tipo_acao := 'UPDATE';
        v_dados_antigos := 'ID: ' || :OLD.id_endereco || ', CEP: ' || :OLD.cep ||  ', Rua: ' || :OLD.rua || ', Número: ' || :OLD.numero || 
                           ', Complemento: ' || :OLD.complemento;
        v_dados_novos := 'ID: ' || :NEW.id_endereco || ', CEP: ' || :NEW.cep ||  ', Rua: ' || :NEW.rua || ', Número: ' || :NEW.numero || 
                         ', Complemento: ' || :NEW.complemento;
    ELSIF DELETING THEN
        v_tipo_acao := 'DELETE';
        v_dados_antigos := 'ID: ' || :OLD.id_endereco || ', CEP: ' || :OLD.cep || 
                           ', Rua: ' || :OLD.rua || ', Número: ' || :OLD.numero || 
                           ', Complemento: ' || :OLD.complemento;
    END IF;

    INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
    VALUES (  SEQ_AUDITORIA.NEXTVAL,  'endereco', v_tipo_acao, SYSDATE, USER, v_dados_antigos, v_dados_novos );
END;
/
CREATE OR REPLACE TRIGGER trg_auditoria_recompensas
AFTER INSERT OR UPDATE OR DELETE ON recompensas
FOR EACH ROW
DECLARE
    v_dados_antigos CLOB;
    v_dados_novos   CLOB;
    v_tipo_acao     VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_tipo_acao := 'INSERT';
        v_dados_novos := 'ID: ' || :NEW.id_recompensas || ', Descrição: ' || :NEW.descricao ||  ', Pontos Necessários: ' || :NEW.pontos_necessarios;
    ELSIF UPDATING THEN
        v_tipo_acao := 'UPDATE';
        v_dados_antigos := 'ID: ' || :OLD.id_recompensas || ', Descrição: ' || :OLD.descricao ||  ', Pontos Necessários: ' || :OLD.pontos_necessarios;
        v_dados_novos := 'ID: ' || :NEW.id_recompensas || ', Descrição: ' || :NEW.descricao ||   ', Pontos Necessários: ' || :NEW.pontos_necessarios;
    ELSIF DELETING THEN
        v_tipo_acao := 'DELETE';
        v_dados_antigos := 'ID: ' || :OLD.id_recompensas || ', Descrição: ' || :OLD.descricao ||  ', Pontos Necessários: ' || :OLD.pontos_necessarios;
    END IF;

    INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
    VALUES ( SEQ_AUDITORIA.NEXTVAL, 'recompensas',  v_tipo_acao, SYSDATE, USER, v_dados_antigos,   v_dados_novos);
END;
/
CREATE OR REPLACE TRIGGER trg_auditoria_residencia
AFTER INSERT OR UPDATE OR DELETE ON residencia
FOR EACH ROW
DECLARE
    v_dados_antigos CLOB;
    v_dados_novos   CLOB;
    v_tipo_acao     VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_tipo_acao := 'INSERT';
        v_dados_novos := 'ID: ' || :NEW.id_residencia || ', ID Usuário: ' || :NEW.id_usuarios ||   ', Endereço: ' || :NEW.id_endereco;
    ELSIF UPDATING THEN
        v_tipo_acao := 'UPDATE';
        v_dados_antigos := 'ID: ' || :OLD.id_residencia || ', ID Usuário: ' || :OLD.id_usuarios ||  ', Endereço: ' || :OLD.id_endereco;
        v_dados_novos := 'ID: ' || :NEW.id_residencia || ', ID Usuário: ' || :NEW.id_usuarios ||  ', Endereço: ' || :NEW.id_endereco;
    ELSIF DELETING THEN
        v_tipo_acao := 'DELETE';
        v_dados_antigos := 'ID: ' || :OLD.id_residencia || ', ID Usuário: ' || :OLD.id_usuarios ||  ', Endereço: ' || :OLD.id_endereco;
    END IF;

    INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
    VALUES ( SEQ_AUDITORIA.NEXTVAL, 'residencia',  v_tipo_acao, SYSDATE, USER, v_dados_antigos, v_dados_novos );
END;
/
CREATE OR REPLACE TRIGGER TRG_AUDITORIA_CONSUMO_ENERGIA
AFTER INSERT OR UPDATE OR DELETE ON consumo_energia
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES (SEQ_AUDITORIA.NEXTVAL, 'CONSUMO_ENERGIA','INSERT',SYSDATE, USER,
            NULL,'ID_RESIDENCIA=' || :NEW.id_residencia || ', DATA_CONSUMO=' || TO_CHAR(:NEW.data_consumo, 'DD/MM/YYYY') || 
            ', CONSUMO=' || :NEW.consumo );
    ELSIF UPDATING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES ( SEQ_AUDITORIA.NEXTVAL,'CONSUMO_ENERGIA', 'UPDATE',SYSDATE,
            USER, 'ID_RESIDENCIA=' || :OLD.id_residencia || 
            ', DATA_CONSUMO=' || TO_CHAR(:OLD.data_consumo, 'DD/MM/YYYY') ||  ', CONSUMO=' || :OLD.consumo,
            'ID_RESIDENCIA=' || :NEW.id_residencia ||  ', DATA_CONSUMO=' || TO_CHAR(:NEW.data_consumo, 'DD/MM/YYYY') || 
            ', CONSUMO=' || :NEW.consumo );
    ELSIF DELETING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES (SEQ_AUDITORIA.NEXTVAL, 'CONSUMO_ENERGIA','DELETE',SYSDATE,USER, 'ID_RESIDENCIA=' || :OLD.id_residencia || 
            ', DATA_CONSUMO=' || TO_CHAR(:OLD.data_consumo, 'DD/MM/YYYY') || ', CONSUMO=' || :OLD.consumo, NULL );
    END IF;
END;
/
CREATE OR REPLACE TRIGGER TRG_AUDITORIA_HISTORICO_PONTOS
AFTER INSERT OR UPDATE OR DELETE ON historico_pontos
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES ( SEQ_AUDITORIA.NEXTVAL,  'HISTORICO_PONTOS', 'INSERT', SYSDATE,  USER,
            NULL,  'ID_HISTORICO=' || :NEW.ID_HISTORICO || ', QUANTIDADE=' || :NEW.QUANTIDADE ||  ', ID_USUARIOS=' || :NEW.ID_USUARIOS || 
            ', DATA_HISTORICO=' || TO_CHAR(:NEW.DATA_HISTORICO, 'DD/MM/YYYY')  );
    ELSIF UPDATING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES (
            SEQ_AUDITORIA.NEXTVAL,
            'HISTORICO_PONTOS',
            'UPDATE',
            SYSDATE,
            USER,
            'ID_HISTORICO=' || :OLD.ID_HISTORICO || 
            ', QUANTIDADE=' || :OLD.QUANTIDADE || 
            ', ID_USUARIOS=' || :OLD.ID_USUARIOS || 
            ', DATA_HISTORICO=' || TO_CHAR(:OLD.DATA_HISTORICO, 'DD/MM/YYYY'),
            'ID_HISTORICO=' || :NEW.ID_HISTORICO || 
            ', QUANTIDADE=' || :NEW.QUANTIDADE || 
            ', ID_USUARIOS=' || :NEW.ID_USUARIOS || 
            ', DATA_HISTORICO=' || TO_CHAR(:NEW.DATA_HISTORICO, 'DD/MM/YYYY')
        );
    ELSIF DELETING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES ( SEQ_AUDITORIA.NEXTVAL, 'HISTORICO_PONTOS', 'DELETE',    SYSDATE, USER,
            'ID_HISTORICO=' || :OLD.ID_HISTORICO || ', QUANTIDADE=' || :OLD.QUANTIDADE || ', ID_USUARIOS=' || :OLD.ID_USUARIOS || 
            ', DATA_HISTORICO=' || TO_CHAR(:OLD.DATA_HISTORICO, 'DD/MM/YYYY'), NULL );
    END IF;
END;
/
CREATE OR REPLACE TRIGGER TRG_AUDITORIA_TROCAS_RECOMPENSAS
AFTER INSERT OR UPDATE OR DELETE ON trocas_recompensas
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES (  SEQ_AUDITORIA.NEXTVAL, 'TROCAS_RECOMPENSAS', 'INSERT',
            SYSDATE, USER, NULL,'ID_TROCAS=' || :NEW.ID_TROCAS || ', PONTOS_UTILIZADOS=' || :NEW.PONTOS_UTILIZADOS || 
            ', ID_RECOMPENSAS=' || :NEW.ID_RECOMPENSAS || 
            ', ID_USUARIOS=' || :NEW.ID_USUARIOS || 
            ', DATA_TROCA=' || TO_CHAR(:NEW.DATA_TROCA, 'DD/MM/YYYY')
        );
    ELSIF UPDATING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES (   SEQ_AUDITORIA.NEXTVAL,   'TROCAS_RECOMPENSAS', 'UPDATE', SYSDATE,
            USER,  'ID_TROCAS=' || :OLD.ID_TROCAS ||  ', PONTOS_UTILIZADOS=' || :OLD.PONTOS_UTILIZADOS || 
            ', ID_RECOMPENSAS=' || :OLD.ID_RECOMPENSAS ||  ', ID_USUARIOS=' || :OLD.ID_USUARIOS || 
            ', DATA_TROCA=' || TO_CHAR(:OLD.DATA_TROCA, 'DD/MM/YYYY'),'ID_TROCAS=' || :NEW.ID_TROCAS || 
            ', PONTOS_UTILIZADOS=' || :NEW.PONTOS_UTILIZADOS ||   ', ID_RECOMPENSAS=' || :NEW.ID_RECOMPENSAS || 
            ', ID_USUARIOS=' || :NEW.ID_USUARIOS ||  ', DATA_TROCA=' || TO_CHAR(:NEW.DATA_TROCA, 'DD/MM/YYYY')      );
    ELSIF DELETING THEN
        INSERT INTO auditoria (id_auditoria, tabela, tipo_acao, data_acao, usuario, dados_antigos, dados_novos)
        VALUES ( SEQ_AUDITORIA.NEXTVAL, 'TROCAS_RECOMPENSAS','DELETE',  SYSDATE,
            USER, 'ID_TROCAS=' || :OLD.ID_TROCAS ||', PONTOS_UTILIZADOS=' || :OLD.PONTOS_UTILIZADOS || 
            ', ID_RECOMPENSAS=' || :OLD.ID_RECOMPENSAS ||  ', ID_USUARIOS=' || :OLD.ID_USUARIOS || 
            ', DATA_TROCA=' || TO_CHAR(:OLD.DATA_TROCA, 'DD/MM/YYYY'),   NULL);
    END IF;
END;
/


--> Inserção de dados
BEGIN
    inserir_usuario(1, 'João Silva', '12345678900', '1987654', 300);
    inserir_usuario(2, 'Maria Oliveira', '23456789001', '116543', 550);
    inserir_usuario(3, 'Carlos Pereira', '34567890102', '115432', 400);
    inserir_usuario(4, 'Ana Souza', '45678901203', '119821', 500);
    inserir_usuario(5, 'Roberto Lima', '56789012304', '1192109', 650);
    inserir_usuario(6, 'Cláudia Santos', '67890123405', '1821098', 800);
    inserir_usuario(7, 'Pedro Costa', '78901234506', '1198985', 800);
    inserir_usuario(8, 'Patrícia Alves', '89012345607', '1107654', 180);
    inserir_usuario(9, 'Rafael Lima', '90123456708', '119543', 200);
    inserir_usuario(10, 'Juliana Ribeiro', '01234567809', '1165432', 900);
END;
/
BEGIN
    inserir_tipo_eletrodomestico(1, 'Geladeira', 2);
    inserir_tipo_eletrodomestico(2, 'Máquina de Lavar', 1);
    inserir_tipo_eletrodomestico(3, 'Microondas', 1);
    inserir_tipo_eletrodomestico(4, 'Ar Condicionado', 4);
    inserir_tipo_eletrodomestico(5, 'Televisão', 4);
    inserir_tipo_eletrodomestico(6, 'Fogão', 1);
    inserir_tipo_eletrodomestico(7, 'Secadora de Roupas', 1);
    inserir_tipo_eletrodomestico(8, 'Aspirador de Pó', 2);
    inserir_tipo_eletrodomestico(9, 'Máquina de Café', 2);
    inserir_tipo_eletrodomestico(10, 'Forno Elétrico', 1);
END;
/
BEGIN
    inserir_endereco(1, '12345-678', 'Av. Paulista', '1000', 'Apt. 101');
    inserir_endereco(2, '23456-789', 'Rua dos Três Irmãos', '250', 'Casa 12');
    inserir_endereco(3, '34567-890', 'Rua Sete de Setembro', '350', 'Apt. 202');
    inserir_endereco(4, '45678-901', 'Rua dos Três Rios', '410', 'Casa 8');
    inserir_endereco(5, '56789-012', 'Rua Amazonas', '500', 'Apt. 303');
    inserir_endereco(6, '67890-123', 'Rua da Consolação', '550', 'Casa 14');
    inserir_endereco(7, '78901-234', 'Av. Rio Branco', '600', 'Apt. 405');
    inserir_endereco(8, '89012-345', 'Rua Marquês de São Vicente', '700', 'Casa 15');
    inserir_endereco(9, '90123-456', 'Rua João Pessoa', '800', 'Apt. 506');
    inserir_endereco(10, '01234-567', 'Rua das Flores', '900', 'Casa 25');
END;
/
BEGIN
    inserir_residencia (1, 'Monitoramento 12323', 3, 450, 1, 1, 1); 
    inserir_residencia(2, 'Monitoramento 248', 4, 500, 2, 2, 2);
    inserir_residencia(3, 'Monitoramento 345', 2, 600, 3, 3, 3);
    inserir_residencia(4, 'Monitoramento 465', 5, 350, 4, 4, 4); 
    inserir_residencia(5, 'Monitoramento 775', 3, 400, 5, 5, 5);
    inserir_residencia(6, 'Monitoramento 645', 6, 500, 6, 6, 6);  
    inserir_residencia(7, 'Monitoramento 744', 4, 250, 7, 7, 7); 
    inserir_residencia(8, 'Monitoramento 888', 3, 550, 8, 8, 8); 
    inserir_residencia(9, 'Monitoramento 90', 2, 300, 9, 9, 9); 
    inserir_residencia(10, 'Monitoramento 100', 5, 700, 10, 10, 10); 
END;
/
BEGIN
    inserir_consumo_energia(1, TO_DATE('2024-10-01', 'YYYY-MM-DD'), 450, 1);
    inserir_consumo_energia(2, TO_DATE('2024-10-02', 'YYYY-MM-DD'), 300, 2);
    inserir_consumo_energia(3, TO_DATE('2024-10-03', 'YYYY-MM-DD'), 600, 3);
    inserir_consumo_energia(4, TO_DATE('2024-10-04', 'YYYY-MM-DD'), 350, 4);
    inserir_consumo_energia(5, TO_DATE('2024-10-05', 'YYYY-MM-DD'), 400, 5);
    inserir_consumo_energia(6, TO_DATE('2024-10-06', 'YYYY-MM-DD'), 500, 6);
    inserir_consumo_energia(7, TO_DATE('2024-10-07', 'YYYY-MM-DD'), 250, 7);
    inserir_consumo_energia(8, TO_DATE('2024-10-08', 'YYYY-MM-DD'), 550, 8);
    inserir_consumo_energia(9, TO_DATE('2024-10-09', 'YYYY-MM-DD'), 300, 9);
    inserir_consumo_energia(10, TO_DATE('2024-10-10', 'YYYY-MM-DD'), 700, 10);
END;
/
BEGIN
    inserir_recompensa(1, 'Desconto em Gás de Cozinha 10% - Ultragaz', -300);
    inserir_recompensa(2, 'Frete Grátis - Ultracargo', -500);
    inserir_recompensa(3, '15% em Cursos e Eventos - FIA', -200);
    inserir_recompensa(4, '1 Consultoria - SAP', -250);
    inserir_recompensa(5, ' 5% de desconto em Veículos e Equipamentos - Mahindra', -350);
    inserir_recompensa(6, 'Gás de Cozinha Gratuito - Ultragaz', -650);
    inserir_recompensa(7, 'Desconto em Transporte - Ultracargo', -500);
    inserir_recompensa(8, 'Voucher para Recarga de Gás - Ultragaz', -120);
    inserir_recompensa(9, 'Crédito para Upgrade de Equipamentos - Mahindra', -180);
    inserir_recompensa(10, 'Desconto em Transporte Internacional - Ultracargo', -700);
END;
/
BEGIN
    inserir_historico_pontos(1, SYSDATE, 300, 1);
    inserir_historico_pontos(2, SYSDATE, 550, 2);
    inserir_historico_pontos(3, SYSDATE, 400, 3);
    inserir_historico_pontos(4, SYSDATE, 500, 4);
    inserir_historico_pontos(5, SYSDATE, 650, 5);
    inserir_historico_pontos(6, SYSDATE, 800, 6);
    inserir_historico_pontos(7, SYSDATE, 800, 7);
    inserir_historico_pontos(8, SYSDATE, 180, 8);
    inserir_historico_pontos(9, SYSDATE, 200, 9);
    inserir_historico_pontos(10, SYSDATE, 900, 10);
END;
/
BEGIN
    inserir_troca_recompensa(1, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 300, 1, 1);
    inserir_troca_recompensa(2, TO_DATE('2024-11-02', 'YYYY-MM-DD'), 500, 2, 2);
    inserir_troca_recompensa(3, TO_DATE('2024-11-03', 'YYYY-MM-DD'), 200, 3, 3);
    inserir_troca_recompensa(4, TO_DATE('2024-11-04', 'YYYY-MM-DD'), 250, 4, 4);
    inserir_troca_recompensa(5, TO_DATE('2024-11-05', 'YYYY-MM-DD'), 350, 5, 5);
    inserir_troca_recompensa(6, TO_DATE('2024-11-06', 'YYYY-MM-DD'), 650, 6, 6);
    inserir_troca_recompensa(7, TO_DATE('2024-11-07', 'YYYY-MM-DD'), 500, 7, 7);
    inserir_troca_recompensa(8, TO_DATE('2024-11-08', 'YYYY-MM-DD'), 120, 8, 8);
    inserir_troca_recompensa(9, TO_DATE('2024-11-09', 'YYYY-MM-DD'), 180, 9, 9);
    inserir_troca_recompensa(10, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 700, 10, 10); 
END;
/

select * from usuarios;
select * from  historico_pontos;
select * from tipo_eletrodomestico;
select * from endereco;
select * from residencia;
select * from consumo_energia;
select * from recompensas;
select * from  historico_pontos;
select * from trocas_recompensas;
select * from auditoria;

SET SERVEROUTPUT ON;
-->  3. Empacotamento de Objetos de Banco de Dados
CREATE OR REPLACE PACKAGE pacote_validacao_consumo AS
--> Função 1: validacao de CEP
    FUNCTION validar_cep(p_cep IN VARCHAR2) RETURN VARCHAR2;
-->Funçao 2: função q calcula a media de consumo com base nos dados da tabela consumo_energia para uma residencia.
    FUNCTION calcular_media_consumo(p_id_residencia IN consumo_energia.id_residencia%TYPE) RETURN NUMBER;
--> Funçao 3: função verifica se o consumo do mês foi menor que a media. Se for, ganha pontos, senão, retorna nenhum ponto ganho
    FUNCTION verificar_consumo_abaixo_media(
        p_id_residencia IN consumo_energia.id_residencia%TYPE,
        p_mes IN NUMBER,
        p_ano IN NUMBER
    ) RETURN VARCHAR;
--> relatorio sobre o usuario
    PROCEDURE gerar_relatorio_usuario(p_id_usuario IN NUMBER);
END pacote_validacao_consumo;
/

CREATE OR REPLACE PACKAGE BODY pacote_validacao_consumo AS

    FUNCTION validar_cep(p_cep IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF REGEXP_LIKE(p_cep, '^\d{5}-\d{3}$') THEN
            RETURN 'CEP válido';
        ELSE
            RETURN 'CEP inválido. Deve estar no formato 12345-678';
        END IF;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RETURN 'Erro: O CEP não pode ser nulo ou vazio';
        WHEN OTHERS THEN
            RETURN 'Erro ao validar CEP: ' || SQLERRM;
    END validar_cep;

    FUNCTION calcular_media_consumo(p_id_residencia IN consumo_energia.id_residencia%TYPE) RETURN NUMBER IS
        v_media_consumo NUMBER;
    BEGIN
        SELECT AVG(consumo)
        INTO v_media_consumo
        FROM consumo_energia
        WHERE id_residencia = p_id_residencia;

        RETURN v_media_consumo;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro: Não foram encontrados dados para a residência com id ' || p_id_residencia);
     WHEN ZERO_DIVIDE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro: O cálculo da média resultou em divisão por zero.');     
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Erro desconhecido ao calcular a média de consumo: ' || SQLERRM);
END calcular_media_consumo;

    FUNCTION verificar_consumo_abaixo_media(
        p_id_residencia IN consumo_energia.id_residencia%TYPE,
        p_mes IN NUMBER,
        p_ano IN NUMBER
    ) RETURN VARCHAR IS
        v_media_consumo NUMBER;
        v_consumo_mes NUMBER;
    BEGIN
        v_media_consumo := calcular_media_consumo(p_id_residencia);
        SELECT SUM(consumo)
        INTO v_consumo_mes
        FROM consumo_energia
        WHERE id_residencia = p_id_residencia
          AND EXTRACT(MONTH FROM data_consumo) = p_mes
          AND EXTRACT(YEAR FROM data_consumo) = p_ano;
        
        IF v_consumo_mes < v_media_consumo THEN
            RETURN 'Consumo abaixo da média. Usuário ganhou 50 pontos!';
        ELSE
            RETURN 'Consumo acima da média. Nenhum ponto ganho.';
        END IF;
    EXCEPTION
       
        WHEN OTHERS THEN
            RETURN 'Erro ao verificar o consumo: ' || SQLERRM;
    END verificar_consumo_abaixo_media;

  PROCEDURE gerar_relatorio_usuario(p_id_usuario IN NUMBER) IS
        v_nome_usuario usuarios.nome%TYPE;
        v_cep endereco.cep%TYPE;
        v_pontos usuarios.pontos%TYPE;
        v_media_consumo residencia.media_consumo%TYPE;
        v_consumo_mes consumo_energia.consumo%TYPE;
    BEGIN
        SELECT nome, pontos
        INTO v_nome_usuario, v_pontos
        FROM usuarios
        WHERE id_usuarios = p_id_usuario;

        SELECT cep
        INTO v_cep
        FROM endereco e
        JOIN residencia r ON e.id_endereco = r.id_endereco
        WHERE r.id_residencia = (SELECT id_residencia FROM residencia WHERE id_usuarios = p_id_usuario);
        
        SELECT media_consumo
        INTO v_media_consumo
        FROM residencia
        WHERE id_usuarios = p_id_usuario;

        SELECT SUM(consumo)
        INTO v_consumo_mes
        FROM consumo_energia
        WHERE id_residencia = (SELECT id_residencia FROM residencia WHERE id_usuarios = p_id_usuario)
        AND EXTRACT(MONTH FROM data_consumo) = 10 
        AND EXTRACT(YEAR FROM data_consumo) = 2024; 

        DBMS_OUTPUT.PUT_LINE('Relatório do Usuário: ' || v_nome_usuario);
        DBMS_OUTPUT.PUT_LINE('CEP: ' || v_cep);
        DBMS_OUTPUT.PUT_LINE('Pontos: ' || v_pontos);
        DBMS_OUTPUT.PUT_LINE('Média de Consumo: ' || v_media_consumo);
        DBMS_OUTPUT.PUT_LINE('Consumo no mês de outubro: ' || v_consumo_mes);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum dado encontrado para o usuário especificado.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    END gerar_relatorio_usuario;
END pacote_validacao_consumo;
/

SELECT cep, pacote_validacao_consumo.validar_cep(cep) AS resultado_validacao FROM endereco;

SELECT pacote_validacao_consumo.calcular_media_consumo(1) FROM DUAL;

SELECT pacote_validacao_consumo.verificar_consumo_abaixo_media(1, 9, 2024) FROM DUAL;
/
BEGIN
    pacote_validacao_consumo.gerar_relatorio_usuario(1); 
END;
/


--> Pacote de exportação do json
SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE pacote_exportacao IS
    PROCEDURE exportar_dados_para_mongodb(p_json OUT CLOB);
END pacote_exportacao;
/

CREATE OR REPLACE PACKAGE BODY pacote_exportacao IS
    PROCEDURE exportar_dados_para_mongodb(p_json OUT CLOB) IS
        v_json_document CLOB;
        v_final_json CLOB := '['; 
        v_first BOOLEAN := TRUE;
    BEGIN
        FOR user_rec IN (
            SELECT json_object(
                'id' VALUE u.id_usuarios,
                'nome' VALUE u.nome,
                'telefone' VALUE u.telefone,
                'pontos' VALUE u.pontos,
                'residencias' VALUE (
                    SELECT json_arrayagg(
                        json_object(
                            'id_residencia' VALUE r.id_residencia,
                            'dispositivo_monitoramento' VALUE r.dispositivo_monitoramento,
                            'quantidade_pessoas' VALUE r.quantidade_pessoas,
                            'media_consumo' VALUE r.media_consumo,
                            'eletrodomesticos' VALUE json_object(
                                'nome_eletrodomestico' VALUE te.nome_eletrodomestico,
                                'quantidade' VALUE te.quantidade),
                            'consumo_energia' VALUE (
                                SELECT json_arrayagg(
                                    json_object(
                                        'id_consumo' VALUE ce.id_consumo,
                                        'data_consumo' VALUE TO_CHAR(ce.data_consumo, 'YYYY-MM-DD'),
                                        'consumo' VALUE ce.consumo ))
                                FROM consumo_energia ce
                                WHERE ce.id_residencia = r.id_residencia ) ))
                    FROM residencia r
                    JOIN tipo_eletrodomestico te ON r.id_eletrodomestico = te.id_eletrodomestico
                    WHERE r.id_usuarios = u.id_usuarios)) AS json_document
            FROM usuarios u
        ) LOOP
            IF NOT v_first THEN
                v_final_json := v_final_json || ',';
            END IF;

            v_json_document := user_rec.json_document;
            v_final_json := v_final_json || v_json_document;

            v_first := FALSE;
        END LOOP;
        v_final_json := v_final_json || ']';
        p_json := v_final_json;

        DBMS_OUTPUT.PUT_LINE('JSON gerado com sucesso.');
    END exportar_dados_para_mongodb;

END pacote_exportacao;
/
DECLARE
    v_json CLOB;
BEGIN
    pacote_exportacao.exportar_dados_para_mongodb(v_json);
    DBMS_OUTPUT.PUT_LINE(v_json);
END;
/

















