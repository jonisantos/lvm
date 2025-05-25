--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.25
-- Dumped by pg_dump version 9.5.25

-- Started on 2025-05-24 21:19:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2369 (class 1262 OID 57746)
-- Name: lvmdb; Type: DATABASE; Schema: -; Owner: postgres
--

--CREATE DATABASE lvmdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';


ALTER DATABASE lvmdb OWNER TO postgres;

--\connect lvmdb

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2372 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 222 (class 1255 OID 58388)
-- Name: validachavepessoa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validachavepessoa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  declare existe integer;

  begin 
    existe = (select count(1) from pessoa_fisica where id = NEW.pessoa_id);
    if(existe <=0 ) then 
     existe = (select count(1) from pessoa_juridica where id = NEW.pessoa_id);
    if (existe <= 0) then
      raise exception 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
     end if;
    end if;
    RETURN NEW;
  end;
  $$;


ALTER FUNCTION public.validachavepessoa() OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 58389)
-- Name: validachavepessoa2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validachavepessoa2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

  declare existe integer;

  begin 
    existe = (select count(1) from pessoa_fisica where id = NEW.pessoa_forn_id);
    if(existe <=0 ) then 
     existe = (select count(1) from pessoa_juridica where id = NEW.pessoa_forn_id);
    if (existe <= 0) then
      raise exception 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
     end if;
    end if;
    RETURN NEW;
  end;
  $$;


ALTER FUNCTION public.validachavepessoa2() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 200 (class 1259 OID 58106)
-- Name: acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acesso (
    id bigint NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.acesso OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 58111)
-- Name: avaliacao_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avaliacao_produto (
    nota integer NOT NULL,
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    produto_id bigint NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.avaliacao_produto OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 58116)
-- Name: categoria_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_produto (
    id bigint NOT NULL,
    nome_desc character varying(255) NOT NULL
);


ALTER TABLE public.categoria_produto OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 58121)
-- Name: conta_pagar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conta_pagar (
    dt_pagamento date,
    dt_vencimento date NOT NULL,
    valor_desconto numeric(38,2),
    valor_total numeric(38,2) NOT NULL,
    id bigint NOT NULL,
    pessoa_forn_id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    descricao character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    CONSTRAINT conta_pagar_status_check CHECK (((status)::text = ANY ((ARRAY['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying, 'ALUGUEL'::character varying, 'FUNCIONARIO'::character varying, 'NEGOCIADA'::character varying])::text[])))
);


ALTER TABLE public.conta_pagar OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 58130)
-- Name: conta_receber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conta_receber (
    dt_pagamento date,
    dt_vencimento date NOT NULL,
    valor_desconto numeric(38,2),
    valor_total numeric(38,2) NOT NULL,
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    descricao character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    CONSTRAINT conta_receber_status_check CHECK (((status)::text = ANY ((ARRAY['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying])::text[])))
);


ALTER TABLE public.conta_receber OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 58139)
-- Name: cup_desc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cup_desc (
    data_validade_cupom date NOT NULL,
    valor_porcent_desc numeric(38,2),
    valor_real_desc numeric(38,2),
    id bigint NOT NULL,
    cod_desc character varying(255) NOT NULL
);


ALTER TABLE public.cup_desc OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 58144)
-- Name: endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco (
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    bairro character varying(255) NOT NULL,
    cep character varying(255) NOT NULL,
    cidade character varying(255) NOT NULL,
    complemento character varying(255),
    numero character varying(255) NOT NULL,
    rua_logra character varying(255) NOT NULL,
    tipo_endereco character varying(255) NOT NULL,
    uf character varying(255) NOT NULL,
    CONSTRAINT endereco_tipo_endereco_check CHECK (((tipo_endereco)::text = ANY ((ARRAY['COBRANCA'::character varying, 'ENTREGA'::character varying])::text[])))
);


ALTER TABLE public.endereco OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 58153)
-- Name: forma_pagamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forma_pagamento (
    id bigint NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.forma_pagamento OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 58158)
-- Name: imagem_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagem_produto (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    imagem_miniatura text NOT NULL,
    imagem_original text NOT NULL
);


ALTER TABLE public.imagem_produto OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 58166)
-- Name: item_venda_loja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_venda_loja (
    quantidade double precision NOT NULL,
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    venda_compra_loja_virtu_id bigint NOT NULL
);


ALTER TABLE public.item_venda_loja OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 58171)
-- Name: marca_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marca_produto (
    id bigint NOT NULL,
    nome_desc character varying(255) NOT NULL
);


ALTER TABLE public.marca_produto OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 58176)
-- Name: nota_fiscal_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_fiscal_compra (
    data_compra date NOT NULL,
    valor_desconto numeric(38,2),
    valor_icms numeric(38,2) NOT NULL,
    valor_total numeric(38,2) NOT NULL,
    conta_pagar_id bigint NOT NULL,
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    descricao_obs character varying(255),
    numero_nota character varying(255) NOT NULL,
    serie_nota character varying(255) NOT NULL
);


ALTER TABLE public.nota_fiscal_compra OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 58184)
-- Name: nota_fiscal_venda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_fiscal_venda (
    id bigint NOT NULL,
    venda_compra_loja_virt_id bigint NOT NULL,
    numero character varying(255) NOT NULL,
    pdf text NOT NULL,
    serie character varying(255) NOT NULL,
    tipo character varying(255) NOT NULL,
    xml text NOT NULL
);


ALTER TABLE public.nota_fiscal_venda OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 58194)
-- Name: nota_item_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_item_produto (
    quantidade double precision NOT NULL,
    id bigint NOT NULL,
    nota_fiscal_compra_id bigint NOT NULL,
    produto_id bigint NOT NULL
);


ALTER TABLE public.nota_item_produto OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 58199)
-- Name: pessoa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    telefone character varying(255) NOT NULL
);


