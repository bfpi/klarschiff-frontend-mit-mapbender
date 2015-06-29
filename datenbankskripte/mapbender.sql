--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.9
-- Dumped by pg_dump version 9.1.4
-- Started on 2013-09-10 14:42:14

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 6 (class 2615 OID 18138)
-- Name: mapbender; Type: SCHEMA; Schema: -; Owner: mapbender
--

CREATE SCHEMA mapbender;


ALTER SCHEMA mapbender OWNER TO mapbender;

--
-- TOC entry 4467 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA mapbender; Type: COMMENT; Schema: -; Owner: mapbender
--

COMMENT ON SCHEMA mapbender IS 'Schema für produktiven Mapbender 2.7.2';


SET search_path = mapbender, pg_catalog;

--
-- TOC entry 292 (class 1255 OID 18139)
-- Dependencies: 6 1903
-- Name: f_collect_custom_cat_layer(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_custom_cat_layer(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_layer_id ALIAS FOR $1;
  custom_cat_string  TEXT;
  custom_cat_record  RECORD;

BEGIN
custom_cat_string := '';

FOR custom_cat_record IN SELECT layer_custom_category.fkey_custom_category_id from layer_custom_category WHERE layer_custom_category.fkey_layer_id=$1  LOOP
custom_cat_string := custom_cat_string || '{' ||custom_cat_record.fkey_custom_category_id || '}';
END LOOP ;
  
RETURN custom_cat_string;

END;
$_$;


ALTER FUNCTION mapbender.f_collect_custom_cat_layer(integer) OWNER TO mapbender;

--
-- TOC entry 293 (class 1255 OID 18140)
-- Dependencies: 6 1903
-- Name: f_collect_custom_cat_wfs_featuretype(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_custom_cat_wfs_featuretype(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_featuretype_id ALIAS FOR $1;
  custom_cat_string  TEXT;
  custom_cat_record  RECORD;

BEGIN
custom_cat_string := '';

FOR custom_cat_record IN SELECT wfs_featuretype_custom_category.fkey_custom_category_id from wfs_featuretype_custom_category WHERE wfs_featuretype_custom_category.fkey_featuretype_id=$1  LOOP
custom_cat_string := custom_cat_string || '{' ||custom_cat_record.fkey_custom_category_id || '}';
END LOOP ;
  
RETURN custom_cat_string;

END;
$_$;


ALTER FUNCTION mapbender.f_collect_custom_cat_wfs_featuretype(integer) OWNER TO mapbender;

--
-- TOC entry 294 (class 1255 OID 18141)
-- Dependencies: 1903 6
-- Name: f_collect_custom_cat_wmc(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_custom_cat_wmc(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_wmc_serial_id ALIAS FOR $1;
  custom_cat_string  TEXT;
  custom_cat_record  RECORD;
BEGIN
custom_cat_string := '';
FOR custom_cat_record IN SELECT wmc_custom_category.fkey_custom_category_id from wmc_custom_category WHERE wmc_custom_category.fkey_wmc_serial_id=$1  LOOP
custom_cat_string := custom_cat_string || '{' ||custom_cat_record.fkey_custom_category_id || '}';
END LOOP ;
RETURN custom_cat_string;
END;
$_$;


ALTER FUNCTION mapbender.f_collect_custom_cat_wmc(integer) OWNER TO mapbender;

--
-- TOC entry 295 (class 1255 OID 18142)
-- Dependencies: 6 1903
-- Name: f_collect_epsg(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_epsg(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_layer_id ALIAS FOR $1;
  epsg_string  TEXT;
  epsg_record  RECORD;

BEGIN
epsg_string := '';

FOR epsg_record IN SELECT layer_epsg.epsg from layer_epsg WHERE layer_epsg.fkey_layer_id=$1  LOOP
epsg_string := epsg_string ||  epsg_record.epsg || ';';
END LOOP ;
  
RETURN epsg_string;

    --CASE
      --WHEN LEN(epsg) > 0 THEN LEFT(epsg, LEN(epsg) - 1)
     -- ELSE epsg
    

END;
$_$;


ALTER FUNCTION mapbender.f_collect_epsg(integer) OWNER TO mapbender;

--
-- TOC entry 296 (class 1255 OID 18143)
-- Dependencies: 6 1903
-- Name: f_collect_inspire_cat_layer(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_inspire_cat_layer(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_layer_id ALIAS FOR $1;
  inspire_cat_string  TEXT;
  inspire_cat_record  RECORD;

BEGIN
inspire_cat_string := '';

FOR inspire_cat_record IN SELECT layer_inspire_category.fkey_inspire_category_id from layer_inspire_category WHERE layer_inspire_category.fkey_layer_id=$1  LOOP
inspire_cat_string := inspire_cat_string || '{' ||inspire_cat_record.fkey_inspire_category_id || '}';
END LOOP ;
  
RETURN inspire_cat_string;

END;
$_$;


ALTER FUNCTION mapbender.f_collect_inspire_cat_layer(integer) OWNER TO mapbender;

--
-- TOC entry 297 (class 1255 OID 18144)
-- Dependencies: 6 1903
-- Name: f_collect_inspire_cat_wfs_featuretype(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_inspire_cat_wfs_featuretype(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_featuretype_id ALIAS FOR $1;
  inspire_cat_string  TEXT;
  inspire_cat_record  RECORD;

BEGIN
inspire_cat_string := '';

FOR inspire_cat_record IN SELECT wfs_featuretype_inspire_category.fkey_inspire_category_id from wfs_featuretype_inspire_category WHERE wfs_featuretype_inspire_category.fkey_featuretype_id=$1  LOOP
inspire_cat_string := inspire_cat_string || '{' ||inspire_cat_record.fkey_inspire_category_id || '}';
END LOOP ;
  
RETURN inspire_cat_string;

END;
$_$;


ALTER FUNCTION mapbender.f_collect_inspire_cat_wfs_featuretype(integer) OWNER TO mapbender;

--
-- TOC entry 300 (class 1255 OID 18145)
-- Dependencies: 6 1903
-- Name: f_collect_inspire_cat_wmc(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_inspire_cat_wmc(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_wmc_serial_id ALIAS FOR $1;
  inspire_cat_string  TEXT;
  inspire_cat_record  RECORD;
BEGIN
inspire_cat_string := '';
FOR inspire_cat_record IN SELECT wmc_inspire_category.fkey_inspire_category_id from wmc_inspire_category WHERE wmc_inspire_category.fkey_wmc_serial_id=$1  LOOP
inspire_cat_string := inspire_cat_string || '{' ||inspire_cat_record.fkey_inspire_category_id || '}';
END LOOP ;
RETURN inspire_cat_string;
END;
$_$;


ALTER FUNCTION mapbender.f_collect_inspire_cat_wmc(integer) OWNER TO mapbender;

--
-- TOC entry 303 (class 1255 OID 18146)
-- Dependencies: 6 1903
-- Name: f_collect_searchtext(integer, integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_searchtext(integer, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
    p_wms_id ALIAS FOR $1;
    p_layer_id ALIAS FOR $2;
    
    r_keywords RECORD;
    l_result TEXT;
BEGIN
    l_result := '';
    l_result := l_result || (SELECT COALESCE(wms_title, '') || ' ' || COALESCE(wms_abstract, '') FROM wms WHERE wms_id = p_wms_id);
    l_result := l_result || (SELECT COALESCE(layer_name, '')|| ' ' || COALESCE(layer_title, '')  || ' ' || COALESCE(layer_abstract, '') FROM layer WHERE layer_id = p_layer_id);
    FOR r_keywords IN SELECT DISTINCT keyword FROM
        (SELECT keyword FROM layer_keyword L JOIN keyword K ON (K.keyword_id = L.fkey_keyword_id AND L.fkey_layer_id = p_layer_id)
        ) AS __keywords__ LOOP
        l_result := l_result || ' ' || COALESCE(r_keywords.keyword, '');
    END LOOP;
    FOR r_keywords IN SELECT DISTINCT md_topic_category_code_de FROM
        (SELECT md_topic_category_code_de FROM md_topic_category T JOIN layer_md_topic_category C ON (C.fkey_md_topic_category_id = T.md_topic_category_id AND C.fkey_layer_id = p_layer_id)
        ) AS __keywords__ LOOP
        l_result := l_result || ' ' || COALESCE(r_keywords.md_topic_category_code_de, '');
    END LOOP;
   l_result := UPPER(l_result);
   l_result := replace(replace(replace(replace(replace(replace(replace(l_result,'Ä','AE'),'ß','SS'),'Ö','OE'),'Ü','UE'),'ä','AE'),'ü','UE'),'ö','OE');

    RETURN l_result;
END;
$_$;


ALTER FUNCTION mapbender.f_collect_searchtext(integer, integer) OWNER TO mapbender;

--
-- TOC entry 304 (class 1255 OID 18147)
-- Dependencies: 6 1903
-- Name: f_collect_searchtext_wfs(integer, integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_searchtext_wfs(integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
   p_wfs_id ALIAS FOR $1;
   p_featuretype_id ALIAS FOR $2;
     r_keywords RECORD;
   l_result TEXT;
BEGIN
   l_result := '';
   l_result := l_result || (SELECT COALESCE(wfs_title, '') || ' ' || COALESCE(wfs_abstract, '') FROM wfs WHERE wfs_id = p_wfs_id);
   l_result := l_result || (SELECT COALESCE(featuretype_name, '')|| ' ' || COALESCE(featuretype_title, '')  || ' ' || COALESCE(featuretype_abstract, '') FROM wfs_featuretype WHERE featuretype_id = p_featuretype_id);
   FOR r_keywords IN SELECT DISTINCT keyword FROM
       (SELECT keyword FROM wfs_featuretype_keyword L JOIN keyword K ON (K.keyword_id = L.fkey_keyword_id AND L.fkey_featuretype_id = p_featuretype_id)
       ) AS __keywords__ LOOP
       l_result := l_result || ' ' || COALESCE(r_keywords.keyword, '');
   END LOOP;
  l_result := UPPER(l_result);
  l_result := replace(replace(replace(replace(replace(replace(replace(l_result,'Ä','AE'),'ß','SS'),'Ö','OE'),'Ü','UE'),'ü','UE'),'ö','OE'),'ä','AE');

   RETURN l_result;
END;
$_$;


ALTER FUNCTION mapbender.f_collect_searchtext_wfs(integer, integer) OWNER TO mapbender;

--
-- TOC entry 305 (class 1255 OID 18148)
-- Dependencies: 6 1903
-- Name: f_collect_searchtext_wmc(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_searchtext_wmc(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    p_wmc_id ALIAS FOR $1;
    
    r_keywords RECORD;
    l_result TEXT;
BEGIN
    l_result := '';
    l_result := l_result || (SELECT COALESCE(wmc_title, '') || ' ' || COALESCE(abstract, '') FROM mb_user_wmc WHERE wmc_serial_id = p_wmc_id);
    FOR r_keywords IN SELECT DISTINCT keyword FROM
        (SELECT keyword FROM wmc_keyword L JOIN keyword K ON (K.keyword_id = L.fkey_keyword_id )
        ) AS __keywords__ LOOP
        l_result := l_result || ' ' || COALESCE(r_keywords.keyword, '');
    END LOOP;
   l_result := UPPER(l_result);
   l_result := replace(replace(replace(replace(l_result,'Ä','AE'),'ß','SS'),'Ö','OE'),'Ü','UE');

    RETURN l_result;
END;
$_$;


ALTER FUNCTION mapbender.f_collect_searchtext_wmc(integer) OWNER TO mapbender;

--
-- TOC entry 306 (class 1255 OID 18149)
-- Dependencies: 6 1903
-- Name: f_collect_topic_cat_layer(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_topic_cat_layer(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_layer_id ALIAS FOR $1;
  topic_cat_string  TEXT;
  topic_cat_record  RECORD;

BEGIN
topic_cat_string := '';

FOR topic_cat_record IN SELECT layer_md_topic_category.fkey_md_topic_category_id from layer_md_topic_category WHERE layer_md_topic_category.fkey_layer_id=$1  LOOP
topic_cat_string := topic_cat_string || '{' ||topic_cat_record.fkey_md_topic_category_id || '}';
END LOOP ;
  
RETURN topic_cat_string;

END;
$_$;


ALTER FUNCTION mapbender.f_collect_topic_cat_layer(integer) OWNER TO mapbender;

--
-- TOC entry 307 (class 1255 OID 18150)
-- Dependencies: 1903 6
-- Name: f_collect_topic_cat_wfs_featuretype(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_topic_cat_wfs_featuretype(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_featuretype_id ALIAS FOR $1;
  topic_cat_string  TEXT;
  topic_cat_record  RECORD;

BEGIN
topic_cat_string := '';

FOR topic_cat_record IN SELECT wfs_featuretype_md_topic_category.fkey_md_topic_category_id from wfs_featuretype_md_topic_category WHERE wfs_featuretype_md_topic_category.fkey_featuretype_id=$1  LOOP
topic_cat_string := topic_cat_string || '{' ||topic_cat_record.fkey_md_topic_category_id || '}';
END LOOP ;
  
RETURN topic_cat_string;

END;
$_$;


ALTER FUNCTION mapbender.f_collect_topic_cat_wfs_featuretype(integer) OWNER TO mapbender;

--
-- TOC entry 308 (class 1255 OID 18151)
-- Dependencies: 6 1903
-- Name: f_collect_topic_cat_wmc(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_collect_topic_cat_wmc(integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$DECLARE
  i_wmc_serial_id ALIAS FOR $1;
  topic_cat_string  TEXT;
  topic_cat_record  RECORD;

BEGIN
topic_cat_string := '';

FOR topic_cat_record IN SELECT wmc_md_topic_category.fkey_md_topic_category_id from wmc_md_topic_category WHERE wmc_md_topic_category.fkey_wmc_serial_id=$1  LOOP
topic_cat_string := topic_cat_string || '{' ||topic_cat_record.fkey_md_topic_category_id || '}';
END LOOP ;
  
RETURN topic_cat_string;

END;
$_$;


ALTER FUNCTION mapbender.f_collect_topic_cat_wmc(integer) OWNER TO mapbender;

--
-- TOC entry 309 (class 1255 OID 18152)
-- Dependencies: 6 1903
-- Name: f_getwfs_tou(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_getwfs_tou(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
   wfs_tou int4;
BEGIN
wfs_tou := fkey_termsofuse_id from wfs_termsofuse where wfs_termsofuse.fkey_wfs_id=$1; 
RETURN wfs_tou;

END;
$_$;


ALTER FUNCTION mapbender.f_getwfs_tou(integer) OWNER TO mapbender;

--
-- TOC entry 310 (class 1255 OID 18153)
-- Dependencies: 1903 6
-- Name: f_getwfsmodultype(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_getwfsmodultype(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
    i_search INT4;
BEGIN
i_search := count(*) from wfs_conf, wfs_conf_element where wfs_conf.wfs_conf_id=$1 and wfs_conf.wfs_conf_id=wfs_conf_element.fkey_wfs_conf_id and f_search=1;
IF i_search > 0 THEN 
RETURN 1;
else
RETURN 0;
END IF;

END;
$_$;


ALTER FUNCTION mapbender.f_getwfsmodultype(integer) OWNER TO mapbender;

--
-- TOC entry 311 (class 1255 OID 18154)
-- Dependencies: 6 1903
-- Name: f_getwms_tou(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_getwms_tou(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
   wms_tou int4;
BEGIN
wms_tou := fkey_termsofuse_id from wms_termsofuse where wms_termsofuse.fkey_wms_id=$1; 
RETURN wms_tou;

END;
$_$;


ALTER FUNCTION mapbender.f_getwms_tou(integer) OWNER TO mapbender;

--
-- TOC entry 312 (class 1255 OID 18155)
-- Dependencies: 6 1903
-- Name: f_layer_load_count(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_layer_load_count(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
   layer_rel int4;
BEGIN
layer_rel := load_count from layer_load_count where layer_load_count.fkey_layer_id=$1; 
RETURN layer_rel;

END;
$_$;


ALTER FUNCTION mapbender.f_layer_load_count(integer) OWNER TO mapbender;

--
-- TOC entry 298 (class 1255 OID 18156)
-- Dependencies: 6 1903
-- Name: f_wmc_load_count(integer); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION f_wmc_load_count(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
   wmc_rel int8;
BEGIN
wmc_rel := load_count from wmc_load_count where wmc_load_count.fkey_wmc_serial_id=$1; 
IF wmc_rel IS NULL THEN
	RETURN 0;
ELSE
	RETURN wmc_rel;
END IF;
END;
$_$;


ALTER FUNCTION mapbender.f_wmc_load_count(integer) OWNER TO mapbender;

--
-- TOC entry 313 (class 1255 OID 18157)
-- Dependencies: 1903 6
-- Name: gettext(text, text); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION gettext(locale_arg text, string text) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
 DECLARE
    msgstr varchar(512);
    trl RECORD;
 BEGIN
    -- RAISE NOTICE '>%<', locale_arg;

    SELECT INTO trl * FROM translations
    WHERE trim(from locale) = trim(from locale_arg) AND msgid = string;
    -- we return the original string, if no translation is found.
    -- this is consistent with gettext's behaviour
    IF NOT FOUND THEN
        RETURN string;
    ELSE
	--RAISE NOTICE '>%<', trl.msgstr;
	msgstr := replace(trl.msgstr,'''','`');
        RETURN msgstr;
    END IF;
 END;
 $$;


ALTER FUNCTION mapbender.gettext(locale_arg text, string text) OWNER TO mapbender;

--
-- TOC entry 314 (class 1255 OID 18158)
-- Dependencies: 6 1903
-- Name: mb_monitor_after(); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION mb_monitor_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
   availability_new REAL;
   average_res_cap REAL;
   count_monitors REAL;
    BEGIN
     IF TG_OP = 'UPDATE' THEN
     
     count_monitors := count(fkey_wms_id) from mb_monitor where fkey_wms_id=NEW.fkey_wms_id;
      --the following should be adopted if the duration of storing is changed!!!
      average_res_cap := ((select average_resp_time from mb_wms_availability where fkey_wms_id=NEW.fkey_wms_id)*count_monitors+(NEW.timestamp_end-NEW.timestamp_begin))/(count_monitors+1);

     IF NEW.status > -1 THEN --service gives caps
      availability_new := round(cast(((select availability from mb_wms_availability where fkey_wms_id=NEW.fkey_wms_id)*count_monitors + 100)/(count_monitors+1) as numeric),2);
     ELSE --service has problems with caps
      availability_new := round(cast(((select availability from mb_wms_availability where fkey_wms_id=NEW.fkey_wms_id)*count_monitors)/(count_monitors+1) as numeric),2);
     END IF;

      UPDATE mb_wms_availability SET average_resp_time=average_res_cap,last_status=NEW.status, availability=availability_new, image=NEW.image, status_comment=NEW.status_comment,upload_url=NEW.upload_url,map_url=NEW.map_url, cap_diff=NEW.cap_diff WHERE mb_wms_availability.fkey_wms_id=NEW.fkey_wms_id;
      RETURN NEW;
     END IF;
     IF TG_OP = 'INSERT' THEN

	IF (select count(fkey_wms_id) from mb_wms_availability where fkey_wms_id=NEW.fkey_wms_id) > 0  then -- service is not new
			UPDATE mb_wms_availability set fkey_upload_id=NEW.upload_id,last_status=NEW.status,status_comment=NEW.status_comment,upload_url=NEW.upload_url, cap_diff=NEW.cap_diff where fkey_wms_id=NEW.fkey_wms_id;
		else --service has not yet been monitored
			INSERT INTO mb_wms_availability (fkey_upload_id,fkey_wms_id,last_status,status_comment,upload_url,map_url,cap_diff,average_resp_time,availability) VALUES (NEW.upload_id,NEW.fkey_wms_id,NEW.status,NEW.status_comment,NEW.upload_url::text,NEW.map_url,NEW.cap_diff,0,100);
		end if;

      RETURN NEW;
     END IF;
    END;
$$;


ALTER FUNCTION mapbender.mb_monitor_after() OWNER TO mapbender;

--
-- TOC entry 315 (class 1255 OID 18159)
-- Dependencies: 1903 6
-- Name: update_lastchanged_column(); Type: FUNCTION; Schema: mapbender; Owner: mapbender
--

CREATE FUNCTION update_lastchanged_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.lastchanged = now(); 
   RETURN NEW;
END;
$$;


ALTER FUNCTION mapbender.update_lastchanged_column() OWNER TO mapbender;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 167 (class 1259 OID 18160)
-- Dependencies: 3991 3992 6
-- Name: cat; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE cat (
    cat_id integer NOT NULL,
    cat_version character varying(50) DEFAULT ''::character varying NOT NULL,
    cat_title character varying(255) DEFAULT ''::character varying NOT NULL,
    cat_abstract text,
    cat_upload_url character varying(255),
    fees character varying(50),
    accessconstraints text,
    providername character varying(255),
    providersite character varying(255),
    individualname character varying(255),
    positionname character varying(255),
    voice character varying(255),
    facsimile character varying(255),
    deliverypoint character varying(255),
    city character varying(255),
    administrativearea character varying(255),
    postalcode character varying(255),
    country character varying(255),
    electronicmailaddress character varying(255),
    cat_getcapabilities_doc text,
    cat_owner integer,
    cat_timestamp integer
);


ALTER TABLE mapbender.cat OWNER TO mapbender;

--
-- TOC entry 168 (class 1259 OID 18168)
-- Dependencies: 6 167
-- Name: cat_cat_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE cat_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.cat_cat_id_seq OWNER TO mapbender;

--
-- TOC entry 4469 (class 0 OID 0)
-- Dependencies: 168
-- Name: cat_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE cat_cat_id_seq OWNED BY cat.cat_id;


--
-- TOC entry 4470 (class 0 OID 0)
-- Dependencies: 168
-- Name: cat_cat_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('cat_cat_id_seq', 2, true);


--
-- TOC entry 169 (class 1259 OID 18170)
-- Dependencies: 6
-- Name: cat_keyword; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE cat_keyword (
    fkey_cat_id integer NOT NULL,
    fkey_keyword_id integer NOT NULL
);


ALTER TABLE mapbender.cat_keyword OWNER TO mapbender;

--
-- TOC entry 170 (class 1259 OID 18173)
-- Dependencies: 6
-- Name: cat_op_conf; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE cat_op_conf (
    fk_cat_id integer NOT NULL,
    param_name character varying(255) NOT NULL,
    param_value text NOT NULL,
    param_type character varying(255) NOT NULL
);


ALTER TABLE mapbender.cat_op_conf OWNER TO mapbender;

--
-- TOC entry 171 (class 1259 OID 18179)
-- Dependencies: 6
-- Name: conformity; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE conformity (
    conformity_id integer NOT NULL,
    conformity_key character varying(255),
    fkey_spec_class_key character varying(255),
    conformity_code_en character varying(255),
    conformity_code_fr character varying(255),
    conformity_code_de character varying(255),
    conformity_symbol character varying(255),
    conformity_description_de text
);


ALTER TABLE mapbender.conformity OWNER TO mapbender;

--
-- TOC entry 172 (class 1259 OID 18185)
-- Dependencies: 6 171
-- Name: conformity_conformity_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE conformity_conformity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.conformity_conformity_id_seq OWNER TO mapbender;

--
-- TOC entry 4471 (class 0 OID 0)
-- Dependencies: 172
-- Name: conformity_conformity_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE conformity_conformity_id_seq OWNED BY conformity.conformity_id;


--
-- TOC entry 4472 (class 0 OID 0)
-- Dependencies: 172
-- Name: conformity_conformity_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('conformity_conformity_id_seq', 6, true);


--
-- TOC entry 173 (class 1259 OID 18187)
-- Dependencies: 6
-- Name: conformity_relation; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE conformity_relation (
    relation_id integer NOT NULL,
    fkey_wms_id integer,
    fkey_wfs_id integer,
    fkey_inspire_md_id integer,
    fkey_conformity_id integer,
    fkey_spec_id integer
);


ALTER TABLE mapbender.conformity_relation OWNER TO mapbender;

--
-- TOC entry 174 (class 1259 OID 18190)
-- Dependencies: 173 6
-- Name: conformity_relation_relation_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE conformity_relation_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.conformity_relation_relation_id_seq OWNER TO mapbender;

--
-- TOC entry 4473 (class 0 OID 0)
-- Dependencies: 174
-- Name: conformity_relation_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE conformity_relation_relation_id_seq OWNED BY conformity_relation.relation_id;


--
-- TOC entry 4474 (class 0 OID 0)
-- Dependencies: 174
-- Name: conformity_relation_relation_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('conformity_relation_relation_id_seq', 1, false);


--
-- TOC entry 175 (class 1259 OID 18192)
-- Dependencies: 6
-- Name: custom_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE custom_category (
    custom_category_id integer NOT NULL,
    custom_category_key character varying(5) NOT NULL,
    custom_category_code_en character varying(255),
    custom_category_code_de character varying(255),
    custom_category_code_fr character varying(255),
    custom_category_symbol character varying(255),
    custom_category_description_de text,
    custom_category_hidden integer
);


ALTER TABLE mapbender.custom_category OWNER TO mapbender;

--
-- TOC entry 176 (class 1259 OID 18198)
-- Dependencies: 6 175
-- Name: custom_category_custom_category_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE custom_category_custom_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.custom_category_custom_category_id_seq OWNER TO mapbender;

--
-- TOC entry 4475 (class 0 OID 0)
-- Dependencies: 176
-- Name: custom_category_custom_category_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE custom_category_custom_category_id_seq OWNED BY custom_category.custom_category_id;


--
-- TOC entry 4476 (class 0 OID 0)
-- Dependencies: 176
-- Name: custom_category_custom_category_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('custom_category_custom_category_id_seq', 4, true);


--
-- TOC entry 177 (class 1259 OID 18200)
-- Dependencies: 3997 3998 3999 4000 4001 4002 4003 4004 6
-- Name: datalink; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE datalink (
    datalink_id integer NOT NULL,
    datalink_type character varying(50) DEFAULT ''::character varying NOT NULL,
    datalink_type_version character varying(50) DEFAULT ''::character varying NOT NULL,
    datalink_url text,
    datalink_owner integer,
    datalink_timestamp integer,
    datalink_timestamp_create integer,
    datalink_timestamp_last_usage integer,
    datalink_abstract text,
    datalink_title character varying(255) DEFAULT ''::character varying NOT NULL,
    datalink_data text,
    datalink_network_access integer,
    datalink_owsproxy character varying(50),
    fees character varying(255),
    accessconstraints text,
    crs character varying(50) DEFAULT ''::character varying NOT NULL,
    minx double precision DEFAULT 0,
    miny double precision DEFAULT 0,
    maxx double precision DEFAULT 0,
    maxy double precision DEFAULT 0
);


ALTER TABLE mapbender.datalink OWNER TO mapbender;

--
-- TOC entry 178 (class 1259 OID 18214)
-- Dependencies: 6 177
-- Name: datalink_datalink_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE datalink_datalink_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.datalink_datalink_id_seq OWNER TO mapbender;

--
-- TOC entry 4477 (class 0 OID 0)
-- Dependencies: 178
-- Name: datalink_datalink_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE datalink_datalink_id_seq OWNED BY datalink.datalink_id;


--
-- TOC entry 4478 (class 0 OID 0)
-- Dependencies: 178
-- Name: datalink_datalink_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('datalink_datalink_id_seq', 1, false);


--
-- TOC entry 179 (class 1259 OID 18216)
-- Dependencies: 6
-- Name: datalink_keyword; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE datalink_keyword (
    fkey_datalink_id integer NOT NULL,
    fkey_keyword_id integer NOT NULL
);


ALTER TABLE mapbender.datalink_keyword OWNER TO mapbender;

--
-- TOC entry 180 (class 1259 OID 18219)
-- Dependencies: 6
-- Name: datalink_md_topic_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE datalink_md_topic_category (
    fkey_datalink_id integer NOT NULL,
    fkey_md_topic_category_id integer NOT NULL
);


ALTER TABLE mapbender.datalink_md_topic_category OWNER TO mapbender;

--
-- TOC entry 181 (class 1259 OID 18222)
-- Dependencies: 4006 4007 4008 4009 6
-- Name: gui; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui (
    gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    gui_name character varying(50) DEFAULT ''::character varying NOT NULL,
    gui_description character varying(255) DEFAULT ''::character varying NOT NULL,
    gui_public integer DEFAULT 1 NOT NULL
);


ALTER TABLE mapbender.gui OWNER TO mapbender;

--
-- TOC entry 182 (class 1259 OID 18229)
-- Dependencies: 4010 4011 6
-- Name: gui_cat; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_cat (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_cat_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE mapbender.gui_cat OWNER TO mapbender;

--
-- TOC entry 183 (class 1259 OID 18234)
-- Dependencies: 6
-- Name: gui_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_category (
    category_id integer NOT NULL,
    category_name character varying(50),
    category_description character varying(255)
);


ALTER TABLE mapbender.gui_category OWNER TO mapbender;

--
-- TOC entry 184 (class 1259 OID 18237)
-- Dependencies: 6 183
-- Name: gui_category_category_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE gui_category_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.gui_category_category_id_seq OWNER TO mapbender;

--
-- TOC entry 4479 (class 0 OID 0)
-- Dependencies: 184
-- Name: gui_category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE gui_category_category_id_seq OWNED BY gui_category.category_id;


--
-- TOC entry 4480 (class 0 OID 0)
-- Dependencies: 184
-- Name: gui_category_category_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('gui_category_category_id_seq', 5, true);


--
-- TOC entry 185 (class 1259 OID 18239)
-- Dependencies: 4013 4014 4015 4016 4017 6
-- Name: gui_element; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_element (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    e_id character varying(50) DEFAULT ''::character varying NOT NULL,
    e_pos integer DEFAULT 2 NOT NULL,
    e_public integer DEFAULT 1 NOT NULL,
    e_comment text,
    e_title character varying(255),
    e_element character varying(255) DEFAULT ''::character varying NOT NULL,
    e_src character varying(255),
    e_attributes text,
    e_left integer,
    e_top integer,
    e_width integer,
    e_height integer,
    e_z_index integer,
    e_more_styles text,
    e_content text,
    e_closetag character varying(255),
    e_js_file character varying(255),
    e_mb_mod character varying(255),
    e_target character varying(255),
    e_requires character varying(255),
    e_url character varying(255)
);


ALTER TABLE mapbender.gui_element OWNER TO mapbender;

--
-- TOC entry 186 (class 1259 OID 18250)
-- Dependencies: 4018 4019 4020 6
-- Name: gui_element_vars; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_element_vars (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_e_id character varying(50) DEFAULT ''::character varying NOT NULL,
    var_name character varying(50) DEFAULT ''::character varying NOT NULL,
    var_value text,
    context text,
    var_type character varying(50)
);


ALTER TABLE mapbender.gui_element_vars OWNER TO mapbender;

--
-- TOC entry 187 (class 1259 OID 18259)
-- Dependencies: 6
-- Name: gui_gui_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_gui_category (
    fkey_gui_id character varying(50) NOT NULL,
    fkey_gui_category_id integer NOT NULL
);


ALTER TABLE mapbender.gui_gui_category OWNER TO mapbender;

--
-- TOC entry 188 (class 1259 OID 18262)
-- Dependencies: 6
-- Name: gui_kml; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_kml (
    kml_id integer NOT NULL,
    fkey_mb_user_id integer NOT NULL,
    fkey_gui_id character varying(50) NOT NULL,
    kml_doc text NOT NULL,
    kml_name character varying(64),
    kml_description text,
    kml_timestamp integer NOT NULL
);


ALTER TABLE mapbender.gui_kml OWNER TO mapbender;

--
-- TOC entry 189 (class 1259 OID 18268)
-- Dependencies: 188 6
-- Name: gui_kml_kml_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE gui_kml_kml_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.gui_kml_kml_id_seq OWNER TO mapbender;

--
-- TOC entry 4481 (class 0 OID 0)
-- Dependencies: 189
-- Name: gui_kml_kml_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE gui_kml_kml_id_seq OWNED BY gui_kml.kml_id;


--
-- TOC entry 4482 (class 0 OID 0)
-- Dependencies: 189
-- Name: gui_kml_kml_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('gui_kml_kml_id_seq', 1, false);


--
-- TOC entry 190 (class 1259 OID 18270)
-- Dependencies: 4022 4023 4024 4025 4026 4027 4028 4029 4030 4031 4032 6
-- Name: gui_layer; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_layer (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_layer_id integer DEFAULT 0 NOT NULL,
    gui_layer_wms_id integer DEFAULT 0,
    gui_layer_status integer DEFAULT 1,
    gui_layer_selectable integer DEFAULT 1,
    gui_layer_visible integer DEFAULT 1,
    gui_layer_queryable integer DEFAULT 0,
    gui_layer_querylayer integer DEFAULT 0,
    gui_layer_minscale integer DEFAULT 0,
    gui_layer_maxscale integer DEFAULT 0,
    gui_layer_priority integer,
    gui_layer_style character varying(50),
    gui_layer_wfs_featuretype character varying(50),
    gui_layer_title character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE mapbender.gui_layer OWNER TO mapbender;

--
-- TOC entry 191 (class 1259 OID 18284)
-- Dependencies: 4033 4034 4035 6
-- Name: gui_mb_group; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_mb_group (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_mb_group_id integer DEFAULT 0 NOT NULL,
    mb_group_type character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE mapbender.gui_mb_group OWNER TO mapbender;

--
-- TOC entry 192 (class 1259 OID 18290)
-- Dependencies: 4036 4037 6
-- Name: gui_mb_user; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_mb_user (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_mb_user_id integer DEFAULT 0 NOT NULL,
    mb_user_type character varying(50)
);


ALTER TABLE mapbender.gui_mb_user OWNER TO mapbender;

--
-- TOC entry 193 (class 1259 OID 18295)
-- Dependencies: 4038 4039 4040 6
-- Name: gui_treegde; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_treegde (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_layer_id text,
    id integer NOT NULL,
    lft integer DEFAULT 0 NOT NULL,
    rgt integer DEFAULT 0 NOT NULL,
    my_layer_title character varying(50),
    layer text,
    wms_id text
);


ALTER TABLE mapbender.gui_treegde OWNER TO mapbender;

--
-- TOC entry 194 (class 1259 OID 18304)
-- Dependencies: 193 6
-- Name: gui_treegde_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE gui_treegde_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.gui_treegde_id_seq OWNER TO mapbender;

--
-- TOC entry 4483 (class 0 OID 0)
-- Dependencies: 194
-- Name: gui_treegde_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE gui_treegde_id_seq OWNED BY gui_treegde.id;


--
-- TOC entry 4484 (class 0 OID 0)
-- Dependencies: 194
-- Name: gui_treegde_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('gui_treegde_id_seq', 1, false);


--
-- TOC entry 195 (class 1259 OID 18306)
-- Dependencies: 4042 4043 6
-- Name: gui_wfs; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_wfs (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_wfs_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE mapbender.gui_wfs OWNER TO mapbender;

--
-- TOC entry 196 (class 1259 OID 18311)
-- Dependencies: 4044 4045 6
-- Name: gui_wfs_conf; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_wfs_conf (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_wfs_conf_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE mapbender.gui_wfs_conf OWNER TO mapbender;

--
-- TOC entry 197 (class 1259 OID 18316)
-- Dependencies: 4046 4047 4048 4049 4050 4051 4052 4053 4054 4055 6
-- Name: gui_wms; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE gui_wms (
    fkey_gui_id character varying(50) DEFAULT ''::character varying NOT NULL,
    fkey_wms_id integer DEFAULT 0 NOT NULL,
    gui_wms_position integer DEFAULT 0 NOT NULL,
    gui_wms_mapformat character varying(50) DEFAULT ''::character varying NOT NULL,
    gui_wms_featureinfoformat character varying(50) DEFAULT ''::character varying NOT NULL,
    gui_wms_exceptionformat character varying(50) DEFAULT ''::character varying NOT NULL,
    gui_wms_epsg character varying(50) DEFAULT ''::character varying NOT NULL,
    gui_wms_visible integer DEFAULT 1 NOT NULL,
    gui_wms_sldurl character varying(255) DEFAULT ''::character varying NOT NULL,
    gui_wms_opacity integer DEFAULT 100
);


ALTER TABLE mapbender.gui_wms OWNER TO mapbender;

--
-- TOC entry 198 (class 1259 OID 18332)
-- Dependencies: 6
-- Name: inspire_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE inspire_category (
    inspire_category_id integer NOT NULL,
    inspire_category_key character varying(5) NOT NULL,
    inspire_category_code_en character varying(255),
    inspire_category_code_de character varying(255),
    inspire_category_code_fr character varying(255),
    inspire_category_symbol character varying(255),
    inspire_category_description_de text
);


ALTER TABLE mapbender.inspire_category OWNER TO mapbender;

--
-- TOC entry 199 (class 1259 OID 18338)
-- Dependencies: 6 198
-- Name: inspire_category_inspire_category_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE inspire_category_inspire_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.inspire_category_inspire_category_id_seq OWNER TO mapbender;

--
-- TOC entry 4485 (class 0 OID 0)
-- Dependencies: 199
-- Name: inspire_category_inspire_category_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE inspire_category_inspire_category_id_seq OWNED BY inspire_category.inspire_category_id;


--
-- TOC entry 4486 (class 0 OID 0)
-- Dependencies: 199
-- Name: inspire_category_inspire_category_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('inspire_category_inspire_category_id_seq', 34, true);


--
-- TOC entry 200 (class 1259 OID 18340)
-- Dependencies: 6
-- Name: inspire_md_data; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE inspire_md_data (
    data_id integer NOT NULL,
    data_time_begin integer,
    data_time_end integer,
    data_lineage text,
    data_spatial_res_value character varying(255),
    data_spatial_res_type integer
);


ALTER TABLE mapbender.inspire_md_data OWNER TO mapbender;

--
-- TOC entry 201 (class 1259 OID 18346)
-- Dependencies: 6 200
-- Name: inspire_md_data_data_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE inspire_md_data_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.inspire_md_data_data_id_seq OWNER TO mapbender;

--
-- TOC entry 4487 (class 0 OID 0)
-- Dependencies: 201
-- Name: inspire_md_data_data_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE inspire_md_data_data_id_seq OWNED BY inspire_md_data.data_id;


--
-- TOC entry 4488 (class 0 OID 0)
-- Dependencies: 201
-- Name: inspire_md_data_data_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('inspire_md_data_data_id_seq', 1, false);


--
-- TOC entry 202 (class 1259 OID 18348)
-- Dependencies: 6
-- Name: keyword; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE keyword (
    keyword_id integer NOT NULL,
    keyword character varying(255) NOT NULL
);


ALTER TABLE mapbender.keyword OWNER TO mapbender;

--
-- TOC entry 203 (class 1259 OID 18351)
-- Dependencies: 202 6
-- Name: keyword_keyword_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE keyword_keyword_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.keyword_keyword_id_seq OWNER TO mapbender;

--
-- TOC entry 4489 (class 0 OID 0)
-- Dependencies: 203
-- Name: keyword_keyword_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE keyword_keyword_id_seq OWNED BY keyword.keyword_id;


--
-- TOC entry 4490 (class 0 OID 0)
-- Dependencies: 203
-- Name: keyword_keyword_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('keyword_keyword_id_seq', 406, true);


--
-- TOC entry 204 (class 1259 OID 18353)
-- Dependencies: 4059 4060 4061 4062 4063 4064 4065 4066 4067 6
-- Name: layer; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer (
    layer_id integer NOT NULL,
    fkey_wms_id integer DEFAULT 0 NOT NULL,
    layer_pos integer DEFAULT 0 NOT NULL,
    layer_parent character varying(50) DEFAULT ''::character varying NOT NULL,
    layer_name character varying(255) DEFAULT ''::character varying NOT NULL,
    layer_title character varying(255) DEFAULT ''::character varying NOT NULL,
    layer_queryable integer DEFAULT 0 NOT NULL,
    layer_minscale integer DEFAULT 0,
    layer_maxscale integer DEFAULT 0,
    layer_dataurl character varying(255),
    layer_metadataurl character varying(255),
    layer_abstract text,
    layer_searchable integer DEFAULT 1,
    uuid uuid
);


ALTER TABLE mapbender.layer OWNER TO mapbender;

--
-- TOC entry 205 (class 1259 OID 18368)
-- Dependencies: 6
-- Name: layer_custom_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_custom_category (
    fkey_layer_id integer NOT NULL,
    fkey_custom_category_id integer NOT NULL
);


ALTER TABLE mapbender.layer_custom_category OWNER TO mapbender;

--
-- TOC entry 206 (class 1259 OID 18371)
-- Dependencies: 4069 4070 4071 4072 4073 4074 6
-- Name: layer_epsg; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_epsg (
    fkey_layer_id integer DEFAULT 0 NOT NULL,
    epsg character varying(50) DEFAULT ''::character varying NOT NULL,
    minx double precision DEFAULT 0,
    miny double precision DEFAULT 0,
    maxx double precision DEFAULT 0,
    maxy double precision DEFAULT 0
);


ALTER TABLE mapbender.layer_epsg OWNER TO mapbender;

--
-- TOC entry 207 (class 1259 OID 18380)
-- Dependencies: 6
-- Name: layer_inspire_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_inspire_category (
    fkey_layer_id integer NOT NULL,
    fkey_inspire_category_id integer NOT NULL
);


ALTER TABLE mapbender.layer_inspire_category OWNER TO mapbender;

--
-- TOC entry 208 (class 1259 OID 18383)
-- Dependencies: 6
-- Name: layer_keyword; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_keyword (
    fkey_layer_id integer NOT NULL,
    fkey_keyword_id integer NOT NULL
);


ALTER TABLE mapbender.layer_keyword OWNER TO mapbender;

--
-- TOC entry 209 (class 1259 OID 18386)
-- Dependencies: 204 6
-- Name: layer_layer_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE layer_layer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.layer_layer_id_seq OWNER TO mapbender;

--
-- TOC entry 4491 (class 0 OID 0)
-- Dependencies: 209
-- Name: layer_layer_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE layer_layer_id_seq OWNED BY layer.layer_id;


--
-- TOC entry 4492 (class 0 OID 0)
-- Dependencies: 209
-- Name: layer_layer_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('layer_layer_id_seq', 20531, true);


--
-- TOC entry 210 (class 1259 OID 18388)
-- Dependencies: 6
-- Name: layer_load_count; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_load_count (
    fkey_layer_id integer,
    load_count bigint
);


ALTER TABLE mapbender.layer_load_count OWNER TO mapbender;

--
-- TOC entry 211 (class 1259 OID 18391)
-- Dependencies: 6
-- Name: layer_md_topic_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_md_topic_category (
    fkey_layer_id integer NOT NULL,
    fkey_md_topic_category_id integer NOT NULL
);


ALTER TABLE mapbender.layer_md_topic_category OWNER TO mapbender;

--
-- TOC entry 212 (class 1259 OID 18394)
-- Dependencies: 6
-- Name: layer_preview; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_preview (
    fkey_layer_id integer NOT NULL,
    layer_map_preview_filename character varying(100),
    layer_extent_preview_filename character varying(100),
    layer_legend_preview_filename character varying(100)
);


ALTER TABLE mapbender.layer_preview OWNER TO mapbender;

--
-- TOC entry 213 (class 1259 OID 18397)
-- Dependencies: 4075 4076 4077 6
-- Name: layer_style; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE layer_style (
    fkey_layer_id integer DEFAULT 0 NOT NULL,
    name character varying(50) DEFAULT ''::character varying NOT NULL,
    title character varying(100) DEFAULT ''::character varying NOT NULL,
    legendurl character varying(255),
    legendurlformat character varying(50)
);


ALTER TABLE mapbender.layer_style OWNER TO mapbender;

--
-- TOC entry 214 (class 1259 OID 18403)
-- Dependencies: 4078 4079 4080 4081 4082 4083 4084 4085 4086 4087 4088 4089 6
-- Name: mb_group; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_group (
    mb_group_id integer NOT NULL,
    mb_group_name character varying(50) DEFAULT ''::character varying NOT NULL,
    mb_group_owner integer,
    mb_group_description character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_title character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_ext_id bigint,
    mb_group_address character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_postcode character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_city character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_stateorprovince character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_country character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_voicetelephone character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_facsimiletelephone character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_email character varying(255) DEFAULT ''::character varying NOT NULL,
    mb_group_logo_path text DEFAULT ''::character varying NOT NULL,
    mb_group_homepage character varying(255)
);


ALTER TABLE mapbender.mb_group OWNER TO mapbender;

--
-- TOC entry 215 (class 1259 OID 18421)
-- Dependencies: 6 214
-- Name: mb_group_mb_group_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE mb_group_mb_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.mb_group_mb_group_id_seq OWNER TO mapbender;

--
-- TOC entry 4493 (class 0 OID 0)
-- Dependencies: 215
-- Name: mb_group_mb_group_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE mb_group_mb_group_id_seq OWNED BY mb_group.mb_group_id;


--
-- TOC entry 4494 (class 0 OID 0)
-- Dependencies: 215
-- Name: mb_group_mb_group_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('mb_group_mb_group_id_seq', 21, true);


--
-- TOC entry 216 (class 1259 OID 18423)
-- Dependencies: 4091 6
-- Name: mb_log; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_log (
    id integer NOT NULL,
    time_client character varying(13) DEFAULT 0,
    time_server character varying(13),
    time_readable character varying(50),
    mb_session character varying(50),
    gui character varying(50),
    module character varying(50),
    ip character varying(20),
    username character varying(50),
    userid character varying(50),
    request text
);


ALTER TABLE mapbender.mb_log OWNER TO mapbender;

--
-- TOC entry 217 (class 1259 OID 18430)
-- Dependencies: 6 216
-- Name: mb_log_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE mb_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.mb_log_id_seq OWNER TO mapbender;

--
-- TOC entry 4495 (class 0 OID 0)
-- Dependencies: 217
-- Name: mb_log_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE mb_log_id_seq OWNED BY mb_log.id;


--
-- TOC entry 4496 (class 0 OID 0)
-- Dependencies: 217
-- Name: mb_log_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('mb_log_id_seq', 1132, true);


--
-- TOC entry 218 (class 1259 OID 18432)
-- Dependencies: 4093 4094 4095 4096 4098 4099 4100 1572 6
-- Name: mb_metadata; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_metadata (
    metadata_id integer NOT NULL,
    uuid character varying(100),
    origin character varying(100),
    includeincaps boolean DEFAULT true,
    schema character varying(32),
    createdate timestamp without time zone,
    changedate timestamp without time zone,
    lastchanged timestamp without time zone DEFAULT now() NOT NULL,
    data text,
    link character varying(250),
    linktype character varying(100),
    md_format character varying(100),
    title character varying(250),
    abstract text,
    searchtext text,
    status character varying(50),
    type character varying(50),
    harvestresult integer,
    harvestexception text,
    export2csw boolean,
    tmp_reference_1 timestamp without time zone,
    tmp_reference_2 timestamp without time zone,
    spatial_res_type character varying(20),
    spatial_res_value character varying(20),
    ref_system character varying(20),
    format character varying(100),
    inspire_charset character varying(10),
    inspire_top_consistence boolean,
    fkey_mb_user_id integer DEFAULT 1 NOT NULL,
    responsible_party integer,
    individual_name integer,
    visibility character varying(12),
    locked boolean DEFAULT false,
    copyof character varying(100),
    constraints text,
    fees character varying(2500),
    classification character varying(100),
    browse_graphic character varying(255),
    inspire_conformance boolean,
    preview_image text,
    the_geom public.geometry,
    lineage text,
    datasetid text,
    randomid character varying(100),
    update_frequency character varying(100),
    responsible_party_name character varying(100),
    CONSTRAINT enforce_dims_the_geom CHECK ((public.ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((public.geometrytype(the_geom) = 'MULTIPOLYGON'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.srid(the_geom) = 4326))
);


ALTER TABLE mapbender.mb_metadata OWNER TO mapbender;

--
-- TOC entry 219 (class 1259 OID 18445)
-- Dependencies: 6 218
-- Name: mb_metadata_metadata_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE mb_metadata_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.mb_metadata_metadata_id_seq OWNER TO mapbender;

--
-- TOC entry 4497 (class 0 OID 0)
-- Dependencies: 219
-- Name: mb_metadata_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE mb_metadata_metadata_id_seq OWNED BY mb_metadata.metadata_id;


--
-- TOC entry 4498 (class 0 OID 0)
-- Dependencies: 219
-- Name: mb_metadata_metadata_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('mb_metadata_metadata_id_seq', 12, true);


--
-- TOC entry 220 (class 1259 OID 18447)
-- Dependencies: 4101 4102 4103 4104 4105 4106 6
-- Name: mb_monitor; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_monitor (
    upload_id character varying(255) DEFAULT ''::character varying NOT NULL,
    fkey_wms_id integer DEFAULT 0 NOT NULL,
    status integer NOT NULL,
    status_comment character varying(255) DEFAULT ''::character varying NOT NULL,
    timestamp_begin integer NOT NULL,
    timestamp_end integer NOT NULL,
    upload_url character varying(255) DEFAULT ''::character varying NOT NULL,
    updated character(1) DEFAULT ''::bpchar NOT NULL,
    image integer,
    map_url character varying(2048),
    cap_diff text DEFAULT ''::text
);


ALTER TABLE mapbender.mb_monitor OWNER TO mapbender;

--
-- TOC entry 221 (class 1259 OID 18459)
-- Dependencies: 4107 6
-- Name: mb_proxy_log; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_proxy_log (
    proxy_log_timestamp timestamp without time zone DEFAULT now(),
    fkey_wms_id integer NOT NULL,
    fkey_mb_user_id integer NOT NULL,
    request character varying(4096),
    pixel bigint,
    price real
);


ALTER TABLE mapbender.mb_proxy_log OWNER TO mapbender;

--
-- TOC entry 222 (class 1259 OID 18466)
-- Dependencies: 4108 6
-- Name: mb_role; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_role (
    role_id integer NOT NULL,
    role_name character varying(50),
    role_description character varying(255),
    role_exclude_auth integer DEFAULT 0 NOT NULL
);


ALTER TABLE mapbender.mb_role OWNER TO mapbender;

--
-- TOC entry 223 (class 1259 OID 18470)
-- Dependencies: 6 222
-- Name: mb_role_role_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE mb_role_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.mb_role_role_id_seq OWNER TO mapbender;

--
-- TOC entry 4499 (class 0 OID 0)
-- Dependencies: 223
-- Name: mb_role_role_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE mb_role_role_id_seq OWNED BY mb_role.role_id;


--
-- TOC entry 4500 (class 0 OID 0)
-- Dependencies: 223
-- Name: mb_role_role_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('mb_role_role_id_seq', 6, true);


--
-- TOC entry 224 (class 1259 OID 18472)
-- Dependencies: 4110 4111 4112 4113 4114 4115 4116 4117 6
-- Name: mb_user; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_user (
    mb_user_id integer NOT NULL,
    mb_user_name character varying(50) DEFAULT ''::character varying NOT NULL,
    mb_user_password character varying(50) DEFAULT ''::character varying NOT NULL,
    mb_user_owner integer DEFAULT 0 NOT NULL,
    mb_user_description character varying(255),
    mb_user_login_count integer DEFAULT 0 NOT NULL,
    mb_user_email character varying(50),
    mb_user_phone character varying(50),
    mb_user_department character varying(255),
    mb_user_resolution integer DEFAULT 72 NOT NULL,
    mb_user_organisation_name character varying(255),
    mb_user_position_name character varying(255),
    mb_user_phone1 character varying(255),
    mb_user_facsimile character varying(255),
    mb_user_delivery_point character varying(255),
    mb_user_city character varying(255),
    mb_user_postal_code integer,
    mb_user_country character varying(255),
    mb_user_online_resource character varying(255),
    mb_user_realname character varying(100),
    mb_user_street character varying(100),
    mb_user_housenumber character varying(50),
    mb_user_reference character varying(100),
    mb_user_for_attention_of character varying(100),
    mb_user_valid_from date,
    mb_user_valid_to date,
    mb_user_password_ticket character varying(100),
    mb_user_digest text,
    mb_user_firstname character varying(255) DEFAULT ''::character varying,
    mb_user_lastname character varying(255) DEFAULT ''::character varying,
    mb_user_academictitle character varying(255) DEFAULT ''::character varying
);


ALTER TABLE mapbender.mb_user OWNER TO mapbender;

--
-- TOC entry 225 (class 1259 OID 18486)
-- Dependencies: 6
-- Name: mb_user_abo_ows; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_user_abo_ows (
    fkey_mb_user_id integer,
    fkey_wms_id integer,
    fkey_wfs_id integer
);


ALTER TABLE mapbender.mb_user_abo_ows OWNER TO mapbender;

--
-- TOC entry 226 (class 1259 OID 18489)
-- Dependencies: 4119 4120 4121 6
-- Name: mb_user_mb_group; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_user_mb_group (
    fkey_mb_user_id integer DEFAULT 0 NOT NULL,
    fkey_mb_group_id integer DEFAULT 0 NOT NULL,
    mb_user_mb_group_type integer DEFAULT 1 NOT NULL
);


ALTER TABLE mapbender.mb_user_mb_group OWNER TO mapbender;

--
-- TOC entry 227 (class 1259 OID 18495)
-- Dependencies: 224 6
-- Name: mb_user_mb_user_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE mb_user_mb_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.mb_user_mb_user_id_seq OWNER TO mapbender;

--
-- TOC entry 4501 (class 0 OID 0)
-- Dependencies: 227
-- Name: mb_user_mb_user_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE mb_user_mb_user_id_seq OWNED BY mb_user.mb_user_id;


--
-- TOC entry 4502 (class 0 OID 0)
-- Dependencies: 227
-- Name: mb_user_mb_user_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('mb_user_mb_user_id_seq', 9, true);


--
-- TOC entry 228 (class 1259 OID 18497)
-- Dependencies: 6
-- Name: mb_user_wmc_wmc_serial_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE mb_user_wmc_wmc_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.mb_user_wmc_wmc_serial_id_seq OWNER TO mapbender;

--
-- TOC entry 4503 (class 0 OID 0)
-- Dependencies: 228
-- Name: mb_user_wmc_wmc_serial_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('mb_user_wmc_wmc_serial_id_seq', 1, false);


--
-- TOC entry 229 (class 1259 OID 18499)
-- Dependencies: 4122 4123 4124 4125 4126 4127 4128 4129 6
-- Name: mb_user_wmc; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_user_wmc (
    wmc_id character varying(20) DEFAULT ''::character varying NOT NULL,
    fkey_user_id integer DEFAULT 0 NOT NULL,
    wmc text NOT NULL,
    wmc_title character varying(50),
    wmc_timestamp integer,
    wmc_serial_id integer DEFAULT nextval('mb_user_wmc_wmc_serial_id_seq'::regclass) NOT NULL,
    wmc_timestamp_create integer,
    wmc_public integer DEFAULT 0 NOT NULL,
    abstract text,
    srs character varying,
    minx double precision DEFAULT 0,
    miny double precision DEFAULT 0,
    maxx double precision DEFAULT 0,
    maxy double precision DEFAULT 0
);


ALTER TABLE mapbender.mb_user_wmc OWNER TO mapbender;

--
-- TOC entry 230 (class 1259 OID 18513)
-- Dependencies: 4130 6
-- Name: mb_wms_availability; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE mb_wms_availability (
    fkey_wms_id integer,
    fkey_upload_id character varying,
    last_status integer,
    availability real,
    image integer,
    status_comment character varying,
    average_resp_time real,
    upload_url character varying,
    map_url character varying,
    cap_diff text DEFAULT ''::text
);


ALTER TABLE mapbender.mb_wms_availability OWNER TO mapbender;

--
-- TOC entry 231 (class 1259 OID 18520)
-- Dependencies: 6
-- Name: md_topic_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE md_topic_category (
    md_topic_category_id integer NOT NULL,
    md_topic_category_code_en character varying(255),
    md_topic_category_code_de character varying(255)
);


ALTER TABLE mapbender.md_topic_category OWNER TO mapbender;

--
-- TOC entry 232 (class 1259 OID 18526)
-- Dependencies: 231 6
-- Name: md_topic_category_md_topic_category_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE md_topic_category_md_topic_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.md_topic_category_md_topic_category_id_seq OWNER TO mapbender;

--
-- TOC entry 4504 (class 0 OID 0)
-- Dependencies: 232
-- Name: md_topic_category_md_topic_category_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE md_topic_category_md_topic_category_id_seq OWNED BY md_topic_category.md_topic_category_id;


--
-- TOC entry 4505 (class 0 OID 0)
-- Dependencies: 232
-- Name: md_topic_category_md_topic_category_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('md_topic_category_md_topic_category_id_seq', 19, true);


--
-- TOC entry 233 (class 1259 OID 18528)
-- Dependencies: 6
-- Name: ows_relation_metadata; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE ows_relation_metadata (
    fkey_metadata_id integer NOT NULL,
    fkey_layer_id integer,
    fkey_featuretype_id integer
);


ALTER TABLE mapbender.ows_relation_metadata OWNER TO mapbender;

--
-- TOC entry 234 (class 1259 OID 18531)
-- Dependencies: 3990 6
-- Name: registrating_groups; Type: VIEW; Schema: mapbender; Owner: mapbender
--

CREATE VIEW registrating_groups AS
    SELECT f.fkey_mb_group_id, f.fkey_mb_user_id FROM mb_user_mb_group f, mb_user_mb_group s WHERE (((f.mb_user_mb_group_type = 1) AND (s.fkey_mb_group_id = 36)) AND (f.fkey_mb_user_id = s.fkey_mb_user_id)) ORDER BY f.fkey_mb_group_id, f.fkey_mb_user_id;


ALTER TABLE mapbender.registrating_groups OWNER TO mapbender;

--
-- TOC entry 235 (class 1259 OID 18535)
-- Dependencies: 6
-- Name: sld_user_layer; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE sld_user_layer (
    sld_user_layer_id integer NOT NULL,
    fkey_mb_user_id integer NOT NULL,
    fkey_layer_id integer NOT NULL,
    fkey_gui_id character varying,
    sld_xml text,
    use_sld smallint
);


ALTER TABLE mapbender.sld_user_layer OWNER TO mapbender;

--
-- TOC entry 236 (class 1259 OID 18541)
-- Dependencies: 235 6
-- Name: sld_user_layer_sld_user_layer_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE sld_user_layer_sld_user_layer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.sld_user_layer_sld_user_layer_id_seq OWNER TO mapbender;

--
-- TOC entry 4506 (class 0 OID 0)
-- Dependencies: 236
-- Name: sld_user_layer_sld_user_layer_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE sld_user_layer_sld_user_layer_id_seq OWNED BY sld_user_layer.sld_user_layer_id;


--
-- TOC entry 4507 (class 0 OID 0)
-- Dependencies: 236
-- Name: sld_user_layer_sld_user_layer_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('sld_user_layer_sld_user_layer_id_seq', 1, false);


--
-- TOC entry 237 (class 1259 OID 18543)
-- Dependencies: 6
-- Name: spec; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE spec (
    spec_id integer NOT NULL,
    spec_key character varying(50) NOT NULL,
    spec_code_en character varying,
    spec_code_de character varying,
    spec_code_fr character varying,
    spec_link_en character varying,
    spec_link_de character varying,
    spec_link_fr character varying,
    spec_description_en text,
    spec_description_de text,
    spec_description_fr text,
    fkey_spec_class_key character varying(255),
    spec_timestamp integer
);


ALTER TABLE mapbender.spec OWNER TO mapbender;

--
-- TOC entry 238 (class 1259 OID 18549)
-- Dependencies: 6
-- Name: spec_classification; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE spec_classification (
    spec_class_id integer NOT NULL,
    spec_class_key character varying(255),
    spec_class_code_de character varying(255),
    spec_class_code_en character varying(255),
    spec_class_code_fr character varying(255),
    spec_class_description_en text,
    spec_class_description_de text,
    spec_class_description_fr text,
    spec_class_timestamp integer
);


ALTER TABLE mapbender.spec_classification OWNER TO mapbender;

--
-- TOC entry 239 (class 1259 OID 18555)
-- Dependencies: 238 6
-- Name: spec_classification_spec_class_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE spec_classification_spec_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.spec_classification_spec_class_id_seq OWNER TO mapbender;

--
-- TOC entry 4508 (class 0 OID 0)
-- Dependencies: 239
-- Name: spec_classification_spec_class_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE spec_classification_spec_class_id_seq OWNED BY spec_classification.spec_class_id;


--
-- TOC entry 4509 (class 0 OID 0)
-- Dependencies: 239
-- Name: spec_classification_spec_class_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('spec_classification_spec_class_id_seq', 1, true);


--
-- TOC entry 240 (class 1259 OID 18557)
-- Dependencies: 237 6
-- Name: spec_spec_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE spec_spec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.spec_spec_id_seq OWNER TO mapbender;

--
-- TOC entry 4510 (class 0 OID 0)
-- Dependencies: 240
-- Name: spec_spec_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE spec_spec_id_seq OWNED BY spec.spec_id;


--
-- TOC entry 4511 (class 0 OID 0)
-- Dependencies: 240
-- Name: spec_spec_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('spec_spec_id_seq', 2, true);


--
-- TOC entry 241 (class 1259 OID 18559)
-- Dependencies: 6
-- Name: termsofuse; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE termsofuse (
    termsofuse_id integer NOT NULL,
    name character varying(255),
    symbollink character varying(255),
    description character varying(255),
    descriptionlink character varying(255)
);


ALTER TABLE mapbender.termsofuse OWNER TO mapbender;

--
-- TOC entry 242 (class 1259 OID 18565)
-- Dependencies: 6
-- Name: translations; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE translations (
    trs_id integer NOT NULL,
    locale character varying(8),
    msgid character varying(512),
    msgstr character varying(512)
);


ALTER TABLE mapbender.translations OWNER TO mapbender;

--
-- TOC entry 243 (class 1259 OID 18571)
-- Dependencies: 242 6
-- Name: translations_trs_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE translations_trs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.translations_trs_id_seq OWNER TO mapbender;

--
-- TOC entry 4512 (class 0 OID 0)
-- Dependencies: 243
-- Name: translations_trs_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE translations_trs_id_seq OWNED BY translations.trs_id;


--
-- TOC entry 4513 (class 0 OID 0)
-- Dependencies: 243
-- Name: translations_trs_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('translations_trs_id_seq', 749, true);


--
-- TOC entry 244 (class 1259 OID 18573)
-- Dependencies: 4136 4137 4138 6
-- Name: wfs; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs (
    wfs_id integer NOT NULL,
    wfs_version character varying(50) DEFAULT ''::character varying NOT NULL,
    wfs_name character varying(255),
    wfs_title character varying(255) DEFAULT ''::character varying NOT NULL,
    wfs_abstract text,
    wfs_getcapabilities character varying(255) DEFAULT ''::character varying NOT NULL,
    wfs_describefeaturetype character varying(255),
    wfs_getfeature character varying(255),
    wfs_transaction character varying(255),
    wfs_owsproxy character varying(50),
    wfs_getcapabilities_doc text,
    wfs_upload_url character varying(255),
    fees text,
    accessconstraints text,
    individualname character varying(255),
    positionname character varying(255),
    providername character varying(255),
    city character varying(255),
    deliverypoint character varying(255),
    administrativearea character varying(255),
    postalcode character varying(255),
    voice character varying(255),
    facsimile character varying(255),
    electronicmailaddress character varying(255),
    wfs_mb_getcapabilities_doc text,
    wfs_owner integer,
    wfs_timestamp integer,
    country character varying(255),
    wfs_timestamp_create integer,
    wfs_network_access integer,
    fkey_mb_group_id integer,
    uuid uuid
);


ALTER TABLE mapbender.wfs OWNER TO mapbender;

--
-- TOC entry 245 (class 1259 OID 18582)
-- Dependencies: 4140 4141 4142 4143 4144 6
-- Name: wfs_conf; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_conf (
    wfs_conf_id integer NOT NULL,
    wfs_conf_abstract text,
    fkey_wfs_id integer DEFAULT 0 NOT NULL,
    fkey_featuretype_id integer DEFAULT 0 NOT NULL,
    g_label character varying(50),
    g_label_id character varying(50),
    g_button character varying(50),
    g_button_id character varying(50),
    g_style text,
    g_buffer double precision DEFAULT 0,
    g_res_style text,
    g_use_wzgraphics integer DEFAULT 0,
    wfs_conf_description text,
    wfs_conf_type integer DEFAULT 0 NOT NULL
);


ALTER TABLE mapbender.wfs_conf OWNER TO mapbender;

--
-- TOC entry 246 (class 1259 OID 18593)
-- Dependencies: 4146 4147 4148 4149 4150 4151 4152 6
-- Name: wfs_conf_element; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_conf_element (
    wfs_conf_element_id integer NOT NULL,
    fkey_wfs_conf_id integer DEFAULT 0 NOT NULL,
    f_id integer DEFAULT 0 NOT NULL,
    f_geom integer DEFAULT 0,
    f_gid integer DEFAULT 0 NOT NULL,
    f_search integer,
    f_pos integer,
    f_style_id character varying(255),
    f_toupper integer,
    f_label character varying(255),
    f_label_id character varying(50),
    f_show integer,
    f_respos integer,
    f_form_element_html text,
    f_edit integer,
    f_mandatory integer,
    f_auth_varname character varying(255),
    f_show_detail integer,
    f_operator character varying(50),
    f_detailpos integer DEFAULT 0,
    f_min_input integer DEFAULT 0,
    f_helptext text,
    f_category_name character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE mapbender.wfs_conf_element OWNER TO mapbender;

--
-- TOC entry 247 (class 1259 OID 18606)
-- Dependencies: 246 6
-- Name: wfs_conf_element_wfs_conf_element_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE wfs_conf_element_wfs_conf_element_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.wfs_conf_element_wfs_conf_element_id_seq OWNER TO mapbender;

--
-- TOC entry 4514 (class 0 OID 0)
-- Dependencies: 247
-- Name: wfs_conf_element_wfs_conf_element_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE wfs_conf_element_wfs_conf_element_id_seq OWNED BY wfs_conf_element.wfs_conf_element_id;


--
-- TOC entry 4515 (class 0 OID 0)
-- Dependencies: 247
-- Name: wfs_conf_element_wfs_conf_element_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('wfs_conf_element_wfs_conf_element_id_seq', 52, true);


--
-- TOC entry 248 (class 1259 OID 18608)
-- Dependencies: 245 6
-- Name: wfs_conf_wfs_conf_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE wfs_conf_wfs_conf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.wfs_conf_wfs_conf_id_seq OWNER TO mapbender;

--
-- TOC entry 4516 (class 0 OID 0)
-- Dependencies: 248
-- Name: wfs_conf_wfs_conf_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE wfs_conf_wfs_conf_id_seq OWNED BY wfs_conf.wfs_conf_id;


--
-- TOC entry 4517 (class 0 OID 0)
-- Dependencies: 248
-- Name: wfs_conf_wfs_conf_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('wfs_conf_wfs_conf_id_seq', 8, true);


--
-- TOC entry 249 (class 1259 OID 18610)
-- Dependencies: 4154 6
-- Name: wfs_element; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_element (
    fkey_featuretype_id integer DEFAULT 0 NOT NULL,
    element_id integer NOT NULL,
    element_name character varying(255),
    element_type character varying(255)
);


ALTER TABLE mapbender.wfs_element OWNER TO mapbender;

--
-- TOC entry 250 (class 1259 OID 18617)
-- Dependencies: 6 249
-- Name: wfs_element_element_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE wfs_element_element_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.wfs_element_element_id_seq OWNER TO mapbender;

--
-- TOC entry 4518 (class 0 OID 0)
-- Dependencies: 250
-- Name: wfs_element_element_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE wfs_element_element_id_seq OWNED BY wfs_element.element_id;


--
-- TOC entry 4519 (class 0 OID 0)
-- Dependencies: 250
-- Name: wfs_element_element_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('wfs_element_element_id_seq', 190, true);


--
-- TOC entry 251 (class 1259 OID 18619)
-- Dependencies: 4156 4157 4158 6
-- Name: wfs_featuretype; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_featuretype (
    fkey_wfs_id integer DEFAULT 0 NOT NULL,
    featuretype_id integer NOT NULL,
    featuretype_name character varying(255) DEFAULT ''::character varying NOT NULL,
    featuretype_title character varying(255),
    featuretype_srs character varying(50),
    featuretype_searchable integer DEFAULT 1,
    featuretype_abstract text,
    uuid uuid
);


ALTER TABLE mapbender.wfs_featuretype OWNER TO mapbender;

--
-- TOC entry 252 (class 1259 OID 18628)
-- Dependencies: 6
-- Name: wfs_featuretype_custom_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_featuretype_custom_category (
    fkey_featuretype_id integer NOT NULL,
    fkey_custom_category_id integer NOT NULL
);


ALTER TABLE mapbender.wfs_featuretype_custom_category OWNER TO mapbender;

--
-- TOC entry 253 (class 1259 OID 18631)
-- Dependencies: 251 6
-- Name: wfs_featuretype_featuretype_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE wfs_featuretype_featuretype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.wfs_featuretype_featuretype_id_seq OWNER TO mapbender;

--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 253
-- Name: wfs_featuretype_featuretype_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE wfs_featuretype_featuretype_id_seq OWNED BY wfs_featuretype.featuretype_id;


--
-- TOC entry 4521 (class 0 OID 0)
-- Dependencies: 253
-- Name: wfs_featuretype_featuretype_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('wfs_featuretype_featuretype_id_seq', 41, true);


--
-- TOC entry 254 (class 1259 OID 18633)
-- Dependencies: 6
-- Name: wfs_featuretype_inspire_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_featuretype_inspire_category (
    fkey_featuretype_id integer NOT NULL,
    fkey_inspire_category_id integer NOT NULL
);


ALTER TABLE mapbender.wfs_featuretype_inspire_category OWNER TO mapbender;

--
-- TOC entry 255 (class 1259 OID 18636)
-- Dependencies: 6
-- Name: wfs_featuretype_keyword; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_featuretype_keyword (
    fkey_featuretype_id integer NOT NULL,
    fkey_keyword_id integer NOT NULL
);


ALTER TABLE mapbender.wfs_featuretype_keyword OWNER TO mapbender;

--
-- TOC entry 256 (class 1259 OID 18639)
-- Dependencies: 6
-- Name: wfs_featuretype_md_topic_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_featuretype_md_topic_category (
    fkey_featuretype_id integer NOT NULL,
    fkey_md_topic_category_id integer NOT NULL
);


ALTER TABLE mapbender.wfs_featuretype_md_topic_category OWNER TO mapbender;

--
-- TOC entry 257 (class 1259 OID 18642)
-- Dependencies: 4160 4161 4162 4163 6
-- Name: wfs_featuretype_namespace; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_featuretype_namespace (
    fkey_wfs_id integer DEFAULT 0 NOT NULL,
    fkey_featuretype_id integer DEFAULT 0 NOT NULL,
    namespace character varying(255) DEFAULT ''::character varying NOT NULL,
    namespace_location character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE mapbender.wfs_featuretype_namespace OWNER TO mapbender;

--
-- TOC entry 258 (class 1259 OID 18652)
-- Dependencies: 6
-- Name: wfs_termsofuse; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wfs_termsofuse (
    fkey_wfs_id integer,
    fkey_termsofuse_id integer
);


ALTER TABLE mapbender.wfs_termsofuse OWNER TO mapbender;

--
-- TOC entry 259 (class 1259 OID 18655)
-- Dependencies: 6 244
-- Name: wfs_wfs_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE wfs_wfs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.wfs_wfs_id_seq OWNER TO mapbender;

--
-- TOC entry 4522 (class 0 OID 0)
-- Dependencies: 259
-- Name: wfs_wfs_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE wfs_wfs_id_seq OWNED BY wfs.wfs_id;


--
-- TOC entry 4523 (class 0 OID 0)
-- Dependencies: 259
-- Name: wfs_wfs_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('wfs_wfs_id_seq', 4, true);


--
-- TOC entry 260 (class 1259 OID 18657)
-- Dependencies: 6
-- Name: wmc_custom_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wmc_custom_category (
    fkey_wmc_serial_id integer NOT NULL,
    fkey_custom_category_id integer NOT NULL
);


ALTER TABLE mapbender.wmc_custom_category OWNER TO mapbender;

--
-- TOC entry 261 (class 1259 OID 18660)
-- Dependencies: 6
-- Name: wmc_inspire_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wmc_inspire_category (
    fkey_wmc_serial_id integer NOT NULL,
    fkey_inspire_category_id integer NOT NULL
);


ALTER TABLE mapbender.wmc_inspire_category OWNER TO mapbender;

--
-- TOC entry 262 (class 1259 OID 18663)
-- Dependencies: 6
-- Name: wmc_keyword; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wmc_keyword (
    fkey_keyword_id integer NOT NULL,
    fkey_wmc_serial_id integer NOT NULL
);


ALTER TABLE mapbender.wmc_keyword OWNER TO mapbender;

--
-- TOC entry 263 (class 1259 OID 18666)
-- Dependencies: 6
-- Name: wmc_load_count; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wmc_load_count (
    fkey_wmc_serial_id integer,
    load_count bigint
);


ALTER TABLE mapbender.wmc_load_count OWNER TO mapbender;

--
-- TOC entry 264 (class 1259 OID 18669)
-- Dependencies: 6
-- Name: wmc_md_topic_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wmc_md_topic_category (
    fkey_wmc_serial_id integer NOT NULL,
    fkey_md_topic_category_id integer NOT NULL
);


ALTER TABLE mapbender.wmc_md_topic_category OWNER TO mapbender;

--
-- TOC entry 265 (class 1259 OID 18672)
-- Dependencies: 6
-- Name: wmc_preview; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wmc_preview (
    fkey_wmc_serial_id integer NOT NULL,
    wmc_preview_filename character varying(100)
);


ALTER TABLE mapbender.wmc_preview OWNER TO mapbender;

--
-- TOC entry 266 (class 1259 OID 18675)
-- Dependencies: 4164 4165 4166 4167 4168 4169 4170 4171 6
-- Name: wms; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wms (
    wms_id integer NOT NULL,
    wms_version character varying(50) DEFAULT ''::character varying NOT NULL,
    wms_title character varying(255) DEFAULT ''::character varying NOT NULL,
    wms_abstract text,
    wms_getcapabilities character varying(255) DEFAULT ''::character varying NOT NULL,
    wms_getmap character varying(255) DEFAULT ''::character varying NOT NULL,
    wms_getfeatureinfo character varying(255) DEFAULT ''::character varying NOT NULL,
    wms_getlegendurl character varying(255),
    wms_filter character varying(255),
    wms_getcapabilities_doc text,
    wms_owsproxy character varying(50),
    wms_upload_url character varying(255),
    fees text,
    accessconstraints text,
    contactperson character varying(255),
    contactposition character varying(255),
    contactorganization character varying(255),
    address character varying(255),
    city character varying(255),
    stateorprovince character varying(255),
    postcode character varying(255),
    country character varying(255),
    contactvoicetelephone character varying(255),
    contactfacsimiletelephone character varying(255),
    contactelectronicmailaddress character varying(255),
    wms_mb_getcapabilities_doc text,
    wms_owner integer,
    wms_timestamp integer,
    wms_supportsld boolean,
    wms_userlayer boolean,
    wms_userstyle boolean,
    wms_remotewfs boolean,
    wms_proxylog integer,
    wms_pricevolume integer,
    wms_username character varying(255) DEFAULT ''::character varying NOT NULL,
    wms_password character varying(255) DEFAULT ''::character varying NOT NULL,
    wms_auth_type character varying(255) DEFAULT ''::character varying NOT NULL,
    wms_timestamp_create integer,
    wms_network_access integer,
    fkey_mb_group_id integer,
    uuid uuid
);


ALTER TABLE mapbender.wms OWNER TO mapbender;

--
-- TOC entry 267 (class 1259 OID 18689)
-- Dependencies: 4173 4174 4175 6
-- Name: wms_format; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wms_format (
    fkey_wms_id integer DEFAULT 0 NOT NULL,
    data_type character varying(50) DEFAULT ''::character varying NOT NULL,
    data_format character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE mapbender.wms_format OWNER TO mapbender;

--
-- TOC entry 268 (class 1259 OID 18695)
-- Dependencies: 6
-- Name: wms_md_topic_category; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wms_md_topic_category (
    fkey_wms_id integer NOT NULL,
    fkey_md_topic_category_id integer NOT NULL
);


ALTER TABLE mapbender.wms_md_topic_category OWNER TO mapbender;

--
-- TOC entry 269 (class 1259 OID 18698)
-- Dependencies: 4176 4177 6
-- Name: wms_srs; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wms_srs (
    fkey_wms_id integer DEFAULT 0 NOT NULL,
    wms_srs character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE mapbender.wms_srs OWNER TO mapbender;

--
-- TOC entry 270 (class 1259 OID 18703)
-- Dependencies: 6
-- Name: wms_termsofuse; Type: TABLE; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE TABLE wms_termsofuse (
    fkey_wms_id integer,
    fkey_termsofuse_id integer
);


ALTER TABLE mapbender.wms_termsofuse OWNER TO mapbender;

--
-- TOC entry 271 (class 1259 OID 18706)
-- Dependencies: 266 6
-- Name: wms_wms_id_seq; Type: SEQUENCE; Schema: mapbender; Owner: mapbender
--

CREATE SEQUENCE wms_wms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mapbender.wms_wms_id_seq OWNER TO mapbender;

--
-- TOC entry 4524 (class 0 OID 0)
-- Dependencies: 271
-- Name: wms_wms_id_seq; Type: SEQUENCE OWNED BY; Schema: mapbender; Owner: mapbender
--

ALTER SEQUENCE wms_wms_id_seq OWNED BY wms.wms_id;


--
-- TOC entry 4525 (class 0 OID 0)
-- Dependencies: 271
-- Name: wms_wms_id_seq; Type: SEQUENCE SET; Schema: mapbender; Owner: mapbender
--

SELECT pg_catalog.setval('wms_wms_id_seq', 957, true);


--
-- TOC entry 3993 (class 2604 OID 18712)
-- Dependencies: 168 167
-- Name: cat_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY cat ALTER COLUMN cat_id SET DEFAULT nextval('cat_cat_id_seq'::regclass);


--
-- TOC entry 3994 (class 2604 OID 18713)
-- Dependencies: 172 171
-- Name: conformity_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY conformity ALTER COLUMN conformity_id SET DEFAULT nextval('conformity_conformity_id_seq'::regclass);


--
-- TOC entry 3995 (class 2604 OID 18714)
-- Dependencies: 174 173
-- Name: relation_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY conformity_relation ALTER COLUMN relation_id SET DEFAULT nextval('conformity_relation_relation_id_seq'::regclass);


--
-- TOC entry 3996 (class 2604 OID 18715)
-- Dependencies: 176 175
-- Name: custom_category_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY custom_category ALTER COLUMN custom_category_id SET DEFAULT nextval('custom_category_custom_category_id_seq'::regclass);


--
-- TOC entry 4005 (class 2604 OID 18716)
-- Dependencies: 178 177
-- Name: datalink_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY datalink ALTER COLUMN datalink_id SET DEFAULT nextval('datalink_datalink_id_seq'::regclass);


--
-- TOC entry 4012 (class 2604 OID 18717)
-- Dependencies: 184 183
-- Name: category_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_category ALTER COLUMN category_id SET DEFAULT nextval('gui_category_category_id_seq'::regclass);


--
-- TOC entry 4021 (class 2604 OID 18718)
-- Dependencies: 189 188
-- Name: kml_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_kml ALTER COLUMN kml_id SET DEFAULT nextval('gui_kml_kml_id_seq'::regclass);


--
-- TOC entry 4041 (class 2604 OID 18719)
-- Dependencies: 194 193
-- Name: id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_treegde ALTER COLUMN id SET DEFAULT nextval('gui_treegde_id_seq'::regclass);


--
-- TOC entry 4056 (class 2604 OID 18720)
-- Dependencies: 199 198
-- Name: inspire_category_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY inspire_category ALTER COLUMN inspire_category_id SET DEFAULT nextval('inspire_category_inspire_category_id_seq'::regclass);


--
-- TOC entry 4057 (class 2604 OID 18721)
-- Dependencies: 201 200
-- Name: data_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY inspire_md_data ALTER COLUMN data_id SET DEFAULT nextval('inspire_md_data_data_id_seq'::regclass);


--
-- TOC entry 4058 (class 2604 OID 18722)
-- Dependencies: 203 202
-- Name: keyword_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY keyword ALTER COLUMN keyword_id SET DEFAULT nextval('keyword_keyword_id_seq'::regclass);


--
-- TOC entry 4068 (class 2604 OID 18723)
-- Dependencies: 209 204
-- Name: layer_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer ALTER COLUMN layer_id SET DEFAULT nextval('layer_layer_id_seq'::regclass);


--
-- TOC entry 4090 (class 2604 OID 18724)
-- Dependencies: 215 214
-- Name: mb_group_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_group ALTER COLUMN mb_group_id SET DEFAULT nextval('mb_group_mb_group_id_seq'::regclass);


--
-- TOC entry 4092 (class 2604 OID 18725)
-- Dependencies: 217 216
-- Name: id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_log ALTER COLUMN id SET DEFAULT nextval('mb_log_id_seq'::regclass);


--
-- TOC entry 4097 (class 2604 OID 18726)
-- Dependencies: 219 218
-- Name: metadata_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_metadata ALTER COLUMN metadata_id SET DEFAULT nextval('mb_metadata_metadata_id_seq'::regclass);


--
-- TOC entry 4109 (class 2604 OID 18727)
-- Dependencies: 223 222
-- Name: role_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_role ALTER COLUMN role_id SET DEFAULT nextval('mb_role_role_id_seq'::regclass);


--
-- TOC entry 4118 (class 2604 OID 18728)
-- Dependencies: 227 224
-- Name: mb_user_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user ALTER COLUMN mb_user_id SET DEFAULT nextval('mb_user_mb_user_id_seq'::regclass);


--
-- TOC entry 4131 (class 2604 OID 18729)
-- Dependencies: 232 231
-- Name: md_topic_category_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY md_topic_category ALTER COLUMN md_topic_category_id SET DEFAULT nextval('md_topic_category_md_topic_category_id_seq'::regclass);


--
-- TOC entry 4132 (class 2604 OID 18730)
-- Dependencies: 236 235
-- Name: sld_user_layer_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY sld_user_layer ALTER COLUMN sld_user_layer_id SET DEFAULT nextval('sld_user_layer_sld_user_layer_id_seq'::regclass);


--
-- TOC entry 4133 (class 2604 OID 18731)
-- Dependencies: 240 237
-- Name: spec_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY spec ALTER COLUMN spec_id SET DEFAULT nextval('spec_spec_id_seq'::regclass);


--
-- TOC entry 4134 (class 2604 OID 18732)
-- Dependencies: 239 238
-- Name: spec_class_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY spec_classification ALTER COLUMN spec_class_id SET DEFAULT nextval('spec_classification_spec_class_id_seq'::regclass);


--
-- TOC entry 4135 (class 2604 OID 18733)
-- Dependencies: 243 242
-- Name: trs_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY translations ALTER COLUMN trs_id SET DEFAULT nextval('translations_trs_id_seq'::regclass);


--
-- TOC entry 4139 (class 2604 OID 18734)
-- Dependencies: 259 244
-- Name: wfs_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs ALTER COLUMN wfs_id SET DEFAULT nextval('wfs_wfs_id_seq'::regclass);


--
-- TOC entry 4145 (class 2604 OID 18735)
-- Dependencies: 248 245
-- Name: wfs_conf_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_conf ALTER COLUMN wfs_conf_id SET DEFAULT nextval('wfs_conf_wfs_conf_id_seq'::regclass);


--
-- TOC entry 4153 (class 2604 OID 18736)
-- Dependencies: 247 246
-- Name: wfs_conf_element_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_conf_element ALTER COLUMN wfs_conf_element_id SET DEFAULT nextval('wfs_conf_element_wfs_conf_element_id_seq'::regclass);


--
-- TOC entry 4155 (class 2604 OID 18737)
-- Dependencies: 250 249
-- Name: element_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_element ALTER COLUMN element_id SET DEFAULT nextval('wfs_element_element_id_seq'::regclass);


--
-- TOC entry 4159 (class 2604 OID 18738)
-- Dependencies: 253 251
-- Name: featuretype_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype ALTER COLUMN featuretype_id SET DEFAULT nextval('wfs_featuretype_featuretype_id_seq'::regclass);


--
-- TOC entry 4172 (class 2604 OID 18739)
-- Dependencies: 271 266
-- Name: wms_id; Type: DEFAULT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wms ALTER COLUMN wms_id SET DEFAULT nextval('wms_wms_id_seq'::regclass);


--
-- TOC entry 4390 (class 0 OID 18160)
-- Dependencies: 167
-- Data for Name: cat; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4391 (class 0 OID 18170)
-- Dependencies: 169
-- Data for Name: cat_keyword; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4392 (class 0 OID 18173)
-- Dependencies: 170
-- Data for Name: cat_op_conf; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4393 (class 0 OID 18179)
-- Dependencies: 171
-- Data for Name: conformity; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO conformity VALUES (1, '1', 'inspire', 'conformant', '', 'Konform', '', 'Die Ressource stimmt mit der angegebenen Spezifikation in vollem Umfang überein.');
INSERT INTO conformity VALUES (2, '2', 'inspire', 'notConformant', '', 'Nicht konform', '', 'Die Ressource stimmt mit der angegebenen Spezifikation nicht überein.');
INSERT INTO conformity VALUES (3, '3', 'inspire', 'notEvaluated', '', 'Nicht überprüft', '', 'Die Übereinstimmung ist nicht überprüft worden.');
INSERT INTO conformity VALUES (4, '1', 'inspire', 'conformant', '', 'Konform', '', 'Die Ressource stimmt mit der angegebenen Spezifikation in vollem Umfang überein.');
INSERT INTO conformity VALUES (5, '2', 'inspire', 'notConformant', '', 'Nicht konform', '', 'Die Ressource stimmt mit der angegebenen Spezifikation nicht überein.');
INSERT INTO conformity VALUES (6, '3', 'inspire', 'notEvaluated', '', 'Nicht überprüft', '', 'Die Übereinstimmung ist nicht überprüft worden.');


--
-- TOC entry 4394 (class 0 OID 18187)
-- Dependencies: 173
-- Data for Name: conformity_relation; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4395 (class 0 OID 18192)
-- Dependencies: 175
-- Data for Name: custom_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO custom_category VALUES (1, 'dc1', 'dummy category', 'Dummy Kategorie', '', '', 'Demo Kategorie zur Klassifizierung von Mapbender Registry Inhalten', NULL);
INSERT INTO custom_category VALUES (2, 'mbc1', 'special standard wmc documents', 'Spezielle Standard WMC Dokumente', NULL, NULL, NULL, 1);
INSERT INTO custom_category VALUES (4, 'mbc1', 'special standard wmc documents', 'Spezielle Standard WMC Dokumente', NULL, NULL, NULL, 1);


--
-- TOC entry 4396 (class 0 OID 18200)
-- Dependencies: 177
-- Data for Name: datalink; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4397 (class 0 OID 18216)
-- Dependencies: 179
-- Data for Name: datalink_keyword; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4398 (class 0 OID 18219)
-- Dependencies: 180
-- Data for Name: datalink_md_topic_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4399 (class 0 OID 18222)
-- Dependencies: 181
-- Data for Name: gui; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui VALUES ('Administration', 'Administration', 'GUI-, WMS- und Benutzerverwaltung', 1);
INSERT INTO gui VALUES ('Administration-erweitert', 'Administration-erweitert', 'WFS- und Metadatenverwaltung', 1);
INSERT INTO gui VALUES ('Klarschiff', 'Klarschiff', 'Standardprofil', 1);


--
-- TOC entry 4400 (class 0 OID 18229)
-- Dependencies: 182
-- Data for Name: gui_cat; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4401 (class 0 OID 18234)
-- Dependencies: 183
-- Data for Name: gui_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui_category VALUES (1, 'Administration', 'Anwendungen zur Administration von Mapbender');
INSERT INTO gui_category VALUES (5, 'Klarschiff', 'Standardprofil der Anwendung Klarschiff');


--
-- TOC entry 4402 (class 0 OID 18239)
-- Dependencies: 185
-- Data for Name: gui_element; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui_element VALUES ('Administration', 'filteredGui_filteredGroup', 2, 1, 'mehreren Gruppen Zugriff auf <br>einzelne Anwendung erlauben', 'mehreren Gruppen Zugriff auf <br>einzelne Anwendung erlauben', 'a', '', 'href = "../php/mod_filteredGui_filteredGroup.php?sessionID&e_id_css=filteredGui_filteredGroup" target = "AdminFrame" ', 8, 605, 190, 25, 10, '', 'mehreren Gruppen Zugriff auf <br>einzelne Anwendung erlauben', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'headline_GUI_Management', 3, 1, 'Anwendungsverwaltung', 'Anwendungsverwaltung', 'div', '', '', 5, 217, 193, 126, 2, '', 'Anwendungsverwaltung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'headline_WMS_Management', 3, 1, 'Hintergrund WMS Management', 'WMS Management', 'div', '', '', 5, 37, 193, 86, 2, '', ' WMS Verwaltung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'headline_User_Authorization', 3, 1, 'Hintergrund Benutzerzugriff erteilen', 'Authorization ', 'div', '', '', 5, 477, 193, 196, 2, '', ' Benutzerzugriff erteilen', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'AdminFrame', 2, 1, 'Bereich fuer Administrationsmodule', '', 'iframe', '', 'frameborder = "0"', 200, 20, 1000, 800, NULL, '', '', 'iframe', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'editElements', 2, 1, 'Anwendungselemente bearbeiten', 'Anwendungselemente bearbeiten', 'a', '', 'href = "../php/mod_editElements.php?sessionID" target = "AdminFrame" ', 8, 260, 190, 20, 5, '', 'Anwendungselemente bearbeiten', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Edit_GUI_Elements');
INSERT INTO gui_element VALUES ('Administration', 'headline_Configure_CSW', 3, 1, 'Catalog Management', 'Catalog Management', 'div', '', '', 5, 760, 193, 66, 2, '', ' CSW Verwaltung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'delete_filteredGui', 2, 1, 'Anwendung löschen', 'Anwendung löschen', 'a', '', 'href = "../php/mod_deleteFilteredGUI.php?sessionID" target = "AdminFrame" ', 8, 280, 190, 20, 5, '', 'Anwendung löschen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/DeleteGUI');
INSERT INTO gui_element VALUES ('Administration', 'loadCSW', 3, 1, 'CSW laden', 'CSW laden', 'a', '', 'href = "../php/mod_loadCatalogCapabilities.php?sessionID" target = "AdminFrame" ', 8, 780, 190, 20, 5, '', 'Add Catalog', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/newGUI');
INSERT INTO gui_element VALUES ('Administration', 'deleteWMS', 2, 1, '!Vollständig löschen!', 'Delete WMS completely', 'a', '', 'href = "../php/mod_deleteWMS.php?sessionID" target = "AdminFrame" ', 8, 100, 190, 20, 5, '', '!Vollständig löschen!', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/DeleteWMS');
INSERT INTO gui_element VALUES ('Administration', 'editFilteredGroup', 2, 1, 'Gruppe anlegen und editieren', 'Create and edit group', 'a', '', 'href = "../php/mod_editFilteredGroup.php?sessionID" target = "AdminFrame" ', 8, 400, 190, 20, 10, '', 'Gruppe anlegen und editieren', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'editFilteredUser', 2, 1, 'Benutzer anlegen und editieren', 'Create and edit user', 'a', '', 'href = "../php/mod_editFilteredUser.php?sessionID" target="AdminFrame"', 8, 380, 190, 20, 10, '', 'Benutzer anlegen und editieren', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'filteredGoup_filteredUser', 2, 1, 'Gruppe mit Benutzern bestücken', 'Add several users to one group', 'a', '', 'href = "../php/mod_filteredGroup_filteredUser.php?sessionID&e_id_css=filteredGoup_filteredUser" target = "AdminFrame" ', 8, 440, 190, 20, 10, '', 'Gruppe mit Benutzern bestücken ', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'filteredUser_filteredGroup', 2, 1, 'Benutzer in Gruppen eintragen', 'Add one user to serveral groups', 'a', '', 'href = "../php/mod_filteredUser_filteredGroup.php?sessionID&e_id_css=filteredUser_filteredGroup" target = "AdminFrame" ', 8, 420, 190, 20, 10, '', 'Benutzer in Gruppen eintragen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'headline_Configure_WMS_Access', 3, 1, 'Hintergrund WMS Zuordnung', 'Configure WMS Access', 'div', '', '', 5, 137, 193, 66, 2, '', ' WMS Zuordnung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'headline_User_Management', 3, 1, 'Hintergrund Benutzerverwaltung', 'User Management', 'div', '', '', 5, 357, 193, 106, 2, '', ' Benutzerverwaltung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'loadWMS', 2, 1, 'Capabilities hochladen', 'Load WMS', 'a', '', 'href = "../php/mod_loadCapabilities.php?sessionID" target="AdminFrame"', 8, 60, 190, 20, 5, '', 'Capabilities hochladen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Add_new_maps_to_Mapbender');
INSERT INTO gui_element VALUES ('Administration', 'showLoggedUser', 2, 1, 'Anzeige des eingeloggten Benutzers', '', 'iframe', '../php/mod_showLoggedUser.php?sessionID', 'frameborder="0" scrolling=''no''', 1, 1, 200, 30, 1, 'background-color:lightgrey;', '', 'iframe', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'newGui', 2, 1, 'Anwendung erzeugen', 'Anwendung erzeugen', 'a', '', 'href = "../php/mod_newGui.php?sessionID" target = "AdminFrame" ', 8, 240, 190, 20, 5, '', 'Anwendung erzeugen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/newGUI');
INSERT INTO gui_element VALUES ('Administration', 'exportGUI', 2, 1, 'Anwendung exportieren (SQL)', 'Anwendung exportieren (SQL)', 'a', '', 'href = "../php/mod_exportGUI.php?sessionID" target = "AdminFrame" ', 8, 300, 190, 20, 10, '', 'Anwendung exportieren (SQL)', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Oberfl%C3%A4che_exportieren_%28SQL%29');
INSERT INTO gui_element VALUES ('Administration', 'filteredGroup_filteredGui', 2, 1, 'Gruppe Zugriff auf <br>Anwendung erlauben', 'Gruppe Zugriff auf <br>Anwendung erlauben', 'a', '', 'href = "../php/mod_filteredGroup_filteredGui.php?sessionID&e_id_css=filteredGroup_filteredGui" target = "AdminFrame" ', 8, 570, 190, 25, 10, '', 'Gruppe Zugriff auf <br>Anwendung erlauben', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'filteredUser_filteredGui', 2, 1, 'einzelnem Benutzer Zugriff auf <br>Anwendungen erlauben', 'einzelnem Benutzer Zugriff auf <br>Anwendungen erlauben', 'a', '', 'href = "../php/mod_filteredUser_filteredGui.php?sessionID&e_id_css=filteredUser_filteredGui" target = "AdminFrame" ', 8, 500, 190, 25, 10, '', 'einzelnem Benutzer Zugriff auf <br>Anwendungen erlauben', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'gui_owner', 2, 1, 'Anwendung editieren Benutzer zuordnen', 'Anwendung editieren Benutzer zuordnen', 'a', '', 'href = "../php/mod_gui_owner.php?sessionID" target = "AdminFrame" ', 8, 640, 190, 20, 10, '', 'Anwendung editieren Benutzer zuordnen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'loadWMSList', 2, 1, 'WMS in Anwendung einbinden', 'WMS in Anwendung einbinden', 'a', '', 'href = "../php/mod_loadCapabilitiesList.php?sessionID" target="AdminFrame"', 8, 160, 190, 20, 5, '', 'WMS in Anwendung einbinden', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Add_new_maps_to_Mapbender');
INSERT INTO gui_element VALUES ('Administration', 'rename_copy_Gui', 2, 1, 'Anwendung kopieren/umbenennen', 'Anwendung kopieren/umbenennen', 'a', '', 'href = "../php/mod_renameGUI.php?sessionID" target = "AdminFrame" ', 8, 320, 190, 20, 10, '', 'Anwendung kopieren/umbenennen', 'a', '', '', '', 'AdminFrame', '');
INSERT INTO gui_element VALUES ('Administration', 'help', 2, 1, 'button help', 'Help', 'img', '../img/button_gray/help_off.png', 'onmouseover = "mb_regButton(''init_help'')"', 210, 2, 24, 24, 1, '', '', '', 'mod_help.php', '../extensions/wz_jsgraphics.js', '', 'jsGraphics', 'http://www.mapbender.org');
INSERT INTO gui_element VALUES ('Administration', 'logout', 2, 1, 'Logout', 'Logout', 'img', '../img/button_gray/logout_off.png', 'onClick="window.location.href=''../php/mod_logout.php?sessionID''" border=''0'' onmouseover=''this.src="../img/button_gray/logout_over.png"'' onmouseout=''this.src="../img/button_gray/logout_off.png"''', 180, 2, 24, 24, 2, '', '', '', '', '', '', '', 'http://www.mapbender.org/index.php/logout');
INSERT INTO gui_element VALUES ('Administration', 'loadCSWinternal', 2, 0, 'CatalogCapabilities hochladen interne Datei, nicht aktiv schalten!', '', '', '', 'href = "../php/mod_loadCatalog.php"', NULL, NULL, NULL, NULL, NULL, '', 'Capabilities hochladen interne Funktion', '', '', '', '', '', 'http://www.mapbender.org/index.php/newGUI');
INSERT INTO gui_element VALUES ('Administration', 'createCategory', 2, 1, 'Anwendungskategorie erzeugen', 'Anwendungskategorie erzeugen', 'a', '', 'href = "../php/mod_createCategory.php?sessionID" target = "AdminFrame" ', 8, 708, 190, 20, 5, '', 'Anwendungskategorie erzeugen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/GUI_Category');
INSERT INTO gui_element VALUES ('Administration', 'headline_GUI_Category', 3, 1, 'Anwendungskategorien verwalten', 'Anwendungskategorien verwalten', 'div', '', '', 5, 685, 193, 66, 2, '', 'Anwendungskategorien verwalten', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration', 'myGUIlist', 2, 1, 'Zurück zur Anwendungsübersicht', 'Zurück zur Anwendungsübersicht', 'img', '../img/button_gray/home_off.png', 'onClick="mod_home_init()" border=''0'' onmouseover=''this.src="../img/button_gray/home_over.png"'' onmouseout=''this.src="../img/button_gray/home_off.png"''', 150, 2, 24, 24, 2, '', '', '', 'mod_home.php', '', '', '', 'http://www.mapbender.org/index.php/MyGUIlist');
INSERT INTO gui_element VALUES ('Administration', 'loadWMSinternal', 2, 0, 'Capabilities hochladen interne Datei, nicht aktiv schalten!', '', '', '', 'href = "../php/mod_loadwms.php"', NULL, NULL, NULL, NULL, NULL, '', 'Capabilities hochladen interne Funktion', '', '', '', '', '', 'http://www.mapbender.org/index.php/Add_new_maps_to_Mapbender');
INSERT INTO gui_element VALUES ('Administration', 'loadCSWGUI', 3, 1, 'CSW einer Applikation zuordnen', 'Link Catalog to GUI', 'a', '', 'href = "../php/mod_loadCatalogToGUI.php?sessionID" target = "AdminFrame" ', 8, 800, 190, 20, 5, '', 'Link Catalog to GUI', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/newGUI');
INSERT INTO gui_element VALUES ('Administration', 'i18n', 1, 1, 'Internationalization module, collects data from all elements and sends them to the server in a single POST request. The strings are translated via gettext only.', 'Internationalization', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '../plugins/mb_i18n.js', '', '', '', 'http://www.mapbender.org/Gettext');
INSERT INTO gui_element VALUES ('Administration', 'filteredGui_filteredUser', 2, 1, 'mehreren Benutzern Zugriff auf <br>einzelne Anwendung erlauben', 'mehreren Benutzern Zugriff auf <br>einzelne Anwendung erlauben', 'a', '', 'href = "../php/mod_filteredGui_filteredUser.php?sessionID&e_id_css=filteredGui_filteredUser" target = "AdminFrame" ', 8, 535, 190, 25, 10, '', 'mehreren Benutzern Zugriff auf <br>einzelne Anwendung erlauben', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/user');
INSERT INTO gui_element VALUES ('Administration', 'editGUI_WMS', 2, 1, 'WMS Anwendungseinstellungen', 'WMS Anwendungseinstellungen', 'a', '', 'href="../php/mod_editGuiWms.php?sessionID"'' target="AdminFrame"', 8, 180, 190, 20, 5, '', 'WMS Anwendungseinstellungen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Edit_GUI_WMS');
INSERT INTO gui_element VALUES ('Administration', 'deleteCategory', 2, 1, 'Anwendungskategorie löschen', 'Anwendungskategorie löschen', 'a', '', 'href = "../php/mod_deleteCategory.php?sessionID" target = "AdminFrame" ', 8, 742, 190, 20, 5, '', 'Anwendungskategorie löschen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/GUI_Category');
INSERT INTO gui_element VALUES ('Administration', 'category_filteredGUI', 2, 1, 'Anwendung zu Kategorie zuordnen', 'Anwendung zu Kategorie zuordnen', 'a', '', 'href = "../php/mod_category_filteredGUI.php?sessionID&e_id_css=filteredUser_filteredGroup" target = "AdminFrame" ', 8, 728, 220, 20, 10, '', 'Anwendung zu Kategorie zuordnen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/GUI_Category');
INSERT INTO gui_element VALUES ('Administration', 'updateWMSs', 2, 1, 'Hochgeladene aktualisieren', 'Update WMS', 'a', '', 'href="../php/mod_updateWMS.php?sessionID"'' target="AdminFrame"', 8, 80, 190, 20, 5, '', 'Hochgeladene aktualisieren', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/UpdateWMS');
INSERT INTO gui_element VALUES ('Administration', 'body', 1, 1, 'Navigation', '', 'body', '', '', 0, 0, NULL, NULL, 0, '', '', '', 'mod_adminNavigation.js', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'CustomizeTree', 2, 1, 'Create a set of nested folders that contain the applications WMS', 'Baumstruktur konfigurieren', 'a', '', 'href = "../php/mod_customTree.php?sessionID" target="AdminFrame"', 10, 533, 200, 20, 5, '', 'Baumstruktur konfigurieren', 'a', '', '', '', 'AdminFrame', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'headline_Configure_WMS_Access', 3, 1, 'Hintergrund WMS Zuordnung', 'WMS Assignment', 'div', '', '', 1, 175, 210, 63, 2, '', 'WMS Zuordnung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'editGUI_WMS', 2, 1, 'WMS Anwendungseinstellungen', 'WMS Anwendungseinstellungen', 'a', '', 'href="../php/mod_editGuiWms.php?sessionID"'' target="AdminFrame"', 10, 218, 200, 20, 5, '', 'WMS Anwendungseinstellungen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Edit_GUI_WMS');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'rename_copy_Gui', 2, 1, 'Anwendung kopieren/umbenennen', 'Anwendung kopieren/umbenennen', 'a', '', 'href = "../php/mod_renameGUI.php?sessionID" target = "AdminFrame" ', 10, 576, 200, 20, 10, '', 'Anwendung kopieren/umbenennen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/RenameGUI');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'AdminFrame', 2, 1, 'Bereich für Administrationsmodule', '', 'iframe', '', 'frameborder = "0"', 210, 25, 1000, 800, 12, '', '', 'iframe', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'EditWMSMetadata', 2, 1, 'edit the metadata of wms', 'edit the metadata of wms', 'a', '', 'href = "../php/mod_editWMS_Metadata.php?show_wms_list=true&sessionID" target="AdminFrame"', 10, 275, 200, 20, 5, '', 'WMS Metadaten', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Edit_WMS_Metadata');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'deleteWFS', 2, 1, 'WFS löschen', 'Delete WFS', 'a', '', 'href = "../php/mod_deleteWFS.php?sessionID" target = "AdminFrame" ', 10, 393, 200, 20, 5, '', 'WFS löschen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/DeleteWFS');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'editElements', 2, 1, 'Anwendungselemente bearbeiten', 'Anwendungselemente bearbeiten', 'a', '', 'href = "../php/mod_editElements.php?sessionID" target = "AdminFrame" ', 10, 491, 200, 25, 5, '', 'Anwendungselemente bearbeiten', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Edit_GUI_Elements');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'deleteWMS', 2, 1, '!Vollständig löschen!', '!Delete WMS completely!', 'a', '', 'href = "../php/mod_deleteWMS.php?sessionID" target = "AdminFrame" ', 10, 100, 200, 20, 5, '', 'WMS löschen!', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/DeleteWMS');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'filteredWms_layer_topic', 2, 1, 'allocate topics to layers of wms of this user', 'allocate topics to layers of wms of this user', 'a', '', 'href = "../php/mod_filteredWms_layer_topic.php?sessionID&e_id_css=filteredWms_layer_topic" target = "AdminFrame" ', 10, 295, 200, 20, 5, '', 'Kategoriezuordnung', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Topic_/_Category');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'headline_Metadata', 3, 1, 'Metadateneditor Caption', 'Metadata', 'div', '', '', 1, 252, 210, 63, 2, '', 'Metadaten', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'headline_WFS_Management', 3, 1, 'WFS Verwaltung', 'WFS Management', 'div', '', '', 1, 330, 210, 103, 2, '', 'WFS Verwaltung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'headline_WMS_Management', 3, 1, 'Dienstverwaltung Beschriftung', 'WMS Management', 'div', '', '', 0, 37, 210, 123, 2, '', 'WMS Verwaltung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'loadWFS', 2, 1, 'WFS Capabilities in eine GUI laden', 'Load WFS Capabilities into a GUI', 'a', '', 'href = "../php/mod_loadWFSCapabilities.php?sessionID" target="AdminFrame"', 10, 353, 200, 20, 5, '', 'WFS laden', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/LoadWFS');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'loadWMS', 2, 1, 'Capabilities hochladen', 'Load WMS', 'a', '', 'href = "../php/mod_loadCapabilities.php?sessionID" target="AdminFrame"', 10, 60, 200, 20, 5, '', 'WMS laden', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Add_new_maps_to_Mapbender');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'orphanWMS', 2, 1, 'display orphaned WMS', 'Delete orphaned WMS', 'a', '', 'href = "../php/mod_orphanWMS.php?sessionID" 
target = "AdminFrame"', 10, 120, 200, 20, 5, '', 'WMS ohne Zuordung löschen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/OrphanWMS');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'showLoggedUser', 2, 1, 'Anzeige des eingeloggten Benutzers', '', 'iframe', '../php/mod_showLoggedUser.php?sessionID', 'frameborder="0" scrolling=''no''', 1, 1, 200, 30, 1, 'background-color:lightgrey;', '', 'iframe', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'wfs_gui', 2, 1, 'edit wfs settings', 'Assign WFS conf to gui', 'a', '', 'href = "../javascripts/mod_wfs_client.html" target="AdminFrame"', 10, 413, 200, 20, 10, '', 'WFS Konfiguration GUI zuweisen', 'a', '', '', '', 'AdminFrame', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'exportGUI', 2, 1, 'Anwendung exportieren (SQL)', 'Anwendung exportieren (SQL)', 'a', '', 'href = "../php/mod_exportGUI.php?sessionID" target = "AdminFrame" ', 10, 554, 200, 25, 10, 'x', 'Anwendung exportieren (SQL)', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Oberfl%C3%A4che_exportieren_%28SQL%29');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'delete_filteredGui', 2, 1, 'Anwendung löschen', 'Anwendung löschen', 'a', '', 'href = "../php/mod_deleteFilteredGUI.php?sessionID" target = "AdminFrame" ', 10, 511, 200, 20, 5, '', 'Anwendung löschen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/DeleteGUI');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'headline_GUI_Management', 3, 1, 'Anwendungsverwaltung', 'Anwendungsverwaltung', 'div', '', '', 1, 448, 210, 153, 2, '', 'Anwendungsverwaltung', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'loadWMSList', 2, 1, 'WMS in Anwendung einbinden', 'WMS in Anwendung einbinden', 'a', '', 'href = "../php/mod_loadCapabilitiesList.php?sessionID" target="AdminFrame"', 10, 198, 200, 20, 5, '', 'WMS in Anwendung einbinden', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Add_new_maps_to_Mapbender');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'wfs_conf', 2, 1, 'WFS konfigurieren', 'Configure WFS', 'a', '', 'href = "../php/mod_wfs_conf_client.php" target="AdminFrame"', 10, 373, 200, 20, 5, '', 'WFS konfigurieren', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Wfs_conf');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'newGui', 2, 1, 'Anwendung erzeugen', 'Anwendung erzeugen', 'a', '', 'href = "../php/mod_newGui.php?sessionID" target = "AdminFrame" ', 10, 471, 200, 20, 5, '', 'Anwendung erzeugen', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/newGUI');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'help', 2, 1, 'button help', 'Help', 'img', '../img/button_gray/help_off.png', 'onmouseover = "mb_regButton(''init_help'')"', 210, 2, 24, 24, 1, '', '', '', 'mod_help.php', '../extensions/wz_jsgraphics.js', '', 'jsGraphics', 'http://www.mapbender.org');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'logout', 2, 1, 'Logout', 'Logout', 'img', '../img/button_gray/logout_off.png', 'onClick="window.location.href=''../php/mod_logout.php?sessionID''" border=''0'' onmouseover=''this.src="../img/button_gray/logout_over.png"'' onmouseout=''this.src="../img/button_gray/logout_off.png"''', 180, 2, 24, 24, 2, '', '', '', '', '', '', '', 'http://www.mapbender.org/index.php/logout');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'myGUIlist', 2, 1, 'Zurück zur Anwendungsübersicht', 'Zurück zur Anwendungsübersicht', 'img', '../img/button_gray/home_off.png', 'onClick="mod_home_init()" border=''0'' onmouseover=''this.src="../img/button_gray/home_over.png"'' onmouseout=''this.src="../img/button_gray/home_off.png"''', 150, 2, 24, 24, 2, '', '', '', 'mod_home.php', '', '', '', 'http://www.mapbender.org/index.php/MyGUIlist');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'body', 1, 1, 'Navigation', '', 'body', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', 'mod_adminNavigation.js', '', '', '', '');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'loadWMSinternal', 2, 0, 'Capabilities hochladen interne Datei, nicht aktiv schalten!', '', '', '', 'href = "../php/mod_loadwms.php"', NULL, NULL, NULL, NULL, NULL, '', 'Capabilities hochladen interne Funktion', '', '', '', '', '', 'http://www.mapbender.org/index.php/Add_new_maps_to_Mapbender');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'loadCSWinternal', 2, 0, 'CatalogCapabilities hochladen interne Datei, nicht aktiv schalten!', '', '', '', 'href = "../php/mod_loadCatalog.php"', NULL, NULL, NULL, NULL, NULL, '', 'Capabilities hochladen interne Funktion', '', '', '', '', '', 'http://www.mapbender.org/index.php/newGUI');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'i18n', 1, 1, 'Internationalization module, collects data from all elements and sends them to the server in a single POST request. The strings are translated via gettext only.', 'Internationalization', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '../plugins/mb_i18n.js', '', '', '', 'http://www.mapbender.org/Gettext');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'owsproxy', 2, 1, 'secure services', 'OWSPROXY', 'a', '', 'href="../php/mod_owsproxy_conf.php?sessionID"'' target="AdminFrame"', 10, 140, 200, 20, 10, '', 'OWSPROXY', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/Owsproxy');
INSERT INTO gui_element VALUES ('Administration-erweitert', 'updateWMSs', 2, 1, 'Hochgeladene aktualisieren', 'Update WMS', 'a', '', 'href="../php/mod_updateWMS.php?sessionID"'' target="AdminFrame"', 10, 80, 200, 20, 5, '', 'WMS aktualisieren', 'a', '', '', '', 'AdminFrame', 'http://www.mapbender.org/index.php/UpdateWMS');
INSERT INTO gui_element VALUES ('Klarschiff', 'jquery_template', 2, 1, 'jQuery-Template-Plugin', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../pc/jquery/jquery.tmpl.min.js', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_datatables', 1, 1, 'Includes the jQuery plugin datatables, use like this
$(selector).datatables(options)', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '../plugins/jq_datatables.js', '../extensions/dataTables-1.5/media/js/jquery.dataTables.min.js', '', '', 'http://www.datatables.net/');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_droppable', 4, 1, 'jQuery UI droppable', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../pc/jquery/ui/jquery.ui.droppable.js', '', 'jq_ui,jq_ui_widget,jq_ui_mouse,jq_ui_draggable', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_button', 5, 1, 'JQuery UI button', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../pc/jquery/ui/jquery.ui.button.js', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'i18n', 1, 1, 'Internationalization module, collects data from all elements and sends them to the server in a single POST request. The strings are translated via gettext only.', 'Internationalization', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '../plugins/mb_i18n.js', '', '', '', 'http://www.mapbender.org/Gettext');
INSERT INTO gui_element VALUES ('Klarschiff', 'widgets', 10, 1, 'Accordion-Container', '', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '', '', 'sidebar_widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'kartenelemente', 14, 1, 'Auswahl der Kartenelemente', 'Kartenelemente', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '../pc/config_projekt.php', '', 'widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'sidebar', 5, 1, 'Sidebar', '', 'div', '', 'class="sidebar-open"', NULL, NULL, 350, NULL, NULL, 'right: 0; top: 0; bottom: 0;', '', 'div', '', '', 'content', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jquery_placeholder', 2, 1, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../pc/jquery/jquery.placeholder.1.2.min.js ', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'beobachtungsflaechen', 13, 1, '', 'Beobachtungsflächen', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '<button id="flaeche_stadtgebiet" class="flaecheAction">gesamtes Stadtgebiet</button>
<button id="flaeche_stadtteil" class="flaecheAction">Stadtteil(e) auswählen</button>
<button id="flaeche_neu" class="flaecheAction">Fläche erstellen</button>
<button id="flaeche_apply" class="flaecheCtrl" style="display:none">übernehmen</button>
<button id="flaeche_cancel" class="flaecheCtrl" style="display:none">abbrechen</button>', 'div', '', '', 'widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'debugconsole', 10, 0, '', '', 'div', '', '', 0, 0, NULL, NULL, 1002, 'position:absolute;top0px;right:0px;z-index:1002;display:block;', '<div style="position: absolute; top: 4px; right: 4px; display: block; z-index: 1002; background-color: rgb(255, 255, 255); border-style: solid; border-width: 1px;" id="divDebugConsole">
	<div style="text-align: right; background-color: rgb(153, 153, 153);" id="debugBar"><b>DEBUGCONSOLE</b>  <a href="javascript:setMinMax(''debugContent'');" style="margin-left: 40px;">MIN/MAX</a>  <a href="javascript:closeDebug(''divDebugConsole'');" style="margin-left: 10px;">CLOSE</a> </div>
	<div style="display: block; text-align: center; padding: 2px; font-size: 11px;" id="debugContent">  <textarea rows="30" cols="50" id="debugField"></textarea> <br>  <input type="button" onclick="clearField(''debugField'');" value="clear all" name="clear all"> </div>
</div>
<script type="text/javascript">
function setMinMax(divname){
    if(document.getElementById(divname).style.display == "none"){
        document.getElementById(divname).style.display = "block";
    }else{
        document.getElementById(divname).style.display = "none";
    }
}
function closeDebug(divname){
    document.getElementById(divname).style.display = "none";
}

function clearField(divname){
    document.getElementById(divname).value= "";
}
function debug(text){
    document.getElementById("debugField").value = document.getElementById("debugField").value +"n" + text;
}
</script>', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'sidebar_toggle', 6, 1, 'Sidebar-Leiste zum An/Ausschalten', 'Menü ein-/ausfahren', 'div', '', '', NULL, NULL, NULL, NULL, NULL, 'display:table-cell;width:10px;', '', 'div', '', '', 'sidebar', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'content', 3, 1, 'Content-Container', '', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'body', 1, 1, 'Body-Tag', '', 'body ', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'header', 2, 0, 'Header-Container', '', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '<h1>Klarschiff</h1>
	<a href="#" id="themeroller">jQUITR</a>', 'div', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_position', 2, 1, 'jQuery UI position', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.position.js', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_mouse', 2, 1, 'jQuery UI mouse', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.mouse.js', '', 'jq_ui_widget', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'map_toggle', 9, 1, 'Buttons für Hintergrundkartenauswahl', '', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '', '', 'sidebar_widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_upload', 1, 1, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../plugins/jq_upload.js', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui', 1, 1, 'The jQuery UI core', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.core.js', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_accordion', 5, 1, 'jQuery UI accordion', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.accordion.js', '', 'jq_ui,jq_ui_widget', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_dialog', 5, 1, 'jQuery UI dialog', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.dialog.js', '', 'jq_ui,jq_ui_widget,jq_ui_button,jq_ui_draggable,jq_ui_mouse,jq_ui_position,jq_ui_resizable', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_draggable', 5, 1, 'Draggable from the jQuery UI framework', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.draggable.js', '', 'jq_ui,jq_ui_mouse,jq_ui_widget', 'http://jqueryui.com/demos/draggable/');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_resizable', 5, 1, 'Resizable from the jQuery UI framework', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '../plugins/jq_ui_resizable.js', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.resizable.js', '', 'jq_ui,jq_ui_mouse,jq_ui_widget', 'http://jqueryui.com/demos/resizable/');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_tabs', 5, 1, 'horizontal tabs from the jQuery UI framework', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.tabs.js', '', 'jq_ui,jq_ui_widget', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'jq_ui_widget', 1, 1, 'jQuery UI widget', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '', '', '', '', '../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.widget.js', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'template_flaeche_abonnieren', 17, 1, 'Template für Dialog zur thematischen Eingrenzung bei Flächenauswahl', '', 'script', '', 'type="text/x-jquery-templ"', NULL, NULL, NULL, NULL, NULL, '', '<form id="rss_abo">
    <input type="hidden" name="id" value="${id}"/>
    <input type="hidden" name="geom" value="${geom}"/>

    <div id="problem" style="width:48%;margin-right:2%">
	<h4 style="margin-bottom:5px;margin-top:2px">Probleme</h4>
        <div>
            <div name="problem_kategorie" class="scrollCheckbox" style="border-bottom:1px solid #999999;margin-bottom:6px">
            </div>
            <input type="checkbox" name="problem_alle" value="1" style="margin-bottom:0"/>
            <label style="font-style:italic;font-weight:bold;font-size:0.8em">alle Probleme</label>
        </div>
    </div>
    <div id="idee" style="width:48%;margin-right:2%">
	<h4 style="margin-bottom:5px;margin-top:2px">Ideen</h4>
        <div>
            <div name="idee_kategorie" class="scrollCheckbox" style="border-bottom:1px solid #999999;margin-bottom:6px">
            </div>
            <input type="checkbox" name="idee_alle" value="1" style="margin-bottom:0"/>
            <label style="font-style:italic;font-weight:bold;font-size:0.8em">alle Ideen</label>
        </div>
    </div>
</form>', 'script', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'ol_map', 2, 1, 'OpenLayers-Karten-Container', '', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', 'Bitte warten Sie, bis die Karte geladen wurde.', 'div', '../pc/config.php', '../pc/OpenLayers-2.13.1/OpenLayers.js,../pc/ol_factories.js,../pc/projekt.js,../pc/map.js,../pc/jquery/jquery.form.js,../pc/jquery.ks.spinner.js,../pc/OpenLayers-2.13.1/lib/OpenLayers/Lang/de.js', 'content', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'sidebar_widgets', 8, 1, 'Sidebar-Widgets-Container', '', 'div', '', '', NULL, NULL, NULL, NULL, NULL, 'display:table-cell;', '<div style="margin-bottom:10px;font-family:''Verdana'';font-size:250%;font-weight:bold;text-align:center;color:#d81920">DEMO</div>', 'div', '', '', 'sidebar', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'back_to_start', 19, 1, 'Button zum Zurückkehren auf Startseite', '', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '', 'div', '', '', 'sidebar_widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'sonderseiten', 18, 1, 'Buttons zum Öffnen der Sonderseiten', 'Hilfe und Impressum', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '<button onClick="window.open(''http://demo.klarschiff-hro.de/pc/hilfe.html'',''_blank'')">Hilfe</button>
<button onClick="window.open(''http://demo.klarschiff-hro.de/pc/datenschutz.html'',''_blank'')">Datenschutz</button>
<button onClick="window.open(''http://demo.klarschiff-hro.de/pc/impressum.html'',''_blank'')">Impressum</button>
<button onClick="window.open(''http://demo.klarschiff-hro.de/pc/nutzungsbedingungen.html'',''_blank'')">Nutzungsbedingungen</button>', 'div', '', '', 'widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'template_meldung_abuse', 16, 1, 'Template für Anzeige Meldung', '', 'script', '', 'type="text/x-jquery-templ"', NULL, NULL, NULL, NULL, NULL, '', '<input type="hidden" name="id" value="${id}"/>
<label style="margin-bottom:3px" for="email">E-Mail-Adresse <span style="font-style:italic;color:#d81920">(maximal 75 Zeichen!)</label>
<input type="text" maxlength="75" name="email" value="${email}"/>
<label for="details" style="margin-top:18px;margin-bottom:3px">Begründung <span style="font-style:italic;color:#d81920">(maximal 500 Zeichen!)</span></label>
<textarea maxlength="500" name="details" onKeyPress="if (/msie/.test(navigator.userAgent.toLowerCase())) return(this.value.length < 500);"></textarea>
<p style="width:98%;margin-top:18px;margin-bottom:3px;font-size: 0.8em;text-align:justify"><b>Hinweis:</b> Einen Missbrauch können und sollten Sie dann melden, wenn durch Betreff, Details oder Foto Persönlichkeitsrechte verletzt werden (z. B. wenn auf dem Foto Gesichter oder Kfz-Kennzeichen zu erkennen sind). <span style="font-style:italic;color:#d81920">Achtung: Wenn Sie einen Missbrauch melden, wird die betroffene Meldung <b>sofort</b> und so lange <b>deaktiviert</b> (und damit unsichtbar), bis wir Ihren Missbrauchshinweis bearbeitet haben.</span></p>', 'script', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'template_meldung_support', 16, 1, 'Template für Anzeige Meldung', '', 'script', '', 'type="text/x-jquery-templ"', NULL, NULL, NULL, NULL, NULL, '', '<input type="hidden" name="id" value="${id}"/>
<label for="email" style="font-size:0.8em;font-weight:bold;margin-bottom:3px">E-Mail-Adresse</label>
<input type="text" name="email" value="${email}" maxlength="75" style="width:99%"/>', 'script', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'template_meldung_edit', 15, 1, 'Template für neue Meldung', '', 'script', '', 'type="text/x-jquery-templ"', NULL, NULL, NULL, NULL, NULL, '', '<form id="meldung" action="../pc/frontend/meldung_submit.php" method="POST" enctype="multipart/form-data">
  <input type="hidden" name="task" value="submit"/>
  <input type="hidden" name="typ" value="${typ}"/>
  <input type="hidden" name="point" value="${point}"/>

  <h4 style="margin-bottom:8px;margin-top:2px">Pflichtangaben</h4>
  <div style="margin-bottom:18px">
  <label for="hauptkategorie" class="required" style="margin-bottom:3px">Hauptkategorie</label>
  <select name="hauptkategorie">
  </select>
	
  <label for="unterkategorie" class="required" style="margin-bottom:3px">Unterkategorie</label>
  <select name="unterkategorie">
  </select>

  <label for="email" class="required" style="margin-bottom:3px">E-Mail-Adresse <span style="font-style:italic;color:#d81920">(maximal 75 Zeichen!)</label>
  <input type="text" maxlength="75" name="email" value="${email}"/>
  </div>

  <h4 style="margin-bottom:8px">weitere Angaben</h4>	
  <label for="betreff" style="margin-bottom:3px">Betreff<span class="betreff-pflicht">*</span> <span style="font-style:italic;color:#d81920">(maximal 50 Zeichen!)</span></label>
  <input type="text" maxlength="50" name="betreff" value="${betreff}"  />
	
  <label for="details" style="margin-bottom:3px">Details<span class="details-pflicht">*</span> <span style="font-style:italic;color:#d81920">(maximal 500 Zeichen!)</span></label>
  <textarea maxlength="500" name="details" onKeyPress="if (/msie/.test(navigator.userAgent.toLowerCase())) return(this.value.length < 500);">${details}</textarea>

  <label for="foto" style="margin-bottom:3px">Foto <span style="font-style:italic;color:#d81920">(Dateigröße maximal 2 MB!)</span></label>
  <input type="file" name="foto"/>
  <table id="fotos"></table>

  <p class="help"><b>Hinweis:</b> Vor der Veröffentlichung werden eingegebene Texte sowie das Foto redaktionell überprüft.</p>
  <p class="help pflicht-fussnote">* Pflichtangabe bei dieser Unterkategorie</p>
	
</form>', 'script', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'standortsuche', 11, 1, 'Standortsuche-Panel', 'Adressensuche', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '<div class="search" style="display:block">
<input type="text" name="searchtext" id="searchtext" />
<div class="results" id="results_container" style="position:relative;"></div>
</div>

<!--
<div class="input_wrapper">
	<input type="text" name="standort" id="standort"/>
</div>
<button>Suchen</button>
-->', 'div', '../pc/search/inc/search2.js', '', 'widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'melden', 12, 1, 'Panel für Idee/Problem melden', 'neue Meldung', 'div', '', '', NULL, NULL, NULL, NULL, NULL, '', '<ol>
  <li><a href="#" id="problem" onclick="hinweisPopup()"><img style="margin-right:10px" alt="Problem melden" src="../pc/media/icons/problem_0.png"/>Problem melden</a></li>
  <li style="margin-top:5px"><a href="#" id="idee" onclick="hinweisPopup()"><img style="margin-right:10px" alt="Idee melden" src="../pc/media/icons/idee_0.png"/>Idee melden</a></li>
</ol>', 'div', '', '', 'widgets', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'template_meldung_show_mobil', 16, 0, 'Template für Anzeige Meldung auf dem Mobil-Client.
Das Element ist hier deaktiviert, da es nicht um PC-Client dargestellt werden soll.
Der Inhalt wird über die Datei pc/frontend/getConfig.php an den Mobil-Client gereicht.', '', 'script', '', 'type="text/x-jquery-templ"', NULL, NULL, NULL, NULL, NULL, '', '<h3 style="margin-left:2%;margin-top:1%;margin-bottom:0.5%">Hauptkategorie</h3>
<p style="margin-left:2%">${hauptkategorie}</p>

<h3 style="margin-left:2%;margin-bottom:0.5%">Unterkategorie</h3>
<p style="margin-left:2%">${unterkategorie}</p>

<h3 style="margin-left:2%;margin-bottom:0.5%">Status</h3>
<p style="margin-left:2%">{{if status != ''wirdNichtBearbeitet'' && status != ''inBearbeitung''}}${status}{{/if}}{{if status == ''wirdNichtBearbeitet''}}wird nicht bearbeitet{{/if}}{{if status == ''inBearbeitung''}}in Bearbeitung{{/if}} (seit ${datum_statusaenderung}){{if zustaendigkeit}}, aktuell bei<br/>${zustaendigkeit}</p>{{/if}}

{{if betreff_vorhanden == "true" && betreff_freigegeben == "true"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Betreff</h3>
<p style="margin-left:2%">${titel}</p>
{{else status == ''offen'' && betreff_vorhanden == "true" && betreff_freigegeben == "false"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Betreff</h3>
<p style="margin-left:2%;font-style:italic">redaktionelle Prüfung ausstehend</p>
{{else status != ''offen'' && status != ''gemeldet'' && betreff_vorhanden == "true" && betreff_freigegeben == "false"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Betreff</h3>
<p style="margin-left:2%;font-style:italic">redaktionell nicht freigegeben</p>
{{/if}}

{{if details_vorhanden == "true" && details_freigegeben == "true"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Details</h3>
<p style="margin-left:2%">${details}</p>
{{else status == ''offen'' && details_vorhanden == "true" && details_freigegeben == "false"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Details</h3>
<p style="margin-left:2%;font-style:italic">redaktionelle Prüfung ausstehend</p>
{{else status != ''offen'' && status != ''gemeldet'' && details_vorhanden == "true" && details_freigegeben == "false"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Details</h3>
<p style="margin-left:2%;font-style:italic">redaktionell nicht freigegeben</p>
{{/if}}
  
{{if foto_vorhanden == "true" && foto_freigegeben == "true"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Foto</h3>
<img style="margin-left:2%;margin-right:2%;margin-top:1%" src="${img_url}" />
{{else status == ''offen'' && foto_vorhanden == "true" && foto_freigegeben == "false"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Foto</h3>
<p style="margin-left:2%;font-style:italic">redaktionelle Prüfung ausstehend</p>
{{else status != ''offen'' && status != ''gemeldet'' && foto_vorhanden == "true" && foto_freigegeben == "false"}}
<h3 style="margin-left:2%;margin-bottom:0.5%">Foto</h3>
<p style="margin-left:2%;font-style:italic">redaktionell nicht freigegeben</p>
{{/if}}

{{if bemerkung}}
<div id="bemerkung_eintrag">
<h3 style="margin-left:2%;margin-bottom:0.5%">Info der Verwaltung</h3>
<p style="margin-left:2%">{{html bemerkung}}</p>
{{/if}}
</div>

<div id="supporters">
<p style="margin-left:2%;margin-top:3%;font-style:italic">bisher <span {{if vorgangstyp == ''problem''}}class="meldung_unterstuetzer_problem"{{/if}}{{if vorgangstyp == ''idee''}}class="meldung_unterstuetzer"{{/if}}>${unterstuetzer}</span> {{if unterstuetzer != 1}}Unterstützungen{{/if}}{{if unterstuetzer == 1}}Unterstützung{{/if}}{{if vorgangstyp == ''idee''}} (${schwellenwert} nötig){{/if}}</p>
</div>', 'script', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'template_meldung_lobhinweisekritik', 16, 1, 'Template für Lob, Hinweise oder Kritik zu einer Meldung', '', 'script', '', 'type="text/x-jquery-templ"', NULL, NULL, NULL, NULL, NULL, '', '<input type="hidden" name="id" value="${id}"/>
<label for="email">Empfänger</label>
<p>${zustaendigkeit}</p>
<label style="margin-bottom:3px;margin-top:15px" for="email">E-Mail-Adresse <span style="font-style:italic;color:#d81920">(maximal 75 Zeichen!)</label>
<input type="text" maxlength="75" name="email" value="${email}"/>
<label for="freitext" style="margin-top:18px;margin-bottom:3px">Freitext <span style="font-style:italic;color:#d81920">(maximal 500 Zeichen!)</span></label>
<textarea maxlength="500" name="freitext" onKeyPress="if (/msie/.test(navigator.userAgent.toLowerCase())) return(this.value.length < 500);"></textarea>', 'script', '', '', '', '', '');
INSERT INTO gui_element VALUES ('Klarschiff', 'template_meldung_show', 16, 1, 'Template für Anzeige Meldung', '', 'script', '', 'type="text/x-jquery-templ"', NULL, NULL, NULL, NULL, NULL, '', '<input type="hidden" name="id" value="${id}"/>
<input type="hidden" name="zustaendigkeit" value="${zustaendigkeit}"/>
<div id="supporters">
<p style="font-style:italic">bisher<span class="meldung_unterstuetzer" style="margin-top:3px;margin-bottom:3px">${unterstuetzer}</span>{{if unterstuetzer != 1}}Unterstützungen{{/if}}{{if unterstuetzer == 1}}Unterstützung{{/if}}{{if vorgangstyp == ''idee''}}<br/>(${schwellenwert} nötig){{/if}}</p>
</div>
Hauptkategorie
<p class="meldung_eintrag">${hauptkategorie}</p>

Unterkategorie
<p class="meldung_eintrag">${unterkategorie}</p>

Status
<p class="meldung_eintrag">${status} (seit ${datum_statusaenderung}){{if zustaendigkeit}}, aktuell bei<br/>${zustaendigkeit}</p>{{/if}}
<div id="meldung_details">
  {{if betreff_vorhanden == "true" && betreff_freigegeben == "true"}}
  Betreff
  <p class="meldung_eintrag">${titel}</p>
  {{else status == ''offen'' && betreff_vorhanden == "true" && betreff_freigegeben == "false"}}
  Betreff
  <p class="meldung_eintrag-nicht-vorhanden">redaktionelle Prüfung ausstehend</p>
  {{else status != ''offen'' && status != ''gemeldet'' && betreff_vorhanden == "true" && betreff_freigegeben == "false"}}
  Betreff
  <p class="meldung_eintrag-nicht-vorhanden">redaktionell nicht freigegeben</p>
  {{/if}}
  {{if details_vorhanden == "true" && details_freigegeben == "true"}}
  Details
  <p class="meldung_eintrag">${details}</p>
  {{else status == ''offen'' && details_vorhanden == "true" && details_freigegeben == "false"}}
  Details
  <p class="meldung_eintrag-nicht-vorhanden">redaktionelle Prüfung ausstehend</p>
  {{else status != ''offen'' && status != ''gemeldet'' && details_vorhanden == "true" && details_freigegeben == "false"}}
  Details
  <p class="meldung_eintrag-nicht-vorhanden">redaktionell nicht freigegeben</p>
  {{/if}}
  {{if foto_vorhanden == "true" && foto_freigegeben == "true"}}
  Foto
  <div class="meldung-foto">
    <img src="${foto_normal}" />
  </div>
  {{else status == ''offen'' && foto_vorhanden == "true" && foto_freigegeben == "false"}}
  Foto
  <p class="meldung_eintrag-nicht-vorhanden">redaktionelle Prüfung ausstehend</p>
  {{else status != ''offen'' && status != ''gemeldet'' && foto_vorhanden == "true" && foto_freigegeben == "false"}}
  Foto
  <p class="meldung_eintrag-nicht-vorhanden">redaktionell nicht freigegeben</p>
  {{/if}}
  {{if bemerkung}}
  Info der Verwaltung
  <p class="meldung_eintrag">{{html bemerkung}}</p>
  {{/if}}

  <p class="meldung_eintrag">bisher <span class="meldung_unterstuetzer">${unterstuetzer}</span> {{if unterstuetzer != 1}}Unterstützungen{{/if}}{{if unterstuetzer == 1}}Unterstützung{{/if}}{{if vorgangstyp == ''idee''}} (${schwellenwert} nötig){{/if}}</p>
    <div id="meldung_actions" class="ui-dialog-buttonpane ui-widget-content ui-helper-clearfix">
        <button id="meldung_unterstuetzen" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button" role="button" aria-disabled="false">
            <span style="line-height:8px" class="ui-button-text">Meldung unterstützen</span>
        </button>
        <button id="meldung_melden" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button" role="button" aria-disabled="false">
            <span style="line-height:8px"class="ui-button-text">Missbrauch melden</span>
        </button>
        <br/>
        <button id="meldung_lobenhinweisenkritisieren" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button" role="button" aria-disabled="false" style="width:97.5%">
            <span style="line-height:8px"class="ui-button-text">Lob, Hinweise oder Kritik zur Meldung</span>
        </button>
    </div>
</div>
<div>
  <button id="meldung_details_show">Details</button>
  <button id="meldung_details_prev" title="Vorherige Meldung anzeigen" style="display:none;">
    <span class="ui-icon ui-icon-seek-prev"></span>
  </button>
  <span id="meldung_details_recorder" style="display:none;"></span>
  <button id="meldung_details_next" title="Nächste Meldung anzeigen" style="display:none;">
    <span class="ui-icon ui-icon-seek-next"></span>
  </button>
</div>', 'script', '', '', '', '', '');


--
-- TOC entry 4403 (class 0 OID 18250)
-- Dependencies: 186
-- Data for Name: gui_element_vars; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'body', 'body_file_css', '../css/admin_service.css', 'file/css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'filteredWms_layer_topic', 'file css', '../css/administration_alloc_4.css', 'css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'filteredWms_layer_topic', 'language', 'de', '', 'php_var');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'help', 'mod_help_color', '#cc33cc', 'color for highlighting', 'var');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'help', 'mod_help_text', 'click highlighted elements for help', '', 'php_var');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'help', 'mod_help_thickness', '3', 'thickness of highlighting', 'var');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'showLoggedUser', 'css_file_user_logged', '../css/administration_alloc.css', 'file/css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'body', 'jq_ui_theme', '../extensions/jquery-ui-1.7.2.custom/css/smoothness/jquery-ui-1.7.2.custom.css', 'UI Theme from Themeroller', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'body', 'body_css_file', '../css/admin.css', 'css-file to define the style fo the admin-gui', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'filteredGoup_filteredUser', 'file css', '../css/administration_alloc.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'filteredGroup_filteredGui', 'file css', '../css/administration_alloc.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'filteredGui_filteredGroup', 'file css', '../css/administration_alloc.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'filteredGui_filteredUser', 'file css', '../css/administration_alloc.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'filteredUser_filteredGroup', 'file css', '../css/administration_alloc.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'filteredUser_filteredGui', 'file css', '../css/administration_alloc.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'gui_owner', 'file css', '../css/administration_alloc.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'help', 'mod_help_color', '#cc33cc', 'color for highlighting', 'var');
INSERT INTO gui_element_vars VALUES ('Administration', 'help', 'mod_help_text', 'click highlighted elements for help', '', 'php_var');
INSERT INTO gui_element_vars VALUES ('Administration', 'help', 'mod_help_thickness', '3', 'thickness of highlighting', 'var');
INSERT INTO gui_element_vars VALUES ('Administration', 'showLoggedUser', 'css_file_user_logged', '../css/administration_alloc.css', 'file/css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'createCategory', 'cssfile', '../css/administration_alloc.css', '', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'category_filteredGUI', 'cssfile', '../css/administration_alloc.css', 'css file for admin module', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'body', 'jq_ui_theme', '../extensions/jquery-ui-1.7.2.custom/css/smoothness/jquery-ui-1.7.2.custom.css', 'UI Theme from Themeroller', 'file/css');
INSERT INTO gui_element_vars VALUES ('Administration', 'editFilteredUser', 'withPasswordInsertion', 'true', 'define if admin can set the new user', 'php_var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'kartenelemente', 'filter', '{
	probleme12: {label: "offene Probleme",     
     enabled: true,
     icons: ["problem_1_layer.png", "problem_2_layer.png"],
     filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "problem"
    	     }),
    	     new OpenLayers.Filter.Logical({
    	    	 type: OpenLayers.Filter.Logical.OR,
    	    	 filters: [
		    new OpenLayers.Filter.Comparison({
			type: OpenLayers.Filter.Comparison.EQUAL_TO,
			property: "status",
			value: "gemeldet"
		    }),
		    new OpenLayers.Filter.Comparison({
			type: OpenLayers.Filter.Comparison.EQUAL_TO,
			property: "status",
			value: "offen"
		    })
    	    	 ]
    	     })
    	 ]
     })},
    probleme3: {label: "Probleme in Bearbeitung",
	 enabled: true,
	 icons: ["problem_3_layer.png"],
	 filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "problem"
    	     }),
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "status",
    	    	 value: "inBearbeitung"
    	     })
    	 ]
     })},
	probleme5: {label: "gelöste Probleme",	 
	 enabled: true,
	 icons: ["problem_5_layer.png"],
	 filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "problem"
    	     }),
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "status",
    	    	 value: "abgeschlossen"
    	     })
    	 ]
     })},
	probleme4: {label: "nicht lösbare Probleme",
	 enabled: true,
	 icons: ["problem_4_layer.png"],
	 filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "problem"
    	     }),
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "status",
    	    	 value: "wirdNichtBearbeitet"
    	     })
    	 ]
     })},
	ideen12: {label: "offene Ideen",
     enabled: true,
     icons: ["idee_1_layer.png", "idee_2_layer.png"],
     filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "idee"
    	     }),
    	     new OpenLayers.Filter.Logical({
    	    	 type: OpenLayers.Filter.Logical.OR,
    	    	 filters: [
		    new OpenLayers.Filter.Comparison({
			type: OpenLayers.Filter.Comparison.EQUAL_TO,
			property: "status",
			value: "gemeldet"
		    }),
		    new OpenLayers.Filter.Comparison({
			type: OpenLayers.Filter.Comparison.EQUAL_TO,
			property: "status",
			value: "offen"
		    })
    	    	 ]
    	     })
    	 ]
     })},
    ideen3: {label: "Ideen in Bearbeitung",
	 enabled: true,
         icons: ["idee_3_layer.png"],
	 filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "idee"
    	     }),
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "status",
    	    	 value: "inBearbeitung"
    	     })
    	 ]
     })},
	ideen5: {label: "umgesetzte Ideen",
	 enabled: true,
         icons: ["idee_5_layer.png"],
	 filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "idee"
    	     }),
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "status",
    	    	 value: "abgeschlossen"
    	     })
    	 ]
     })},
	ideen4: {label: "nicht umsetzbare Ideen",
	 enabled: true,
	 icons: ["idee_4_layer.png"],
	 filter: new OpenLayers.Filter.Logical({
    	 type: OpenLayers.Filter.Logical.AND,
    	 filters: [
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "vorgangstyp",
    	    	 value: "idee"
    	     }),
    	     new OpenLayers.Filter.Comparison({
    	    	 type: OpenLayers.Filter.Comparison.EQUAL_TO,
    	    	 property: "status",
    	    	 value: "wirdNichtBearbeitet"
    	     })
    	 ]
     })}
}', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'css_file_body', '../pc/map.css', 'file/css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'bilder_pfad', '../fotos/', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'css_spinner', '../pc/jquery.ks.spinner.css', '', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'maxExtent', '[271265.01714072, 5971859.93045162, 346749.189382955, 6017571.95459192]', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'projection_units', 'm', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'scales', '[65000,
 50000,
 25000,
 10000,
  5000,
  2500,
  1000,
   500]', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'startExtent', '[302094.65625, 5991073.5, 325566.71875, 6016343]', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'jq_ui_theme', '../pc/jquery/theme/jquery-ui-1.8.11.custom.css', 'UI Theme from Themeroller', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'css_file_client ', '../pc/map_fine.css', 'file/css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'includeWhileLoading', '../include/gui1_splash.php', '', 'php_var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'popupcss', '../css/popup.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'use_load_message', 'true', '', 'php_var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'tablesortercss', '../css/tablesorter.css', 'file css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'jquery_datatables', '../extensions/dataTables-1.5/media/css/demo_table_jui.css', '', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'css_class_bg', 'body{ background-color: #ffffff; }', 'to define the color of the body', 'text/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'jq_datatables', 'defaultCss', '../extensions/dataTables-1.5/media/css/demo_table_jui.css', '', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'kartenelemente', 'schwellenwert', '20', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'ImgPath', '../pc/OpenLayers-2.13.1/img/', '', 'var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'ol_map', 'theme', '../pc/OpenLayers-2.13.1/theme/default/style.css', '', 'var');
