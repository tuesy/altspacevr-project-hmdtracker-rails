--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: hmd_states; Type: TABLE; Schema: public; Owner: jimmy; Tablespace: 
--

CREATE TABLE hmd_states (
    id integer NOT NULL,
    hmd_id integer NOT NULL,
    state character varying(64) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.hmd_states OWNER TO jimmy;

--
-- Name: hmd_states_id_seq; Type: SEQUENCE; Schema: public; Owner: jimmy
--

CREATE SEQUENCE hmd_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hmd_states_id_seq OWNER TO jimmy;

--
-- Name: hmd_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jimmy
--

ALTER SEQUENCE hmd_states_id_seq OWNED BY hmd_states.id;


--
-- Name: hmds; Type: TABLE; Schema: public; Owner: jimmy; Tablespace: 
--

CREATE TABLE hmds (
    id integer NOT NULL,
    name character varying(512) NOT NULL,
    company character varying(512) NOT NULL,
    state character varying(64) NOT NULL,
    image_url character varying(512) NOT NULL,
    announced_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.hmds OWNER TO jimmy;

--
-- Name: hmds_id_seq; Type: SEQUENCE; Schema: public; Owner: jimmy
--

CREATE SEQUENCE hmds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hmds_id_seq OWNER TO jimmy;

--
-- Name: hmds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jimmy
--

ALTER SEQUENCE hmds_id_seq OWNED BY hmds.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: jimmy; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO jimmy;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: jimmy
--

ALTER TABLE ONLY hmd_states ALTER COLUMN id SET DEFAULT nextval('hmd_states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: jimmy
--

ALTER TABLE ONLY hmds ALTER COLUMN id SET DEFAULT nextval('hmds_id_seq'::regclass);


--
-- Data for Name: hmd_states; Type: TABLE DATA; Schema: public; Owner: jimmy
--

COPY hmd_states (id, hmd_id, state, created_at, updated_at) FROM stdin;
\.


--
-- Name: hmd_states_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jimmy
--

SELECT pg_catalog.setval('hmd_states_id_seq', 1, false);


--
-- Data for Name: hmds; Type: TABLE DATA; Schema: public; Owner: jimmy
--

COPY hmds (id, name, company, state, image_url, announced_at, created_at, updated_at) FROM stdin;
1	Rift DK1	Oculus VR	released	http://i.imgur.com/EY3KHSz.jpg	2012-08-01 00:00:00	2015-10-01 22:47:45.581766	2015-10-01 22:47:45.581766
2	Rift DK2	Oculus VR	released	http://i.imgur.com/awhOYii.jpg	2014-03-04 00:00:00	2015-10-01 22:47:45.58798	2015-10-01 22:47:45.58798
3	Rift CV1	Oculus VR	announced	http://i.imgur.com/Nw077of.jpg	2015-05-18 00:00:00	2015-10-01 22:47:45.590128	2015-10-01 22:47:45.590128
4	Gear VR Innovator Edition	Oculus/Samsung	released	http://i.imgur.com/K1kUWVc.png	2014-09-03 00:00:00	2015-10-01 22:47:45.592551	2015-10-01 22:47:45.592551
5	OSVR	Razer	devkit	http://i.imgur.com/QSo3WHu.jpg	2015-01-05 00:00:00	2015-10-01 22:47:45.594509	2015-10-01 22:47:45.594509
6	Vive	Valve/HTC	announced	http://i.imgur.com/fuvkUTB.jpg	2015-03-01 00:00:00	2015-10-01 22:47:45.59681	2015-10-01 22:47:45.59681
7	3D Head	Anakando Media Group	devkit	http://i.imgur.com/npqEWje.jpg	2015-03-01 00:00:00	2015-10-01 22:47:45.599074	2015-10-01 22:47:45.599074
\.


--
-- Name: hmds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jimmy
--

SELECT pg_catalog.setval('hmds_id_seq', 7, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: jimmy
--

COPY schema_migrations (version) FROM stdin;
20150528233405
20150528235540
\.


--
-- Name: hmd_states_pkey; Type: CONSTRAINT; Schema: public; Owner: jimmy; Tablespace: 
--

ALTER TABLE ONLY hmd_states
    ADD CONSTRAINT hmd_states_pkey PRIMARY KEY (id);


--
-- Name: hmds_pkey; Type: CONSTRAINT; Schema: public; Owner: jimmy; Tablespace: 
--

ALTER TABLE ONLY hmds
    ADD CONSTRAINT hmds_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: jimmy; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: jimmy
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM jimmy;
GRANT ALL ON SCHEMA public TO jimmy;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