ALTER TABLE public.pessoa OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 58207)
-- Name: pessoa_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa_fisica (
    data_nascimento date,
    id bigint NOT NULL,
    cpf character varying(255) NOT NULL
);


ALTER TABLE public.pessoa_fisica OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 58212)
-- Name: pessoa_juridica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa_juridica (
    id bigint NOT NULL,
    categoria character varying(255),
    cnpj character varying(255) NOT NULL,
    insc_estadual character varying(255) NOT NULL,
    insc_municipal character varying(255),
    nome_fantasia character varying(255) NOT NULL,
    razao_social character varying(255) NOT NULL
);


ALTER TABLE public.pessoa_juridica OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 58220)
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    alerta_qtde_estoque boolean,
    altura double precision NOT NULL,
    ativo boolean NOT NULL,
    largura double precision NOT NULL,
    peso double precision NOT NULL,
    profundidade double precision NOT NULL,
    qtd_estoque integer NOT NULL,
    qtde_alerta_estoque integer,
    qtde_clique integer,
    valor_venda numeric(38,2) NOT NULL,
    id bigint NOT NULL,
    descricao text NOT NULL,
    link_youtube character varying(255),
    nome character varying(255) NOT NULL,
    tipo_unidade character varying(255) NOT NULL
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 58068)
-- Name: seq_acesso; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_acesso
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_acesso OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 58070)
-- Name: seq_avaliacao_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_avaliacao_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_avaliacao_produto OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 58072)
-- Name: seq_categoria_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_categoria_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_categoria_produto OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 58074)
-- Name: seq_conta_pagar; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_conta_pagar
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_conta_pagar OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 58076)
-- Name: seq_conta_receber; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_conta_receber
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_conta_receber OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 58078)
-- Name: seq_cup_desc; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_cup_desc
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_cup_desc OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 58080)
-- Name: seq_endereco; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_endereco
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_endereco OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 58082)
-- Name: seq_forma_pagamento; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_forma_pagamento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_forma_pagamento OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 58084)
-- Name: seq_imagem_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_imagem_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_imagem_produto OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 58086)
-- Name: seq_item_venda_loja; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_item_venda_loja
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_item_venda_loja OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 58088)
-- Name: seq_marca_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_marca_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_marca_produto OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 58090)
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_fiscal_compra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_nota_fiscal_compra OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 58092)
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_fiscal_venda
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_nota_fiscal_venda OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 58094)
-- Name: seq_nota_item_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_item_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_nota_item_produto OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 58096)
-- Name: seq_pessoa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_pessoa
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_pessoa OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 58098)
-- Name: seq_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_produto OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 58100)
-- Name: seq_status_rastreio; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_status_rastreio
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_status_rastreio OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 58102)
-- Name: seq_usuario; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_usuario
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_usuario OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 58104)
-- Name: seq_vd_cp_loja_virt; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_vd_cp_loja_virt
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_vd_cp_loja_virt OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 58228)
-- Name: status_rastreio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_rastreio (
    id bigint NOT NULL,
    venda_compra_loja_virt_id bigint NOT NULL,
    centro_distribuicao character varying(255),
    cidade character varying(255),
    estado character varying(255),
    status character varying(255)
);


