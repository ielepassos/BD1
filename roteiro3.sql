--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.venda DROP CONSTRAINT medicamento_fk;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT id_venda_fk;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT id_farmacia_sk;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT gerente_fk;
ALTER TABLE ONLY public.venda DROP CONSTRAINT funcionario_fk;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT endereco_clientefk;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT cliente_fk;
ALTER TABLE ONLY public.venda DROP CONSTRAINT cliente_fk;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
ALTER TABLE ONLY public.medicamento DROP CONSTRAINT medicamento_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT issede;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_pkey;
ALTER TABLE ONLY public.endereco DROP CONSTRAINT endereco_pkey;
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT bairro_farmacia_unico;
ALTER TABLE public.venda ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medicamento ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.farmacia ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entrega ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.endereco ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.venda_id_seq;
DROP TABLE public.venda;
DROP SEQUENCE public.medicamento_id_seq;
DROP TABLE public.medicamento;
DROP TABLE public.funcionario;
DROP SEQUENCE public.farmacia_id_seq;
DROP TABLE public.farmacia;
DROP SEQUENCE public.entrega_id_seq;
DROP TABLE public.entrega;
DROP SEQUENCE public.endereco_id_seq;
DROP TABLE public.endereco;
DROP TABLE public.cliente;
DROP TYPE public.estados_ne;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: estados_ne; Type: TYPE; Schema: public; Owner: ielefp
--

CREATE TYPE public.estados_ne AS ENUM (
    'RN',
    'PB',
    'PE',
    'AL',
    'BA',
    'MA',
    'PI',
    'SE',
    'CE'
);


ALTER TYPE public.estados_ne OWNER TO ielefp;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.cliente (
    cpf character(11) NOT NULL,
    nome text,
    contato text NOT NULL,
    iscadastrado boolean NOT NULL,
    ano_nascimento integer,
    CONSTRAINT isdemaior CHECK (((date_part('year'::text, now()) - (ano_nascimento)::double precision) >= (18)::double precision))
);


ALTER TABLE public.cliente OWNER TO ielefp;

--
-- Name: endereco; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.endereco (
    id integer NOT NULL,
    cpf_cliente character(11) NOT NULL,
    rua text NOT NULL,
    numero character varying(10) NOT NULL,
    bairro text NOT NULL,
    cidade text NOT NULL,
    estado character(2) NOT NULL,
    tipo character varying(45) NOT NULL,
    cliente_cadastrado boolean NOT NULL,
    CONSTRAINT tipo_endereco CHECK ((((tipo)::text = 'residencia'::text) OR ((tipo)::text = 'trabalho'::text) OR ((tipo)::text = 'outro'::text)))
);


ALTER TABLE public.endereco OWNER TO ielefp;

--
-- Name: endereco_id_seq; Type: SEQUENCE; Schema: public; Owner: ielefp
--

CREATE SEQUENCE public.endereco_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_id_seq OWNER TO ielefp;

--
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ielefp
--

ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;


--
-- Name: entrega; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.entrega (
    id integer NOT NULL,
    data timestamp without time zone,
    id_farmacia integer NOT NULL,
    endereco_cliente integer NOT NULL,
    id_venda integer NOT NULL
);


ALTER TABLE public.entrega OWNER TO ielefp;

--
-- Name: entrega_id_seq; Type: SEQUENCE; Schema: public; Owner: ielefp
--

CREATE SEQUENCE public.entrega_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entrega_id_seq OWNER TO ielefp;

--
-- Name: entrega_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ielefp
--

ALTER SEQUENCE public.entrega_id_seq OWNED BY public.entrega.id;


--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.farmacia (
    id integer NOT NULL,
    bairro text NOT NULL,
    cidade text NOT NULL,
    tipo character varying(6) NOT NULL,
    cpf_gerente character(11) NOT NULL,
    funcao_gerente character varying(25) NOT NULL,
    estado public.estados_ne,
    CONSTRAINT funcao_gerente_check CHECK ((((funcao_gerente)::text = 'farmaceutico'::text) OR ((funcao_gerente)::text = 'administrador'::text))),
    CONSTRAINT sede_filial CHECK ((((tipo)::text = 'sede'::text) OR ((tipo)::text = 'filial'::text)))
);


ALTER TABLE public.farmacia OWNER TO ielefp;

--
-- Name: farmacia_id_seq; Type: SEQUENCE; Schema: public; Owner: ielefp
--

CREATE SEQUENCE public.farmacia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacia_id_seq OWNER TO ielefp;

