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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT cpf_func;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome text NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT chk_funcao CHECK ((((funcao)::text = 'LIMPEZA'::text) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT chk_nivel CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar))),
    CONSTRAINT funcao_superior_chk CHECK (((NOT ((funcao)::text = 'LIMPEZA'::text)) OR (superior_cpf IS NOT NULL))),
    CONSTRAINT tam_cpf CHECK ((char_length(cpf) = 11)),
    CONSTRAINT tam_cpf_superior CHECK ((char_length(superior_cpf) = 11))
);


ALTER TABLE public.funcionario OWNER TO ielefp;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: ielefp
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao text NOT NULL,
    func_resp_cpf character varying(11),
    prioridade integer,
    status character(1) NOT NULL,
    CONSTRAINT check_length CHECK ((char_length((func_resp_cpf)::text) = 11)),
    CONSTRAINT check_num CHECK ((prioridade < 32768)),
    CONSTRAINT check_prioridade CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT check_status CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar))),
    CONSTRAINT cpf_null CHECK (((NOT ((status = 'E'::bpchar) OR (status = 'C'::bpchar))) OR (func_resp_cpf IS NOT NULL)))
);


ALTER TABLE public.tarefas OWNER TO ielefp;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: ielefp
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '1994-06-09', 'lui', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911', '1994-06-08', 'lui', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '1994-06-08', 'luiba', 'SUP_LIMPEZA', 'S', '32323232911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1994-06-08', 'luibabu', 'LIMPEZA', 'S', '32323232911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432133', '1994-06-08', 'luizinha', 'LIMPEZA', 'S', '32323232911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432166', '1994-06-08', 'luizao', 'LIMPEZA', 'S', '32323232911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432100', '1994-06-08', 'ielerson', 'LIMPEZA', 'S', '32323232911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432101', '1994-06-08', 'ielison', 'LIMPEZA', 'S', '32323232911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432102', '1994-06-08', 'ielindissima', 'LIMPEZA', 'S', '32323232911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432109', '1994-06-08', 'luluzinha', 'LIMPEZA', 'S', '32323232911');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: ielefp
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147423846, 'comprar xuxu na feira', NULL, 3, 'P');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: cpf_func; Type: FK CONSTRAINT; Schema: public; Owner: ielefp
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT cpf_func FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