ALTER TABLE public.status_rastreio OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 58236)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    data_atual_senha date NOT NULL,
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    login character varying(255) NOT NULL,
    senha character varying(255) NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 58244)
-- Name: usuarios_acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios_acesso (
    acesso_id bigint NOT NULL,
    usuario_id bigint NOT NULL
);


ALTER TABLE public.usuarios_acesso OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 58251)
-- Name: vd_cp_loja_virt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vd_cp_loja_virt (
    data_entrega date NOT NULL,
    data_venda date NOT NULL,
    dia_entrega integer NOT NULL,
    valor_desconto numeric(38,2),
    valor_fret numeric(38,2) NOT NULL,
    valor_total numeric(38,2) NOT NULL,
    cupom_desc_id bigint,
    endereco_cobranca_id bigint NOT NULL,
    endereco_entrega_id bigint NOT NULL,
    forma_pagamento_id bigint NOT NULL,
    id bigint NOT NULL,
    nota_fiscal_venda_id bigint NOT NULL,
    pessoa_id bigint NOT NULL
);


ALTER TABLE public.vd_cp_loja_virt OWNER TO postgres;

--
-- TOC entry 2342 (class 0 OID 58106)
-- Dependencies: 200
-- Data for Name: acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acesso (id, descricao) FROM stdin;
\.


--
-- TOC entry 2343 (class 0 OID 58111)
-- Dependencies: 201
-- Data for Name: avaliacao_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avaliacao_produto (nota, id, pessoa_id, produto_id, descricao) FROM stdin;
\.


--
-- TOC entry 2344 (class 0 OID 58116)
-- Dependencies: 202
-- Data for Name: categoria_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_produto (id, nome_desc) FROM stdin;
\.


--
-- TOC entry 2345 (class 0 OID 58121)
-- Dependencies: 203
-- Data for Name: conta_pagar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conta_pagar (dt_pagamento, dt_vencimento, valor_desconto, valor_total, id, pessoa_forn_id, pessoa_id, descricao, status) FROM stdin;
\.


--
-- TOC entry 2346 (class 0 OID 58130)
-- Dependencies: 204
-- Data for Name: conta_receber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conta_receber (dt_pagamento, dt_vencimento, valor_desconto, valor_total, id, pessoa_id, descricao, status) FROM stdin;
\.


--
-- TOC entry 2347 (class 0 OID 58139)
-- Dependencies: 205
-- Data for Name: cup_desc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cup_desc (data_validade_cupom, valor_porcent_desc, valor_real_desc, id, cod_desc) FROM stdin;
\.


--
-- TOC entry 2348 (class 0 OID 58144)
-- Dependencies: 206
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco (id, pessoa_id, bairro, cep, cidade, complemento, numero, rua_logra, tipo_endereco, uf) FROM stdin;
\.


--
-- TOC entry 2349 (class 0 OID 58153)
-- Dependencies: 207
-- Data for Name: forma_pagamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forma_pagamento (id, descricao) FROM stdin;
\.


--
-- TOC entry 2350 (class 0 OID 58158)
-- Dependencies: 208
-- Data for Name: imagem_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imagem_produto (id, produto_id, imagem_miniatura, imagem_original) FROM stdin;
\.


--
-- TOC entry 2351 (class 0 OID 58166)
-- Dependencies: 209
-- Data for Name: item_venda_loja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_venda_loja (quantidade, id, produto_id, venda_compra_loja_virtu_id) FROM stdin;
\.