--
-- Name: farmacia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ielefp
--

ALTER SEQUENCE public.farmacia_id_seq OWNED BY public.farmacia.id;


--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    nome text,
    funcao character varying(25) NOT NULL,
    id_farmacia integer,
    isgerente boolean,
    CONSTRAINT funcao_funcionario CHECK ((((funcao)::text = 'farmaceutico'::text) OR ((funcao)::text = 'administrador'::text) OR ((funcao)::text = 'vendedor'::text) OR ((funcao)::text = 'entregador'::text) OR ((funcao)::text = 'caixa'::text)))
);


ALTER TABLE public.funcionario OWNER TO ielefp;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    nome text,
    fabricante text,
    isexclusivo boolean NOT NULL
);


ALTER TABLE public.medicamento OWNER TO ielefp;

--
-- Name: medicamento_id_seq; Type: SEQUENCE; Schema: public; Owner: ielefp
--

CREATE SEQUENCE public.medicamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamento_id_seq OWNER TO ielefp;

--
-- Name: medicamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ielefp
--

ALTER SEQUENCE public.medicamento_id_seq OWNED BY public.medicamento.id;


--
-- Name: venda; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.venda (
    id integer NOT NULL,
    valor numeric NOT NULL,
    cpf_funcionario character(11) NOT NULL,
    id_medicamento integer NOT NULL,
    cpf_cliente character(11),
    funcionario_funcao character varying(25) NOT NULL,
    medicamento_exclusivo boolean NOT NULL,
    cliente_cadastrado boolean NOT NULL,
    CONSTRAINT client_check CHECK (((NOT (medicamento_exclusivo = true)) OR (cliente_cadastrado = true))),
    CONSTRAINT funcionario_vendedor_check CHECK (((funcionario_funcao)::text = 'vendedor'::text))
);


ALTER TABLE public.venda OWNER TO ielefp;

--
-- Name: venda_id_seq; Type: SEQUENCE; Schema: public; Owner: ielefp
--

CREATE SEQUENCE public.venda_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.venda_id_seq OWNER TO ielefp;

--
-- Name: venda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ielefp
--

ALTER SEQUENCE public.venda_id_seq OWNED BY public.venda.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.entrega ALTER COLUMN id SET DEFAULT nextval('public.entrega_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.farmacia ALTER COLUMN id SET DEFAULT nextval('public.farmacia_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.medicamento ALTER COLUMN id SET DEFAULT nextval('public.medicamento_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.venda ALTER COLUMN id SET DEFAULT nextval('public.venda_id_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: ielefp
--



--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: ielefp
--



--
-- Name: endereco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ielefp
--

SELECT pg_catalog.setval('public.endereco_id_seq', 1, false);


--
-- Data for Name: entrega; Type: TABLE DATA; Schema: public; Owner: ielefp
--



--
-- Name: entrega_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ielefp
--

SELECT pg_catalog.setval('public.entrega_id_seq', 1, false);


--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: ielefp
--



--
-- Name: farmacia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ielefp
--

SELECT pg_catalog.setval('public.farmacia_id_seq', 1, false);


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: ielefp
--



--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: ielefp
--



--
-- Name: medicamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ielefp
--

SELECT pg_catalog.setval('public.medicamento_id_seq', 1, false);


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: ielefp
--



--
-- Name: venda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ielefp
--

SELECT pg_catalog.setval('public.venda_id_seq', 1, false);


--
-- Name: bairro_farmacia_unico; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT bairro_farmacia_unico UNIQUE (bairro);


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf, iscadastrado);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- Name: entrega_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_pkey PRIMARY KEY (id);


--
-- Name: farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id);


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf, funcao);


--
-- Name: issede; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT issede EXCLUDE USING gist (tipo WITH =) WHERE (((tipo)::text = 'sede'::text));


--
-- Name: medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id, isexclusivo);


--
-- Name: venda_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT cliente_fk FOREIGN KEY (cpf_cliente, cliente_cadastrado) REFERENCES public.cliente(cpf, iscadastrado);


--
-- Name: cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT cliente_fk FOREIGN KEY (cpf_cliente, cliente_cadastrado) REFERENCES public.cliente(cpf, iscadastrado);


--
-- Name: endereco_clientefk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT endereco_clientefk FOREIGN KEY (endereco_cliente) REFERENCES public.endereco(id);


--
-- Name: funcionario_fk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT funcionario_fk FOREIGN KEY (cpf_funcionario, funcionario_funcao) REFERENCES public.funcionario(cpf, funcao);


