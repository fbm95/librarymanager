CREATE TABLE Client (
	id_client varchar2(40),
	nume varchar2(255),
	prenume varchar2(255),
	CNP varchar2(14),
	adresa varchar2(255)
);

CREATE TABLE Angajat (
	id_angajat varchar2(40),
	nume varchar2(255),
	prenume varchar2(255),
	functie varchar2(100),
	salariu number
);

CREATE TABLE Carte (
	id_carte varchar2(40),
	titlu varchar2(255),
	autor varchar2(255),
	editura varchar2(255),
	an_aparitie NUMBER,
	gen varchar2(255),
	valoare_inventar NUMBER,
	coef_multiplicare NUMBER,
	imprumutat NUMBER(1),
	imprumutabil NUMBER(1)
);

CREATE TABLE Imprumut (
	id_imprumut varchar2(40),
	id_carte varchar2(40),
	id_client varchar2(40),
	data_imprumut DATE,
	data_returnare DATE,
	returnat NUMBER(1)
);

ALTER TABLE CARTE ADD CONSTRAINT id_carte_pk PRIMARY KEY(id_carte);
ALTER TABLE ANGAJAT ADD CONSTRAINT id_angajat_pk PRIMARY KEY(id_angajat);
ALTER TABLE CLIENT ADD CONSTRAINT id_client_pk PRIMARY KEY(id_client);
ALTER TABLE IMPRUMUT ADD CONSTRAINT id_imprumut_pk PRIMARY KEY(id_imprumut);

ALTER TABLE CLIENT ADD CONSTRAINT cnp_unique UNIQUE(CNP);

ALTER TABLE CARTE ADD CONSTRAINT imprumutat_check_01 CHECK(imprumutat = 0 OR imprumutat = 1);
ALTER TABLE CARTE ADD CONSTRAINT imprumutabil_check_01 CHECK(imprumutabil = 0 OR imprumutabil = 1);
ALTER TABLE IMPRUMUT ADD CONSTRAINT returnat_check_01 CHECK(returnat = 0 OR returnat = 1);

ALTER TABLE IMPRUMUT ADD CONSTRAINT id_carte_fk FOREIGN KEY(id_carte) REFERENCES CARTE(id_carte);
ALTER TABLE IMPRUMUT ADD CONSTRAINT id_client_fk FOREIGN KEY(id_client) REFERENCES CLIENT(id_client);

--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION INSERT_CLIENT (
    p_id varchar2,
    p_nume varchar2,
    p_prenume varchar2,
    p_CNP varchar2,
    p_adresa varchar2
) RETURN varchar2
AS
BEGIN

    INSERT INTO Client VALUES (p_id, p_nume, p_prenume, p_CNP, p_adresa);

    RETURN p_id;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '0';

END INSERT_CLIENT;

/

CREATE OR REPLACE FUNCTION INSERT_ANGAJAT (
    p_id varchar2,
    p_nume varchar2,
    p_prenume varchar2,
    p_functie varchar2,
    p_salariu number
) RETURN varchar2
AS
BEGIN

    INSERT INTO Angajat VALUES (p_id, p_nume, p_prenume, p_functie, p_salariu);

    RETURN p_id;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '0';

END INSERT_ANGAJAT;

/

CREATE OR REPLACE FUNCTION INSERT_CARTE (
    p_id varchar2,
    p_titlu varchar2,
    p_autor varchar2,
    p_editura varchar2,
    p_an_aparitie number,
    p_gen varchar2,
    p_valoare_inventar number,
    p_coef_multiplicare number := 0.5,
    p_imprumutat number := 0,
    p_imprumutabil number := 1
) RETURN varchar2
AS
BEGIN

    INSERT INTO Carte VALUES (p_id, p_titlu, p_autor, p_editura, p_an_aparitie, p_gen, p_valoare_inventar, p_coef_multiplicare, p_imprumutat, p_imprumutabil);

    RETURN p_id;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '0';

END INSERT_CARTE;

/

CREATE OR REPLACE FUNCTION INSERT_IMPRUMUT (
    p_id_imprumut varchar2,
    p_id_carte varchar2,
    p_id_client varchar2,
    p_data_imprumut DATE := SYSDATE,
    p_data_returnare DATE,
    p_returnat NUMBER := 0

) RETURN varchar2
AS
    v_imprumutabil NUMBER;
    v_imprumutat NUMBER;

    ex_carte_indisponibila EXCEPTION;
BEGIN

    SELECT imprumutabil, imprumutat
    INTO v_imprumutabil, v_imprumutat
    FROM Carte
    WHERE Carte.id_carte = p_id_carte;

    IF v_imprumutabil = 1 AND v_imprumutat = 0 THEN
        INSERT INTO Imprumut VALUES (p_id_imprumut, p_id_carte, p_id_client, p_data_imprumut, p_data_returnare, p_returnat);
        UPDATE Carte SET imprumutat = 1 WHERE Carte.id_carte = p_id_carte;
    ELSE
        RAISE ex_carte_indisponibila;
    END IF;

    RETURN p_id_imprumut;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '0';

END INSERT_IMPRUMUT;

/

CREATE OR REPLACE FUNCTION UPDATE_INAPOIERE_CARTE ( -- RETURNEAZA VALOARE AMENZII
    p_id_carte varchar2,
    p_data_returnare date
) RETURN number --
AS
    v_imprumutat NUMBER(1);
    v_data_imprumut DATE;
    v_valoare_inventar NUMBER;
    v_coef_multiplicare NUMBER;
    v_amenda NUMBER;
    ex_nicio_carte EXCEPTION;
    ex_data_invalida EXCEPTION;
BEGIN

    SELECT COUNT(*)
    INTO v_imprumutat
    FROM Imprumut
    WHERE (p_id_carte = Imprumut.id_carte AND Imprumut.returnat = 0);

    IF v_imprumutat > 0 THEN
        SELECT data_imprumut, valoare_inventar, coef_multiplicare
        INTO v_data_imprumut, v_valoare_inventar, v_coef_multiplicare
        FROM
            imprumut
            INNER JOIN Carte
                ON Carte.id_carte = Imprumut.id_carte
        WHERE (p_id_carte = Imprumut.id_carte AND Imprumut.returnat = 0);

        UPDATE Imprumut SET returnat = 1 WHERE p_id_carte = id_carte AND returnat = 0;

        IF(v_data_imprumut <= p_data_returnare) THEN
            RETURN (p_data_returnare - v_data_imprumut) * v_valoare_inventar * v_coef_multiplicare;
        ELSE
            RAISE ex_data_invalida;
        END IF;
    ELSE
        RAISE ex_nicio_carte;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;


END UPDATE_INAPOIERE_CARTE;

/

CREATE OR REPLACE PROCEDURE UPDATE_CARTE_IMPRUMUTABIL(
    p_id_carte VARCHAR2,
    p_imprumutabil NUMBER
)
AS
    ex_parametru_invalid EXCEPTION;
BEGIN
    IF p_imprumutabil = 0 OR p_imprumutabil = 1 THEN
        UPDATE CARTE SET imprumutabil = p_imprumutabil WHERE id_carte = p_id_carte;
    ELSE
        RAISE ex_parametru_invalid;
    END IF;

END UPDATE_CARTE_IMPRUMUTABIL;

/

-- Inserare ANGAJAT, CARTE, CLIENT, IMPRUMUT (cu UPDATE IN TABELA CARTE => IMPRUMUTAT)
-- UPDATE IMPRUMUT LA RETURNARE
-- UPDATE CARTE -> IMPRUMUTABIL 0/1