--
-- TOC entry 2352 (class 0 OID 58171)
-- Dependencies: 210
-- Data for Name: marca_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marca_produto (id, nome_desc) FROM stdin;
\.


--
-- TOC entry 2353 (class 0 OID 58176)
-- Dependencies: 211
-- Data for Name: nota_fiscal_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nota_fiscal_compra (data_compra, valor_desconto, valor_icms, valor_total, conta_pagar_id, id, pessoa_id, descricao_obs, numero_nota, serie_nota) FROM stdin;
\.


--
-- TOC entry 2354 (class 0 OID 58184)
-- Dependencies: 212
-- Data for Name: nota_fiscal_venda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nota_fiscal_venda (id, venda_compra_loja_virt_id, numero, pdf, serie, tipo, xml) FROM stdin;
\.


--
-- TOC entry 2355 (class 0 OID 58194)
-- Dependencies: 213
-- Data for Name: nota_item_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nota_item_produto (quantidade, id, nota_fiscal_compra_id, produto_id) FROM stdin;
\.


--
-- TOC entry 2356 (class 0 OID 58199)
-- Dependencies: 214
-- Data for Name: pessoa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pessoa (id, email, nome, telefone) FROM stdin;
\.


--
-- TOC entry 2357 (class 0 OID 58207)
-- Dependencies: 215
-- Data for Name: pessoa_fisica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pessoa_fisica (data_nascimento, id, cpf) FROM stdin;
\.


--
-- TOC entry 2358 (class 0 OID 58212)
-- Dependencies: 216
-- Data for Name: pessoa_juridica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pessoa_juridica (id, categoria, cnpj, insc_estadual, insc_municipal, nome_fantasia, razao_social) FROM stdin;
\.


--
-- TOC entry 2359 (class 0 OID 58220)
-- Dependencies: 217
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (alerta_qtde_estoque, altura, ativo, largura, peso, profundidade, qtd_estoque, qtde_alerta_estoque, qtde_clique, valor_venda, id, descricao, link_youtube, nome, tipo_unidade) FROM stdin;
\.


--
-- TOC entry 2373 (class 0 OID 0)
-- Dependencies: 181
-- Name: seq_acesso; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_acesso', 1, false);


--
-- TOC entry 2374 (class 0 OID 0)
-- Dependencies: 182
-- Name: seq_avaliacao_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_avaliacao_produto', 1, false);


--
-- TOC entry 2375 (class 0 OID 0)
-- Dependencies: 183
-- Name: seq_categoria_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_categoria_produto', 1, false);


--
-- TOC entry 2376 (class 0 OID 0)
-- Dependencies: 184
-- Name: seq_conta_pagar; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_conta_pagar', 1, false);


--
-- TOC entry 2377 (class 0 OID 0)
-- Dependencies: 185
-- Name: seq_conta_receber; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_conta_receber', 1, false);


--
-- TOC entry 2378 (class 0 OID 0)
-- Dependencies: 186
-- Name: seq_cup_desc; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cup_desc', 1, false);


--
-- TOC entry 2379 (class 0 OID 0)
-- Dependencies: 187
-- Name: seq_endereco; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_endereco', 1, false);


--
-- TOC entry 2380 (class 0 OID 0)
-- Dependencies: 188
-- Name: seq_forma_pagamento; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_forma_pagamento', 1, false);


--
-- TOC entry 2381 (class 0 OID 0)
-- Dependencies: 189
-- Name: seq_imagem_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_imagem_produto', 1, false);


--
-- TOC entry 2382 (class 0 OID 0)
-- Dependencies: 190
-- Name: seq_item_venda_loja; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_item_venda_loja', 1, false);


--
-- TOC entry 2383 (class 0 OID 0)
-- Dependencies: 191
-- Name: seq_marca_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_marca_produto', 1, false);


--
-- TOC entry 2384 (class 0 OID 0)
-- Dependencies: 192
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_compra', 1, false);


--
-- TOC entry 2385 (class 0 OID 0)
-- Dependencies: 193
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_venda', 1, false);


