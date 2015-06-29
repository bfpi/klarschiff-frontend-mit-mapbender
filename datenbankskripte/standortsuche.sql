--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.5
-- Dumped by pg_dump version 9.1.3
-- Started on 2012-05-07 16:06:22

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 148 (class 1259 OID 19040)
-- Dependencies: 2901 2902 2903 6 1395
-- Name: standortsuche; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE standortsuche (
    id integer NOT NULL,
    poi_titel character varying(255),
    poi_alternativtitel character varying(255),
    stadtteil_id integer,
    stadtteil_name character varying(255),
    strasse_id integer,
    strasse_name character varying(255),
    keywords character varying(255),
    strasse character varying(255),
    hausnummer character varying(10),
    hausnummerzusatz character varying(10),
    stadtteil character varying(255),
    postleitzahl character varying(5),
    geom geometry,
    zusatz character varying(255),
    CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'GEOMETRYCOLLECTION'::text) OR (geom IS NULL))),
    CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 25833))
);


ALTER TABLE public.standortsuche OWNER TO admin;

--
-- TOC entry 149 (class 1259 OID 19049)
-- Dependencies: 148 6
-- Name: standortsuche_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE standortsuche_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.standortsuche_id_seq OWNER TO admin;

--
-- TOC entry 2910 (class 0 OID 0)
-- Dependencies: 149
-- Name: standortsuche_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE standortsuche_id_seq OWNED BY standortsuche.id;


--
-- TOC entry 2900 (class 2604 OID 19051)
-- Dependencies: 149 148
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY standortsuche ALTER COLUMN id SET DEFAULT nextval('standortsuche_id_seq'::regclass);


--
-- TOC entry 2906 (class 2606 OID 19058)
-- Dependencies: 148 148
-- Name: standortsuche_pk; Type: CONSTRAINT; Schema: public; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY standortsuche
    ADD CONSTRAINT standortsuche_pk PRIMARY KEY (id);


--
-- TOC entry 2904 (class 1259 OID 19059)
-- Dependencies: 148 2338
-- Name: standortsuche_ix; Type: INDEX; Schema: public; Owner: admin; Tablespace: 
--

CREATE INDEX standortsuche_ix ON standortsuche USING gist (geom);

ALTER TABLE standortsuche CLUSTER ON standortsuche_ix;


--
-- TOC entry 2909 (class 0 OID 0)
-- Dependencies: 148
-- Name: standortsuche; Type: ACL; Schema: public; Owner: admin
--

REVOKE ALL ON TABLE standortsuche FROM PUBLIC;
REVOKE ALL ON TABLE standortsuche FROM admin;
GRANT ALL ON TABLE standortsuche TO admin;
GRANT SELECT ON TABLE standortsuche TO standortsuche;


--
-- TOC entry 2911 (class 0 OID 0)
-- Dependencies: 149
-- Name: standortsuche_id_seq; Type: ACL; Schema: public; Owner: admin
--

REVOKE ALL ON SEQUENCE standortsuche_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE standortsuche_id_seq FROM admin;
GRANT ALL ON SEQUENCE standortsuche_id_seq TO admin;
GRANT USAGE ON SEQUENCE standortsuche_id_seq TO standortsuche;


-- Completed on 2012-05-07 16:06:22

--
-- PostgreSQL database dump complete
--