--
-- Name: gerente_fk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT gerente_fk FOREIGN KEY (cpf_gerente, funcao_gerente) REFERENCES public.funcionario(cpf, funcao);


--
-- Name: id_farmacia_sk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT id_farmacia_sk FOREIGN KEY (id_farmacia) REFERENCES public.farmacia(id);


--
-- Name: id_venda_fk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT id_venda_fk FOREIGN KEY (id_venda) REFERENCES public.venda(id);


--
-- Name: medicamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT medicamento_fk FOREIGN KEY (id_medicamento, medicamento_exclusivo) REFERENCES public.medicamento(id, isexclusivo);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

-- TESTES--

--criando funcionarios e farmacia
INSERT INTO funcionario VALUES('05661655460', 'ielinda', 'administrador',null);
INSERT INTO farmacia (bairro, cidade, tipo, cpf_gerente, funcao_gerente, estado) VALUES ('sao jose', 'campina
', 'sede', '05661655460', 'administrador', 'PB');
INSERT INTO funcionario VALUES('72756292400', 'iana daya', 'administrador',1);
INSERT INTO funcionario VALUES('45646660460', 'paulo marcio', 'vendedor',null);

--vai dar erro pois nao cria 2 sedes

INSERT INTO farmacia (bairro, cidade, tipo, cpf_gerente, funcao_gerente, estado) VALUES ('santo antonio', 'campina
', 'sede', '72756292400', 'administrador', 'PB');

--vai dar erro pois nao pode criar mais de uma farmacia no mesmo bairro

INSERT INTO farmacia (bairro, cidade, tipo, cpf_gerente, funcao_gerente, estado) VALUES ('sao jose', 'campina
', 'sede', '72756292400', 'administrador', 'PB');

-- vai dar erro pois gerente so pode ser administrador ou farmaceutico

INSERT INTO farmacia (bairro, cidade, tipo, cpf_gerente, funcao_gerente, estado) VALUES ('sto antonio', 'campina
', 'filial', '45646660460', 'vendedor', 'PB');

--vai dar erro pos essa funcao de funcionario nao existe

INSERT INTO funcionario VALUES('45646660466', 'paula marcia', 'xuxuzinho',null,null);

-- criando clientes
INSERT INTO cliente VALUES('12345678901', 'cuca','99710486',FALSE,2000);
INSERT INTO cliente VALUES('11234567890', 'saci','99710478',FALSE,1998);
INSERT INTO cliente VALUES('11235567890', 'boto','99710478',TRUE,1998);


-- vai dar errado pois cliente de menor
INSERT INTO cliente VALUES('11234567890', 'boto','99710000',FALSE,2007);

--criando medicamentos

INSERT INTO medicamento VALUES(1, 'dipirona', 'generico', FALSE);
INSERT INTO medicamento VALUES(17, 'ivermectina', 'generico', TRUE);

--venda feita
INSERT INTO venda (valor, cpf_funcionario, id_medicamento, cpf_cliente, funcionario_funcao, medicamento_exclusivo, cliente_cadastrado) VALUES (1, '45646660460',1,'12345678901','vendedor',FALSE,FALSE);

--vai dar errado pois uma venda so eh feita por vendedor

INSERT INTO venda (valor, cpf_funcionario, id_medicamento, cpf_cliente, funcionario_funcao, medicamento_exclusivo, cliente_cadastrado) VALUES (1, '45646660460', 1,'12345678901','administrador',FALSE,FALSE);

--vai dar certo pois apesar do medicamento ser exclusivo, o cliente eh cadastrado

INSERT INTO venda (valor, cpf_funcionario, id_medicamento, cpf_cliente, funcionario_funcao, medicamento_exclusivo, cliente_cadastrado) VALUES ( 19, '45646660460',17,'11235567890','vendedor',TRUE, TRUE);

--vai dar errado pois cliente nao cadastrado

INSERT INTO venda (valor, cpf_funcionario, id_medicamento, cpf_cliente, funcionario_funcao, medicamento_exclusivo, cliente_cadastrado) VALUES ( 19, '45646660460',17,'11235567890','vendedor',TRUE, FALSE);

--vai dar errado pois essa id de medicamento exclusiva nao existe(o medicamento que o id refere nao eh excluisvo)

INSERT INTO venda (valor, cpf_funcionario, id_medicamento, cpf_cliente, funcionario_funcao, medicamento_exclusivo, cliente_cadastrado) VALUES ( 19, '45646660460',1,'11235567890','vendedor',TRUE, TRUE);