--
-- TOC entry 2386 (class 0 OID 0)
-- Dependencies: 194
-- Name: seq_nota_item_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_item_produto', 1, false);


--
-- TOC entry 2387 (class 0 OID 0)
-- Dependencies: 195
-- Name: seq_pessoa; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_pessoa', 1, false);


--
-- TOC entry 2388 (class 0 OID 0)
-- Dependencies: 196
-- Name: seq_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_produto', 1, false);


--
-- TOC entry 2389 (class 0 OID 0)
-- Dependencies: 197
-- Name: seq_status_rastreio; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_status_rastreio', 1, false);


--
-- TOC entry 2390 (class 0 OID 0)
-- Dependencies: 198
-- Name: seq_usuario; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_usuario', 1, false);


--
-- TOC entry 2391 (class 0 OID 0)
-- Dependencies: 199
-- Name: seq_vd_cp_loja_virt; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_vd_cp_loja_virt', 1, false);


--
-- TOC entry 2360 (class 0 OID 58228)
-- Dependencies: 218
-- Data for Name: status_rastreio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_rastreio (id, venda_compra_loja_virt_id, centro_distribuicao, cidade, estado, status) FROM stdin;
\.


--
-- TOC entry 2361 (class 0 OID 58236)
-- Dependencies: 219
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (data_atual_senha, id, pessoa_id, login, senha) FROM stdin;
\.


--
-- TOC entry 2362 (class 0 OID 58244)
-- Dependencies: 220
-- Data for Name: usuarios_acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios_acesso (acesso_id, usuario_id) FROM stdin;
\.


--
-- TOC entry 2363 (class 0 OID 58251)
-- Dependencies: 221
-- Data for Name: vd_cp_loja_virt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vd_cp_loja_virt (data_entrega, data_venda, dia_entrega, valor_desconto, valor_fret, valor_total, cupom_desc_id, endereco_cobranca_id, endereco_entrega_id, forma_pagamento_id, id, nota_fiscal_venda_id, pessoa_id) FROM stdin;
\.


--
-- TOC entry 2118 (class 2606 OID 58110)
-- Name: acesso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acesso
    ADD CONSTRAINT acesso_pkey PRIMARY KEY (id);


--
-- TOC entry 2120 (class 2606 OID 58115)
-- Name: avaliacao_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT avaliacao_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 2122 (class 2606 OID 58120)
-- Name: categoria_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_produto
    ADD CONSTRAINT categoria_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 2124 (class 2606 OID 58129)
-- Name: conta_pagar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_pagar
    ADD CONSTRAINT conta_pagar_pkey PRIMARY KEY (id);


--
-- TOC entry 2126 (class 2606 OID 58138)
-- Name: conta_receber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_receber
    ADD CONSTRAINT conta_receber_pkey PRIMARY KEY (id);


--
-- TOC entry 2128 (class 2606 OID 58143)
-- Name: cup_desc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cup_desc
    ADD CONSTRAINT cup_desc_pkey PRIMARY KEY (id);


--
-- TOC entry 2130 (class 2606 OID 58152)
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 2132 (class 2606 OID 58157)
-- Name: forma_pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forma_pagamento
    ADD CONSTRAINT forma_pagamento_pkey PRIMARY KEY (id);


--
-- TOC entry 2134 (class 2606 OID 58165)
-- Name: imagem_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT imagem_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 2136 (class 2606 OID 58170)
-- Name: item_venda_loja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT item_venda_loja_pkey PRIMARY KEY (id);


--
-- TOC entry 2138 (class 2606 OID 58175)
-- Name: marca_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marca_produto
    ADD CONSTRAINT marca_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 2140 (class 2606 OID 58183)
-- Name: nota_fiscal_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT nota_fiscal_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 2142 (class 2606 OID 58191)
-- Name: nota_fiscal_venda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT nota_fiscal_venda_pkey PRIMARY KEY (id);


--
-- TOC entry 2144 (class 2606 OID 58193)
-- Name: nota_fiscal_venda_venda_compra_loja_virt_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT nota_fiscal_venda_venda_compra_loja_virt_id_key UNIQUE (venda_compra_loja_virt_id);


