--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: road_sections; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE road_sections (
    id integer NOT NULL,
    road_id integer,
    ign_route_id integer,
    number_begin integer,
    number_end integer
);


ALTER TABLE public.road_sections OWNER TO agilis;

--
-- Name: address_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE address_sections_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.address_sections_id_seq OWNER TO agilis;

--
-- Name: address_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE address_sections_id_seq OWNED BY road_sections.id;


--
-- Name: address_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('address_sections_id_seq', 220, true);


--
-- Name: roads; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE roads (
    id integer NOT NULL,
    name character varying(255),
    number_begin integer,
    number_end integer,
    city_id integer
);


ALTER TABLE public.roads OWNER TO agilis;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE addresses_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO agilis;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE addresses_id_seq OWNED BY roads.id;


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('addresses_id_seq', 308, true);


--
-- Name: cities; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying(255),
    upcase_name character varying(255),
    zip_code integer,
    insee_code integer,
    region_code integer,
    lat numeric(19,16),
    lng numeric(19,16),
    eloignement double precision
);


ALTER TABLE public.cities OWNER TO agilis;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE cities_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cities_id_seq OWNER TO agilis;

--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('cities_id_seq', 37029, true);


--
-- Name: connectionlink; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE connectionlink (
    id integer NOT NULL,
    departureid bigint,
    arrivalid bigint,
    objectid character varying(255),
    objectversion integer,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    name character varying(255),
    comment character varying(255),
    linkdistance numeric(19,2),
    linktype character varying(255),
    defaultduration timestamp without time zone,
    frequenttravellerduration timestamp without time zone,
    occasionaltravellerduration timestamp without time zone,
    mobilityrestrictedtravellerduration timestamp without time zone,
    mobilityrestrictedsuitability boolean,
    stairsavailability boolean,
    liftavailability boolean
);


ALTER TABLE public.connectionlink OWNER TO agilis;

--
-- Name: connectionlink_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE connectionlink_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.connectionlink_id_seq OWNER TO agilis;

--
-- Name: connectionlink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE connectionlink_id_seq OWNED BY connectionlink.id;


--
-- Name: connectionlink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('connectionlink_id_seq', 1, false);


--
-- Name: geocoder_locations; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE geocoder_locations (
    id integer NOT NULL,
    name character varying(255),
    zone_id integer,
    stored_words character varying(255),
    stored_phonetics character varying(255),
    reference_id integer,
    reference_type character varying(255)
);


ALTER TABLE public.geocoder_locations OWNER TO agilis;

--
-- Name: geocoder_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE geocoder_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.geocoder_locations_id_seq OWNER TO agilis;

--
-- Name: geocoder_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE geocoder_locations_id_seq OWNED BY geocoder_locations.id;


--
-- Name: geocoder_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('geocoder_locations_id_seq', 1, false);


--
-- Name: geocoder_zones; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE geocoder_zones (
    id integer NOT NULL,
    name character varying(255),
    uid integer,
    stored_words character varying(255),
    zip_code character varying(255)
);


ALTER TABLE public.geocoder_zones OWNER TO agilis;

--
-- Name: geocoder_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE geocoder_zones_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.geocoder_zones_id_seq OWNER TO agilis;

--
-- Name: geocoder_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE geocoder_zones_id_seq OWNED BY geocoder_zones.id;


--
-- Name: geocoder_zones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('geocoder_zones_id_seq', 154, true);


--
-- Name: ign_routes; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE ign_routes (
    gid integer NOT NULL,
    nb_voies integer,
    pos_sol integer,
    prec_plani double precision,
    prec_alti double precision,
    largeur double precision,
    z_ini double precision,
    z_fin double precision,
    id character varying(255),
    nature character varying(255),
    numero character varying(255),
    importance character varying(255),
    cl_admin character varying(255),
    gestion character varying(255),
    mise_serv character varying(255),
    it_vert character varying(255),
    it_europ character varying(255),
    fictif character varying(255),
    franchisst character varying(255),
    nom_iti character varying(255),
    sens character varying(255),
    typ_adres character varying(255),
    etat character varying(255),
    nom_rue_g character varying(255),
    nom_rue_d character varying(255),
    inseecom_g character varying(255),
    inseecom_d character varying(255),
    codevoie_g character varying(255),
    codevoie_d character varying(255),
    bornedeb_g integer,
    bornedeb_d integer,
    bornefin_g integer,
    bornefin_d integer,
    address_id integer
);


