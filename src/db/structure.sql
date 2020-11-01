--
-- PostgreSQL database dump
--

-- Dumped from database version 11.9
-- Dumped by pg_dump version 11.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: characters; Type: TABLE; Schema: public; Owner: em
--

CREATE TABLE public.characters (
    id integer NOT NULL,
    name character varying(12),
    current_map character varying(254),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.characters OWNER TO em;

--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: em
--

CREATE SEQUENCE public.characters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.characters_id_seq OWNER TO em;

--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: em
--

ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;


--
-- Name: migration_versions; Type: TABLE; Schema: public; Owner: em
--

CREATE TABLE public.migration_versions (
    id integer NOT NULL,
    version character varying(17) NOT NULL
);


ALTER TABLE public.migration_versions OWNER TO em;

--
-- Name: migration_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: em
--

CREATE SEQUENCE public.migration_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migration_versions_id_seq OWNER TO em;

--
-- Name: migration_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: em
--

ALTER SEQUENCE public.migration_versions_id_seq OWNED BY public.migration_versions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: em
--

CREATE TABLE public.users (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uid character varying(254),
    email character varying(254)
);


ALTER TABLE public.users OWNER TO em;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: em
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO em;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: em
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: em
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Name: migration_versions id; Type: DEFAULT; Schema: public; Owner: em
--

ALTER TABLE ONLY public.migration_versions ALTER COLUMN id SET DEFAULT nextval('public.migration_versions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: em
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: em
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: migration_versions migration_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: em
--

ALTER TABLE ONLY public.migration_versions
    ADD CONSTRAINT migration_versions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: em
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: characters_name_idx; Type: INDEX; Schema: public; Owner: em
--

CREATE UNIQUE INDEX characters_name_idx ON public.characters USING btree (name);


--
-- Name: users_uid_idx; Type: INDEX; Schema: public; Owner: em
--

CREATE UNIQUE INDEX users_uid_idx ON public.users USING btree (uid);


--
-- Name: characters fk_cr_53a8ea746c; Type: FK CONSTRAINT; Schema: public; Owner: em
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT fk_cr_53a8ea746c FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