--
-- TOC entry 2146 (class 2606 OID 58198)
-- Name: nota_item_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_item_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 2150 (class 2606 OID 58211)
-- Name: pessoa_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_fisica
    ADD CONSTRAINT pessoa_fisica_pkey PRIMARY KEY (id);


--
-- TOC entry 2152 (class 2606 OID 58219)
-- Name: pessoa_juridica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_juridica
    ADD CONSTRAINT pessoa_juridica_pkey PRIMARY KEY (id);


--
-- TOC entry 2148 (class 2606 OID 58206)
-- Name: pessoa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (id);


--
-- TOC entry 2154 (class 2606 OID 58227)
-- Name: produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- TOC entry 2156 (class 2606 OID 58235)
-- Name: status_rastreio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_rastreio
    ADD CONSTRAINT status_rastreio_pkey PRIMARY KEY (id);


--
-- TOC entry 2160 (class 2606 OID 58250)
-- Name: unique_acesso_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT unique_acesso_user UNIQUE (usuario_id, acesso_id);


--
-- TOC entry 2158 (class 2606 OID 58243)
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 2162 (class 2606 OID 58248)
-- Name: usuarios_acesso_acesso_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT usuarios_acesso_acesso_id_key UNIQUE (acesso_id);


--
-- TOC entry 2164 (class 2606 OID 58257)
-- Name: vd_cp_loja_virt_nota_fiscal_venda_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT vd_cp_loja_virt_nota_fiscal_venda_id_key UNIQUE (nota_fiscal_venda_id);


--
-- TOC entry 2166 (class 2606 OID 58255)
-- Name: vd_cp_loja_virt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT vd_cp_loja_virt_pkey PRIMARY KEY (id);


--
-- TOC entry 2199 (class 2620 OID 58397)
-- Name: validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.conta_receber FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2201 (class 2620 OID 58399)
-- Name: validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.endereco FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2203 (class 2620 OID 58401)
-- Name: validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.nota_fiscal_compra FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2205 (class 2620 OID 58403)
-- Name: validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.usuario FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2207 (class 2620 OID 58405)
-- Name: validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.vd_cp_loja_virt FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2200 (class 2620 OID 58398)
-- Name: validachavepessoa2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.conta_receber FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2202 (class 2620 OID 58400)
-- Name: validachavepessoa2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.endereco FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2204 (class 2620 OID 58402)
-- Name: validachavepessoa2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.nota_fiscal_compra FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2206 (class 2620 OID 58404)
-- Name: validachavepessoa2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.usuario FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2208 (class 2620 OID 58406)
-- Name: validachavepessoa2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.vd_cp_loja_virt FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2193 (class 2620 OID 58391)
-- Name: validachavepessoaavaliacaoproduto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaavaliacaoproduto BEFORE UPDATE ON public.avaliacao_produto FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2194 (class 2620 OID 58392)
-- Name: validachavepessoaavaliacaoproduto2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaavaliacaoproduto2 BEFORE INSERT ON public.avaliacao_produto FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2195 (class 2620 OID 58393)
-- Name: validachavepessoacontapagar; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagar BEFORE UPDATE ON public.conta_pagar FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2196 (class 2620 OID 58394)
-- Name: validachavepessoacontapagar2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagar2 BEFORE INSERT ON public.conta_pagar FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa();


--
-- TOC entry 2197 (class 2620 OID 58395)
-- Name: validachavepessoacontapagarpessoa_forn_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagarpessoa_forn_id BEFORE UPDATE ON public.conta_pagar FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa2();


--
-- TOC entry 2198 (class 2620 OID 58396)
-- Name: validachavepessoacontapagarpessoa_forn_id2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagarpessoa_forn_id2 BEFORE INSERT ON public.conta_pagar FOR EACH ROW EXECUTE PROCEDURE public.validachavepessoa2();


--
-- TOC entry 2185 (class 2606 OID 58348)
-- Name: aesso_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT aesso_fk FOREIGN KEY (acesso_id) REFERENCES public.acesso(id);


--
-- TOC entry 2176 (class 2606 OID 58303)
-- Name: conta_pagar_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT conta_pagar_fk FOREIGN KEY (conta_pagar_id) REFERENCES public.conta_pagar(id);