ALTER TABLE public.ign_routes OWNER TO agilis;

--
-- Name: ign_routes_gid_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE ign_routes_gid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ign_routes_gid_seq OWNER TO agilis;

--
-- Name: ign_routes_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE ign_routes_gid_seq OWNED BY ign_routes.gid;


--
-- Name: ign_routes_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('ign_routes_gid_seq', 264, true);


--
-- Name: journey_pattern_stop_points; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE journey_pattern_stop_points (
    id integer NOT NULL,
    journey_pattern_id integer,
    route_id integer,
    line_id integer,
    stop_point_id integer,
    stop_area_id integer,
    commercial_stop_area_id integer,
    "position" integer,
    terminus boolean,
    is_outward boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.journey_pattern_stop_points OWNER TO agilis;

--
-- Name: journey_pattern_stop_points_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE journey_pattern_stop_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.journey_pattern_stop_points_id_seq OWNER TO agilis;

--
-- Name: journey_pattern_stop_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE journey_pattern_stop_points_id_seq OWNED BY journey_pattern_stop_points.id;


--
-- Name: journey_pattern_stop_points_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('journey_pattern_stop_points_id_seq', 1, false);


--
-- Name: journeypattern; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE journeypattern (
    id integer NOT NULL,
    name character varying(255),
    publishedname character varying(255),
    registrationnumber character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.journeypattern OWNER TO agilis;

--
-- Name: journeypattern_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE journeypattern_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.journeypattern_id_seq OWNER TO agilis;

--
-- Name: journeypattern_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE journeypattern_id_seq OWNED BY journeypattern.id;


--
-- Name: journeypattern_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('journeypattern_id_seq', 1, false);


--
-- Name: line; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE line (
    id integer NOT NULL,
    name character varying(255),
    publishedname character varying(255),
    number character varying(255),
    registrationnumber character varying(255),
    transportmodename character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.line OWNER TO agilis;

--
-- Name: line_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.line_id_seq OWNER TO agilis;

--
-- Name: line_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE line_id_seq OWNED BY line.id;


--
-- Name: line_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('line_id_seq', 1, false);


--
-- Name: place_types; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE place_types (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.place_types OWNER TO agilis;

--
-- Name: place_types_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE place_types_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.place_types_id_seq OWNER TO agilis;

--
-- Name: place_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE place_types_id_seq OWNED BY place_types.id;


--
-- Name: place_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('place_types_id_seq', 132, true);


--
-- Name: places; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE places (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    address character varying(255),
    city_code character varying(255),
    lng numeric(19,16),
    lat numeric(19,16),
    place_type_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.places OWNER TO agilis;

--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE places_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.places_id_seq OWNER TO agilis;

--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE places_id_seq OWNED BY places.id;


--
-- Name: places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('places_id_seq', 66, true);


--
-- Name: route; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE route (
    id integer NOT NULL,
    oppositerouteid bigint,
    lineid bigint,
    name character varying(255),
    publishedname character varying(255),
    direction character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.route OWNER TO agilis;

--
-- Name: route_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.route_id_seq OWNER TO agilis;

--
-- Name: route_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE route_id_seq OWNED BY route.id;


--
-- Name: route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('route_id_seq', 1, false);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO agilis;

--
-- Name: stop_area_places; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE stop_area_places (
    id integer NOT NULL,
    stop_area_id integer,
    place_id integer,
    duration integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.stop_area_places OWNER TO agilis;

--
-- Name: stop_area_places_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE stop_area_places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.stop_area_places_id_seq OWNER TO agilis;

--
-- Name: stop_area_places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE stop_area_places_id_seq OWNED BY stop_area_places.id;


--
-- Name: stop_area_places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('stop_area_places_id_seq', 1, false);


--
-- Name: stoparea; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE stoparea (
    id integer NOT NULL,
    parentid bigint,
    objectid character varying(255),
    objectversion integer,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    name character varying(255),
    comment character varying(255),
    areatype character varying(255),
    registrationnumber character varying(255),
    nearesttopicname character varying(255),
    farecode integer,
    longitude numeric(19,16),
    latitude numeric(19,16),
    longlattype character varying(255),
    x numeric(19,2),
    y numeric(19,2),
    projectiontype character varying(255),
    countrycode character varying(255),
    streetname character varying(255),
    modes integer DEFAULT 0
);


ALTER TABLE public.stoparea OWNER TO agilis;

--
-- Name: stoparea_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE stoparea_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.stoparea_id_seq OWNER TO agilis;

--
-- Name: stoparea_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE stoparea_id_seq OWNED BY stoparea.id;


--
-- Name: stoparea_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('stoparea_id_seq', 1, false);


--
-- Name: stoppoint; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE stoppoint (
    id integer NOT NULL,
    routeid bigint,
    stopareaid bigint,
    modifie boolean,
    "position" integer,
    objectid character varying(255),
    objectversion integer,
    creationtime timestamp without time zone,
    creatorid character varying(255)
);


ALTER TABLE public.stoppoint OWNER TO agilis;

--
-- Name: stoppoint_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE stoppoint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.stoppoint_id_seq OWNER TO agilis;

--
-- Name: stoppoint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE stoppoint_id_seq OWNED BY stoppoint.id;


--
-- Name: stoppoint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('stoppoint_id_seq', 1, false);


--
-- Name: timetable; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE timetable (
    id integer NOT NULL,
    objectid character varying(255),
    objectversion integer,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    version character varying(255),
    comment character varying(255),
    intdaytypes integer DEFAULT 0
);


ALTER TABLE public.timetable OWNER TO agilis;

--
-- Name: timetable_date; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE timetable_date (
    id integer NOT NULL,
    timetableid integer NOT NULL,
    date date,
    "position" integer NOT NULL
);


ALTER TABLE public.timetable_date OWNER TO agilis;

--
-- Name: timetable_date_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE timetable_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.timetable_date_id_seq OWNER TO agilis;

--
-- Name: timetable_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE timetable_date_id_seq OWNED BY timetable_date.id;


--
-- Name: timetable_date_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('timetable_date_id_seq', 1, false);


--
-- Name: timetable_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE timetable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.timetable_id_seq OWNER TO agilis;

--
-- Name: timetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE timetable_id_seq OWNED BY timetable.id;


--
-- Name: timetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('timetable_id_seq', 1, false);


--
-- Name: timetable_period; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE timetable_period (
    id integer NOT NULL,
    timetableid integer NOT NULL,
    periodstart date,
    periodend date,
    "position" integer NOT NULL
);


ALTER TABLE public.timetable_period OWNER TO agilis;

--
-- Name: timetable_period_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE timetable_period_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.timetable_period_id_seq OWNER TO agilis;

--
-- Name: timetable_period_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE timetable_period_id_seq OWNED BY timetable_period.id;


--
-- Name: timetable_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('timetable_period_id_seq', 1, false);


--
-- Name: timetablevehiclejourney; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE timetablevehiclejourney (
    id integer NOT NULL,
    timetableid integer,
    vehiclejourneyid integer
);


ALTER TABLE public.timetablevehiclejourney OWNER TO agilis;

--
-- Name: timetablevehiclejourney_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE timetablevehiclejourney_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.timetablevehiclejourney_id_seq OWNER TO agilis;

--
-- Name: timetablevehiclejourney_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE timetablevehiclejourney_id_seq OWNED BY timetablevehiclejourney.id;


--
-- Name: timetablevehiclejourney_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('timetablevehiclejourney_id_seq', 1, false);


--
-- Name: vehiclejourney; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE vehiclejourney (
    id integer NOT NULL,
    routeid integer,
    journeypatternid integer,
    transportmode character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    vehicletypeidentifier character varying(255)
);


ALTER TABLE public.vehiclejourney OWNER TO agilis;

--
-- Name: vehiclejourney_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE vehiclejourney_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.vehiclejourney_id_seq OWNER TO agilis;

--
-- Name: vehiclejourney_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE vehiclejourney_id_seq OWNED BY vehiclejourney.id;


--
-- Name: vehiclejourney_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('vehiclejourney_id_seq', 1, false);


--
-- Name: vehiclejourneyatstop; Type: TABLE; Schema: public; Owner: agilis; Tablespace: 
--

CREATE TABLE vehiclejourneyatstop (
    id integer NOT NULL,
    vehiclejourneyid integer,
    stoppointid integer,
    arrivaltime timestamp without time zone,
    departuretime timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.vehiclejourneyatstop OWNER TO agilis;

--
-- Name: vehiclejourneyatstop_id_seq; Type: SEQUENCE; Schema: public; Owner: agilis
--

CREATE SEQUENCE vehiclejourneyatstop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.vehiclejourneyatstop_id_seq OWNER TO agilis;

--
-- Name: vehiclejourneyatstop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: agilis
--

ALTER SEQUENCE vehiclejourneyatstop_id_seq OWNED BY vehiclejourneyatstop.id;


--
-- Name: vehiclejourneyatstop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: agilis
--

SELECT pg_catalog.setval('vehiclejourneyatstop_id_seq', 1, false);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE connectionlink ALTER COLUMN id SET DEFAULT nextval('connectionlink_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE geocoder_locations ALTER COLUMN id SET DEFAULT nextval('geocoder_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE geocoder_zones ALTER COLUMN id SET DEFAULT nextval('geocoder_zones_id_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE ign_routes ALTER COLUMN gid SET DEFAULT nextval('ign_routes_gid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE journey_pattern_stop_points ALTER COLUMN id SET DEFAULT nextval('journey_pattern_stop_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE journeypattern ALTER COLUMN id SET DEFAULT nextval('journeypattern_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE line ALTER COLUMN id SET DEFAULT nextval('line_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE place_types ALTER COLUMN id SET DEFAULT nextval('place_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE places ALTER COLUMN id SET DEFAULT nextval('places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE road_sections ALTER COLUMN id SET DEFAULT nextval('address_sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE roads ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE route ALTER COLUMN id SET DEFAULT nextval('route_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE stop_area_places ALTER COLUMN id SET DEFAULT nextval('stop_area_places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE stoparea ALTER COLUMN id SET DEFAULT nextval('stoparea_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE stoppoint ALTER COLUMN id SET DEFAULT nextval('stoppoint_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE timetable ALTER COLUMN id SET DEFAULT nextval('timetable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE timetable_date ALTER COLUMN id SET DEFAULT nextval('timetable_date_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE timetable_period ALTER COLUMN id SET DEFAULT nextval('timetable_period_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE timetablevehiclejourney ALTER COLUMN id SET DEFAULT nextval('timetablevehiclejourney_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE vehiclejourney ALTER COLUMN id SET DEFAULT nextval('vehiclejourney_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: agilis
--

ALTER TABLE vehiclejourneyatstop ALTER COLUMN id SET DEFAULT nextval('vehiclejourneyatstop_id_seq'::regclass);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY cities (id, name, upcase_name, zip_code, insee_code, region_code, lat, lng, eloignement) FROM stdin;
\.


--
-- Data for Name: connectionlink; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY connectionlink (id, departureid, arrivalid, objectid, objectversion, creationtime, creatorid, name, comment, linkdistance, linktype, defaultduration, frequenttravellerduration, occasionaltravellerduration, mobilityrestrictedtravellerduration, mobilityrestrictedsuitability, stairsavailability, liftavailability) FROM stdin;
\.


--
-- Data for Name: geocoder_locations; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY geocoder_locations (id, name, zone_id, stored_words, stored_phonetics, reference_id, reference_type) FROM stdin;
\.


--
-- Data for Name: geocoder_zones; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY geocoder_zones (id, name, uid, stored_words, zip_code) FROM stdin;
\.


--
-- Data for Name: ign_routes; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY ign_routes (gid, nb_voies, pos_sol, prec_plani, prec_alti, largeur, z_ini, z_fin, id, nature, numero, importance, cl_admin, gestion, mise_serv, it_vert, it_europ, fictif, franchisst, nom_iti, sens, typ_adres, etat, nom_rue_g, nom_rue_d, inseecom_g, inseecom_d, codevoie_g, codevoie_d, bornedeb_g, bornedeb_d, bornefin_g, bornefin_d, address_id) FROM stdin;
\.


--
-- Data for Name: journey_pattern_stop_points; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY journey_pattern_stop_points (id, journey_pattern_id, route_id, line_id, stop_point_id, stop_area_id, commercial_stop_area_id, "position", terminus, is_outward, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: journeypattern; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY journeypattern (id, name, publishedname, registrationnumber, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: line; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY line (id, name, publishedname, number, registrationnumber, transportmodename, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: place_types; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY place_types (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY places (id, name, description, address, city_code, lng, lat, place_type_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: road_sections; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY road_sections (id, road_id, ign_route_id, number_begin, number_end) FROM stdin;
\.


--
-- Data for Name: roads; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY roads (id, name, number_begin, number_end, city_id) FROM stdin;
\.


--
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY route (id, oppositerouteid, lineid, name, publishedname, direction, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY schema_migrations (version) FROM stdin;
20090313134311
20090324085045
20090324085058
20090324095327
20090325130011
20090410162112
20090416123512
20090702083343
20090702121007
20090819120504
20090824155126
20090824160349
20090824160424
20090824160503
20090923095425
20091014133024
20091023133024
20091120080820
20100210161726
20100211165812
20100218100310
20100218114753
20100222164729
20100223093844
20100224170944
20100225111854
20100225162843
20100308093201
20100310161350
20100311155131
20100311160318
20100315163219
20100317155910
20100317181132
20100322160346
20100324095805
20100324095923
20100325113910
20100324113008
20100902153658
\.


--
-- Data for Name: stop_area_places; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY stop_area_places (id, stop_area_id, place_id, duration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stoparea; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY stoparea (id, parentid, objectid, objectversion, creationtime, creatorid, name, comment, areatype, registrationnumber, nearesttopicname, farecode, longitude, latitude, longlattype, x, y, projectiontype, countrycode, streetname, modes) FROM stdin;
\.


--
-- Data for Name: stoppoint; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY stoppoint (id, routeid, stopareaid, modifie, "position", objectid, objectversion, creationtime, creatorid) FROM stdin;
\.


--
-- Data for Name: timetable; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY timetable (id, objectid, objectversion, creationtime, creatorid, version, comment, intdaytypes) FROM stdin;
\.


--
-- Data for Name: timetable_date; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY timetable_date (id, timetableid, date, "position") FROM stdin;
\.


--
-- Data for Name: timetable_period; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY timetable_period (id, timetableid, periodstart, periodend, "position") FROM stdin;
\.


--
-- Data for Name: timetablevehiclejourney; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY timetablevehiclejourney (id, timetableid, vehiclejourneyid) FROM stdin;
\.


--
-- Data for Name: vehiclejourney; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY vehiclejourney (id, routeid, journeypatternid, transportmode, created_at, updated_at, vehicletypeidentifier) FROM stdin;
\.


--
-- Data for Name: vehiclejourneyatstop; Type: TABLE DATA; Schema: public; Owner: agilis
--

COPY vehiclejourneyatstop (id, vehiclejourneyid, stoppointid, arrivaltime, departuretime, created_at, updated_at) FROM stdin;
\.


--
-- Name: address_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY road_sections
    ADD CONSTRAINT address_sections_pkey PRIMARY KEY (id);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY roads
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: connectionlink_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY connectionlink
    ADD CONSTRAINT connectionlink_pkey PRIMARY KEY (id);


--
-- Name: geocoder_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY geocoder_locations
    ADD CONSTRAINT geocoder_locations_pkey PRIMARY KEY (id);


--
-- Name: geocoder_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY geocoder_zones
    ADD CONSTRAINT geocoder_zones_pkey PRIMARY KEY (id);


--
-- Name: ign_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY ign_routes
    ADD CONSTRAINT ign_routes_pkey PRIMARY KEY (gid);


--
-- Name: journey_pattern_stop_points_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY journey_pattern_stop_points
    ADD CONSTRAINT journey_pattern_stop_points_pkey PRIMARY KEY (id);


--
-- Name: journeypattern_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY journeypattern
    ADD CONSTRAINT journeypattern_pkey PRIMARY KEY (id);


--
-- Name: line_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_pkey PRIMARY KEY (id);


--
-- Name: place_types_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY place_types
    ADD CONSTRAINT place_types_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: route_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);


--
-- Name: stop_area_places_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY stop_area_places
    ADD CONSTRAINT stop_area_places_pkey PRIMARY KEY (id);


--
-- Name: stoparea_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY stoparea
    ADD CONSTRAINT stoparea_pkey PRIMARY KEY (id);


--
-- Name: stoppoint_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY stoppoint
    ADD CONSTRAINT stoppoint_pkey PRIMARY KEY (id);


--
-- Name: timetable_date_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY timetable_date
    ADD CONSTRAINT timetable_date_pkey PRIMARY KEY (id);


--
-- Name: timetable_period_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY timetable_period
    ADD CONSTRAINT timetable_period_pkey PRIMARY KEY (id);


--
-- Name: timetable_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY timetable
    ADD CONSTRAINT timetable_pkey PRIMARY KEY (id);


--
-- Name: timetablevehiclejourney_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY timetablevehiclejourney
    ADD CONSTRAINT timetablevehiclejourney_pkey PRIMARY KEY (id);


--
-- Name: vehiclejourney_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY vehiclejourney
    ADD CONSTRAINT vehiclejourney_pkey PRIMARY KEY (id);


--
-- Name: vehiclejourneyatstop_pkey; Type: CONSTRAINT; Schema: public; Owner: agilis; Tablespace: 
--

ALTER TABLE ONLY vehiclejourneyatstop
    ADD CONSTRAINT vehiclejourneyatstop_pkey PRIMARY KEY (id);


--
-- Name: connectionlink_objectid_key; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE UNIQUE INDEX connectionlink_objectid_key ON connectionlink USING btree (objectid);


--
-- Name: index_address_sections_on_address_id; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_address_sections_on_address_id ON road_sections USING btree (road_id);


--
-- Name: index_cities_on_insee_code; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_cities_on_insee_code ON cities USING btree (insee_code);


--
-- Name: index_cities_on_name; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_cities_on_name ON cities USING btree (name);


--
-- Name: index_journey_pattern_stop_points_on_commercial_stop_area_id; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_journey_pattern_stop_points_on_commercial_stop_area_id ON journey_pattern_stop_points USING btree (commercial_stop_area_id);


--
-- Name: index_journey_pattern_stop_points_on_journey_pattern_id; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_journey_pattern_stop_points_on_journey_pattern_id ON journey_pattern_stop_points USING btree (journey_pattern_id);


--
-- Name: index_journey_pattern_stop_points_on_stop_point_id; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_journey_pattern_stop_points_on_stop_point_id ON journey_pattern_stop_points USING btree (stop_point_id);


--
-- Name: index_route_on_lineid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_route_on_lineid ON route USING btree (lineid);


--
-- Name: index_stoparea_on_parentid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_stoparea_on_parentid ON stoparea USING btree (parentid);


--
-- Name: index_stoppoint_on_stopareaid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_stoppoint_on_stopareaid ON stoppoint USING btree (stopareaid);


--
-- Name: index_timetable_date_on_timetableid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_timetable_date_on_timetableid ON timetable_date USING btree (timetableid);


--
-- Name: index_timetable_period_on_timetableid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_timetable_period_on_timetableid ON timetable_period USING btree (timetableid);


--
-- Name: index_timetablevehiclejourney_on_timetableid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_timetablevehiclejourney_on_timetableid ON timetablevehiclejourney USING btree (timetableid);


--
-- Name: index_timetablevehiclejourney_on_vehiclejourneyid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_timetablevehiclejourney_on_vehiclejourneyid ON timetablevehiclejourney USING btree (vehiclejourneyid);


--
-- Name: index_vehiclejourney_on_routeid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_vehiclejourney_on_routeid ON vehiclejourney USING btree (routeid);


--
-- Name: index_vehiclejourneyatstop_on_stoppointid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_vehiclejourneyatstop_on_stoppointid ON vehiclejourneyatstop USING btree (stoppointid);


--
-- Name: index_vehiclejourneyatstop_on_vehiclejourneyid; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE INDEX index_vehiclejourneyatstop_on_vehiclejourneyid ON vehiclejourneyatstop USING btree (vehiclejourneyid);


--
-- Name: stoparea_objectid_key; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE UNIQUE INDEX stoparea_objectid_key ON stoparea USING btree (objectid);


--
-- Name: stoppoint_objectid_key; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE UNIQUE INDEX stoppoint_objectid_key ON stoppoint USING btree (objectid);


--
-- Name: timetable_objectid_key; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE UNIQUE INDEX timetable_objectid_key ON timetable USING btree (objectid);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: agilis; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