INSERT INTO gui_element_vars VALUES ('Administration', 'body', 'favicon', '/favicon.ico', 'favicon', 'php_var');
INSERT INTO gui_element_vars VALUES ('Administration-erweitert', 'body', 'favicon', '/favicon.ico', 'favicon', 'php_var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'body', 'favicon', '/favicon.ico', 'favicon', 'php_var');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'standortsuche', 'css', '../pc/search/inc/search.css', 'file/css', 'file/css');
INSERT INTO gui_element_vars VALUES ('Klarschiff', 'standortsuche', 'url', '../pc/search/server.php', '', 'var');


--
-- TOC entry 4404 (class 0 OID 18259)
-- Dependencies: 187
-- Data for Name: gui_gui_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui_gui_category VALUES ('Administration-erweitert', 1);
INSERT INTO gui_gui_category VALUES ('Administration', 1);
INSERT INTO gui_gui_category VALUES ('Klarschiff', 5);


--
-- TOC entry 4405 (class 0 OID 18262)
-- Dependencies: 188
-- Data for Name: gui_kml; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4406 (class 0 OID 18270)
-- Dependencies: 190
-- Data for Name: gui_layer; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui_layer VALUES ('Klarschiff', 20531, 942, 0, 0, 0, 0, 0, 400, 151000, 0, '', NULL, 'Stadtplan');
INSERT INTO gui_layer VALUES ('Klarschiff', 20528, 942, 1, 1, 1, 0, 0, 400, 151000, 1, '', NULL, 'Stadtplan');
INSERT INTO gui_layer VALUES ('Klarschiff', 20529, 942, 0, 0, 0, 0, 0, 400, 151000, 2, '', NULL, 'Stadtplan (ohne Beschriftung)');
INSERT INTO gui_layer VALUES ('Klarschiff', 20530, 957, 0, 0, 0, 0, 0, 400, 151000, 0, '', NULL, 'Luftbild');
INSERT INTO gui_layer VALUES ('Klarschiff', 20524, 957, 1, 1, 1, 0, 0, 400, 151000, 0, '', NULL, 'Luftbild');


--
-- TOC entry 4407 (class 0 OID 18284)
-- Dependencies: 191
-- Data for Name: gui_mb_group; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4408 (class 0 OID 18290)
-- Dependencies: 192
-- Data for Name: gui_mb_user; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui_mb_user VALUES ('Administration-erweitert', 1, 'owner');
INSERT INTO gui_mb_user VALUES ('Administration', 1, 'owner');
INSERT INTO gui_mb_user VALUES ('Klarschiff', 1, 'owner');
INSERT INTO gui_mb_user VALUES ('Klarschiff', 7, NULL);


--
-- TOC entry 4409 (class 0 OID 18295)
-- Dependencies: 193
-- Data for Name: gui_treegde; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4410 (class 0 OID 18306)
-- Dependencies: 195
-- Data for Name: gui_wfs; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4411 (class 0 OID 18311)
-- Dependencies: 196
-- Data for Name: gui_wfs_conf; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4412 (class 0 OID 18316)
-- Dependencies: 197
-- Data for Name: gui_wms; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO gui_wms VALUES ('Klarschiff', 957, 1, 'image/png', 'text/html', 'application/vnd.ogc.se_inimage', 'EPSG:4326', 1, '', 100);
INSERT INTO gui_wms VALUES ('Klarschiff', 942, 0, 'image/png', 'text/html', 'application/vnd.ogc.se_inimage', 'EPSG:25833', 1, '', 100);


--
-- TOC entry 4413 (class 0 OID 18332)
-- Dependencies: 198
-- Data for Name: inspire_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO inspire_category VALUES (1, '1.1', 'Coordinate reference systems', 'Koordinatenreferenzsysteme', '', '', 'Systeme zur eindeutigen räumlichen Referenzierung von Geodaten anhand eines Koordinatensatzes (x, y, z) und/oder Angaben zu Breite, Länge und Höhe auf der Grundlage eines geodätischen horizontalen und vertikalen Datums.');
INSERT INTO inspire_category VALUES (2, '1.2', 'Geographical grid systems', 'Geografische Gittersysteme', '', '', 'Harmonisiertes Gittersystem mit Mehrfachauflösung, gemeinsamem Ursprungspunkt und standardisierter Lokalisierung und Größe der Gitterzellen.');
INSERT INTO inspire_category VALUES (3, '1.3', 'Geographical names', 'Geografische Bezeichnungen', '', '', 'Namen von Gebieten, Regionen, Orten, Großstädten, Vororten, Städten oder Siedlungen sowie jedes geografische oder topografische Merkmal von öffentlichem oder historischem Interesse.');
INSERT INTO inspire_category VALUES (4, '1.4', 'Administrative units', 'Verwaltungseinheiten', '', '', 'Lokale, regionale und nationale Verwaltungseinheiten, die die Gebiete abgrenzen, in denen die Mitgliedstaaten Hoheitsbefugnisse haben und/oder ausüben und die durch Verwaltungsgrenzen voneinander getrennt sind.');
INSERT INTO inspire_category VALUES (5, '1.5', 'Addresses', 'Adressen', '', '', 'Lokalisierung von Grundstücken anhand von Adressdaten, in der Regel Straßenname, Hausnummer und Postleitzahl.');
INSERT INTO inspire_category VALUES (6, '1.6', 'Cadastral parcels', 'Flurstücke/Grundstücke (Katasterparzellen)', '', '', 'Gebiete, die anhand des Grundbuchs oder gleichwertiger Verzeichnisse bestimmt werden. ');
INSERT INTO inspire_category VALUES (7, '1.7', 'Transport networks', 'Verkehrsnetze', '', '', 'Verkehrsnetze und zugehörige Infrastruktureinrichtungen für Straßen-, Schienen- und Luftverkehr sowie Schifffahrt. Umfasst auch die Verbindungen zwischen den verschiedenen Netzen. Umfasst auch das transeuropäische Verkehrsnetz im Sinne der Entscheidung Nr. 1692/96/EG des Europäischen Parlaments und des Rates vom 23. Juli 1996 über gemeinschaftliche Leitlinien für den Aufbau eines transeuropäischen Verkehrsnetzes und künftiger Überarbeitungen dieser Entscheidung. ');
INSERT INTO inspire_category VALUES (8, '1.8', 'Hydrography', 'Gewässernetz', '', '', 'Elemente des Gewässernetzes, einschließlich Meeresgebieten und allen sonstigen Wasserkörpern und hiermit verbundenen Teilsystemen, darunter Einzugsgebiete und Teileinzugsgebiete. Gegebenenfalls gemäß den Definitionen der Richtlinie 2000/60/EG des Europäischen Parlaments und des Rates vom 23. Oktober 2000 zur Schaffung eines Ordnungsrahmens für Maßnahmen der Gemeinschaft im Bereich der Wasserpolitik und in Form von Netzen.');
INSERT INTO inspire_category VALUES (9, '1.9', 'Protected sites', 'Schutzgebiete', '', '', 'Gebiete, die im Rahmen des internationalen und des gemeinschaftlichen Rechts sowie des Rechts der Mitgliedstaaten ausgewiesen sind oder verwaltet werden, um spezifische Erhaltungsziele zu erreichen.');
INSERT INTO inspire_category VALUES (10, '2.1', 'Elevation', 'Höhe', '', '', 'Digitale Höhenmodelle für Land-, Eis- und Meeresflächen. Dazu gehören Geländemodell, Tiefenmessung und Küstenlinie.');
INSERT INTO inspire_category VALUES (11, '2.2', 'Land cover', 'Bodenbedeckung', '', '', 'Physische und biologische Bedeckung der Erdoberfläche, einschließlich künstlicher Flächen, landwirtschaftlicher Flächen, Wäldern, natürlicher (naturnaher) Gebiete, Feuchtgebieten und Wasserkörpern.');
INSERT INTO inspire_category VALUES (12, '2.3', 'Orthoimagery', 'Orthofotografie', '', '', 'Georeferenzierte Bilddaten der Erdoberfläche von satelliten- oder luftfahrzeuggestützten Sensoren.');
INSERT INTO inspire_category VALUES (13, '2.4', 'Geology', 'Geologie', '', '', 'Geologische Beschreibung anhand von Zusammensetzung und Struktur. Dies umfasst auch Grundgestein, Grundwasserleiter und Geomorphologie.');
INSERT INTO inspire_category VALUES (14, '3.1', 'Statistical units', 'Statistische Einheiten', '', '', 'Einheiten für die Verbreitung oder Verwendung statistischer Daten.');
INSERT INTO inspire_category VALUES (15, '3.2', 'Buildings', 'Gebäude', '', '', 'Geografischer Standort von Gebäuden.');
INSERT INTO inspire_category VALUES (16, '3.3', 'Soil', 'Boden', '', '', 'Beschreibung von Boden und Unterboden anhand von Tiefe, Textur, Struktur und Gehalt an Teilchen sowie organischem Material, Steinigkeit, Erosion, gegebenenfalls durchschnittliches Gefälle und erwartete Wasserspeicherkapazität.');
INSERT INTO inspire_category VALUES (17, '3.4', 'Land use', 'Bodennutzung', '', '', 'Beschreibung von Gebieten anhand ihrer derzeitigen und geplanten künftigen Funktion oder ihres sozioökonomischen Zwecks (z. B. Wohn-, Industrie- oder Gewerbegebiete, land- oder forstwirtschaftliche Flächen, Freizeitgebiete).');
INSERT INTO inspire_category VALUES (18, '3.5', 'Human health and safety', 'Gesundheit und Sicherheit', '', '', 'Geografische Verteilung verstärkt auftretender pathologischer Befunde (Allergien, Krebserkrankungen, Erkrankungen der Atemwege usw.), Informationen über Auswirkungen auf die Gesundheit (Biomarker, Rückgang der Fruchtbarkeit, Epidemien) oder auf das Wohlbefinden (Ermüdung, Stress usw.) der Menschen in unmittelbarem Zusammenhang mit der Umweltqualität (Luftverschmutzung, Chemikalien, Abbau der Ozonschicht, Lärm usw.) oder in mittelbarem Zusammenhang mit der Umweltqualität (Nahrung, genetisch veränderte Organismen usw.).');
INSERT INTO inspire_category VALUES (19, '3.6', 'Utility and governmental services', 'Versorgungswirtschaft und staatliche Dienste', '', '', 'Versorgungseinrichtungen wie Abwasser- und Abfallentsorgung, Energieversorgung und Wasserversorgung; staatliche Verwaltungs- und Sozialdienste wie öffentliche Verwaltung, Katastrophenschutz, Schulen und Krankenhäuser.');
INSERT INTO inspire_category VALUES (20, '3.7', 'Environmental monitoring facilities', 'Umweltüberwachung', '', '', 'Standort und Betrieb von Umweltüberwachungseinrichtungen einschließlich Beobachtung und Messung von Schadstoffen, des Zustands von Umweltmedien und anderen Parametern des Ökosystems (Artenvielfalt, ökologischer Zustand der Vegetation usw.) durch oder im Auftrag von öffentlichen Behörden.');
INSERT INTO inspire_category VALUES (21, '3.8', 'Production and industrial facilities', 'Produktions- und Industrieanlagen', '', '', 'Standorte für industrielle Produktion, einschließlich durch die Richtlinie 96/61/EG des Rates vom 24. September 1996 über die integrierte Vermeidung und Verminderung der Umweltverschmutzung erfasste Anlagen und Einrichtungen zur Wasserentnahme sowie Bergbau- und Lagerstandorte.');
INSERT INTO inspire_category VALUES (22, '3.9', 'Agricultural and aquaculture facilities', 'Landwirtschaftliche Anlagen und Aquakulturanlagen', '', '', 'Landwirtschaftliche Anlagen und Produktionsstätten (einschließlich Bewässerungssystemen, Gewächshäusern und Ställen).');
INSERT INTO inspire_category VALUES (23, '3.10', 'Population distribution — demography', 'Verteilung der Bevölkerung — Demografie', '', '', 'Geografische Verteilung der Bevölkerung, einschließlich Bevölkerungsmerkmalen und Tätigkeitsebenen, zusammengefasst nach Gitter, Region, Verwaltungseinheit oder sonstigen analytischen Einheiten.');
INSERT INTO inspire_category VALUES (24, '3.11', 'Area management/restriction/regulation zones and reporting units', 'Bewirtschaftungsgebiete/Schutzgebiete/geregelte Gebiete und Berichterstattungseinheiten', '', '', 'Auf internationaler, europäischer, nationaler, regionaler und lokaler Ebene bewirtschaftete, geregelte oder zu Zwecken der Berichterstattung herangezogene Gebiete. Dazu zählen Deponien, Trinkwasserschutzgebiete, nitratempfindliche Gebiete, geregelte Fahrwasser auf See oder auf großen Binnengewässern, Gebiete für die Abfallverklappung, Lärmschutzgebiete, für Exploration und Bergbau ausgewiesene Gebiete, Flussgebietseinheiten, entsprechende Berichterstattungseinheiten und Gebiete des Küstenzonenmanagements.');
INSERT INTO inspire_category VALUES (25, '3.12', 'Natural risk zones', 'Gebiete mit naturbedingten Risiken', '', '', 'Gefährdete Gebiete, eingestuft nach naturbedingten Risiken (sämtliche atmosphärischen, hydrologischen, seismischen, vulkanischen Phänomene sowie Naturfeuer, die aufgrund ihres örtlichen Auftretens sowie ihrer Schwere und Häufigkeit signifikante Auswirkungen auf die Gesellschaft haben können), z. B. Überschwemmungen, Erdrutsche und Bodensenkungen, Lawinen, Waldbrände, Erdbeben oder Vulkanausbrüche.');
INSERT INTO inspire_category VALUES (26, '3.13', 'Atmospheric conditions', 'Atmosphärische Bedingungen', '', '', 'Physikalische Bedingungen in der Atmosphäre. Dazu zählen Geodaten auf der Grundlage von Messungen, Modellen oder einer Kombination aus beiden sowie Angabe der Messstandorte.');
INSERT INTO inspire_category VALUES (27, '3.14', 'Meteorological geographical features', 'Meteorologisch-geografische Kennwerte', '', '', 'Witterungsbedingungen und deren Messung; Niederschlag, Temperatur, Gesamtverdunstung (Evapotranspiration), Windgeschwindigkeit und Windrichtung.');
INSERT INTO inspire_category VALUES (28, '3.15', 'Oceanographic geographical features', 'Ozeanografisch-geografische Kennwerte', '', '', 'Physikalische Bedingungen der Ozeane (Strömungsverhältnisse, Salinität, Wellenhöhe usw.).');
INSERT INTO inspire_category VALUES (29, '3.16', 'Sea regions', 'Meeresregionen', '', '', 'Physikalische Bedingungen von Meeren und salzhaltigen Gewässern, aufgeteilt nach Regionen und Teilregionen mit gemeinsamen Merkmalen.');
INSERT INTO inspire_category VALUES (30, '3.17', 'Bio-geographical regions', 'Biogeografische Regionen', '', '', 'Gebiete mit relativ homogenen ökologischen Bedingungen und gemeinsamen Merkmalen.');
INSERT INTO inspire_category VALUES (31, '3.18', 'Habitats and biotopes', 'Lebensräume und Biotope', '', '', 'Geografische Gebiete mit spezifischen ökologischen Bedingungen, Prozessen, Strukturen und (lebensunterstützenden) Funktionen als physische Grundlage für dort lebende Organismen. Dies umfasst auch durch geografische, abiotische und biotische Merkmale gekennzeichnete natürliche oder naturnahe terrestrische und aquatische Gebiete.');
INSERT INTO inspire_category VALUES (32, '3.19', 'Species distribution', 'Verteilung der Arten', '', '', 'Geografische Verteilung des Auftretens von Tier- und Pflanzenarten, zusammengefasst in Gittern, Region, Verwaltungseinheit oder sonstigen analytischen Einheiten.');
INSERT INTO inspire_category VALUES (33, '3.20', 'Energy resources', 'Energiequellen', '', '', 'Energiequellen wie Kohlenwasserstoffe, Wasserkraft, Bioenergie, Sonnen- und Windenergie usw., gegebenenfalls mit Tiefen- bzw. Höhenangaben zur Ausdehnung der Energiequelle.');
INSERT INTO inspire_category VALUES (34, '3.21', 'Mineral resources', 'Mineralische Bodenschätze', '', '', 'Mineralische Bodenschätze wie Metallerze, Industrieminerale usw., gegebenenfalls mit Tiefen- bzw. Höhenangaben zur Ausdehnung der Bodenschätze.');


--
-- TOC entry 4414 (class 0 OID 18340)
-- Dependencies: 200
-- Data for Name: inspire_md_data; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4415 (class 0 OID 18348)
-- Dependencies: 202
-- Data for Name: keyword; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO keyword VALUES (1, 'Germany');
INSERT INTO keyword VALUES (2, 'Deutschland');
INSERT INTO keyword VALUES (3, 'WebGIS');
INSERT INTO keyword VALUES (5, 'WFS');
INSERT INTO keyword VALUES (6, 'WhereGroup');
INSERT INTO keyword VALUES (7, 'Mapbender');
INSERT INTO keyword VALUES (8, 'Laender');
INSERT INTO keyword VALUES (10, 'city');
INSERT INTO keyword VALUES (11, 'Ort');
INSERT INTO keyword VALUES (12, 'Staedte');
INSERT INTO keyword VALUES (13, 'Stadt');
INSERT INTO keyword VALUES (14, 'Postleitzahl');
INSERT INTO keyword VALUES (15, 'PLZ');
INSERT INTO keyword VALUES (16, 'postcode');
INSERT INTO keyword VALUES (17, 'railroad');
INSERT INTO keyword VALUES (18, 'Bahn');
INSERT INTO keyword VALUES (19, 'DB');
INSERT INTO keyword VALUES (20, 'river');
INSERT INTO keyword VALUES (21, 'Fluss');
INSERT INTO keyword VALUES (22, 'water');
INSERT INTO keyword VALUES (23, 'Wasser');
INSERT INTO keyword VALUES (24, 'road');
INSERT INTO keyword VALUES (25, 'Strasse');
INSERT INTO keyword VALUES (26, 'Infrastruktur');
INSERT INTO keyword VALUES (28, 'Bundesland');
INSERT INTO keyword VALUES (29, 'Land');
INSERT INTO keyword VALUES (30, 'digitize');
INSERT INTO keyword VALUES (31, 'polygon');
INSERT INTO keyword VALUES (32, 'Linie');
INSERT INTO keyword VALUES (33, 'line');
INSERT INTO keyword VALUES (34, 'point');
INSERT INTO keyword VALUES (35, 'Punkt');
INSERT INTO keyword VALUES (36, 'poi');
INSERT INTO keyword VALUES (37, 'ArcIMS');
INSERT INTO keyword VALUES (38, 'ESRI');
INSERT INTO keyword VALUES (39, 'OGC Map Service');
INSERT INTO keyword VALUES (40, 'Web Mapping');
INSERT INTO keyword VALUES (41, 'GIS');
INSERT INTO keyword VALUES (42, 'GDI NRW');
INSERT INTO keyword VALUES (43, 'NWSIB');
INSERT INTO keyword VALUES (44, 'klassifiziertes Strassennetz');
INSERT INTO keyword VALUES (45, 'Anweisung Strasseninformationsbank ASB');
INSERT INTO keyword VALUES (46, 'Netzknoten-Stationierungssystem');
INSERT INTO keyword VALUES (47, 'birds');
INSERT INTO keyword VALUES (48, 'distribution');
INSERT INTO keyword VALUES (49, 'abundance');
INSERT INTO keyword VALUES (50, 'conservation');
INSERT INTO keyword VALUES (51, 'sites');
INSERT INTO keyword VALUES (52, 'monitoring');
INSERT INTO keyword VALUES (53, 'populations');
INSERT INTO keyword VALUES (54, 'canada');
INSERT INTO keyword VALUES (55, 'iba');
INSERT INTO keyword VALUES (56, 'birdlife');
INSERT INTO keyword VALUES (57, 'winter');
INSERT INTO keyword VALUES (58, 'survey');
INSERT INTO keyword VALUES (59, 'population');
INSERT INTO keyword VALUES (60, 'volunteers');
INSERT INTO keyword VALUES (61, 'cbc');
INSERT INTO keyword VALUES (62, 'christmas');
INSERT INTO keyword VALUES (63, 'Slubfurt');
INSERT INTO keyword VALUES (64, 'Slubice');
INSERT INTO keyword VALUES (65, 'Frankfurt (Oder)');
INSERT INTO keyword VALUES (66, 'topophilia');
INSERT INTO keyword VALUES (67, 'mental maps');
INSERT INTO keyword VALUES (68, 'geopgraphy');
INSERT INTO keyword VALUES (69, 'spatial perception');
INSERT INTO keyword VALUES (71, 'sense of place and identity');
INSERT INTO keyword VALUES (70, 'waterbirds');
INSERT INTO keyword VALUES (72, 'amphibians');
INSERT INTO keyword VALUES (73, 'cognitive map');
INSERT INTO keyword VALUES (74, 'marsh');
INSERT INTO keyword VALUES (75, 'spatial cognition');
INSERT INTO keyword VALUES (76, 'wetland');
INSERT INTO keyword VALUES (77, 'cognitive psychology');
INSERT INTO keyword VALUES (78, 'cognitive science');
INSERT INTO keyword VALUES (79, 'urban design');
INSERT INTO keyword VALUES (80, 'united states');
INSERT INTO keyword VALUES (81, 'great lakes');
INSERT INTO keyword VALUES (82, 'spatial orientation');
INSERT INTO keyword VALUES (83, 'AOC');
INSERT INTO keyword VALUES (84, 'identity of place');
INSERT INTO keyword VALUES (85, 'borders');
INSERT INTO keyword VALUES (86, 'national landscapes');
INSERT INTO keyword VALUES (87, 'Gavia immer');
INSERT INTO keyword VALUES (88, 'loons');
INSERT INTO keyword VALUES (89, 'lakes');
INSERT INTO keyword VALUES (90, 'acid rain');
INSERT INTO keyword VALUES (91, 'disturbance');
INSERT INTO keyword VALUES (92, 'ecosystem health');
INSERT INTO keyword VALUES (93, 'breeding range');
INSERT INTO keyword VALUES (94, 'Ontario');
INSERT INTO keyword VALUES (95, 'deegree');
INSERT INTO keyword VALUES (96, 'wms');
INSERT INTO keyword VALUES (97, 'ImageryBaseMapsEarthCover');
INSERT INTO keyword VALUES (99, 'BaseMaps');
INSERT INTO keyword VALUES (100, 'EarthCover');
INSERT INTO keyword VALUES (101, 'JPL');
INSERT INTO keyword VALUES (102, 'Jet Propulsion Laboratory');
INSERT INTO keyword VALUES (104, 'none');
INSERT INTO keyword VALUES (105, 'SLD');
INSERT INTO keyword VALUES (106, 'owls');
INSERT INTO keyword VALUES (107, 'Global');
INSERT INTO keyword VALUES (108, 'broadcast');
INSERT INTO keyword VALUES (109, 'breeding');
INSERT INTO keyword VALUES (110, 'roadside');
INSERT INTO keyword VALUES (111, 'Delaware');
INSERT INTO keyword VALUES (112, 'DataMIL');
INSERT INTO keyword VALUES (113, 'The National Map');
INSERT INTO keyword VALUES (114, 'framework');
INSERT INTO keyword VALUES (115, 'orthoimagery');
INSERT INTO keyword VALUES (116, 'orthophotography');
INSERT INTO keyword VALUES (117, 'aerial imagery');
INSERT INTO keyword VALUES (118, 'imagery');
INSERT INTO keyword VALUES (119, 'OGC');
INSERT INTO keyword VALUES (120, 'La Rioja');
INSERT INTO keyword VALUES (121, 'Cartografia');
INSERT INTO keyword VALUES (122, 'Mapas');
INSERT INTO keyword VALUES (123, 'TAT');
INSERT INTO keyword VALUES (124, 'Critical Habitat');
INSERT INTO keyword VALUES (125, 'NWI');
INSERT INTO keyword VALUES (126, 'seacoos');
INSERT INTO keyword VALUES (127, 'near real-time ocean data');
INSERT INTO keyword VALUES (128, 'merged observational data');
INSERT INTO keyword VALUES (129, 'merged models');
INSERT INTO keyword VALUES (130, 'southeastern united states');
INSERT INTO keyword VALUES (131, 'in-situ moored sensing');
INSERT INTO keyword VALUES (132, 'in-situ drifting sensing');
INSERT INTO keyword VALUES (133, 'coastal');
INSERT INTO keyword VALUES (134, 'offshore');
INSERT INTO keyword VALUES (135, 'remote sensing');
INSERT INTO keyword VALUES (136, 'satellites');
INSERT INTO keyword VALUES (137, 'aircraft');
INSERT INTO keyword VALUES (138, 'current');
INSERT INTO keyword VALUES (139, 'sea surface temperature');
INSERT INTO keyword VALUES (140, 'SST');
INSERT INTO keyword VALUES (141, 'wind speed and direction');
INSERT INTO keyword VALUES (142, 'RGB');
INSERT INTO keyword VALUES (143, 'true color');
INSERT INTO keyword VALUES (144, 'TBA');
INSERT INTO keyword VALUES (145, 'enhanced true color image');
INSERT INTO keyword VALUES (146, 'upper ocean waters');
INSERT INTO keyword VALUES (171, 'Testing');
INSERT INTO keyword VALUES (147, 'coastal zones');
INSERT INTO keyword VALUES (148, 'ocean color');
INSERT INTO keyword VALUES (149, 'MODerate Resolution Imaging Spectroradiometers');
INSERT INTO keyword VALUES (150, 'MODIS');
INSERT INTO keyword VALUES (151, 'NASA polar orbiting Terra and Aqua satellites');
INSERT INTO keyword VALUES (152, 'USF Institute for Marine Remote Sensing');
INSERT INTO keyword VALUES (153, 'imars');
INSERT INTO keyword VALUES (154, 'approximate true color');
INSERT INTO keyword VALUES (155, 'land areas');
INSERT INTO keyword VALUES (156, 'chesapeake bay');
INSERT INTO keyword VALUES (157, 'florida bay');
INSERT INTO keyword VALUES (158, 'miss plume');
INSERT INTO keyword VALUES (159, 'suwannee river');
INSERT INTO keyword VALUES (160, 'tampa bay');
INSERT INTO keyword VALUES (161, 'operational');
INSERT INTO keyword VALUES (162, 'cloud free');
INSERT INTO keyword VALUES (163, 'satellite SST');
INSERT INTO keyword VALUES (164, 'Optimal Interpolation');
INSERT INTO keyword VALUES (165, 'NOAA and NASA satellites');
INSERT INTO keyword VALUES (166, 'USF Ocean Circulation Group');
INSERT INTO keyword VALUES (168, 'AVHRR');
INSERT INTO keyword VALUES (169, 'Advanced Very High Resolution Radiometer');
INSERT INTO keyword VALUES (170, 'NOAA satellites');
INSERT INTO keyword VALUES (172, 'ICEDS');
INSERT INTO keyword VALUES (173, 'Texas');
INSERT INTO keyword VALUES (174, 'LANDSAT');
INSERT INTO keyword VALUES (175, 'Mesonet');
INSERT INTO keyword VALUES (176, 'SRTM');
INSERT INTO keyword VALUES (177, 'radar');
INSERT INTO keyword VALUES (178, 'GRID');
INSERT INTO keyword VALUES (179, 'LANDSAT 5');
INSERT INTO keyword VALUES (180, 'SRTM3');
INSERT INTO keyword VALUES (181, 'GSHHS');
INSERT INTO keyword VALUES (182, 'SRTM30');
INSERT INTO keyword VALUES (183, 'GTOPO30');
INSERT INTO keyword VALUES (184, 'USGS');
INSERT INTO keyword VALUES (185, 'DOQ');
INSERT INTO keyword VALUES (186, 'DRG');
INSERT INTO keyword VALUES (187, 'DNM');
INSERT INTO keyword VALUES (188, 'Topographic');
INSERT INTO keyword VALUES (189, 'GDI');
INSERT INTO keyword VALUES (190, 'UrbanArea');
INSERT INTO keyword VALUES (191, 'Urban Areas');
INSERT INTO keyword VALUES (192, 'Navigation');
INSERT INTO keyword VALUES (193, 'Brandenburg');
INSERT INTO keyword VALUES (194, 'Weather Maps');
INSERT INTO keyword VALUES (210, 'ALK');
INSERT INTO keyword VALUES (211, 'ZV-Aut');
INSERT INTO keyword VALUES (212, 'obak');
INSERT INTO keyword VALUES (213, 'Liegenschaftskarte');
INSERT INTO keyword VALUES (200, 'BLUE MARBLE');
INSERT INTO keyword VALUES (201, 'DMSP');
INSERT INTO keyword VALUES (202, 'NOAA');
INSERT INTO keyword VALUES (203, 'night lights');
INSERT INTO keyword VALUES (204, 'ASTER DEM footprints');
INSERT INTO keyword VALUES (205, 'water bodies');
INSERT INTO keyword VALUES (206, 'ASTER');
INSERT INTO keyword VALUES (207, 'Three Gorges');
INSERT INTO keyword VALUES (208, 'ECW');
INSERT INTO keyword VALUES (209, 'JPEG 2000');
INSERT INTO keyword VALUES (214, 'Kataster');
INSERT INTO keyword VALUES (215, 'Flurstueckssuche');
INSERT INTO keyword VALUES (216, 'Flurstueck');
INSERT INTO keyword VALUES (217, 'Flurstueckskennzeichen');
INSERT INTO keyword VALUES (218, 'Nations Europe');
INSERT INTO keyword VALUES (219, 'Onshore Geology Europe Geochronologic Age Lithology Metamorphism');
INSERT INTO keyword VALUES (220, 'Offshore Geology Europe Geochronologic Age Lithology Metamorphism');
INSERT INTO keyword VALUES (221, 'Geology Europe Ophiolite Complex');
INSERT INTO keyword VALUES (222, 'Onshore Geology Europe Magmatic');
INSERT INTO keyword VALUES (223, 'Offshore Geology Europe Magmatic');
INSERT INTO keyword VALUES (224, 'Geology Europe Onshore Metamorphism');
INSERT INTO keyword VALUES (225, 'Rivers Europe Topography');
INSERT INTO keyword VALUES (226, 'Canals Europe Topography');
INSERT INTO keyword VALUES (227, 'Geology Europe Lakes Topography');
INSERT INTO keyword VALUES (228, 'Geology Europe Boundaries Topography');
INSERT INTO keyword VALUES (229, 'Geology Europe Towns Topography');
INSERT INTO keyword VALUES (230, 'Geology Europe Capitals Topography');
INSERT INTO keyword VALUES (231, 'Geology Europe Coastline Topography');
INSERT INTO keyword VALUES (232, 'Geobasisdaten');
INSERT INTO keyword VALUES (233, 'Luftbild');
INSERT INTO keyword VALUES (234, 'Orthophoto');
INSERT INTO keyword VALUES (235, 'DOP');
INSERT INTO keyword VALUES (236, 'DOP40');
INSERT INTO keyword VALUES (237, 'DLM');
INSERT INTO keyword VALUES (238, 'osm basic');
INSERT INTO keyword VALUES (239, 'OpenStreetMap');
INSERT INTO keyword VALUES (240, 'Landwirtschaft');
INSERT INTO keyword VALUES (241, 'Bauernhof');
INSERT INTO keyword VALUES (242, 'OSM');
INSERT INTO keyword VALUES (243, 'Industrie');
INSERT INTO keyword VALUES (244, 'Industriegebiet');
INSERT INTO keyword VALUES (245, 'Bauland');
INSERT INTO keyword VALUES (246, 'Grünfläche');
INSERT INTO keyword VALUES (247, 'unkultiviertes Land');
INSERT INTO keyword VALUES (248, 'Unterholz');
INSERT INTO keyword VALUES (249, 'Busch');
INSERT INTO keyword VALUES (250, 'Park');
INSERT INTO keyword VALUES (251, 'Naherholungsgebiet');
INSERT INTO keyword VALUES (252, 'Wald/Forst');
INSERT INTO keyword VALUES (253, 'Wiese');
INSERT INTO keyword VALUES (254, 'Fußgängerzone');
INSERT INTO keyword VALUES (255, 'Strassen');
INSERT INTO keyword VALUES (256, 'Gebäude');
INSERT INTO keyword VALUES (257, 'Gewaesser');
INSERT INTO keyword VALUES (258, 'Flüße');
INSERT INTO keyword VALUES (259, 'Bach');
INSERT INTO keyword VALUES (260, 'Baeche');
INSERT INTO keyword VALUES (261, 'Kanal');
INSERT INTO keyword VALUES (262, 'Wasserbecken');
INSERT INTO keyword VALUES (263, 'Insel');
INSERT INTO keyword VALUES (264, 'Küste');
INSERT INTO keyword VALUES (265, 'Strand');
INSERT INTO keyword VALUES (266, 'Fußgängerwege');
INSERT INTO keyword VALUES (267, 'Radweg');
INSERT INTO keyword VALUES (268, 'Wege');
INSERT INTO keyword VALUES (269, 'Wohnstrasse');
INSERT INTO keyword VALUES (270, 'Zufahrtswege');
INSERT INTO keyword VALUES (271, 'einfache Strasse');
INSERT INTO keyword VALUES (272, 'Landstrasse');
INSERT INTO keyword VALUES (273, 'Bundesstrasse');
INSERT INTO keyword VALUES (274, 'Kraftfahrstrasse');
INSERT INTO keyword VALUES (275, 'Autobahn');
INSERT INTO keyword VALUES (276, 'Ortschaft');
INSERT INTO keyword VALUES (277, 'Orte');
INSERT INTO keyword VALUES (278, 'Weiler');
INSERT INTO keyword VALUES (279, 'Stadtteil');
INSERT INTO keyword VALUES (280, 'Dorf');
INSERT INTO keyword VALUES (281, 'Zug');
INSERT INTO keyword VALUES (282, 'Bahnhof');
INSERT INTO keyword VALUES (283, 'Flughafen');
INSERT INTO keyword VALUES (284, 'Kirche');
INSERT INTO keyword VALUES (285, 'Friedhof');
INSERT INTO keyword VALUES (286, 'Gräber');
INSERT INTO keyword VALUES (287, 'Copyright');
INSERT INTO keyword VALUES (288, 'Lizenz');
INSERT INTO keyword VALUES (289, 'Straßenkarte');
INSERT INTO keyword VALUES (290, 'MapServer');
INSERT INTO keyword VALUES (291, 'OSGeo');
INSERT INTO keyword VALUES (292, 'UBA');
INSERT INTO keyword VALUES (293, 'BLE');
INSERT INTO keyword VALUES (294, 'Flaechen OSM');
INSERT INTO keyword VALUES (295, 'Luftbilder');
INSERT INTO keyword VALUES (296, 'Orthophotos');
INSERT INTO keyword VALUES (297, 'Stadtgrundkarte');
INSERT INTO keyword VALUES (298, 'Flächennutzungsplan');
INSERT INTO keyword VALUES (299, 'Bebauungsplan');
INSERT INTO keyword VALUES (300, 'Sanierungsgebiet');
INSERT INTO keyword VALUES (301, 'Bodenrichtwert');
INSERT INTO keyword VALUES (302, 'Mobilfunkantenne');
INSERT INTO keyword VALUES (303, 'Windenergieanlage');
INSERT INTO keyword VALUES (304, 'Sehenswürdigkeit');
INSERT INTO keyword VALUES (305, 'Hotel');
INSERT INTO keyword VALUES (306, 'Pension');
INSERT INTO keyword VALUES (307, 'Herberge');
INSERT INTO keyword VALUES (308, 'Museum');
INSERT INTO keyword VALUES (309, 'Galerie');
INSERT INTO keyword VALUES (310, 'Touristeninformation');
INSERT INTO keyword VALUES (311, 'Toilette');
INSERT INTO keyword VALUES (312, 'Brunnen');
INSERT INTO keyword VALUES (313, 'Denkmal');
INSERT INTO keyword VALUES (314, 'Kunstwerk');
INSERT INTO keyword VALUES (315, 'Naturdenkmal');
INSERT INTO keyword VALUES (316, 'Webcam');
INSERT INTO keyword VALUES (317, 'Jakobsweg');
INSERT INTO keyword VALUES (318, 'ALKIS');
INSERT INTO keyword VALUES (319, 'Flurstück');
INSERT INTO keyword VALUES (320, 'NAS');
INSERT INTO keyword VALUES (321, 'Katasteramt');
INSERT INTO keyword VALUES (322, 'Quellenangabe');
INSERT INTO keyword VALUES (323, '');
INSERT INTO keyword VALUES (324, 'infoMapAccessService');
INSERT INTO keyword VALUES (325, 'wald');
INSERT INTO keyword VALUES (326, 'GEOSERVER');
INSERT INTO keyword VALUES (327, 'Wahllokal');
INSERT INTO keyword VALUES (328, 'Wahlbezirk');
INSERT INTO keyword VALUES (329, 'Baudenkmal');
INSERT INTO keyword VALUES (330, 'Camping');
INSERT INTO keyword VALUES (331, 'Kunst im öffentlichen Raum');
INSERT INTO keyword VALUES (332, 'Behörde');
INSERT INTO keyword VALUES (333, 'Ortsamtsbereich');
INSERT INTO keyword VALUES (334, 'Ortsteil');
INSERT INTO keyword VALUES (335, 'Polizeidienststelle');
INSERT INTO keyword VALUES (336, 'Verwaltungsstandort');
INSERT INTO keyword VALUES (337, 'Wikipedia-Verweis');
INSERT INTO keyword VALUES (338, 'Begegnungszentrum');
INSERT INTO keyword VALUES (339, 'Behinderteneinrichtung');
INSERT INTO keyword VALUES (340, 'Hospiz');
INSERT INTO keyword VALUES (341, 'Kinder- und Jugendarbeit');
INSERT INTO keyword VALUES (342, 'Kinder- und Jugendhilfe');
INSERT INTO keyword VALUES (343, 'Kindertagesstätte');
INSERT INTO keyword VALUES (344, 'Pflegeeinrichtung');
INSERT INTO keyword VALUES (345, 'Psychiatrische Pflegeeinrichtung');
INSERT INTO keyword VALUES (346, 'Schule');
INSERT INTO keyword VALUES (347, 'Tagesmutter/-vater');
INSERT INTO keyword VALUES (348, 'Tagespflegeeinrichtung');
INSERT INTO keyword VALUES (349, 'Universität');
INSERT INTO keyword VALUES (350, 'Wissenschaftliche Einrichtung');
INSERT INTO keyword VALUES (351, 'Solarpotential (Photovoltaik)');
INSERT INTO keyword VALUES (352, 'Solarpotential (Solarthermie)');
INSERT INTO keyword VALUES (353, 'Apotheke');
INSERT INTO keyword VALUES (354, 'Ärztehaus');
INSERT INTO keyword VALUES (355, 'Klinik');
INSERT INTO keyword VALUES (356, 'Ballspielanlage');
INSERT INTO keyword VALUES (357, 'Bibliothek');
INSERT INTO keyword VALUES (358, 'Gerätespielanlage');
INSERT INTO keyword VALUES (359, 'Jugendtreff');
INSERT INTO keyword VALUES (360, 'Kino');
INSERT INTO keyword VALUES (361, 'Musikclub');
INSERT INTO keyword VALUES (362, 'Musikschule');
INSERT INTO keyword VALUES (363, 'Skateanlage');
INSERT INTO keyword VALUES (364, 'Sonderform');
INSERT INTO keyword VALUES (365, 'Sportanlage');
INSERT INTO keyword VALUES (366, 'Sporthalle');
INSERT INTO keyword VALUES (367, 'Tanzschule');
INSERT INTO keyword VALUES (368, 'Theater');
INSERT INTO keyword VALUES (369, 'Verein');
INSERT INTO keyword VALUES (370, 'Aussichtspunkt');
INSERT INTO keyword VALUES (371, 'Forsthaus');
INSERT INTO keyword VALUES (372, 'Lehrpfad');
INSERT INTO keyword VALUES (373, 'Parkplatz');
INSERT INTO keyword VALUES (374, 'Reitweg');
INSERT INTO keyword VALUES (375, 'Wanderweg');
INSERT INTO keyword VALUES (376, 'Altkleidercontainer');
INSERT INTO keyword VALUES (377, 'Glascontainer');
INSERT INTO keyword VALUES (378, 'Kleingartenanlage');
INSERT INTO keyword VALUES (379, 'Papiercontainer');
INSERT INTO keyword VALUES (380, 'Parkanlage');
INSERT INTO keyword VALUES (381, 'Recyclinghof');
INSERT INTO keyword VALUES (382, 'barrierefreie Toilette');
INSERT INTO keyword VALUES (383, 'Baustelle');
INSERT INTO keyword VALUES (384, 'Fähre');
INSERT INTO keyword VALUES (385, 'Parkhaus');
INSERT INTO keyword VALUES (386, 'Radfahrspur');
INSERT INTO keyword VALUES (387, 'Radfernweg');
INSERT INTO keyword VALUES (388, 'Regionalbahn');
INSERT INTO keyword VALUES (389, 'Regionalbus');
INSERT INTO keyword VALUES (390, 'Reisebusparkplatz');
INSERT INTO keyword VALUES (391, 'Reisebusterminal');
INSERT INTO keyword VALUES (392, 'S-Bahn');
INSERT INTO keyword VALUES (393, 'Stadtbus');
INSERT INTO keyword VALUES (394, 'Stadtbusverkehr');
INSERT INTO keyword VALUES (395, 'Tankstelle');
INSERT INTO keyword VALUES (396, 'Tiefgarage');
INSERT INTO keyword VALUES (397, 'Tram');
INSERT INTO keyword VALUES (398, 'Tramverkehr');
INSERT INTO keyword VALUES (399, 'verkehrsberuhigte Straße');
INSERT INTO keyword VALUES (400, 'verkehrsreiche Straße ohne Radweg');
INSERT INTO keyword VALUES (401, 'Verkehrszeichen');
INSERT INTO keyword VALUES (402, 'Hintergrund');
INSERT INTO keyword VALUES (403, 'Topographische Karte');
INSERT INTO keyword VALUES (404, 'Übersichtskarte');
INSERT INTO keyword VALUES (405, 'DTK');
INSERT INTO keyword VALUES (406, 'TK');


--
-- TOC entry 4416 (class 0 OID 18353)
-- Dependencies: 204
-- Data for Name: layer; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO layer VALUES (20530, 957, 0, '', 'Luftbild', 'Luftbild', 0, 0, 0, NULL, NULL, 'Luftbild der Hansestadt Rostock und Umgebung', 1, 'cf9280b2-7334-53ed-de09-2708a76ca7be');
INSERT INTO layer VALUES (20524, 957, 1, '0', 'luftbild', 'Luftbild', 0, 0, 0, NULL, NULL, NULL, 1, 'bd22a298-ac94-a732-f994-2d0c719184e4');
INSERT INTO layer VALUES (20531, 942, 0, '', 'Stadtplan', 'Stadtplan', 0, 0, 0, NULL, NULL, 'Stadtplandienst für Mecklenburg-Vorpommern auf Basis von amtlichen und OpenStreetMap-Daten', 1, 'b2cf6421-bc39-42f5-5e58-3178a757f7a7');
INSERT INTO layer VALUES (20528, 942, 1, '0', 'stadtplan', 'Stadtplan', 0, 0, 0, NULL, NULL, NULL, 1, 'd780f077-4f06-8f3b-67dc-bc3d7d3baa9f');
INSERT INTO layer VALUES (20529, 942, 2, '0', 'stadtplan_notext', 'Stadtplan (ohne Beschriftung)', 0, 0, 0, NULL, NULL, NULL, 1, '751eb5a4-2794-2faf-1943-0fd4d38b617d');


--
-- TOC entry 4417 (class 0 OID 18368)
-- Dependencies: 205
-- Data for Name: layer_custom_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4418 (class 0 OID 18371)
-- Dependencies: 206
-- Data for Name: layer_epsg; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO layer_epsg VALUES (20530, 'EPSG:4326', 10.3394197138999999, 52.9854108366000034, 14.7015062580000002, 54.821744089100001);
INSERT INTO layer_epsg VALUES (20530, 'EPSG:900913', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20530, 'EPSG:3857', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20530, 'EPSG:2398', 4388606.16021442041, 5874435.34058917966, 4673752.11627614964, 6080882.41046546027);
INSERT INTO layer_epsg VALUES (20530, 'EPSG:25833', 187216.292681551015, 5880815.06169820018, 480821.264967644005, 6074996.42796261981);
INSERT INTO layer_epsg VALUES (20524, 'EPSG:4326', 10.3394197138999999, 52.9854108366000034, 14.7015062580000002, 54.821744089100001);
INSERT INTO layer_epsg VALUES (20524, 'EPSG:900913', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20524, 'EPSG:3857', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20524, 'EPSG:2398', 4388606.16021442041, 5874435.34058917966, 4673752.11627614964, 6080882.41046546027);
INSERT INTO layer_epsg VALUES (20524, 'EPSG:25833', 187216.292681551015, 5880815.06169820018, 480821.264967644005, 6074996.42796261981);
INSERT INTO layer_epsg VALUES (20531, 'EPSG:4326', 10.3394197138999999, 52.9854108366000034, 14.7015062580000002, 54.821744089100001);
INSERT INTO layer_epsg VALUES (20531, 'EPSG:900913', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20531, 'EPSG:3857', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20531, 'EPSG:2398', 4388606.16021442041, 5874435.34058917966, 4673752.11627614964, 6080882.41046546027);
INSERT INTO layer_epsg VALUES (20531, 'EPSG:25833', 187216.292681551015, 5880815.06169820018, 480821.264967644005, 6074996.42796261981);
INSERT INTO layer_epsg VALUES (20528, 'EPSG:4326', 10.3394197138999999, 52.9854108366000034, 14.7015062580000002, 54.821744089100001);
INSERT INTO layer_epsg VALUES (20528, 'EPSG:900913', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20528, 'EPSG:3857', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20528, 'EPSG:25833', 200000, 5880000, 480000, 6075000);
INSERT INTO layer_epsg VALUES (20528, 'EPSG:2398', 4388606.16021442041, 5874435.34058917966, 4673752.11627614964, 6080882.41046546027);
INSERT INTO layer_epsg VALUES (20529, 'EPSG:4326', 10.3394197138999999, 52.9854108366000034, 14.7015062580000002, 54.821744089100001);
INSERT INTO layer_epsg VALUES (20529, 'EPSG:900913', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20529, 'EPSG:3857', 1150978.93764999998, 6980299.7758200001, 1636564.1905400001, 7327346.85094000027);
INSERT INTO layer_epsg VALUES (20529, 'EPSG:25833', 200000, 5880000, 480000, 6075000);
INSERT INTO layer_epsg VALUES (20529, 'EPSG:2398', 4388606.16021442041, 5874435.34058917966, 4673752.11627614964, 6080882.41046546027);


--
-- TOC entry 4419 (class 0 OID 18380)
-- Dependencies: 207
-- Data for Name: layer_inspire_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4420 (class 0 OID 18383)
-- Dependencies: 208
-- Data for Name: layer_keyword; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4421 (class 0 OID 18388)
-- Dependencies: 210
-- Data for Name: layer_load_count; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4422 (class 0 OID 18391)
-- Dependencies: 211
-- Data for Name: layer_md_topic_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4423 (class 0 OID 18394)
-- Dependencies: 212
-- Data for Name: layer_preview; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4424 (class 0 OID 18397)
-- Dependencies: 213
-- Data for Name: layer_style; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4425 (class 0 OID 18403)
-- Dependencies: 214
-- Data for Name: mb_group; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4426 (class 0 OID 18423)
-- Dependencies: 216
-- Data for Name: mb_log; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4427 (class 0 OID 18432)
-- Dependencies: 218
-- Data for Name: mb_metadata; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO mb_metadata VALUES (1, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:27.886635', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (2, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:27.938039', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (3, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:27.987954', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (4, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.038902', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (5, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.09321', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (6, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.145805', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (7, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.198871', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (8, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.252841', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (9, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.305539', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (10, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.357941', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (11, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.407025', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mb_metadata VALUES (12, NULL, 'capabilities', true, NULL, NULL, NULL, '2011-08-24 10:53:28.455723', NULL, 'http://www.mapbender.de/', 'TC211', 'text/html', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4428 (class 0 OID 18447)
-- Dependencies: 220
-- Data for Name: mb_monitor; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4429 (class 0 OID 18459)
-- Dependencies: 221
-- Data for Name: mb_proxy_log; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4430 (class 0 OID 18466)
-- Dependencies: 222
-- Data for Name: mb_role; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO mb_role VALUES (1, 'standard role', 'No special role - old behaviour.', 0);
INSERT INTO mb_role VALUES (2, 'primary', 'Primary group for a mapbender user.', 0);
INSERT INTO mb_role VALUES (3, 'metadata editor', 'Group for which the user can edit and publish metadata.', 1);
INSERT INTO mb_role VALUES (4, 'standard role', 'No special role - old behaviour.', 0);
INSERT INTO mb_role VALUES (5, 'primary', 'Primary group for a mapbender user.', 0);
INSERT INTO mb_role VALUES (6, 'metadata editor', 'Group for which the user can edit and publish metadata.', 1);


--
-- TOC entry 4431 (class 0 OID 18472)
-- Dependencies: 224
-- Data for Name: mb_user; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO mb_user VALUES (7, 'public', '4c9184f37cff01bcdc32dc486ec36961', 1, 'anonymer User', 0, NULL, NULL, NULL, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', '', '');
INSERT INTO mb_user VALUES (1, 'admin', '999b1e180b439db5a80692ba9f3d58e8', 1, 'Administrator', 0, NULL, NULL, NULL, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', '', '');


--
-- TOC entry 4432 (class 0 OID 18486)
-- Dependencies: 225
-- Data for Name: mb_user_abo_ows; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4433 (class 0 OID 18489)
-- Dependencies: 226
-- Data for Name: mb_user_mb_group; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4434 (class 0 OID 18499)
-- Dependencies: 229
-- Data for Name: mb_user_wmc; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4435 (class 0 OID 18513)
-- Dependencies: 230
-- Data for Name: mb_wms_availability; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4436 (class 0 OID 18520)
-- Dependencies: 231
-- Data for Name: md_topic_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO md_topic_category VALUES (1, 'farming', 'Landwirtschaft');
INSERT INTO md_topic_category VALUES (2, 'biota', 'Biotope');
INSERT INTO md_topic_category VALUES (3, 'boundaries', 'Grenzen');
INSERT INTO md_topic_category VALUES (4, 'climatologyMeteorologyAtmosphere', 'Wetterkunde');
INSERT INTO md_topic_category VALUES (5, 'economy', 'Wirtschaft');
INSERT INTO md_topic_category VALUES (6, 'elevation', 'Hoehendaten');
INSERT INTO md_topic_category VALUES (7, 'environment', 'Umwelt');
INSERT INTO md_topic_category VALUES (8, 'geoscientificInformation', 'Geowissenschaft');
INSERT INTO md_topic_category VALUES (9, 'health', 'Gesundheit');
INSERT INTO md_topic_category VALUES (10, 'imageryBaseMapsEarthCover', 'Grundlagenkarten');
INSERT INTO md_topic_category VALUES (11, 'intelligenceMilitary', 'militärische Aufklärung');
INSERT INTO md_topic_category VALUES (12, 'inlandWaters', 'Binnengewässer');
INSERT INTO md_topic_category VALUES (13, 'location', 'Ortsinformationen');
INSERT INTO md_topic_category VALUES (14, 'oceans', 'Meereskunde');
INSERT INTO md_topic_category VALUES (15, 'planningCadastre', 'Landnutzung/Planung/Kataster');
INSERT INTO md_topic_category VALUES (16, 'society', 'Gesellschaft');
INSERT INTO md_topic_category VALUES (17, 'structure', 'Bauwerke');
INSERT INTO md_topic_category VALUES (18, 'transportation', 'Transportwesen');
INSERT INTO md_topic_category VALUES (19, 'utilitiesCommunication', 'Infrastruktur');


--
-- TOC entry 4437 (class 0 OID 18528)
-- Dependencies: 233
-- Data for Name: ows_relation_metadata; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4438 (class 0 OID 18535)
-- Dependencies: 235
-- Data for Name: sld_user_layer; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4439 (class 0 OID 18543)
-- Dependencies: 237
-- Data for Name: spec; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO spec VALUES (1, 'ir_interop', 'INSPIRE Implementing rules laying down technical arrangements', NULL, NULL, 'http://www.geoportal.rlp.de/', NULL, NULL, 'INSPIRE Implementing rules laying down technical arrangements for the interoperability and harmonisation of orthoimagery', NULL, NULL, 'inspire', 1305410400);
INSERT INTO spec VALUES (2, 'ir_interop', 'INSPIRE Implementing rules laying down technical arrangements', NULL, NULL, 'http://www.geoportal.rlp.de/', NULL, NULL, 'INSPIRE Implementing rules laying down technical arrangements for the interoperability and harmonisation of orthoimagery', NULL, NULL, 'inspire', 1305410400);


--
-- TOC entry 4440 (class 0 OID 18549)
-- Dependencies: 238
-- Data for Name: spec_classification; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO spec_classification VALUES (1, 'inspire', 'INSPIRE', NULL, NULL, NULL, 'Klasse der Inspire Spezifikationen/Regulations', NULL, NULL);


--
-- TOC entry 4441 (class 0 OID 18559)
-- Dependencies: 241
-- Data for Name: termsofuse; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO termsofuse VALUES (1, 'CC by-nc-nd', 'http://i.creativecommons.org/l/by-nc-nd/3.0/de/88x31.png', 'Creative Commons: Namensnennung - Keine kommerzielle Nutzung - Keine Bearbeitungen 3.0 Deutschland', 'http://creativecommons.org/licenses/by-nc-nd/3.0/de/');


--
-- TOC entry 4442 (class 0 OID 18565)
-- Dependencies: 242
-- Data for Name: translations; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO translations VALUES (1, 'de', 'Pan', 'Ausschnitt verschieben');
INSERT INTO translations VALUES (2, 'de', 'Display complete map', 'gesamte Karte anzeigen');
INSERT INTO translations VALUES (3, 'de', 'Zoom in', 'In die Karte hineinzoomen');
INSERT INTO translations VALUES (4, 'de', 'Zoom out', 'Aus der Karte herauszoomen');
INSERT INTO translations VALUES (5, 'de', 'Back', 'Zurück');
INSERT INTO translations VALUES (6, 'de', 'Forward', 'Nach vorne');
INSERT INTO translations VALUES (7, 'de', 'Coordinates', 'Koordinaten anzeigen');
INSERT INTO translations VALUES (8, 'de', 'Zoom by rectangle', 'Ausschnitt wählen');
INSERT INTO translations VALUES (9, 'de', 'Redraw', 'Neu laden oder Tastatur: Leertaste');
INSERT INTO translations VALUES (10, 'de', 'Query', 'Datenabfrage');
INSERT INTO translations VALUES (11, 'de', 'Logout', 'Abmelden');
INSERT INTO translations VALUES (12, 'de', 'WMS preferences', 'WMS Einstellungen');
INSERT INTO translations VALUES (13, 'de', 'Adding WMS from filtered list', 'WMS von gefilteter Liste hinzufügen');
INSERT INTO translations VALUES (14, 'de', 'Set map center', 'Kartenmittelpunkt setzen');
INSERT INTO translations VALUES (15, 'de', 'Help', 'Hilfe');
INSERT INTO translations VALUES (16, 'de', 'Show WMS infos', 'Anzeige von WMS Informationen');
INSERT INTO translations VALUES (17, 'de', 'Save workspace as web map context document', 'Ansicht als Web Map Context Dokument speichern');
INSERT INTO translations VALUES (18, 'de', 'Resize Mapsize', 'Bildschirmgröße anpassen');
INSERT INTO translations VALUES (19, 'de', 'Rubber', 'Skizze löschen');
INSERT INTO translations VALUES (20, 'de', 'Get Area', 'Fläche berechnen');
INSERT INTO translations VALUES (21, 'de', 'Close Polygon', 'Polygon schliessen');
INSERT INTO translations VALUES (22, 'de', 'Move back to your GUI list', 'Zurück zur GUI Liste');
INSERT INTO translations VALUES (23, 'de', 'Legend', 'Legende');
INSERT INTO translations VALUES (24, 'de', 'Print', 'Druck');
INSERT INTO translations VALUES (25, 'de', 'Imprint', 'Impressum');
INSERT INTO translations VALUES (26, 'de', 'Maps', 'Karten');
INSERT INTO translations VALUES (27, 'de', 'Search', 'Suche');
INSERT INTO translations VALUES (28, 'de', 'Meetingpoint', 'Treffpunkt');
INSERT INTO translations VALUES (29, 'de', 'Metadatasearch', 'Metadatensuche');
INSERT INTO translations VALUES (30, 'de', 'Adding WMS', 'WMS hinzufügen');
INSERT INTO translations VALUES (31, 'de', 'Adding WMS from List', 'WMS aus Liste hinzufügen');
INSERT INTO translations VALUES (32, 'de', 'Info', 'Info');
INSERT INTO translations VALUES (33, 'de', 'Change Projection', 'Projektion ändern');
INSERT INTO translations VALUES (34, 'de', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (35, 'de', 'Digitize', 'Digitalisierung');
INSERT INTO translations VALUES (36, 'de', 'Overview', 'Übersichtskarte');
INSERT INTO translations VALUES (37, 'de', 'Drag Mapsize', 'Karte vergrößern');
INSERT INTO translations VALUES (38, 'de', 'Mapframe', 'Kartenfenster');
INSERT INTO translations VALUES (39, 'de', 'Navigation Frame', 'Navigationsfenster');
INSERT INTO translations VALUES (40, 'de', 'Scale Select', 'Auswahl des Maßstabes');
INSERT INTO translations VALUES (41, 'de', 'Scale Text', 'Maßstab per Texteingabe');
INSERT INTO translations VALUES (42, 'de', 'Scalebar', 'Maßstabsleiste');
INSERT INTO translations VALUES (43, 'de', 'Set Background', 'Hintegrundkarte auswählen');
INSERT INTO translations VALUES (44, 'de', 'Zoom to Coordinates', 'Zu den Koordinaten zoomen');
INSERT INTO translations VALUES (45, 'de', 'Change Password', 'Passwort ändern');
INSERT INTO translations VALUES (46, 'de', 'Load a web map context document', 'laden eines Web Map Context Dokumentes');
INSERT INTO translations VALUES (47, 'de', 'Logo', 'Logo');
INSERT INTO translations VALUES (48, 'bg', 'Pan', 'Премести областта');
INSERT INTO translations VALUES (49, 'bg', 'Display complete map', 'Покажи цялата карта');
INSERT INTO translations VALUES (50, 'bg', 'Zoom in', 'Покажи картата в по-едър мащаб');
INSERT INTO translations VALUES (51, 'bg', 'Zoom out', 'Покажи картата в по-дребен мащаб');
INSERT INTO translations VALUES (52, 'bg', 'Back', 'Назад');
INSERT INTO translations VALUES (53, 'bg', 'Forward', 'Напред');
INSERT INTO translations VALUES (54, 'bg', 'Coordinates', 'Координати');
INSERT INTO translations VALUES (55, 'bg', 'Zoom by rectangle', 'Увеличи картата в избраната област');
INSERT INTO translations VALUES (56, 'bg', 'Redraw', 'Пречертай или от клавиатурата: празен интервал');
INSERT INTO translations VALUES (57, 'bg', 'Query', 'Зявка към данните');
INSERT INTO translations VALUES (58, 'bg', 'Logout', 'Изход на потребител');
INSERT INTO translations VALUES (59, 'bg', 'WMS preferences', 'WMS настройки');
INSERT INTO translations VALUES (60, 'bg', 'Adding WMS from filtered list', 'Добави WMS от избран списък');
INSERT INTO translations VALUES (61, 'bg', 'Set map center', 'Постави център на карта');
INSERT INTO translations VALUES (62, 'bg', 'Help', 'Помощ');
INSERT INTO translations VALUES (63, 'bg', 'Show WMS infos', 'Покажи WMS информация');
INSERT INTO translations VALUES (64, 'bg', 'Save workspace as web map context document', 'Запази работния документ като Web Map Context документ');
INSERT INTO translations VALUES (65, 'bg', 'Resize Mapsize', 'Напасни големината на картата');
INSERT INTO translations VALUES (66, 'bg', 'Rubber', 'Изтрий');
INSERT INTO translations VALUES (67, 'bg', 'Get Area', 'Изчисли площ');
INSERT INTO translations VALUES (68, 'bg', 'Close Polygon', 'Затвори полигон');
INSERT INTO translations VALUES (69, 'bg', 'Move back to your GUI list', 'Назад към списъка с интерфейси (GUI)');
INSERT INTO translations VALUES (70, 'bg', 'Legend', 'Легенда');
INSERT INTO translations VALUES (71, 'bg', 'Print', 'Печат');
INSERT INTO translations VALUES (72, 'bg', 'Imprint', 'Авторско каре');
INSERT INTO translations VALUES (73, 'bg', 'Maps', 'Карти');
INSERT INTO translations VALUES (74, 'bg', 'Search', 'Търсене');
INSERT INTO translations VALUES (75, 'bg', 'Meetingpoint', 'Място на среща');
INSERT INTO translations VALUES (76, 'bg', 'Metadatasearch', 'Търсене по метаданни');
INSERT INTO translations VALUES (77, 'bg', 'Adding WMS', 'Добави WMS');
INSERT INTO translations VALUES (78, 'bg', 'Adding WMS from List', 'Добави WMS от списък');
INSERT INTO translations VALUES (79, 'bg', 'Info', 'Информация');
INSERT INTO translations VALUES (80, 'bg', 'Change Projection', 'Промени проекция');
INSERT INTO translations VALUES (81, 'bg', 'Copyright', 'Авторско право');
INSERT INTO translations VALUES (82, 'bg', 'Digitize', 'Дигитализиране');
INSERT INTO translations VALUES (83, 'bg', 'Overview', 'Обзорна карта');
INSERT INTO translations VALUES (84, 'bg', 'Drag Mapsize', 'Промени размера на картата');
INSERT INTO translations VALUES (85, 'bg', 'Mapframe', 'Рамка на картата');
INSERT INTO translations VALUES (86, 'bg', 'Navigation Frame', 'Навигационна рамка');
INSERT INTO translations VALUES (87, 'bg', 'Scale Select', 'Избор на мащаб');
INSERT INTO translations VALUES (88, 'bg', 'Scale Text', 'Въведи мащаб');
INSERT INTO translations VALUES (89, 'bg', 'Scalebar', 'Мащабна скала');
INSERT INTO translations VALUES (90, 'bg', 'Set Background', 'Избери фоново изображение');
INSERT INTO translations VALUES (91, 'bg', 'Zoom to Coordinates', 'Покажи картата около посочените координати');
INSERT INTO translations VALUES (92, 'bg', 'Change Password', 'Промени парола');
INSERT INTO translations VALUES (93, 'bg', 'Load a web map context document', 'Зареди Web Map Context документ');
INSERT INTO translations VALUES (94, 'bg', 'Logo', 'Фирмен знак');
INSERT INTO translations VALUES (95, 'bg', 'Measure distance', 'Измери разстояние');
INSERT INTO translations VALUES (96, 'gr', 'Pan', 'Μετακίνηση');
INSERT INTO translations VALUES (97, 'gr', 'Display complete map', 'Επίδειξη Πλήρους Χάρτη');
INSERT INTO translations VALUES (98, 'gr', 'Zoom in', 'Zoom In');
INSERT INTO translations VALUES (99, 'gr', 'Zoom out', 'Zoom Out');
INSERT INTO translations VALUES (100, 'gr', 'Back', 'Πίσω');
INSERT INTO translations VALUES (101, 'gr', 'Forward', 'Πρόσθια');
INSERT INTO translations VALUES (102, 'gr', 'Coordinates', 'Συντεταγμένες');
INSERT INTO translations VALUES (103, 'gr', 'Zoom by rectangle', 'Ζουμ από ορθογώνιο');
INSERT INTO translations VALUES (104, 'gr', 'Redraw', 'Απόσυρση');
INSERT INTO translations VALUES (105, 'gr', 'Query', 'Μέτρηση Εμβαδού');
INSERT INTO translations VALUES (106, 'gr', 'Logout', 'Αποσύνδεση');
INSERT INTO translations VALUES (107, 'gr', 'WMS preferences', 'Αλλάξτε τη διάταξη των WMS');
INSERT INTO translations VALUES (108, 'gr', 'Adding WMS from filtered list', 'Πρόσθεση WMS από το φιλτραρισμένο κατάλογο');
INSERT INTO translations VALUES (109, 'gr', 'Set map center', 'Το καθορισμένο Κέντρο Χαρτών');
INSERT INTO translations VALUES (110, 'gr', 'Help', 'Βοήθεια');
INSERT INTO translations VALUES (112, 'gr', 'Rubber', 'Το λάστιχο- Τρίφτης');
INSERT INTO translations VALUES (113, 'gr', 'Close Polygon', 'Το Κλειστό Πολύγωνο');
INSERT INTO translations VALUES (114, 'gr', 'Move back to your GUI list', 'Παρουσίαση του GUI Καταλόγου');
INSERT INTO translations VALUES (115, 'gr', 'Print', 'Εκτύπωση');
INSERT INTO translations VALUES (116, 'gr', 'Maps', ' Χάρτες');
INSERT INTO translations VALUES (117, 'gr', 'Adding WMS', 'Πρόσθεση WMS');
INSERT INTO translations VALUES (118, 'gr', 'Adding WMS from List', 'Πρόσθεση WMS από τον κατάλογο');
INSERT INTO translations VALUES (119, 'gr', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (122, 'gr', 'Measure distance', 'Μέτρηση Απόστασης');
INSERT INTO translations VALUES (123, 'gr', 'Meetingpoint', 'Σημείο Συνάντησης');
INSERT INTO translations VALUES (124, 'gr', 'Info', 'Πληροφορίες');
INSERT INTO translations VALUES (125, 'gr', 'Digitize', 'Ψηφιοποίηση');
INSERT INTO translations VALUES (126, 'gr', 'Change Projection', 'Αλλαγή Προβολής');
INSERT INTO translations VALUES (127, 'gr', 'Set Background', 'Επιλογή Φόντου');
INSERT INTO translations VALUES (128, 'gr', 'Overview', 'Προεπισκόπιση');
INSERT INTO translations VALUES (129, 'gr', 'Change Password', 'Αλλαγή Συνθηματικού');
INSERT INTO translations VALUES (130, 'gr', 'Scalebar', 'Κανόνας Κλίμακας');
INSERT INTO translations VALUES (131, 'gr ', 'Logo', 'Λογότυπο');
INSERT INTO translations VALUES (132, 'gr', 'Zoom to Coordinates', 'Εστίαση σε Συντεταγμένες');
INSERT INTO translations VALUES (133, 'gr', 'Scale Text', 'Κείμενο Κλίμακας');
INSERT INTO translations VALUES (134, 'gr', 'Show WMS infos', 'Προβολή WMS πληροφοριών');
INSERT INTO translations VALUES (135, 'gr', 'Legend', 'Λεζάντα');
INSERT INTO translations VALUES (136, 'gr', 'Search', 'Αναζήτηση');
INSERT INTO translations VALUES (137, 'gr', 'Resize Mapsize', 'Αλλαγή Μεγέθους Χάρτη');
INSERT INTO translations VALUES (138, 'gr', 'Drag Mapsize', 'Αλλαγή Μεγέθους Χάρτη με Ολίσθηση');
INSERT INTO translations VALUES (139, 'gr', 'Mapframe', 'Πλαίσιο Χάρτη');
INSERT INTO translations VALUES (140, 'gr', 'Get Area', 'Προβολή Περιοχής');
INSERT INTO translations VALUES (141, 'gr', 'Imprint', 'Αποτύπωση');
INSERT INTO translations VALUES (142, 'gr', 'Scale Select', 'Επιλογή Κλίμακας');
INSERT INTO translations VALUES (143, 'gr', 'Metadatasearch', 'Αναζήτηση στα Metadata');
INSERT INTO translations VALUES (144, 'nl', 'Pan', 'Selectie verschuiven');
INSERT INTO translations VALUES (145, 'nl', 'Display complete map', 'Hele kaart tonen');
INSERT INTO translations VALUES (146, 'nl', 'Zoom in', 'Inzoomen');
INSERT INTO translations VALUES (147, 'nl', 'Zoom out', 'Uitzoomen');
INSERT INTO translations VALUES (148, 'nl', 'Back', 'Terug');
INSERT INTO translations VALUES (149, 'nl', 'Forward', 'Voorwaarts');
INSERT INTO translations VALUES (150, 'nl', 'Coordinates', 'Koordinaten tonen');
INSERT INTO translations VALUES (151, 'nl', 'Zoom by rectangle', 'Zoom rechthoek-selectie');
INSERT INTO translations VALUES (152, 'nl', 'Redraw', 'Opfrissen of toetsenbord : spatiebalk');
INSERT INTO translations VALUES (153, 'nl', 'Query', 'Data opvragen');
INSERT INTO translations VALUES (154, 'nl', 'Logout', 'Afmelden');
INSERT INTO translations VALUES (155, 'nl', 'WMS preferences', 'WMS instellingen');
INSERT INTO translations VALUES (156, 'nl', 'Adding WMS from filtered list', 'WMS van gefilterte lijst toevoegen');
INSERT INTO translations VALUES (157, 'nl', 'Set map center', 'Kaartmiddelpunt aangeven');
INSERT INTO translations VALUES (158, 'nl', 'Help', 'Help');
INSERT INTO translations VALUES (159, 'nl', 'Show WMS infos', 'Tonen van WMS Informatie');
INSERT INTO translations VALUES (160, 'nl', 'Save workspace as web map context document', 'zicht als Web map context dokument bewaren');
INSERT INTO translations VALUES (161, 'nl', 'Resize Mapsize', 'beeldschermgrote aanpassen');
INSERT INTO translations VALUES (162, 'nl', 'Rubber', 'schets verwerpen');
INSERT INTO translations VALUES (163, 'nl', 'Get Area', 'oppervlakte berekenen');
INSERT INTO translations VALUES (164, 'nl', 'Close Polygon', 'Polygoon sluiten');
INSERT INTO translations VALUES (165, 'nl', 'Move back to your GUI list', 'Terug naar GUI lijst');
INSERT INTO translations VALUES (166, 'nl', 'Legend', 'Legende');
INSERT INTO translations VALUES (167, 'nl', 'Print', 'Drukken');
INSERT INTO translations VALUES (168, 'nl', 'Imprint', 'Impressum');
INSERT INTO translations VALUES (169, 'nl', 'Maps', 'Kaarten');
INSERT INTO translations VALUES (170, 'nl', 'Search', 'Zoek');
INSERT INTO translations VALUES (171, 'nl', 'Meetingpoint', 'Trefpunt');
INSERT INTO translations VALUES (172, 'nl', 'Metadatasearch', 'Zoeken naar Metadata');
INSERT INTO translations VALUES (173, 'nl', 'Adding WMS', 'WMS toevoegen');
INSERT INTO translations VALUES (174, 'nl', 'Adding WMS from List', 'WMS uit lijst toevoegen');
INSERT INTO translations VALUES (175, 'nl', 'Info', 'Informatie');
INSERT INTO translations VALUES (176, 'nl', 'Change Projection', 'Projektie veranderen');
INSERT INTO translations VALUES (177, 'nl', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (178, 'nl', 'Digitize', 'Digitaliseren');
INSERT INTO translations VALUES (179, 'nl', 'Overview', 'overzichtskaart');
INSERT INTO translations VALUES (180, 'nl', 'Drag Mapsize', 'Kaart vergroten');
INSERT INTO translations VALUES (181, 'nl', 'Mapframe', 'Kaartvenster');
INSERT INTO translations VALUES (182, 'nl', 'Navigation Frame', 'Navigeervenster');
INSERT INTO translations VALUES (183, 'nl', 'Scale Select', 'Schaal selecteren');
INSERT INTO translations VALUES (184, 'nl', 'Scale Text', 'Schaal via tekstingave');
INSERT INTO translations VALUES (185, 'nl', 'Scalebar', 'Schaalbalk');
INSERT INTO translations VALUES (186, 'nl', 'Set Background', 'Achtergrond selecteren');
INSERT INTO translations VALUES (187, 'nl', 'Zoom to Coordinates', 'Naar koordinaten zoomen');
INSERT INTO translations VALUES (188, 'nl', 'Change Password', 'Paswoord wijzigen');
INSERT INTO translations VALUES (189, 'nl', 'Load a web map context document', 'Laad een Web Map Context Dokument');
INSERT INTO translations VALUES (190, 'nl', 'Logo', 'Logo');
INSERT INTO translations VALUES (191, 'nl', 'Measure distance', 'Meet afstand');
INSERT INTO translations VALUES (192, 'it', 'Pan', 'Sposta dettaglio');
INSERT INTO translations VALUES (193, 'it', 'Display complete map', 'Mostra tutta la mappa');
INSERT INTO translations VALUES (194, 'it', 'Zoom in', 'Ingrandisci');
INSERT INTO translations VALUES (195, 'it', 'Zoom out', 'Riduci');
INSERT INTO translations VALUES (196, 'it', 'Back', 'Indietro');
INSERT INTO translations VALUES (197, 'it', 'Forward', 'Avanti');
INSERT INTO translations VALUES (198, 'it', 'Coordinates', 'Mostra coordinate');
INSERT INTO translations VALUES (199, 'it', 'Zoom by rectangle', 'Seleziona dettaglio');
INSERT INTO translations VALUES (200, 'it', 'Redraw', 'Ridisegna oppure, da tastiera: spazio');
INSERT INTO translations VALUES (201, 'it', 'Query', 'Interroga');
INSERT INTO translations VALUES (202, 'it', 'Logout', 'Logout');
INSERT INTO translations VALUES (203, 'it', 'WMS preferences', 'Impostazioni WMS');
INSERT INTO translations VALUES (204, 'it', 'Adding WMS from filtered list', 'Aggiungi un WMS da una lista filtrata');
INSERT INTO translations VALUES (205, 'it', 'Set map center', 'Fissa il centro della mappa');
INSERT INTO translations VALUES (206, 'it', 'Help', 'Aiuto');
INSERT INTO translations VALUES (207, 'it', 'Show WMS infos', 'Mostra informazioni sul WMS');
INSERT INTO translations VALUES (208, 'it', 'Save workspace as web map context document', 'Salva vista come documento di Web Map Context');
INSERT INTO translations VALUES (209, 'it', 'Resize Mapsize', 'Adatta la dimensione della mappa');
INSERT INTO translations VALUES (210, 'it', 'Rubber', 'Cancella bozza');
INSERT INTO translations VALUES (211, 'it', 'Get Area', 'Calcola area');
INSERT INTO translations VALUES (212, 'it', 'Close Polygon', 'Chiudi poligono');
INSERT INTO translations VALUES (213, 'it', 'Move back to your GUI list', 'Torna alla lista delle GUI');
INSERT INTO translations VALUES (214, 'it', 'Legend', 'Legenda');
INSERT INTO translations VALUES (215, 'it', 'Print', 'Stampa');
INSERT INTO translations VALUES (216, 'it', 'Imprint', 'Colophon');
INSERT INTO translations VALUES (217, 'it', 'Maps', 'Mappe');
INSERT INTO translations VALUES (218, 'it', 'Search', 'Cerca');
INSERT INTO translations VALUES (219, 'it', 'Meetingpoint', 'Punti di incontro');
INSERT INTO translations VALUES (220, 'it', 'Metadatasearch', 'Ricerca metadati');
INSERT INTO translations VALUES (221, 'it', 'Adding WMS', 'Aggiungi WMS');
INSERT INTO translations VALUES (222, 'it', 'Adding WMS from List', 'Aggiungi WMS da lista');
INSERT INTO translations VALUES (223, 'it', 'Info', 'Info');
INSERT INTO translations VALUES (224, 'it', 'Change Projection', 'Cambia proiezione');
INSERT INTO translations VALUES (225, 'it', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (226, 'it', 'Digitize', 'Digitalizza');
INSERT INTO translations VALUES (227, 'it', 'Overview', 'Mappa di insieme');
INSERT INTO translations VALUES (228, 'it', 'Drag Mapsize', 'Cambia dimensione mappa');
INSERT INTO translations VALUES (229, 'it', 'Mapframe', 'Quadro della mappa');
INSERT INTO translations VALUES (230, 'it', 'Navigation Frame', 'Quadro di navigazione');
INSERT INTO translations VALUES (231, 'it', 'Scale Select', 'Scelta della scala');
INSERT INTO translations VALUES (232, 'it', 'Scale Text', 'Scala dei testi');
INSERT INTO translations VALUES (233, 'it', 'Scalebar', 'Scala di riferimento');
INSERT INTO translations VALUES (234, 'it', 'Set Background', 'Seleziona mappa di sfondo');
INSERT INTO translations VALUES (235, 'it', 'Zoom to Coordinates', 'Ingrandisci alle coordinate');
INSERT INTO translations VALUES (236, 'it', 'Change Password', 'Cambia password');
INSERT INTO translations VALUES (237, 'it', 'Load a web map context document', 'Carica un documento Web Map Context');
INSERT INTO translations VALUES (238, 'it', 'Logo', 'Logo');
INSERT INTO translations VALUES (239, 'it', 'Measure distance', 'Misura distanza');
INSERT INTO translations VALUES (240, 'es', 'Pan', 'Desplazamiento');
INSERT INTO translations VALUES (242, 'es', 'Zoom in', 'Zoom +');
INSERT INTO translations VALUES (243, 'es', 'Zoom out', 'Zoom -');
INSERT INTO translations VALUES (244, 'es', 'Back', 'Zoom previo');
INSERT INTO translations VALUES (245, 'es', 'Forward', 'Zoom siguiente');
INSERT INTO translations VALUES (246, 'es', 'Coordinates', 'Mostrar coordenadas');
INSERT INTO translations VALUES (247, 'es', 'Zoom by rectangle', 'Zoom rectángulo');
INSERT INTO translations VALUES (248, 'es', 'Redraw', 'Refrescar');
INSERT INTO translations VALUES (249, 'es', 'Query', 'Busqueda de datos');
INSERT INTO translations VALUES (250, 'es', 'Logout', 'Terminar');
INSERT INTO translations VALUES (251, 'es', 'WMS preferences', 'Ajuste WMS');
INSERT INTO translations VALUES (252, 'es', 'Adding WMS from filtered list', 'Anadir WMS desde lista filtrada');
INSERT INTO translations VALUES (253, 'es', 'Set map center', 'Centrar');
INSERT INTO translations VALUES (254, 'es', 'Help', 'Ayuda');
INSERT INTO translations VALUES (255, 'es', 'Show WMS infos', 'Mostrar información sobre WMS');
INSERT INTO translations VALUES (256, 'es', 'Save workspace as web map context document', 'Guardar vista como fichero Web Map Context');
INSERT INTO translations VALUES (257, 'es', 'Resize Mapsize', 'Modificar el tamano de mapa');
INSERT INTO translations VALUES (258, 'es', 'Rubber', 'Borrar');
INSERT INTO translations VALUES (259, 'es', 'Get Area', 'Calcular area');
INSERT INTO translations VALUES (260, 'es', 'Close Polygon', 'Cerrar polígono');
INSERT INTO translations VALUES (261, 'es', 'Move back to your GUI list', 'Volver a la lista WMS');
INSERT INTO translations VALUES (263, 'es', 'Print', 'Imprimir');
INSERT INTO translations VALUES (264, 'es', 'Imprint', 'Aviso legal');
INSERT INTO translations VALUES (265, 'es', 'Maps', 'Mapas');
INSERT INTO translations VALUES (266, 'es', 'Search', 'Busqueda');
INSERT INTO translations VALUES (267, 'es', 'Meetingpoint', 'Lugar de reunión');
INSERT INTO translations VALUES (268, 'es', 'Metadatasearch', 'Búsqueda de datos meta');
INSERT INTO translations VALUES (269, 'es', 'Adding WMS', 'Añadir WMS');
INSERT INTO translations VALUES (270, 'es', 'Adding WMS from List', 'Añadir WMS desde lista');
INSERT INTO translations VALUES (271, 'es', 'Info', 'Informacion');
INSERT INTO translations VALUES (272, 'es', 'Change Projection', 'Cambiar projecto');
INSERT INTO translations VALUES (273, 'es', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (274, 'es', 'Digitize', 'Digitalización');
INSERT INTO translations VALUES (275, 'es', 'Overview', 'Mapa de visión general');
INSERT INTO translations VALUES (276, 'es', 'Drag Mapsize', 'Ampilar vista de mapa');
INSERT INTO translations VALUES (277, 'es', 'Mapframe', 'Ventana de mapa');
INSERT INTO translations VALUES (278, 'es', 'Navigation Frame', 'Ventana de navigacion');
INSERT INTO translations VALUES (279, 'es', 'Scale Select', 'Selecionar escala');
INSERT INTO translations VALUES (282, 'es', 'Set Background', 'Poner el fondo');
INSERT INTO translations VALUES (283, 'es', 'Zoom to Coordinates', 'Zoom en coordenadas');
INSERT INTO translations VALUES (284, 'es', 'Change Password', 'Cambiar clave');
INSERT INTO translations VALUES (285, 'es', 'Load a web map context document', 'Cargar un documento de Web Map Context');
INSERT INTO translations VALUES (286, 'es', 'Logo', 'Logo');
INSERT INTO translations VALUES (287, 'es', 'Measure distance', 'Medir distancias');
INSERT INTO translations VALUES (288, 'de', 'Set language', 'Sprache auswählen');
INSERT INTO translations VALUES (290, 'it', 'Set language', 'Lingua');
INSERT INTO translations VALUES (291, 'fr', 'Set language', 'Choisir une langue');
INSERT INTO translations VALUES (292, 'de', 'Measure distance', 'Messen');
INSERT INTO translations VALUES (293, 'pt', 'Zoom out', 'Zoom -');
INSERT INTO translations VALUES (294, 'pt', 'Back', 'Zoom previo');
INSERT INTO translations VALUES (296, 'pt', 'Coordinates', 'Mostrar coordinadas');
INSERT INTO translations VALUES (297, 'pt', 'Zoom by rectangle', 'Zoom retángulo');
INSERT INTO translations VALUES (298, 'pt', 'Redraw', 'Refrescar');
INSERT INTO translations VALUES (299, 'pt', 'Query', 'Procurar dados');
INSERT INTO translations VALUES (300, 'pt', 'Logout', 'Terminar sessão');
INSERT INTO translations VALUES (301, 'pt', 'WMS preferences', 'Ajuste WMS');
INSERT INTO translations VALUES (302, 'pt', 'Adding WMS from filtered list', 'Adicionar WMS desde lista filtrada');
INSERT INTO translations VALUES (303, 'pt', 'Set map center', 'Centrar');
INSERT INTO translations VALUES (304, 'pt', 'Help', 'Ajuda');
INSERT INTO translations VALUES (305, 'pt', 'Show WMS infos', 'Mostrar informação sobre WMS');
INSERT INTO translations VALUES (306, 'pt', 'Save workspace as web map context document', 'Guardar vista como arquivo Web Map Context');
INSERT INTO translations VALUES (307, 'pt', 'Resize Mapsize', 'Modificar tamanho do mapa');
INSERT INTO translations VALUES (308, 'pt', 'Rubber', 'Apagar');
INSERT INTO translations VALUES (309, 'pt', 'Get Area', 'Calcular area');
INSERT INTO translations VALUES (310, 'pt', 'Close Polygon', 'Fechar polígono');
INSERT INTO translations VALUES (311, 'pt', 'Move back to your GUI list', 'Volver a lista WMS');
INSERT INTO translations VALUES (312, 'pt', 'Legend', 'Legenda');
INSERT INTO translations VALUES (313, 'pt', 'Print', 'Imprimir');
INSERT INTO translations VALUES (314, 'pt', 'Imprint', 'Expediente');
INSERT INTO translations VALUES (315, 'pt', 'Maps', 'Mapas');
INSERT INTO translations VALUES (316, 'pt', 'Search', 'Procura');
INSERT INTO translations VALUES (317, 'pt', 'Meetingpoint', 'Lugar de reunião, ');
INSERT INTO translations VALUES (318, 'pt', 'Metadatasearch', 'Procura metadados');
INSERT INTO translations VALUES (319, 'pt', 'Adding WMS', 'Adicionar WMS');
INSERT INTO translations VALUES (320, 'pt', 'Adding WMS from List', 'Adicionar WMS desde lista');
INSERT INTO translations VALUES (321, 'pt', 'Info', 'Informação');
INSERT INTO translations VALUES (322, 'pt', 'Change Projection', 'Trocar projeto');
INSERT INTO translations VALUES (323, 'pt', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (324, 'pt', 'Digitize', 'Captura');
INSERT INTO translations VALUES (325, 'pt', 'Overview', 'Mapa de vição geral');
INSERT INTO translations VALUES (326, 'pt', 'Drag Mapsize', 'Ampliar janela do mapa');
INSERT INTO translations VALUES (327, 'pt', 'Mapframe', 'Janela do mapa');
INSERT INTO translations VALUES (328, 'pt', 'Navigation Frame', 'Janela do navegação');
INSERT INTO translations VALUES (330, 'pt', 'Scale Text', 'Texto da escala');
INSERT INTO translations VALUES (331, 'pt', 'Scalebar', 'Barra de escala');
INSERT INTO translations VALUES (332, 'pt', 'Set Background', 'Pôr fondo');
INSERT INTO translations VALUES (334, 'pt', 'Change Password', 'Trocar senha');
INSERT INTO translations VALUES (335, 'pt', 'Load a web map context document', 'Carregar documento do Web Map Context');
INSERT INTO translations VALUES (280, 'es', 'Scale Text', 'Escala de texto');
INSERT INTO translations VALUES (281, 'es', 'Scalebar', 'Barra de escala');
INSERT INTO translations VALUES (262, 'es', 'Legend', 'Referencia');
INSERT INTO translations VALUES (241, 'es', 'Display complete map', 'Mostrar mapa completo');
INSERT INTO translations VALUES (295, 'pt', 'Forward', 'Zoom seguinte');
INSERT INTO translations VALUES (329, 'pt', 'Scale Select', 'Selecionar escala');
INSERT INTO translations VALUES (336, 'pt', 'Logo', 'Logo');
INSERT INTO translations VALUES (337, 'pt', 'Measure distance', 'Medir distância');
INSERT INTO translations VALUES (341, 'pt', 'Pan', 'Desplazamento');
INSERT INTO translations VALUES (342, 'pt', 'Display complete map', 'Zoom na Extensão Total');
INSERT INTO translations VALUES (343, 'pt', 'Zoom in', 'Zoom +');
INSERT INTO translations VALUES (344, 'fr', 'Pan', 'Déplacer la sélection');
INSERT INTO translations VALUES (345, 'fr', 'Display complete map', 'Afficher toute la carte');
INSERT INTO translations VALUES (346, 'fr', 'Zoom in', 'Zoomer');
INSERT INTO translations VALUES (347, 'fr', 'Zoom out', 'Dézoomer');
INSERT INTO translations VALUES (348, 'fr', 'Back', 'Précédent');
INSERT INTO translations VALUES (349, 'fr', 'Forward', 'Suivant');
INSERT INTO translations VALUES (350, 'fr', 'Coordinates', 'Afficher les coordonnées');
INSERT INTO translations VALUES (351, 'fr', 'Zoom by rectangle', 'Zoomer sur la sélection');
INSERT INTO translations VALUES (352, 'fr', 'Redraw', 'Actualiser [Espace]');
INSERT INTO translations VALUES (353, 'fr', 'Query', 'Interroger la base de données');
INSERT INTO translations VALUES (354, 'fr', 'Logout', 'Déconnexion');
INSERT INTO translations VALUES (355, 'fr', 'WMS preferences', 'Configuration du WMS');
INSERT INTO translations VALUES (356, 'fr', 'Adding WMS from filtered list', 'Ajouter un WMS de la liste filtrée');
INSERT INTO translations VALUES (357, 'fr', 'Set map center', 'Définir le centre de la carte');
INSERT INTO translations VALUES (358, 'fr', 'Help', 'Aide');
INSERT INTO translations VALUES (359, 'fr', 'Show WMS infos', 'Affichage des informations du WMS');
INSERT INTO translations VALUES (361, 'fr', 'Resize Mapsize', 'Redimensionner la taille de la carte');
INSERT INTO translations VALUES (362, 'fr', 'Rubber', 'Gomme');
INSERT INTO translations VALUES (363, 'fr', 'Get Area', 'Calculer la superficie');
INSERT INTO translations VALUES (364, 'fr', 'Close Polygon', 'Fermer le polygone');
INSERT INTO translations VALUES (365, 'fr', 'Move back to your GUI list', 'Retour à votre liste GUI');
INSERT INTO translations VALUES (366, 'fr', 'Legend', 'Légende');
INSERT INTO translations VALUES (367, 'fr', 'Print', 'Imprimer');
INSERT INTO translations VALUES (368, 'fr', 'Imprint', 'Envoyer / Imprint');
INSERT INTO translations VALUES (369, 'fr', 'Maps', 'Cartes');
INSERT INTO translations VALUES (370, 'fr', 'Search', 'Recherche');
INSERT INTO translations VALUES (371, 'fr', 'Meetingpoint', 'Point de rencontre');
INSERT INTO translations VALUES (372, 'fr', 'Metadatasearch', 'Recherche des métadonnées');
INSERT INTO translations VALUES (373, 'fr', 'Adding WMS', 'Ajouter WMS');
INSERT INTO translations VALUES (374, 'fr', 'Adding WMS from List', 'Ajouter WMS depuis la liste');
INSERT INTO translations VALUES (375, 'fr', 'Info', 'Info');
INSERT INTO translations VALUES (376, 'fr', 'Change Projection', 'Changer la projection');
INSERT INTO translations VALUES (377, 'fr', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (378, 'fr', 'Digitize', 'Numériser');
INSERT INTO translations VALUES (380, 'fr', 'Drag Mapsize', 'Modifier la taille de la carte');
INSERT INTO translations VALUES (381, 'fr', 'Mapframe', 'Fenêtre de la carte');
INSERT INTO translations VALUES (382, 'fr', 'Navigation Frame', 'Fenêtre de navigation');
INSERT INTO translations VALUES (385, 'fr', 'Scalebar', 'Echelle graphique');
INSERT INTO translations VALUES (387, 'fr', 'Zoom to Coordinates', 'Zoomer aux coordonnées');
INSERT INTO translations VALUES (388, 'fr', 'Change Password', 'Changer le mot de passe');
INSERT INTO translations VALUES (389, 'fr', 'Load a web map context document', 'Charger un fichier Web Map Context');
INSERT INTO translations VALUES (390, 'fr', 'Logo', 'Logo');
INSERT INTO translations VALUES (289, 'es', 'Set language', 'Seleccionar Idioma');
INSERT INTO translations VALUES (391, 'hu', 'Pan', 'Nézetet mozgat');
INSERT INTO translations VALUES (392, 'hu', 'Display complete map', 'Teljes nézet');
INSERT INTO translations VALUES (393, 'hu', 'Zoom in', 'Nagyít');
INSERT INTO translations VALUES (394, 'hu', 'Zoom out', 'Kicsnyít');
INSERT INTO translations VALUES (395, 'hu', 'Back', 'Vissza');
INSERT INTO translations VALUES (396, 'hu', 'Forward', 'Előre');
INSERT INTO translations VALUES (397, 'hu', 'Coordinates', 'Koordináták kijelzése');
INSERT INTO translations VALUES (398, 'hu', 'Zoom by rectangle', 'Kijelölt területre nagyít');
INSERT INTO translations VALUES (399, 'hu', 'Redraw', 'Újrarajzol');
INSERT INTO translations VALUES (400, 'hu', 'Query', 'Adatok lekérése');
INSERT INTO translations VALUES (401, 'hu', 'Logout', 'Kijelentkezés');
INSERT INTO translations VALUES (402, 'hu', 'WMS preferences', 'WMS beállítások');
INSERT INTO translations VALUES (403, 'hu', 'Adding WMS from filtered list', 'WMS hozzáadása szűrt listából');
INSERT INTO translations VALUES (404, 'hu', 'Set map center', 'Nézet középpontja');
INSERT INTO translations VALUES (405, 'hu', 'Help', 'Segítség');
INSERT INTO translations VALUES (406, 'hu', 'Show WMS infos', 'WMS adatok megjelenítése');
INSERT INTO translations VALUES (407, 'hu', 'Save workspace as web map context document', 'Nézet mentése Web Map Context formában');
INSERT INTO translations VALUES (408, 'hu', 'Resize Mapsize', 'Térkép átméretezése');
INSERT INTO translations VALUES (409, 'hu', 'Rubber', 'Törlés');
INSERT INTO translations VALUES (410, 'hu', 'Get Area', 'Területszámítás');
INSERT INTO translations VALUES (411, 'hu', 'Close Polygon', 'Sokszög bezárása');
INSERT INTO translations VALUES (412, 'hu', 'Move back to your GUI list', 'Vissza a GUI listához');
INSERT INTO translations VALUES (413, 'hu', 'Legend', 'Jelmagyarázat');
INSERT INTO translations VALUES (414, 'hu', 'Print', 'Nyomtat');
INSERT INTO translations VALUES (415, 'hu', 'Imprint', 'Impresszum');
INSERT INTO translations VALUES (416, 'hu', 'Maps', 'Térképek');
INSERT INTO translations VALUES (417, 'hu', 'Search', 'Keres');
INSERT INTO translations VALUES (418, 'hu', 'Meetingpoint', 'Találkozási pont');
INSERT INTO translations VALUES (419, 'hu', 'Metadatasearch', 'Metaadat keresés');
INSERT INTO translations VALUES (420, 'hu', 'Adding WMS', 'WMS hozzáadása');
INSERT INTO translations VALUES (421, 'hu', 'Adding WMS from List', 'WMS hozzáadása listából');
INSERT INTO translations VALUES (422, 'hu', 'Info', 'Információ');
INSERT INTO translations VALUES (423, 'hu', 'Change Projection', 'Más vetület választása');
INSERT INTO translations VALUES (424, 'hu', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (425, 'hu', 'Digitize', 'Digitalizálás');
INSERT INTO translations VALUES (426, 'hu', 'Overview', 'Átnézeti térkép');
INSERT INTO translations VALUES (427, 'hu', 'Drag Mapsize', 'Térkép átméretezése');
INSERT INTO translations VALUES (428, 'hu', 'Mapframe', 'Térképablak');
INSERT INTO translations VALUES (429, 'hu', 'Navigation Frame', 'Navigációs ablak');
INSERT INTO translations VALUES (430, 'hu', 'Scale Select', 'Lépték választása');
INSERT INTO translations VALUES (431, 'hu', 'Scale Text', 'Lépték megadása');
INSERT INTO translations VALUES (432, 'hu', 'Scalebar', 'Aránymérték');
INSERT INTO translations VALUES (433, 'hu', 'Set Background', 'Háttér beállítása');
INSERT INTO translations VALUES (434, 'hu', 'Zoom to Coordinates', 'Ugrás adott koordinátákra');
INSERT INTO translations VALUES (435, 'hu', 'Change Password', 'Jelszó módosítása');
INSERT INTO translations VALUES (436, 'hu', 'Load a web map context document', 'Web Map Context dokumentum betöltése');
INSERT INTO translations VALUES (437, 'hu', 'Logo', 'Logó');
INSERT INTO translations VALUES (438, 'hu', 'Measure distance', 'Távolságmérés');
INSERT INTO translations VALUES (338, 'pt', 'Set language', 'Selecionar Linguagem');
INSERT INTO translations VALUES (333, 'pt', 'Zoom to Coordinates', 'Zoom para coordinadas');
INSERT INTO translations VALUES (340, 'pt', 'Drag Mapsize', 'Agrandar Mapa');
INSERT INTO translations VALUES (339, 'pt', 'Navigation Frame', 'Marco de navegação');
INSERT INTO translations VALUES (379, 'fr', 'Overview', 'Carte de''aperçu');
INSERT INTO translations VALUES (591, 'de', 'Add GeoRSS', 'GeoRSS hinzufügen');
INSERT INTO translations VALUES (592, 'de', 'Search CSW', 'Katalogsuche');
INSERT INTO translations VALUES (488, 'hu', 'Set language', 'Másik nyelv...');
INSERT INTO translations VALUES (489, 'it', 'Set language', 'Assegnare linguaggio');
INSERT INTO translations VALUES (490, 'nl', 'Set language', 'Taal instellen');
INSERT INTO translations VALUES (540, 'de', 'Add GeoRSS', 'GeoRSS hinzufügen');
INSERT INTO translations VALUES (541, 'de', 'Search CSW', 'Katalogsuche');
INSERT INTO translations VALUES (593, 'de', 'Coordinate lookup', 'Koordinatensuche');
INSERT INTO translations VALUES (383, 'fr', 'Scale Select', 'Sélection de l''échelle');
INSERT INTO translations VALUES (384, 'fr', 'Scale Text', 'Texte de l''échelle');
INSERT INTO translations VALUES (386, 'fr', 'Set Background', 'Sélectionner la carte d''arrière-plan');
INSERT INTO translations VALUES (360, 'fr', 'Save workspace as web map context document', 'Sauvegarder la vue/l''espace de travail en tant que Web Map Context');
INSERT INTO translations VALUES (643, 'de', 'Add GeoRSS', 'GeoRSS hinzufügen');
INSERT INTO translations VALUES (644, 'de', 'Search CSW', 'Katalogsuche');
INSERT INTO translations VALUES (645, 'de', 'Coordinate lookup', 'Koordinatensuche');
INSERT INTO translations VALUES (695, 'de', 'Add GeoRSS', 'GeoRSS hinzufügen');
INSERT INTO translations VALUES (696, 'de', 'Search CSW', 'Katalogsuche');
INSERT INTO translations VALUES (697, 'de', 'Coordinate lookup', 'Koordinatensuche');
INSERT INTO translations VALUES (698, 'pl', 'Pan', 'Przesuń');
INSERT INTO translations VALUES (699, 'pl', 'Display complete map', 'Pokaż calą mapę');
INSERT INTO translations VALUES (700, 'pl', 'Zoom in', 'Powiększ');
INSERT INTO translations VALUES (701, 'pl', 'Zoom out', 'Pomniejsz');
INSERT INTO translations VALUES (702, 'pl', 'Back', 'Wróć');
INSERT INTO translations VALUES (703, 'pl', 'Forward', 'Do przodu');
INSERT INTO translations VALUES (704, 'pl', 'Coordinates', 'Współrzędne');
INSERT INTO translations VALUES (705, 'pl', 'Zoom by rectangle', 'Wybierz fragment mapy');
INSERT INTO translations VALUES (706, 'pl', 'Redraw', 'Załaduj ponownie');
INSERT INTO translations VALUES (707, 'pl', 'Query', 'Szukaj danych');
INSERT INTO translations VALUES (708, 'pl', 'Logout', 'Wymelduj');
INSERT INTO translations VALUES (709, 'pl', 'WMS preferences', 'Ustawienia WMS');
INSERT INTO translations VALUES (710, 'pl', 'Adding WMS from filtered list', 'Dodaj WMS z listy');
INSERT INTO translations VALUES (711, 'pl', 'Set map center', 'Zaznacz środek mapy');
INSERT INTO translations VALUES (712, 'pl', 'Help', 'Pomoc');
INSERT INTO translations VALUES (713, 'pl', 'Show WMS infos', 'Informacje WMS');
INSERT INTO translations VALUES (714, 'pl', 'Save workspace as web map context document', 'Zapisz widok jako web map context dokument');
INSERT INTO translations VALUES (715, 'pl', 'Resize Mapsize', 'Zmień rozmiar mapy');
INSERT INTO translations VALUES (716, 'pl', 'Rubber', 'Usuń szkic');
INSERT INTO translations VALUES (717, 'pl', 'Get Area', 'Oblicz powierzchnię');
INSERT INTO translations VALUES (718, 'pl', 'Close Polygon', 'Zamknij poligon');
INSERT INTO translations VALUES (719, 'pl', 'Move back to your GUI list', 'Z powrotem do listy GUI');
INSERT INTO translations VALUES (720, 'pl', 'Legend', 'Legenda');
INSERT INTO translations VALUES (721, 'pl', 'Print', 'Drukuj');
INSERT INTO translations VALUES (722, 'pl', 'Imprint', 'Imprint');
INSERT INTO translations VALUES (723, 'pl', 'Maps', 'Mapy');
INSERT INTO translations VALUES (724, 'pl', 'Search', 'Szukaj');
INSERT INTO translations VALUES (725, 'pl', 'Meetingpoint', 'Miejsce spotkań');
INSERT INTO translations VALUES (726, 'pl', 'Metadatasearch', 'Wyszukiwanie metadanych');
INSERT INTO translations VALUES (727, 'pl', 'Adding WMS', 'Dodaj WMS');
INSERT INTO translations VALUES (728, 'pl', 'Adding WMS from List', 'Dodaj WMS z listy');
INSERT INTO translations VALUES (729, 'pl', 'Info', 'Informacja');
INSERT INTO translations VALUES (730, 'pl', 'Change Projection', 'Zmień układ współrzędnych');
INSERT INTO translations VALUES (731, 'pl', 'Copyright', 'Copyright');
INSERT INTO translations VALUES (732, 'pl', 'Digitize', 'Dygitalizacja');
INSERT INTO translations VALUES (733, 'pl', 'Overview', 'Mapa przeglądowa');
INSERT INTO translations VALUES (734, 'pl', 'Drag Mapsize', 'Powiększ');
INSERT INTO translations VALUES (735, 'pl', 'Mapframe', 'Okno mapy');
INSERT INTO translations VALUES (736, 'pl', 'Navigation Frame', 'Pasek narzędzi');
INSERT INTO translations VALUES (737, 'pl', 'Scale Select', 'Wybierz skalę');
INSERT INTO translations VALUES (738, 'pl', 'Scale Text', 'Wpisz skalę');
INSERT INTO translations VALUES (739, 'pl', 'Scalebar', 'Podziałka');
INSERT INTO translations VALUES (740, 'pl', 'Set Background', 'Wybierz mapę tematyczną jako tło');
INSERT INTO translations VALUES (741, 'pl', 'Zoom to Coordinates', 'Powiększ według współrzędnych');
INSERT INTO translations VALUES (742, 'pl', 'Change Password', 'Zmień hasło');
INSERT INTO translations VALUES (743, 'pl', 'Load a web map context document', 'Załaduj web map context dokument');
INSERT INTO translations VALUES (744, 'pl', 'Logo', 'Logo');
INSERT INTO translations VALUES (745, 'pl', 'Measure distance', 'Zmierz odległość');
INSERT INTO translations VALUES (746, 'pl', 'Set language', 'Wybierz język');
INSERT INTO translations VALUES (120, 'gr', 'Navigation Frame', 'Περίγραμμα/Κορνίζα πλοήγησης');
INSERT INTO translations VALUES (121, 'gr', 'Load a web map context document', 'Φόρτωση κειμένου διαδυκτιακού χάρτη');
INSERT INTO translations VALUES (111, 'gr', 'Save workspace as web map context document', 'Αποθήκευση χώρου εργασίας με μορφή κείμενου διαδυκτιακού χάρτη');
INSERT INTO translations VALUES (747, 'de', 'Add GeoRSS', 'GeoRSS hinzufügen');
INSERT INTO translations VALUES (748, 'de', 'Search CSW', 'Katalogsuche');
INSERT INTO translations VALUES (749, 'de', 'Coordinate lookup', 'Koordinatensuche');


--
-- TOC entry 4443 (class 0 OID 18573)
-- Dependencies: 244
-- Data for Name: wfs; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4444 (class 0 OID 18582)
-- Dependencies: 245
-- Data for Name: wfs_conf; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4445 (class 0 OID 18593)
-- Dependencies: 246
-- Data for Name: wfs_conf_element; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4446 (class 0 OID 18610)
-- Dependencies: 249
-- Data for Name: wfs_element; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4447 (class 0 OID 18619)
-- Dependencies: 251
-- Data for Name: wfs_featuretype; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4448 (class 0 OID 18628)
-- Dependencies: 252
-- Data for Name: wfs_featuretype_custom_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4449 (class 0 OID 18633)
-- Dependencies: 254
-- Data for Name: wfs_featuretype_inspire_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4450 (class 0 OID 18636)
-- Dependencies: 255
-- Data for Name: wfs_featuretype_keyword; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4451 (class 0 OID 18639)
-- Dependencies: 256
-- Data for Name: wfs_featuretype_md_topic_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4452 (class 0 OID 18642)
-- Dependencies: 257
-- Data for Name: wfs_featuretype_namespace; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4453 (class 0 OID 18652)
-- Dependencies: 258
-- Data for Name: wfs_termsofuse; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4454 (class 0 OID 18657)
-- Dependencies: 260
-- Data for Name: wmc_custom_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4455 (class 0 OID 18660)
-- Dependencies: 261
-- Data for Name: wmc_inspire_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4456 (class 0 OID 18663)
-- Dependencies: 262
-- Data for Name: wmc_keyword; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4457 (class 0 OID 18666)
-- Dependencies: 263
-- Data for Name: wmc_load_count; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4458 (class 0 OID 18669)
-- Dependencies: 264
-- Data for Name: wmc_md_topic_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4459 (class 0 OID 18672)
-- Dependencies: 265
-- Data for Name: wmc_preview; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4460 (class 0 OID 18675)
-- Dependencies: 266
-- Data for Name: wms; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO wms VALUES (957, '1.1.1', 'Luftbild', 'Luftbild der Hansestadt Rostock und Umgebung', 'http://geo.sv.rostock.de/geodienste/luftbild/ows?', 'http://geo.sv.rostock.de/geodienste/luftbild/ows?', 'http://geo.sv.rostock.de/geodienste/luftbild/ows?', NULL, NULL, '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE WMT_MS_Capabilities SYSTEM "http://schemas.opengis.net/wms/1.1.1/WMS_MS_Capabilities.dtd"
 [
 <!ELEMENT VendorSpecificCapabilities EMPTY>
 ]>  <!-- end of DOCTYPE declaration -->
<WMT_MS_Capabilities version="1.1.1">
<Service>
  <Name>OGC:WMS</Name>
  <Title>Luftbild</Title>
  <Abstract>Luftbild der Hansestadt Rostock und Umgebung</Abstract>
  <OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/luftbild/stadtplan/ows?"/>
  <ContactInformation>
      <ContactPersonPrimary>
        <ContactPerson>Geodienste</ContactPerson>
        <ContactOrganization>Kataster-, Vermessungs- und Liegenschaftsamt der Hansestadt Rostock</ContactOrganization>
      </ContactPersonPrimary>
      <ContactPosition></ContactPosition>
      <ContactAddress>
        <AddressType>postal</AddressType>
        <Address>Holbeinplatz 14</Address>
        <City>Rostock</City>
        <StateOrProvince></StateOrProvince>
        <PostCode>18069</PostCode>
        <Country>DE</Country>
      </ContactAddress>
      <ContactVoiceTelephone>+49-381-3816281</ContactVoiceTelephone>
      <ContactFacsimileTelephone>+49-381-3816902</ContactFacsimileTelephone>
      <ContactElectronicMailAddress>geodienste@rostock.de</ContactElectronicMailAddress>
  </ContactInformation>
  <Fees>None</Fees>
  <AccessConstraints>Die von der Hansestadt Rostock angebotenen Inhalte, die durch das Landesamt für innere Verwaltung Mecklenburg-Vorpommern (LAiV-MV) zur Verfügung gestellt werden, sind durch das Landesgesetz über das amtliche Geoinformations- und Vermessungswesen (GeoVermG M-V) und das Bundesgesetz über Urheberrecht und verwandte Schutzrechte (UrhG) in den jeweils geltenden Fassungen geschützt. Eine Nutzungserlaubnis liegt der Hansestadt Rostock vor. Der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © GeoBasis-DE/M-V.</AccessConstraints>
</Service>
<Capability>
  <Request>
    <GetCapabilities>
      <Format>application/vnd.ogc.wms_xml</Format>
      <DCPType>
        <HTTP>
          <Get><OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/geodienste/luftbild/ows?"/></Get>
        </HTTP>
      </DCPType>
    </GetCapabilities>
    <GetMap>
        <Format>image/png</Format>
        <Format>image/tiff</Format>
        <Format>image/jpeg</Format>
      <DCPType>
        <HTTP>
          <Get><OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/geodienste/luftbild/ows?"/></Get>
        </HTTP>
      </DCPType>
    </GetMap>
    <GetFeatureInfo>
      <Format>text/plain</Format>
      <Format>text/html</Format>
      <Format>application/vnd.ogc.gml</Format>
      <DCPType>
        <HTTP>
          <Get><OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/geodienste/luftbild/ows?"/></Get>
        </HTTP>
      </DCPType>
    </GetFeatureInfo>
  </Request>
  <Exception>
    <Format>application/vnd.ogc.se_xml</Format>
    <Format>application/vnd.ogc.se_inimage</Format>
    <Format>application/vnd.ogc.se_blank</Format>
  </Exception>
  <Layer>
    <Title>Luftbild</Title>
    <SRS>EPSG:2398</SRS>
    <SRS>EPSG:3857</SRS>
    <SRS>EPSG:4326</SRS>
    <SRS>EPSG:25833</SRS>
    <SRS>EPSG:900913</SRS>
    <LatLonBoundingBox minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
    <BoundingBox SRS="EPSG:900913" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
    <BoundingBox SRS="EPSG:4326" minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
    <BoundingBox SRS="EPSG:3857" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
    <Layer>
      <Name>luftbild</Name>
      <Title>Luftbild</Title>
      <LatLonBoundingBox minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
      <BoundingBox SRS="EPSG:900913" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
      <BoundingBox SRS="EPSG:4326" minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
      <BoundingBox SRS="EPSG:3857" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
    </Layer>
  </Layer>
</Capability>
</WMT_MS_Capabilities>', NULL, 'http://geo.sv.rostock.de/geodienste/luftbild/ows?REQUEST=GetCapabilities&SERVICE=WMS&VERSION=1.1.1', 'None', 'Die von der Hansestadt Rostock angebotenen Inhalte, die durch das Landesamt für innere Verwaltung Mecklenburg-Vorpommern (LAiV-MV) zur Verfügung gestellt werden, sind durch das Landesgesetz über das amtliche Geoinformations- und Vermessungswesen (GeoVermG M-V) und das Bundesgesetz über Urheberrecht und verwandte Schutzrechte (UrhG) in den jeweils geltenden Fassungen geschützt. Eine Nutzungserlaubnis liegt der Hansestadt Rostock vor. Der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © GeoBasis-DE/M-V.', 'Geodienste', NULL, 'Kataster-, Vermessungs- und Liegenschaftsamt der Hansestadt Rostock', 'Holbeinplatz 14', 'Rostock', NULL, '18069', 'DE', '+49-381-3816281', '+49-381-3816902', 'geodienste@rostock.de', NULL, 1, 1356008538, false, false, false, false, NULL, NULL, '', '', '', 1321014877, 0, NULL, NULL);
INSERT INTO wms VALUES (942, '1.1.1', 'Stadtplan', 'Stadtplandienst für Mecklenburg-Vorpommern auf Basis von amtlichen und OpenStreetMap-Daten', 'http://geo.sv.rostock.de/geodienste/stadtplan/ows?', 'http://geo.sv.rostock.de/geodienste/stadtplan/ows?', 'http://geo.sv.rostock.de/geodienste/stadtplan/ows?', NULL, NULL, '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE WMT_MS_Capabilities SYSTEM "http://schemas.opengis.net/wms/1.1.1/WMS_MS_Capabilities.dtd"
 [
 <!ELEMENT VendorSpecificCapabilities EMPTY>
 ]>  <!-- end of DOCTYPE declaration -->
<WMT_MS_Capabilities version="1.1.1">
<Service>
  <Name>OGC:WMS</Name>
  <Title>Stadtplan</Title>
  <Abstract>Stadtplandienst für Mecklenburg-Vorpommern auf Basis von amtlichen und OpenStreetMap-Daten</Abstract>
  <OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/geodienste/stadtplan/ows?"/>
  <ContactInformation>
      <ContactPersonPrimary>
        <ContactPerson>Geodienste</ContactPerson>
        <ContactOrganization>Kataster-, Vermessungs- und Liegenschaftsamt der Hansestadt Rostock</ContactOrganization>
      </ContactPersonPrimary>
      <ContactPosition></ContactPosition>
      <ContactAddress>
        <AddressType>postal</AddressType>
        <Address>Holbeinplatz 14</Address>
        <City>Rostock</City>
        <StateOrProvince></StateOrProvince>
        <PostCode>18069</PostCode>
        <Country>DE</Country>
      </ContactAddress>
      <ContactVoiceTelephone>+49-381-3816281</ContactVoiceTelephone>
      <ContactFacsimileTelephone>+49-381-3816902</ContactFacsimileTelephone>
      <ContactElectronicMailAddress>geodienste@rostock.de</ContactElectronicMailAddress>
  </ContactInformation>
  <Fees>none</Fees>
  <AccessConstraints>Die von der Hansestadt Rostock angebotenen und in ihrem Eigentum befindlichen Kartenbilder unterliegen der freien Lizenz Creative Commons Namensnennung 3.0 (CC BY 3.0). Damit ist es gestattet die Kartenbilder zu kopieren, zu verbreiten, öffentlich zugänglich zu machen, Abwandlungen und Bearbeitungen anzufertigen sowie die Kartenbilder kommerziell zu nutzen. Allein der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © Hansestadt Rostock (CC BY 3.0). Die den Kartenbildern zugrundeliegenden Daten des Projektes OpenStreetMap unterliegen der freien Datenbanklizenz Open Data Commons Open Database License (ODbL). Für die Aufbereitung der Daten verwendet die Hansestadt Rostock die Open-Source-Software Imposm. Der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © OpenStreetMap (ODbL). Die den Kartenbildern zugrundeliegenden Daten der unteren Vermessungs- und Geoinformationsbehörden Mecklenburg-Vorpommerns (uVGB-MV) sind durch das Landesgesetz über das amtliche Geoinformations- und Vermessungswesen (GeoVermG M-V) und das Bundesgesetz über Urheberrecht und verwandte Schutzrechte (UrhG) in den jeweils geltenden Fassungen geschützt. Eine Nutzungserlaubnis liegt der Hansestadt Rostock vor. Der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © uVGB-MV.</AccessConstraints>
</Service>
<Capability>
  <Request>
    <GetCapabilities>
      <Format>application/vnd.ogc.wms_xml</Format>
      <DCPType>
        <HTTP>
          <Get><OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/geodienste/stadtplan/ows?"/></Get>
        </HTTP>
      </DCPType>
    </GetCapabilities>
    <GetMap>
        <Format>image/png</Format>
        <Format>image/tiff</Format>
        <Format>image/jpeg</Format>
      <DCPType>
        <HTTP>
          <Get><OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/geodienste/stadtplan/ows?"/></Get>
        </HTTP>
      </DCPType>
    </GetMap>
    <GetFeatureInfo>
      <Format>text/plain</Format>
      <Format>text/html</Format>
      <Format>application/vnd.ogc.gml</Format>
      <DCPType>
        <HTTP>
          <Get><OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="http://geo.sv.rostock.de/geodienste/stadtplan/ows?"/></Get>
        </HTTP>
      </DCPType>
    </GetFeatureInfo>
  </Request>
  <Exception>
    <Format>application/vnd.ogc.se_xml</Format>
    <Format>application/vnd.ogc.se_inimage</Format>
    <Format>application/vnd.ogc.se_blank</Format>
  </Exception>
  <Layer>
    <Title>Stadtplan</Title>
    <SRS>EPSG:2398</SRS>
    <SRS>EPSG:2399</SRS>
    <SRS>EPSG:3857</SRS>
    <SRS>EPSG:4326</SRS>
    <SRS>EPSG:25833</SRS>
    <SRS>EPSG:900913</SRS>
    <LatLonBoundingBox minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
    <BoundingBox SRS="EPSG:900913" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
    <BoundingBox SRS="EPSG:4326" minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
    <BoundingBox SRS="EPSG:3857" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
    <Layer>
      <Name>stadtplan</Name>
      <Title>Stadtplan</Title>
      <LatLonBoundingBox minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
      <BoundingBox SRS="EPSG:900913" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
      <BoundingBox SRS="EPSG:4326" minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
      <BoundingBox SRS="EPSG:3857" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
      <BoundingBox SRS="EPSG:25833" minx="200000" miny="5880000" maxx="480000" maxy="6075000" />
    </Layer>
    <Layer>
      <Name>stadtplan_notext</Name>
      <Title>Stadtplan (ohne Beschriftung)</Title>
      <LatLonBoundingBox minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
      <BoundingBox SRS="EPSG:900913" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
      <BoundingBox SRS="EPSG:4326" minx="10.3394197139" miny="52.9854108366" maxx="14.701506258" maxy="54.8217440891" />
      <BoundingBox SRS="EPSG:3857" minx="1150978.93765" miny="6980299.77582" maxx="1636564.19054" maxy="7327346.85094" />
      <BoundingBox SRS="EPSG:25833" minx="200000" miny="5880000" maxx="480000" maxy="6075000" />
    </Layer>
  </Layer>
</Capability>
</WMT_MS_Capabilities>', NULL, 'http://geo.sv.rostock.de/geodienste/stadtplan/ows?REQUEST=GetCapabilities&SERVICE=WMS&VERSION=1.1.1', 'none', 'Die von der Hansestadt Rostock angebotenen und in ihrem Eigentum befindlichen Kartenbilder unterliegen der freien Lizenz Creative Commons Namensnennung 3.0 (CC BY 3.0). Damit ist es gestattet die Kartenbilder zu kopieren, zu verbreiten, öffentlich zugänglich zu machen, Abwandlungen und Bearbeitungen anzufertigen sowie die Kartenbilder kommerziell zu nutzen. Allein der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © Hansestadt Rostock (CC BY 3.0). Die den Kartenbildern zugrundeliegenden Daten des Projektes OpenStreetMap unterliegen der freien Datenbanklizenz Open Data Commons Open Database License (ODbL). Für die Aufbereitung der Daten verwendet die Hansestadt Rostock die Open-Source-Software Imposm. Der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © OpenStreetMap (ODbL). Die den Kartenbildern zugrundeliegenden Daten der unteren Vermessungs- und Geoinformationsbehörden Mecklenburg-Vorpommerns (uVGB-MV) sind durch das Landesgesetz über das amtliche Geoinformations- und Vermessungswesen (GeoVermG M-V) und das Bundesgesetz über Urheberrecht und verwandte Schutzrechte (UrhG) in den jeweils geltenden Fassungen geschützt. Eine Nutzungserlaubnis liegt der Hansestadt Rostock vor. Der Quellenvermerk ist stets und bei jedweder Art der Nutzung erforderlich und wie folgt auszugestalten: © uVGB-MV.', 'Geodienste', NULL, 'Kataster-, Vermessungs- und Liegenschaftsamt der Hansestadt Rostock', 'Holbeinplatz 14', 'Rostock', NULL, '18069', 'DE', '+49-381-3816281', '+49-381-3816902', 'geodienste@rostock.de', NULL, 1, 1356011095, false, false, false, false, NULL, NULL, '', '', '', 1319635468, 0, NULL, NULL);


--
-- TOC entry 4461 (class 0 OID 18689)
-- Dependencies: 267
-- Data for Name: wms_format; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO wms_format VALUES (942, 'map', 'image/png');
INSERT INTO wms_format VALUES (942, 'map', 'image/tiff');
INSERT INTO wms_format VALUES (942, 'map', 'image/jpeg');
INSERT INTO wms_format VALUES (942, 'featureinfo', 'text/plain');
INSERT INTO wms_format VALUES (942, 'featureinfo', 'text/html');
INSERT INTO wms_format VALUES (942, 'featureinfo', 'application/vnd.ogc.gml');
INSERT INTO wms_format VALUES (942, 'exception', 'application/vnd.ogc.se_xml');
INSERT INTO wms_format VALUES (942, 'exception', 'application/vnd.ogc.se_inimage');
INSERT INTO wms_format VALUES (942, 'exception', 'application/vnd.ogc.se_blank');
INSERT INTO wms_format VALUES (957, 'map', 'image/png');
INSERT INTO wms_format VALUES (957, 'map', 'image/tiff');
INSERT INTO wms_format VALUES (957, 'map', 'image/jpeg');
INSERT INTO wms_format VALUES (957, 'featureinfo', 'text/plain');
INSERT INTO wms_format VALUES (957, 'featureinfo', 'text/html');
INSERT INTO wms_format VALUES (957, 'featureinfo', 'application/vnd.ogc.gml');
INSERT INTO wms_format VALUES (957, 'exception', 'application/vnd.ogc.se_xml');
INSERT INTO wms_format VALUES (957, 'exception', 'application/vnd.ogc.se_inimage');
INSERT INTO wms_format VALUES (957, 'exception', 'application/vnd.ogc.se_blank');


--
-- TOC entry 4462 (class 0 OID 18695)
-- Dependencies: 268
-- Data for Name: wms_md_topic_category; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4463 (class 0 OID 18698)
-- Dependencies: 269
-- Data for Name: wms_srs; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--

INSERT INTO wms_srs VALUES (942, 'EPSG:2398');
INSERT INTO wms_srs VALUES (942, 'EPSG:2399');
INSERT INTO wms_srs VALUES (942, 'EPSG:3857');
INSERT INTO wms_srs VALUES (942, 'EPSG:4326');
INSERT INTO wms_srs VALUES (942, 'EPSG:25833');
INSERT INTO wms_srs VALUES (942, 'EPSG:900913');
INSERT INTO wms_srs VALUES (957, 'EPSG:2398');
INSERT INTO wms_srs VALUES (957, 'EPSG:3857');
INSERT INTO wms_srs VALUES (957, 'EPSG:4326');
INSERT INTO wms_srs VALUES (957, 'EPSG:25833');
INSERT INTO wms_srs VALUES (957, 'EPSG:900913');


--
-- TOC entry 4464 (class 0 OID 18703)
-- Dependencies: 270
-- Data for Name: wms_termsofuse; Type: TABLE DATA; Schema: mapbender; Owner: mapbender
--



--
-- TOC entry 4179 (class 2606 OID 18743)
-- Dependencies: 167 167
-- Name: cat_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY cat
    ADD CONSTRAINT cat_pkey PRIMARY KEY (cat_id);


--
-- TOC entry 4185 (class 2606 OID 18745)
-- Dependencies: 171 171
-- Name: conformity_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY conformity
    ADD CONSTRAINT conformity_pkey PRIMARY KEY (conformity_id);


--
-- TOC entry 4189 (class 2606 OID 18747)
-- Dependencies: 175 175
-- Name: custom_category_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY custom_category
    ADD CONSTRAINT custom_category_pkey PRIMARY KEY (custom_category_id);


--
-- TOC entry 4221 (class 2606 OID 18749)
-- Dependencies: 200 200
-- Name: data_id_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY inspire_md_data
    ADD CONSTRAINT data_id_pkey PRIMARY KEY (data_id);


--
-- TOC entry 4219 (class 2606 OID 18751)
-- Dependencies: 198 198
-- Name: inspire_category_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY inspire_category
    ADD CONSTRAINT inspire_category_pkey PRIMARY KEY (inspire_category_id);


--
-- TOC entry 4224 (class 2606 OID 18753)
-- Dependencies: 202 202
-- Name: keyword_keyword_key; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY keyword
    ADD CONSTRAINT keyword_keyword_key UNIQUE (keyword);


--
-- TOC entry 4232 (class 2606 OID 18755)
-- Dependencies: 212 212
-- Name: layer_preview_fkey_layer_id_key; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY layer_preview
    ADD CONSTRAINT layer_preview_fkey_layer_id_key UNIQUE (fkey_layer_id);


--
-- TOC entry 4205 (class 2606 OID 18757)
-- Dependencies: 188 188
-- Name: mb_gui_kml_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_kml
    ADD CONSTRAINT mb_gui_kml_pkey PRIMARY KEY (kml_id);


--
-- TOC entry 4253 (class 2606 OID 18759)
-- Dependencies: 231 231
-- Name: md_topic_category_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY md_topic_category
    ADD CONSTRAINT md_topic_category_pkey PRIMARY KEY (md_topic_category_id);


--
-- TOC entry 4239 (class 2606 OID 18761)
-- Dependencies: 218 218
-- Name: metadata_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_metadata
    ADD CONSTRAINT metadata_pkey PRIMARY KEY (metadata_id);


--
-- TOC entry 4181 (class 2606 OID 18763)
-- Dependencies: 169 169 169
-- Name: pk_cat_keyword; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY cat_keyword
    ADD CONSTRAINT pk_cat_keyword PRIMARY KEY (fkey_cat_id, fkey_keyword_id);


--
-- TOC entry 4197 (class 2606 OID 18765)
-- Dependencies: 183 183
-- Name: pk_category_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_category
    ADD CONSTRAINT pk_category_id PRIMARY KEY (category_id);


--
-- TOC entry 4183 (class 2606 OID 18767)
-- Dependencies: 170 170 170 170 170
-- Name: pk_con_cat_op; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY cat_op_conf
    ADD CONSTRAINT pk_con_cat_op PRIMARY KEY (fk_cat_id, param_type, param_name, param_value);


--
-- TOC entry 4191 (class 2606 OID 18769)
-- Dependencies: 177 177
-- Name: pk_datalink_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY datalink
    ADD CONSTRAINT pk_datalink_id PRIMARY KEY (datalink_id);


--
-- TOC entry 4193 (class 2606 OID 18771)
-- Dependencies: 179 179 179
-- Name: pk_datalink_keyword; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY datalink_keyword
    ADD CONSTRAINT pk_datalink_keyword PRIMARY KEY (fkey_datalink_id, fkey_keyword_id);


--
-- TOC entry 4278 (class 2606 OID 18773)
-- Dependencies: 251 251
-- Name: pk_featuretype_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wfs_featuretype
    ADD CONSTRAINT pk_featuretype_id PRIMARY KEY (featuretype_id);


--
-- TOC entry 4280 (class 2606 OID 18775)
-- Dependencies: 257 257 257 257
-- Name: pk_featuretype_namespace; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wfs_featuretype_namespace
    ADD CONSTRAINT pk_featuretype_namespace PRIMARY KEY (fkey_wfs_id, fkey_featuretype_id, namespace);


--
-- TOC entry 4199 (class 2606 OID 18777)
-- Dependencies: 185 185 185
-- Name: pk_fkey_gui_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_element
    ADD CONSTRAINT pk_fkey_gui_id PRIMARY KEY (fkey_gui_id, e_id);


--
-- TOC entry 4201 (class 2606 OID 18779)
-- Dependencies: 186 186 186 186
-- Name: pk_fkey_gui_id_fkey_e_id_var_name; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_element_vars
    ADD CONSTRAINT pk_fkey_gui_id_fkey_e_id_var_name PRIMARY KEY (fkey_gui_id, fkey_e_id, var_name);


--
-- TOC entry 4209 (class 2606 OID 18781)
-- Dependencies: 191 191 191
-- Name: pk_fkey_mb_group_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_mb_group
    ADD CONSTRAINT pk_fkey_mb_group_id PRIMARY KEY (fkey_mb_group_id, fkey_gui_id);


--
-- TOC entry 4211 (class 2606 OID 18783)
-- Dependencies: 192 192 192
-- Name: pk_fkey_mb_user_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_mb_user
    ADD CONSTRAINT pk_fkey_mb_user_id PRIMARY KEY (fkey_gui_id, fkey_mb_user_id);


--
-- TOC entry 4249 (class 2606 OID 18785)
-- Dependencies: 226 226 226 226
-- Name: pk_fkey_mb_user_mb_group_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_user_mb_group
    ADD CONSTRAINT pk_fkey_mb_user_mb_group_id PRIMARY KEY (fkey_mb_user_id, fkey_mb_group_id, mb_user_mb_group_type);


--
-- TOC entry 4213 (class 2606 OID 18787)
-- Dependencies: 193 193 193 193 193
-- Name: pk_fkey_treegde_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_treegde
    ADD CONSTRAINT pk_fkey_treegde_id PRIMARY KEY (fkey_gui_id, id, lft, rgt);


--
-- TOC entry 4215 (class 2606 OID 18789)
-- Dependencies: 196 196 196
-- Name: pk_fkey_wfs_conf_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_wfs_conf
    ADD CONSTRAINT pk_fkey_wfs_conf_id PRIMARY KEY (fkey_gui_id, fkey_wfs_conf_id);


--
-- TOC entry 4234 (class 2606 OID 18791)
-- Dependencies: 214 214
-- Name: pk_group_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_group
    ADD CONSTRAINT pk_group_id PRIMARY KEY (mb_group_id);


--
-- TOC entry 4203 (class 2606 OID 18793)
-- Dependencies: 187 187 187
-- Name: pk_gui_gui_category; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_gui_category
    ADD CONSTRAINT pk_gui_gui_category PRIMARY KEY (fkey_gui_id, fkey_gui_category_id);


--
-- TOC entry 4195 (class 2606 OID 18795)
-- Dependencies: 181 181
-- Name: pk_gui_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui
    ADD CONSTRAINT pk_gui_id PRIMARY KEY (gui_id);


--
-- TOC entry 4207 (class 2606 OID 18797)
-- Dependencies: 190 190 190
-- Name: pk_gui_layer; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_layer
    ADD CONSTRAINT pk_gui_layer PRIMARY KEY (fkey_gui_id, fkey_layer_id);


--
-- TOC entry 4217 (class 2606 OID 18799)
-- Dependencies: 197 197 197
-- Name: pk_gui_wms; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY gui_wms
    ADD CONSTRAINT pk_gui_wms PRIMARY KEY (fkey_gui_id, fkey_wms_id);


--
-- TOC entry 4226 (class 2606 OID 18801)
-- Dependencies: 202 202
-- Name: pk_keyword_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY keyword
    ADD CONSTRAINT pk_keyword_id PRIMARY KEY (keyword_id);


--
-- TOC entry 4228 (class 2606 OID 18803)
-- Dependencies: 204 204
-- Name: pk_layer_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY layer
    ADD CONSTRAINT pk_layer_id PRIMARY KEY (layer_id);


--
-- TOC entry 4230 (class 2606 OID 18805)
-- Dependencies: 208 208 208
-- Name: pk_layer_keyword; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY layer_keyword
    ADD CONSTRAINT pk_layer_keyword PRIMARY KEY (fkey_layer_id, fkey_keyword_id);


--
-- TOC entry 4236 (class 2606 OID 18807)
-- Dependencies: 216 216
-- Name: pk_mb_log; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_log
    ADD CONSTRAINT pk_mb_log PRIMARY KEY (id);


--
-- TOC entry 4243 (class 2606 OID 18809)
-- Dependencies: 220 220 220
-- Name: pk_mb_monitor; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_monitor
    ADD CONSTRAINT pk_mb_monitor PRIMARY KEY (upload_id, fkey_wms_id);


--
-- TOC entry 4247 (class 2606 OID 18811)
-- Dependencies: 224 224
-- Name: pk_mb_user_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_user
    ADD CONSTRAINT pk_mb_user_id PRIMARY KEY (mb_user_id);


--
-- TOC entry 4292 (class 2606 OID 18813)
-- Dependencies: 268 268 268
-- Name: pk_md_topic_category; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wms_md_topic_category
    ADD CONSTRAINT pk_md_topic_category PRIMARY KEY (fkey_wms_id, fkey_md_topic_category_id);


--
-- TOC entry 4255 (class 2606 OID 18815)
-- Dependencies: 235 235
-- Name: pk_sld_user_layer; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY sld_user_layer
    ADD CONSTRAINT pk_sld_user_layer PRIMARY KEY (sld_user_layer_id);


--
-- TOC entry 4251 (class 2606 OID 18817)
-- Dependencies: 229 229
-- Name: pk_user_wmc; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_user_wmc
    ADD CONSTRAINT pk_user_wmc PRIMARY KEY (wmc_serial_id);


--
-- TOC entry 4272 (class 2606 OID 18819)
-- Dependencies: 246 246
-- Name: pk_wfs_conf_element_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wfs_conf_element
    ADD CONSTRAINT pk_wfs_conf_element_id PRIMARY KEY (wfs_conf_element_id);


--
-- TOC entry 4270 (class 2606 OID 18821)
-- Dependencies: 245 245
-- Name: pk_wfs_conf_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wfs_conf
    ADD CONSTRAINT pk_wfs_conf_id PRIMARY KEY (wfs_conf_id);


--
-- TOC entry 4274 (class 2606 OID 18823)
-- Dependencies: 249 249 249
-- Name: pk_wfs_element; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wfs_element
    ADD CONSTRAINT pk_wfs_element PRIMARY KEY (fkey_featuretype_id, element_id);


--
-- TOC entry 4268 (class 2606 OID 18825)
-- Dependencies: 244 244
-- Name: pk_wfs_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wfs
    ADD CONSTRAINT pk_wfs_id PRIMARY KEY (wfs_id);


--
-- TOC entry 4282 (class 2606 OID 18827)
-- Dependencies: 262 262 262
-- Name: pk_wmc_keyword; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wmc_keyword
    ADD CONSTRAINT pk_wmc_keyword PRIMARY KEY (fkey_wmc_serial_id, fkey_keyword_id);


--
-- TOC entry 4290 (class 2606 OID 18829)
-- Dependencies: 267 267 267 267
-- Name: pk_wms_format; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wms_format
    ADD CONSTRAINT pk_wms_format PRIMARY KEY (fkey_wms_id, data_type, data_format);


--
-- TOC entry 4288 (class 2606 OID 18831)
-- Dependencies: 266 266
-- Name: pk_wms_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wms
    ADD CONSTRAINT pk_wms_id PRIMARY KEY (wms_id);


--
-- TOC entry 4294 (class 2606 OID 18833)
-- Dependencies: 269 269 269
-- Name: pk_wms_srs; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wms_srs
    ADD CONSTRAINT pk_wms_srs PRIMARY KEY (fkey_wms_id, wms_srs);


--
-- TOC entry 4187 (class 2606 OID 18835)
-- Dependencies: 173 173
-- Name: relation_id_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY conformity_relation
    ADD CONSTRAINT relation_id_pkey PRIMARY KEY (relation_id);


--
-- TOC entry 4245 (class 2606 OID 18837)
-- Dependencies: 222 222
-- Name: role_id; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY mb_role
    ADD CONSTRAINT role_id PRIMARY KEY (role_id);


--
-- TOC entry 4259 (class 2606 OID 18839)
-- Dependencies: 238 238
-- Name: spec_class_id_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY spec_classification
    ADD CONSTRAINT spec_class_id_pkey PRIMARY KEY (spec_class_id);


--
-- TOC entry 4261 (class 2606 OID 18841)
-- Dependencies: 238 238
-- Name: spec_classification_spec_class_key_key; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY spec_classification
    ADD CONSTRAINT spec_classification_spec_class_key_key UNIQUE (spec_class_key);


--
-- TOC entry 4257 (class 2606 OID 18843)
-- Dependencies: 237 237
-- Name: spec_id_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY spec
    ADD CONSTRAINT spec_id_pkey PRIMARY KEY (spec_id);


--
-- TOC entry 4263 (class 2606 OID 18845)
-- Dependencies: 241 241
-- Name: termsofuse_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY termsofuse
    ADD CONSTRAINT termsofuse_pkey PRIMARY KEY (termsofuse_id);


--
-- TOC entry 4266 (class 2606 OID 18847)
-- Dependencies: 242 242
-- Name: translations_pkey; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY translations
    ADD CONSTRAINT translations_pkey PRIMARY KEY (trs_id);


--
-- TOC entry 4276 (class 2606 OID 18849)
-- Dependencies: 249 249
-- Name: wfs_element_element_id_key; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wfs_element
    ADD CONSTRAINT wfs_element_element_id_key UNIQUE (element_id);


--
-- TOC entry 4285 (class 2606 OID 18851)
-- Dependencies: 265 265
-- Name: wmc_fkey_layer_id_key; Type: CONSTRAINT; Schema: mapbender; Owner: mapbender; Tablespace: 
--

ALTER TABLE ONLY wmc_preview
    ADD CONSTRAINT wmc_fkey_layer_id_key UNIQUE (fkey_wmc_serial_id);


--
-- TOC entry 4283 (class 1259 OID 18854)
-- Dependencies: 263
-- Name: idx_fkey_wmc_serial_id; Type: INDEX; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE INDEX idx_fkey_wmc_serial_id ON wmc_load_count USING btree (fkey_wmc_serial_id);


--
-- TOC entry 4240 (class 1259 OID 18855)
-- Dependencies: 220
-- Name: idx_mb_monitor_status; Type: INDEX; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE INDEX idx_mb_monitor_status ON mb_monitor USING btree (status);


--
-- TOC entry 4241 (class 1259 OID 18856)
-- Dependencies: 220
-- Name: idx_mb_monitor_upload_id; Type: INDEX; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE INDEX idx_mb_monitor_upload_id ON mb_monitor USING btree (upload_id);


--
-- TOC entry 4286 (class 1259 OID 18857)
-- Dependencies: 266
-- Name: idx_wms_id; Type: INDEX; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE INDEX idx_wms_id ON wms USING btree (wms_id);


--
-- TOC entry 4222 (class 1259 OID 18858)
-- Dependencies: 202
-- Name: ind_keyword; Type: INDEX; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE INDEX ind_keyword ON keyword USING btree (keyword);


--
-- TOC entry 4237 (class 1259 OID 18859)
-- Dependencies: 2805 218
-- Name: mb_metadata_ix; Type: INDEX; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE INDEX mb_metadata_ix ON mb_metadata USING gist (the_geom);

ALTER TABLE mb_metadata CLUSTER ON mb_metadata_ix;


--
-- TOC entry 4264 (class 1259 OID 18860)
-- Dependencies: 242
-- Name: msgid_idx; Type: INDEX; Schema: mapbender; Owner: mapbender; Tablespace: 
--

CREATE INDEX msgid_idx ON translations USING btree (msgid);


--
-- TOC entry 4389 (class 2620 OID 18861)
-- Dependencies: 220 314
-- Name: mb_monitor_after; Type: TRIGGER; Schema: mapbender; Owner: mapbender
--

CREATE TRIGGER mb_monitor_after AFTER INSERT OR UPDATE ON mb_monitor FOR EACH ROW EXECUTE PROCEDURE mb_monitor_after();


--
-- TOC entry 4388 (class 2620 OID 18862)
-- Dependencies: 218 315
-- Name: update_mb_metadata_lastchanged; Type: TRIGGER; Schema: mapbender; Owner: mapbender
--

CREATE TRIGGER update_mb_metadata_lastchanged BEFORE UPDATE ON mb_metadata FOR EACH ROW EXECUTE PROCEDURE update_lastchanged_column();


--
-- TOC entry 4298 (class 2606 OID 18863)
-- Dependencies: 171 173 4184
-- Name: conformity_relation_conformity_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY conformity_relation
    ADD CONSTRAINT conformity_relation_conformity_fkey FOREIGN KEY (fkey_conformity_id) REFERENCES conformity(conformity_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4299 (class 2606 OID 18868)
-- Dependencies: 200 173 4220
-- Name: conformity_relation_inspire_md_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY conformity_relation
    ADD CONSTRAINT conformity_relation_inspire_md_fkey FOREIGN KEY (fkey_inspire_md_id) REFERENCES inspire_md_data(data_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4300 (class 2606 OID 18873)
-- Dependencies: 4256 237 173
-- Name: conformity_relation_spec_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY conformity_relation
    ADD CONSTRAINT conformity_relation_spec_fkey FOREIGN KEY (fkey_spec_id) REFERENCES spec(spec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4301 (class 2606 OID 18878)
-- Dependencies: 4267 173 244
-- Name: conformity_relation_wfs_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY conformity_relation
    ADD CONSTRAINT conformity_relation_wfs_id_fkey FOREIGN KEY (fkey_wfs_id) REFERENCES wfs(wfs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4302 (class 2606 OID 18883)
-- Dependencies: 173 266 4287
-- Name: conformity_relation_wms_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY conformity_relation
    ADD CONSTRAINT conformity_relation_wms_id_fkey FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4306 (class 2606 OID 18888)
-- Dependencies: 180 4190 177
-- Name: datalink_md_topic_category_fkey_datalink_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY datalink_md_topic_category
    ADD CONSTRAINT datalink_md_topic_category_fkey_datalink_id_fkey FOREIGN KEY (fkey_datalink_id) REFERENCES datalink(datalink_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4307 (class 2606 OID 18893)
-- Dependencies: 4252 231 180
-- Name: datalink_md_topic_category_fkey_md_topic_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY datalink_md_topic_category
    ADD CONSTRAINT datalink_md_topic_category_fkey_md_topic_category_id_fkey FOREIGN KEY (fkey_md_topic_category_id) REFERENCES md_topic_category(md_topic_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4303 (class 2606 OID 18898)
-- Dependencies: 177 4246 224
-- Name: datalink_owner_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY datalink
    ADD CONSTRAINT datalink_owner_fkey FOREIGN KEY (datalink_owner) REFERENCES mb_user(mb_user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4297 (class 2606 OID 18903)
-- Dependencies: 4178 170 167
-- Name: fk_cat_conf_to_cat; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY cat_op_conf
    ADD CONSTRAINT fk_cat_conf_to_cat FOREIGN KEY (fk_cat_id) REFERENCES cat(cat_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4308 (class 2606 OID 18908)
-- Dependencies: 167 4178 182
-- Name: fkey_cat_cat_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_cat
    ADD CONSTRAINT fkey_cat_cat_id FOREIGN KEY (fkey_cat_id) REFERENCES cat(cat_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4309 (class 2606 OID 18913)
-- Dependencies: 181 4194 182
-- Name: fkey_cat_gui_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_cat
    ADD CONSTRAINT fkey_cat_gui_id FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4295 (class 2606 OID 18918)
-- Dependencies: 169 4178 167
-- Name: fkey_cat_id_fkey_keyword_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY cat_keyword
    ADD CONSTRAINT fkey_cat_id_fkey_keyword_id FOREIGN KEY (fkey_cat_id) REFERENCES cat(cat_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4304 (class 2606 OID 18923)
-- Dependencies: 4190 179 177
-- Name: fkey_datalink_id_fkey_keyword_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY datalink_keyword
    ADD CONSTRAINT fkey_datalink_id_fkey_keyword_id FOREIGN KEY (fkey_datalink_id) REFERENCES datalink(datalink_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4368 (class 2606 OID 18928)
-- Dependencies: 251 255 4277
-- Name: fkey_featuretype_id_fkey_keyword_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_keyword
    ADD CONSTRAINT fkey_featuretype_id_fkey_keyword_id FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4296 (class 2606 OID 18933)
-- Dependencies: 169 4225 202
-- Name: fkey_keyword_id_fkey_cat_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY cat_keyword
    ADD CONSTRAINT fkey_keyword_id_fkey_cat_id FOREIGN KEY (fkey_keyword_id) REFERENCES keyword(keyword_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4305 (class 2606 OID 18938)
-- Dependencies: 4225 202 179
-- Name: fkey_keyword_id_fkey_datalink_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY datalink_keyword
    ADD CONSTRAINT fkey_keyword_id_fkey_datalink_id FOREIGN KEY (fkey_keyword_id) REFERENCES keyword(keyword_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4369 (class 2606 OID 18943)
-- Dependencies: 4225 255 202
-- Name: fkey_keyword_id_fkey_featuretype_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_keyword
    ADD CONSTRAINT fkey_keyword_id_fkey_featuretype_id FOREIGN KEY (fkey_keyword_id) REFERENCES keyword(keyword_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4335 (class 2606 OID 18948)
-- Dependencies: 202 208 4225
-- Name: fkey_keyword_id_fkey_layer_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_keyword
    ADD CONSTRAINT fkey_keyword_id_fkey_layer_id FOREIGN KEY (fkey_keyword_id) REFERENCES keyword(keyword_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4340 (class 2606 OID 18953)
-- Dependencies: 212 4227 204
-- Name: fkey_layer_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_preview
    ADD CONSTRAINT fkey_layer_id FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4336 (class 2606 OID 18958)
-- Dependencies: 4227 208 204
-- Name: fkey_layer_id_fkey_keyword_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_keyword
    ADD CONSTRAINT fkey_layer_id_fkey_keyword_id FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4346 (class 2606 OID 18963)
-- Dependencies: 4246 226 224
-- Name: fkey_mb_user_mb_group_mb_use_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user_mb_group
    ADD CONSTRAINT fkey_mb_user_mb_group_mb_use_id FOREIGN KEY (fkey_mb_user_id) REFERENCES mb_user(mb_user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4347 (class 2606 OID 18968)
-- Dependencies: 222 226 4244
-- Name: fkey_mb_user_mb_group_role_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user_mb_group
    ADD CONSTRAINT fkey_mb_user_mb_group_role_id FOREIGN KEY (mb_user_mb_group_type) REFERENCES mb_role(role_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4342 (class 2606 OID 18973)
-- Dependencies: 4287 220 266
-- Name: fkey_monitor_wms_id_wms_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_monitor
    ADD CONSTRAINT fkey_monitor_wms_id_wms_id FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4310 (class 2606 OID 18978)
-- Dependencies: 181 4194 185
-- Name: gui_element_ibfk1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_element
    ADD CONSTRAINT gui_element_ibfk1 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4311 (class 2606 OID 18983)
-- Dependencies: 185 4198 185 186 186
-- Name: gui_element_vars_ibfk1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_element_vars
    ADD CONSTRAINT gui_element_vars_ibfk1 FOREIGN KEY (fkey_gui_id, fkey_e_id) REFERENCES gui_element(fkey_gui_id, e_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4312 (class 2606 OID 18988)
-- Dependencies: 4196 183 187
-- Name: gui_gui_category_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_gui_category
    ADD CONSTRAINT gui_gui_category_ibfk_1 FOREIGN KEY (fkey_gui_category_id) REFERENCES gui_category(category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4313 (class 2606 OID 18993)
-- Dependencies: 4194 187 181
-- Name: gui_gui_category_ibfk_2; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_gui_category
    ADD CONSTRAINT gui_gui_category_ibfk_2 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4314 (class 2606 OID 18998)
-- Dependencies: 4246 188 224
-- Name: gui_kml_fkey_mb_user_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_kml
    ADD CONSTRAINT gui_kml_fkey_mb_user_id FOREIGN KEY (fkey_mb_user_id) REFERENCES mb_user(mb_user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4315 (class 2606 OID 19003)
-- Dependencies: 188 181 4194
-- Name: gui_kml_id_fkey_gui_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_kml
    ADD CONSTRAINT gui_kml_id_fkey_gui_id FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4318 (class 2606 OID 19008)
-- Dependencies: 4194 181 191
-- Name: gui_mb_group_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_mb_group
    ADD CONSTRAINT gui_mb_group_ibfk_1 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4319 (class 2606 OID 19013)
-- Dependencies: 191 214 4233
-- Name: gui_mb_group_ibfk_2; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_mb_group
    ADD CONSTRAINT gui_mb_group_ibfk_2 FOREIGN KEY (fkey_mb_group_id) REFERENCES mb_group(mb_group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4320 (class 2606 OID 19018)
-- Dependencies: 181 4194 192
-- Name: gui_mb_user_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_mb_user
    ADD CONSTRAINT gui_mb_user_ibfk_1 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4321 (class 2606 OID 19023)
-- Dependencies: 224 4246 192
-- Name: gui_mb_user_ibfk_2; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_mb_user
    ADD CONSTRAINT gui_mb_user_ibfk_2 FOREIGN KEY (fkey_mb_user_id) REFERENCES mb_user(mb_user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4322 (class 2606 OID 19028)
-- Dependencies: 193 4194 181
-- Name: gui_treegde_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_treegde
    ADD CONSTRAINT gui_treegde_ibfk_1 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4325 (class 2606 OID 19033)
-- Dependencies: 181 4194 196
-- Name: gui_wfs_conf_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_wfs_conf
    ADD CONSTRAINT gui_wfs_conf_ibfk_1 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4326 (class 2606 OID 19038)
-- Dependencies: 196 4269 245
-- Name: gui_wfs_conf_ibfk_2; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_wfs_conf
    ADD CONSTRAINT gui_wfs_conf_ibfk_2 FOREIGN KEY (fkey_wfs_conf_id) REFERENCES wfs_conf(wfs_conf_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4323 (class 2606 OID 19043)
-- Dependencies: 195 4194 181
-- Name: gui_wfs_ibfk_3; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_wfs
    ADD CONSTRAINT gui_wfs_ibfk_3 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4324 (class 2606 OID 19048)
-- Dependencies: 195 4267 244
-- Name: gui_wfs_ibfk_4; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_wfs
    ADD CONSTRAINT gui_wfs_ibfk_4 FOREIGN KEY (fkey_wfs_id) REFERENCES wfs(wfs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4327 (class 2606 OID 19053)
-- Dependencies: 181 197 4194
-- Name: gui_wms_ibfk_3; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_wms
    ADD CONSTRAINT gui_wms_ibfk_3 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4328 (class 2606 OID 19058)
-- Dependencies: 4287 197 266
-- Name: gui_wms_ibfk_4; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_wms
    ADD CONSTRAINT gui_wms_ibfk_4 FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4330 (class 2606 OID 19063)
-- Dependencies: 4188 175 205
-- Name: layer_custom_category_fkey_custom_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_custom_category
    ADD CONSTRAINT layer_custom_category_fkey_custom_category_id_fkey FOREIGN KEY (fkey_custom_category_id) REFERENCES custom_category(custom_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4331 (class 2606 OID 19068)
-- Dependencies: 205 4227 204
-- Name: layer_custom_category_fkey_layer_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_custom_category
    ADD CONSTRAINT layer_custom_category_fkey_layer_id_fkey FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4332 (class 2606 OID 19073)
-- Dependencies: 204 4227 206
-- Name: layer_epsg_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_epsg
    ADD CONSTRAINT layer_epsg_ibfk_1 FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4329 (class 2606 OID 19078)
-- Dependencies: 4287 266 204
-- Name: layer_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer
    ADD CONSTRAINT layer_ibfk_1 FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4333 (class 2606 OID 19083)
-- Dependencies: 198 207 4218
-- Name: layer_inspire_category_fkey_inspire_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_inspire_category
    ADD CONSTRAINT layer_inspire_category_fkey_inspire_category_id_fkey FOREIGN KEY (fkey_inspire_category_id) REFERENCES inspire_category(inspire_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4334 (class 2606 OID 19088)
-- Dependencies: 204 4227 207
-- Name: layer_inspire_category_fkey_layer_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_inspire_category
    ADD CONSTRAINT layer_inspire_category_fkey_layer_id_fkey FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4337 (class 2606 OID 19093)
-- Dependencies: 204 4227 210
-- Name: layer_load_count_fkey_layer_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_load_count
    ADD CONSTRAINT layer_load_count_fkey_layer_id_fkey FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4338 (class 2606 OID 19098)
-- Dependencies: 4227 204 211
-- Name: layer_md_topic_category_fkey_layer_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_md_topic_category
    ADD CONSTRAINT layer_md_topic_category_fkey_layer_id_fkey FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4339 (class 2606 OID 19103)
-- Dependencies: 4252 231 211
-- Name: layer_md_topic_category_fkey_md_topic_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_md_topic_category
    ADD CONSTRAINT layer_md_topic_category_fkey_md_topic_category_id_fkey FOREIGN KEY (fkey_md_topic_category_id) REFERENCES md_topic_category(md_topic_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4341 (class 2606 OID 19108)
-- Dependencies: 4227 213 204
-- Name: layer_style_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY layer_style
    ADD CONSTRAINT layer_style_ibfk_1 FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4343 (class 2606 OID 19113)
-- Dependencies: 225 4246 224
-- Name: mb_user_abo_ows_user_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user_abo_ows
    ADD CONSTRAINT mb_user_abo_ows_user_id_fkey FOREIGN KEY (fkey_mb_user_id) REFERENCES mb_user(mb_user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4344 (class 2606 OID 19118)
-- Dependencies: 225 4267 244
-- Name: mb_user_abo_ows_wfs_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user_abo_ows
    ADD CONSTRAINT mb_user_abo_ows_wfs_fkey FOREIGN KEY (fkey_wfs_id) REFERENCES wfs(wfs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4345 (class 2606 OID 19123)
-- Dependencies: 225 266 4287
-- Name: mb_user_abo_ows_wms_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user_abo_ows
    ADD CONSTRAINT mb_user_abo_ows_wms_fkey FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4348 (class 2606 OID 19128)
-- Dependencies: 226 214 4233
-- Name: mb_user_mb_group_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user_mb_group
    ADD CONSTRAINT mb_user_mb_group_ibfk_1 FOREIGN KEY (fkey_mb_group_id) REFERENCES mb_group(mb_group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4349 (class 2606 OID 19133)
-- Dependencies: 224 4246 229
-- Name: mb_user_wmc_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_user_wmc
    ADD CONSTRAINT mb_user_wmc_ibfk_1 FOREIGN KEY (fkey_user_id) REFERENCES mb_user(mb_user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4350 (class 2606 OID 19138)
-- Dependencies: 266 4287 230
-- Name: mb_wms_availability_fkey_wms_id_wms_id; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY mb_wms_availability
    ADD CONSTRAINT mb_wms_availability_fkey_wms_id_wms_id FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4351 (class 2606 OID 19143)
-- Dependencies: 233 4277 251
-- Name: ows_relation_metadata_fkey_featuretype_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY ows_relation_metadata
    ADD CONSTRAINT ows_relation_metadata_fkey_featuretype_id_fkey FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4352 (class 2606 OID 19148)
-- Dependencies: 4227 233 204
-- Name: ows_relation_metadata_fkey_layer_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY ows_relation_metadata
    ADD CONSTRAINT ows_relation_metadata_fkey_layer_id_fkey FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4353 (class 2606 OID 19153)
-- Dependencies: 218 4238 233
-- Name: ows_relation_metadata_fkey_metadata_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY ows_relation_metadata
    ADD CONSTRAINT ows_relation_metadata_fkey_metadata_id_fkey FOREIGN KEY (fkey_metadata_id) REFERENCES mb_metadata(metadata_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4316 (class 2606 OID 19158)
-- Dependencies: 190 181 4194
-- Name: pk_gui_layer_ifbk3; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_layer
    ADD CONSTRAINT pk_gui_layer_ifbk3 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4317 (class 2606 OID 19163)
-- Dependencies: 4227 204 190
-- Name: pk_gui_layer_ifbk4; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY gui_layer
    ADD CONSTRAINT pk_gui_layer_ifbk4 FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4354 (class 2606 OID 19168)
-- Dependencies: 4246 224 235
-- Name: sld_user_layer_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY sld_user_layer
    ADD CONSTRAINT sld_user_layer_ibfk_1 FOREIGN KEY (fkey_mb_user_id) REFERENCES mb_user(mb_user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4355 (class 2606 OID 19173)
-- Dependencies: 4227 235 204
-- Name: sld_user_layer_ibfk_2; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY sld_user_layer
    ADD CONSTRAINT sld_user_layer_ibfk_2 FOREIGN KEY (fkey_layer_id) REFERENCES layer(layer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4356 (class 2606 OID 19178)
-- Dependencies: 4194 235 181
-- Name: sld_user_layer_ibfk_3; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY sld_user_layer
    ADD CONSTRAINT sld_user_layer_ibfk_3 FOREIGN KEY (fkey_gui_id) REFERENCES gui(gui_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4357 (class 2606 OID 19183)
-- Dependencies: 4260 238 237
-- Name: spec_spec_class_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY spec
    ADD CONSTRAINT spec_spec_class_fkey FOREIGN KEY (fkey_spec_class_key) REFERENCES spec_classification(spec_class_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4360 (class 2606 OID 19188)
-- Dependencies: 245 246 4269
-- Name: wfs_conf_element_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_conf_element
    ADD CONSTRAINT wfs_conf_element_ibfk_1 FOREIGN KEY (fkey_wfs_conf_id) REFERENCES wfs_conf(wfs_conf_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4361 (class 2606 OID 19193)
-- Dependencies: 4275 249 246
-- Name: wfs_conf_element_id_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_conf_element
    ADD CONSTRAINT wfs_conf_element_id_ibfk_1 FOREIGN KEY (f_id) REFERENCES wfs_element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4358 (class 2606 OID 19198)
-- Dependencies: 244 245 4267
-- Name: wfs_conf_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_conf
    ADD CONSTRAINT wfs_conf_ibfk_1 FOREIGN KEY (fkey_wfs_id) REFERENCES wfs(wfs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4359 (class 2606 OID 19203)
-- Dependencies: 4277 245 251
-- Name: wfs_conf_ibfk_2; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_conf
    ADD CONSTRAINT wfs_conf_ibfk_2 FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4362 (class 2606 OID 19208)
-- Dependencies: 4277 249 251
-- Name: wfs_element_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_element
    ADD CONSTRAINT wfs_element_ibfk_1 FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4364 (class 2606 OID 19213)
-- Dependencies: 175 4188 252
-- Name: wfs_featuretype_custom_category_fkey_custom_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_custom_category
    ADD CONSTRAINT wfs_featuretype_custom_category_fkey_custom_category_id_fkey FOREIGN KEY (fkey_custom_category_id) REFERENCES custom_category(custom_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4365 (class 2606 OID 19218)
-- Dependencies: 251 252 4277
-- Name: wfs_featuretype_custom_category_fkey_featuretype_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_custom_category
    ADD CONSTRAINT wfs_featuretype_custom_category_fkey_featuretype_id_fkey FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4363 (class 2606 OID 19223)
-- Dependencies: 251 244 4267
-- Name: wfs_featuretype_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype
    ADD CONSTRAINT wfs_featuretype_ibfk_1 FOREIGN KEY (fkey_wfs_id) REFERENCES wfs(wfs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4366 (class 2606 OID 19228)
-- Dependencies: 4277 251 254
-- Name: wfs_featuretype_inspire_category_fkey_featuretype_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_inspire_category
    ADD CONSTRAINT wfs_featuretype_inspire_category_fkey_featuretype_id_fkey FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4367 (class 2606 OID 19233)
-- Dependencies: 198 4218 254
-- Name: wfs_featuretype_inspire_category_fkey_inspire_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_inspire_category
    ADD CONSTRAINT wfs_featuretype_inspire_category_fkey_inspire_category_id_fkey FOREIGN KEY (fkey_inspire_category_id) REFERENCES inspire_category(inspire_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4370 (class 2606 OID 19238)
-- Dependencies: 251 4277 256
-- Name: wfs_featuretype_md_topic_category_fkey_featuretype_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_md_topic_category
    ADD CONSTRAINT wfs_featuretype_md_topic_category_fkey_featuretype_id_fkey FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4371 (class 2606 OID 19243)
-- Dependencies: 4252 256 231
-- Name: wfs_featuretype_md_topic_category_fkey_md_topic_cat_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_md_topic_category
    ADD CONSTRAINT wfs_featuretype_md_topic_category_fkey_md_topic_cat_id_fkey FOREIGN KEY (fkey_md_topic_category_id) REFERENCES md_topic_category(md_topic_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4372 (class 2606 OID 19248)
-- Dependencies: 257 4277 251
-- Name: wfs_featuretype_namespace_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_namespace
    ADD CONSTRAINT wfs_featuretype_namespace_ibfk_1 FOREIGN KEY (fkey_featuretype_id) REFERENCES wfs_featuretype(featuretype_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4373 (class 2606 OID 19253)
-- Dependencies: 257 244 4267
-- Name: wfs_featuretype_namespace_ibfk_2; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_featuretype_namespace
    ADD CONSTRAINT wfs_featuretype_namespace_ibfk_2 FOREIGN KEY (fkey_wfs_id) REFERENCES wfs(wfs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4374 (class 2606 OID 19258)
-- Dependencies: 258 244 4267
-- Name: wfs_termsofuse_fkey_wfs_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_termsofuse
    ADD CONSTRAINT wfs_termsofuse_fkey_wfs_id_fkey FOREIGN KEY (fkey_wfs_id) REFERENCES wfs(wfs_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4375 (class 2606 OID 19263)
-- Dependencies: 241 4262 258
-- Name: wfs_termsofuse_termsofuse_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wfs_termsofuse
    ADD CONSTRAINT wfs_termsofuse_termsofuse_fkey FOREIGN KEY (fkey_termsofuse_id) REFERENCES termsofuse(termsofuse_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4376 (class 2606 OID 19268)
-- Dependencies: 175 4188 260
-- Name: wmc_custom_category_fkey_custom_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wmc_custom_category
    ADD CONSTRAINT wmc_custom_category_fkey_custom_category_id_fkey FOREIGN KEY (fkey_custom_category_id) REFERENCES custom_category(custom_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4377 (class 2606 OID 19273)
-- Dependencies: 261 198 4218
-- Name: wmc_inspire_category_fkey_inspire_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wmc_inspire_category
    ADD CONSTRAINT wmc_inspire_category_fkey_inspire_category_id_fkey FOREIGN KEY (fkey_inspire_category_id) REFERENCES inspire_category(inspire_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4378 (class 2606 OID 19278)
-- Dependencies: 202 262 4225
-- Name: wmc_keyword_fkey_keyword_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wmc_keyword
    ADD CONSTRAINT wmc_keyword_fkey_keyword_id_fkey FOREIGN KEY (fkey_keyword_id) REFERENCES keyword(keyword_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4379 (class 2606 OID 19283)
-- Dependencies: 229 262 4250
-- Name: wmc_keyword_fkey_wmc_serial_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wmc_keyword
    ADD CONSTRAINT wmc_keyword_fkey_wmc_serial_id_fkey FOREIGN KEY (fkey_wmc_serial_id) REFERENCES mb_user_wmc(wmc_serial_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4380 (class 2606 OID 19288)
-- Dependencies: 231 4252 264
-- Name: wmc_topic_category_fkey_md_topic_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wmc_md_topic_category
    ADD CONSTRAINT wmc_topic_category_fkey_md_topic_category_id_fkey FOREIGN KEY (fkey_md_topic_category_id) REFERENCES md_topic_category(md_topic_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4381 (class 2606 OID 19293)
-- Dependencies: 229 4250 264
-- Name: wmc_topic_category_fkey_wmc_serial_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wmc_md_topic_category
    ADD CONSTRAINT wmc_topic_category_fkey_wmc_serial_id_fkey FOREIGN KEY (fkey_wmc_serial_id) REFERENCES mb_user_wmc(wmc_serial_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4382 (class 2606 OID 19298)
-- Dependencies: 266 4287 267
-- Name: wms_format_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wms_format
    ADD CONSTRAINT wms_format_ibfk_1 FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4383 (class 2606 OID 19303)
-- Dependencies: 4252 231 268
-- Name: wms_md_topic_category_fkey_md_topic_category_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wms_md_topic_category
    ADD CONSTRAINT wms_md_topic_category_fkey_md_topic_category_id_fkey FOREIGN KEY (fkey_md_topic_category_id) REFERENCES md_topic_category(md_topic_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4384 (class 2606 OID 19308)
-- Dependencies: 4287 266 268
-- Name: wms_md_topic_category_fkey_wms_id_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wms_md_topic_category
    ADD CONSTRAINT wms_md_topic_category_fkey_wms_id_fkey FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4385 (class 2606 OID 19313)
-- Dependencies: 269 4287 266
-- Name: wms_srs_ibfk_1; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wms_srs
    ADD CONSTRAINT wms_srs_ibfk_1 FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4386 (class 2606 OID 19318)
-- Dependencies: 4262 241 270
-- Name: wms_termsofuse_termsofuse_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wms_termsofuse
    ADD CONSTRAINT wms_termsofuse_termsofuse_fkey FOREIGN KEY (fkey_termsofuse_id) REFERENCES termsofuse(termsofuse_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4387 (class 2606 OID 19323)
-- Dependencies: 266 4287 270
-- Name: wms_termsofuse_wms_fkey; Type: FK CONSTRAINT; Schema: mapbender; Owner: mapbender
--

ALTER TABLE ONLY wms_termsofuse
    ADD CONSTRAINT wms_termsofuse_wms_fkey FOREIGN KEY (fkey_wms_id) REFERENCES wms(wms_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4468 (class 0 OID 0)
-- Dependencies: 6
-- Name: mapbender; Type: ACL; Schema: -; Owner: mapbender
--

REVOKE ALL ON SCHEMA mapbender FROM PUBLIC;
REVOKE ALL ON SCHEMA mapbender FROM mapbender;
GRANT ALL ON SCHEMA mapbender TO mapbender;
GRANT USAGE ON SCHEMA mapbender TO PUBLIC;


-- Completed on 2013-09-10 14:42:16

--
-- PostgreSQL database dump complete
--