--
-- TOC entry 2187 (class 2606 OID 58358)
-- Name: cupom_desc_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT cupom_desc_fk FOREIGN KEY (cupom_desc_id) REFERENCES public.cup_desc(id);


--
-- TOC entry 2188 (class 2606 OID 58363)
-- Name: endereco_cobranca_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT endereco_cobranca_fk FOREIGN KEY (endereco_cobranca_id) REFERENCES public.endereco(id);


--
-- TOC entry 2189 (class 2606 OID 58368)
-- Name: endereco_entrega_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT endereco_entrega_fk FOREIGN KEY (endereco_entrega_id) REFERENCES public.endereco(id);


--
-- TOC entry 2182 (class 2606 OID 58333)
-- Name: fkor0e1i8f3vc9f721q0wcx1nbp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_juridica
    ADD CONSTRAINT fkor0e1i8f3vc9f721q0wcx1nbp FOREIGN KEY (id) REFERENCES public.pessoa(id);


--
-- TOC entry 2181 (class 2606 OID 58328)
-- Name: fksrkbwlwurui650owdeqn7mbx6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_fisica
    ADD CONSTRAINT fksrkbwlwurui650owdeqn7mbx6 FOREIGN KEY (id) REFERENCES public.pessoa(id);


--
-- TOC entry 2190 (class 2606 OID 58373)
-- Name: forma_pagamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT forma_pagamento_fk FOREIGN KEY (forma_pagamento_id) REFERENCES public.forma_pagamento(id);


--
-- TOC entry 2179 (class 2606 OID 58318)
-- Name: nota_fiscal_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_fiscal_compra_fk FOREIGN KEY (nota_fiscal_compra_id) REFERENCES public.nota_fiscal_compra(id);


--
-- TOC entry 2191 (class 2606 OID 58378)
-- Name: nota_fiscal_venda_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT nota_fiscal_venda_fk FOREIGN KEY (nota_fiscal_venda_id) REFERENCES public.nota_fiscal_venda(id);


--
-- TOC entry 2167 (class 2606 OID 58258)
-- Name: pessoa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2170 (class 2606 OID 58268)
-- Name: pessoa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_pagar
    ADD CONSTRAINT pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2171 (class 2606 OID 58278)
-- Name: pessoa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_receber
    ADD CONSTRAINT pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2172 (class 2606 OID 58283)
-- Name: pessoa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2177 (class 2606 OID 58308)
-- Name: pessoa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2184 (class 2606 OID 58343)
-- Name: pessoa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2192 (class 2606 OID 58383)
-- Name: pessoa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2169 (class 2606 OID 58273)
-- Name: pessoa_forn_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_pagar
    ADD CONSTRAINT pessoa_forn_fk FOREIGN KEY (pessoa_forn_id) REFERENCES public.pessoa(id);


--
-- TOC entry 2168 (class 2606 OID 58263)
-- Name: produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 2173 (class 2606 OID 58288)
-- Name: produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 2174 (class 2606 OID 58293)
-- Name: produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 2180 (class 2606 OID 58323)
-- Name: produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 2186 (class 2606 OID 58353)
-- Name: usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT usuario_fk FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 2178 (class 2606 OID 58313)
-- Name: venda_compra_loja_virt_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT venda_compra_loja_virt_fk FOREIGN KEY (venda_compra_loja_virt_id) REFERENCES public.vd_cp_loja_virt(id);


--
-- TOC entry 2183 (class 2606 OID 58338)
-- Name: venda_compra_loja_virt_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_rastreio
    ADD CONSTRAINT venda_compra_loja_virt_fk FOREIGN KEY (venda_compra_loja_virt_id) REFERENCES public.vd_cp_loja_virt(id);


--
-- TOC entry 2175 (class 2606 OID 58298)
-- Name: venda_compraloja_virtu_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT venda_compraloja_virtu_fk FOREIGN KEY (venda_compra_loja_virtu_id) REFERENCES public.vd_cp_loja_virt(id);


--
-- TOC entry 2371 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2025-05-24 21:19:33

--
-- PostgreSQL database dump complete
--

