--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: sim
--

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: company; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE company (
    id bigint NOT NULL,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    name character varying(255),
    shortname character varying(255),
    organizationalunit character varying(255),
    operatingdepartmentname character varying(255),
    code character varying(255),
    phone character varying(255),
    fax character varying(255),
    email character varying(255),
    registrationnumber character varying(255)
);


ALTER TABLE public.company OWNER TO sim;

--
-- Name: connectionlink; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE connectionlink (
    id bigint NOT NULL,
    departureid bigint,
    arrivalid bigint,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    name character varying(255),
    comment character varying(255),
    linkdistance numeric(19,2),
    linktype character varying(255),
    defaultduration time without time zone,
    frequenttravellerduration time without time zone,
    occasionaltravellerduration time without time zone,
    mobilityrestrictedtravellerduration time without time zone,
    mobilityrestrictedsuitability boolean,
    stairsavailability boolean,
    liftavailability boolean
);


ALTER TABLE public.connectionlink OWNER TO sim;

--
-- Name: routingconstraint; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE routingconstraint (
    id bigint NOT NULL,
    objectid character varying(255),
    lineid bigint,
    name character varying(255)
);


ALTER TABLE public.routingconstraint OWNER TO sim;

--
-- Name: routingconstraint_stoparea; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE routingconstraint_stoparea (
    routingconstraintid bigint NOT NULL,
    stopareaid bigint,
    "position" integer NOT NULL
);


ALTER TABLE public.routingconstraint_stoparea OWNER TO sim;

--
-- Name: journeypattern; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE journeypattern (
    id bigint NOT NULL,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    registrationnumber character varying(255),
    name character varying(255),
    publishedname character varying(255),
    comment character varying(255)
);


ALTER TABLE public.journeypattern OWNER TO sim;

--
-- Name: line; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE line (
    id bigint NOT NULL,
    ptnetworkid bigint,
    companyid bigint,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    name character varying(255),
    number character varying(255),
    publishedname character varying(255),
    transportmodename character varying(255),
    registrationnumber character varying(255),
    comment character varying(255)
);


ALTER TABLE public.line OWNER TO sim;

--
-- Name: ptnetwork; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE ptnetwork (
    id bigint NOT NULL,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    versiondate date,
    description character varying(255),
    name character varying(255),
    registrationnumber character varying(255),
    sourcename character varying(255),
    sourceidentifier character varying(255),
    comment character varying(255)
);


ALTER TABLE public.ptnetwork OWNER TO sim;

--
-- Name: route; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE route (
    id bigint NOT NULL,
    oppositerouteid bigint,
    lineid bigint,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    name character varying(255),
    publishedname character varying(255),
    number character varying(255),
    direction character varying(255),
    comment character varying(255),
    wayback character varying(255)
);


ALTER TABLE public.route OWNER TO sim;

--
-- Name: stoparea; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE stoparea (
    id bigint NOT NULL,
    parentid bigint,
    objectid character varying(255),
    objectversion bigint,
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


ALTER TABLE public.stoparea OWNER TO sim;

--
-- Name: stoppoint; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE stoppoint (
    id bigint NOT NULL,
    routeid bigint,
    stopareaid bigint,
    ismodified boolean,
    "position" integer,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255)
);


ALTER TABLE public.stoppoint OWNER TO sim;

--
-- Name: timetable; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE timetable (
    id bigint NOT NULL,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    version character varying(255),
    comment character varying(255),
    intdaytypes integer
);


ALTER TABLE public.timetable OWNER TO sim;

--
-- Name: timetable_date; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE timetable_date (
    timetableid bigint NOT NULL,
    date date,
    "position" integer NOT NULL
);


ALTER TABLE public.timetable_date OWNER TO sim;

--
-- Name: timetable_period; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE timetable_period (
    timetableid bigint NOT NULL,
    periodstart date,
    periodend date,
    "position" integer NOT NULL
);


ALTER TABLE public.timetable_period OWNER TO sim;

--
-- Name: timetablevehiclejourney; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE timetablevehiclejourney (
    id bigint NOT NULL,
    timetableid bigint,
    vehiclejourneyid bigint
);


ALTER TABLE public.timetablevehiclejourney OWNER TO sim;

--
-- Name: vehiclejourney; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE vehiclejourney (
    id bigint NOT NULL,
    routeid bigint,
    journeypatternid bigint,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    publishedjourneyname character varying(255),
    publishedjourneyidentifier character varying(255),
    transportmode character varying(255),
    vehicletypeidentifier character varying(255),
    statusvalue character varying(255),
    facility character varying(255),
    number bigint,
    comment character varying(255)
);


ALTER TABLE public.vehiclejourney OWNER TO sim;

--
-- Name: vehiclejourneyatstop; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE vehiclejourneyatstop (
    id bigint NOT NULL,
    vehiclejourneyid bigint,
    stoppointid bigint,
    ismodified boolean,
    arrivaltime time without time zone,
    departuretime time without time zone,
    waitingtime time without time zone,
    connectingserviceid character varying(255),
    boardingalightingpossibility character varying(255),
    isdeparture boolean
);


ALTER TABLE public.vehiclejourneyatstop OWNER TO sim;

--
-- Name: address_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE address_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_sections_id_seq OWNER TO sim;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO sim;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cities_id_seq OWNER TO sim;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE cities (
    id integer DEFAULT nextval('cities_id_seq'::regclass) NOT NULL,
    name character varying(255),
    upcase_name character varying(255),
    zip_code integer,
    insee_code integer,
    region_code integer,
    lat numeric(19,16),
    lng numeric(19,16),
    eloignement double precision
);


ALTER TABLE public.cities OWNER TO sim;

--
-- Name: geocoder_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE geocoder_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geocoder_locations_id_seq OWNER TO sim;

--
-- Name: geocoder_locations; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE geocoder_locations (
    id integer DEFAULT nextval('geocoder_locations_id_seq'::regclass) NOT NULL,
    name character varying(255),
    zone_id integer,
    stored_words character varying(255),
    stored_phonetics character varying(255),
    reference_id integer,
    reference_type character varying(255)
);


ALTER TABLE public.geocoder_locations OWNER TO sim;

--
-- Name: geocoder_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE geocoder_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.geocoder_zones_id_seq OWNER TO sim;

--
-- Name: geocoder_zones; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE geocoder_zones (
    id integer DEFAULT nextval('geocoder_zones_id_seq'::regclass) NOT NULL,
    name character varying(255),
    uid integer,
    stored_words character varying(255),
    zip_code character varying(255)
);


ALTER TABLE public.geocoder_zones OWNER TO sim;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO sim;

--
-- Name: ign_routes_gid_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE ign_routes_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ign_routes_gid_seq OWNER TO sim;

--
-- Name: ign_routes; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE ign_routes (
    gid integer DEFAULT nextval('ign_routes_gid_seq'::regclass) NOT NULL,
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


ALTER TABLE public.ign_routes OWNER TO sim;

--
-- Name: journey_pattern_stop_points_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE journey_pattern_stop_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journey_pattern_stop_points_id_seq OWNER TO sim;

--
-- Name: journey_pattern_stop_points; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE journey_pattern_stop_points (
    id integer DEFAULT nextval('journey_pattern_stop_points_id_seq'::regclass) NOT NULL,
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


ALTER TABLE public.journey_pattern_stop_points OWNER TO sim;

--
-- Name: place_types_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE place_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.place_types_id_seq OWNER TO sim;

--
-- Name: place_types; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE place_types (
    id integer DEFAULT nextval('place_types_id_seq'::regclass) NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.place_types OWNER TO sim;

--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.places_id_seq OWNER TO sim;

--
-- Name: places; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE places (
    id integer DEFAULT nextval('places_id_seq'::regclass) NOT NULL,
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


ALTER TABLE public.places OWNER TO sim;

--
-- Name: road_sections; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE road_sections (
    id integer DEFAULT nextval('address_sections_id_seq'::regclass) NOT NULL,
    road_id integer,
    ign_route_id integer,
    number_begin integer,
    number_end integer
);


ALTER TABLE public.road_sections OWNER TO sim;

--
-- Name: roads; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE roads (
    id integer DEFAULT nextval('addresses_id_seq'::regclass) NOT NULL,
    name character varying(255),
    number_begin integer,
    number_end integer,
    city_id integer
);


ALTER TABLE public.roads OWNER TO sim;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO sim;

--
-- Name: stop_area_places_id_seq; Type: SEQUENCE; Schema: public; Owner: sim
--

CREATE SEQUENCE stop_area_places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stop_area_places_id_seq OWNER TO sim;

--
-- Name: stop_area_places; Type: TABLE; Schema: public; Owner: sim; Tablespace: 
--

CREATE TABLE stop_area_places (
    id integer DEFAULT nextval('stop_area_places_id_seq'::regclass) NOT NULL,
    stop_area_id integer,
    place_id integer,
    duration integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.stop_area_places OWNER TO sim;

--
-- Name: address_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY road_sections
    ADD CONSTRAINT address_sections_pkey PRIMARY KEY (id);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY roads
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: company_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_objectid_key UNIQUE (objectid);


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: company_registrationnumber_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_registrationnumber_key UNIQUE (registrationnumber);


--
-- Name: connectionlink_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY connectionlink
    ADD CONSTRAINT connectionlink_objectid_key UNIQUE (objectid);


--
-- Name: connectionlink_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY connectionlink
    ADD CONSTRAINT connectionlink_pkey PRIMARY KEY (id);


--
-- Name: geocoder_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY geocoder_locations
    ADD CONSTRAINT geocoder_locations_pkey PRIMARY KEY (id);


--
-- Name: geocoder_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY geocoder_zones
    ADD CONSTRAINT geocoder_zones_pkey PRIMARY KEY (id);


--
-- Name: ign_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY ign_routes
    ADD CONSTRAINT ign_routes_pkey PRIMARY KEY (gid);


--
-- Name: journey_pattern_stop_points_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY journey_pattern_stop_points
    ADD CONSTRAINT journey_pattern_stop_points_pkey PRIMARY KEY (id);


--
-- Name: journeypattern_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY journeypattern
    ADD CONSTRAINT journeypattern_objectid_key UNIQUE (objectid);


--
-- Name: journeypattern_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY journeypattern
    ADD CONSTRAINT journeypattern_pkey PRIMARY KEY (id);


--
-- Name: journeypattern_registrationnumber_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY journeypattern
    ADD CONSTRAINT journeypattern_registrationnumber_key UNIQUE (registrationnumber);


--
-- Name: line_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_objectid_key UNIQUE (objectid);


--
-- Name: line_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_pkey PRIMARY KEY (id);


--
-- Name: line_registrationnumber_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY line
    ADD CONSTRAINT line_registrationnumber_key UNIQUE (registrationnumber);


--
-- Name: place_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY place_types
    ADD CONSTRAINT place_types_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: ptnetwork_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY ptnetwork
    ADD CONSTRAINT ptnetwork_objectid_key UNIQUE (objectid);


--
-- Name: ptnetwork_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY ptnetwork
    ADD CONSTRAINT ptnetwork_pkey PRIMARY KEY (id);


--
-- Name: ptnetwork_registrationnumber_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY ptnetwork
    ADD CONSTRAINT ptnetwork_registrationnumber_key UNIQUE (registrationnumber);


--
-- Name: route_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_objectid_key UNIQUE (objectid);


--
-- Name: route_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);


--
-- Name: routingconstraint_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY routingconstraint
    ADD CONSTRAINT routingconstraint_objectid_key UNIQUE (objectid);


--
-- Name: routingconstraint_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY routingconstraint
    ADD CONSTRAINT routingconstraint_pkey PRIMARY KEY (id);


--
-- Name: routingconstraint_stoparea_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY routingconstraint_stoparea
    ADD CONSTRAINT routingconstraint_stoparea_pkey PRIMARY KEY (routingconstraintid, "position");


--
-- Name: stop_area_places_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY stop_area_places
    ADD CONSTRAINT stop_area_places_pkey PRIMARY KEY (id);


--
-- Name: stoparea_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY stoparea
    ADD CONSTRAINT stoparea_objectid_key UNIQUE (objectid);


--
-- Name: stoparea_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY stoparea
    ADD CONSTRAINT stoparea_pkey PRIMARY KEY (id);


--
-- Name: stoppoint_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY stoppoint
    ADD CONSTRAINT stoppoint_objectid_key UNIQUE (objectid);


--
-- Name: stoppoint_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY stoppoint
    ADD CONSTRAINT stoppoint_pkey PRIMARY KEY (id);


--
-- Name: timetable_date_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY timetable_date
    ADD CONSTRAINT timetable_date_pkey PRIMARY KEY (timetableid, "position");


--
-- Name: timetable_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY timetable
    ADD CONSTRAINT timetable_objectid_key UNIQUE (objectid);


--
-- Name: timetable_period_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY timetable_period
    ADD CONSTRAINT timetable_period_pkey PRIMARY KEY (timetableid, "position");


--
-- Name: timetable_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY timetable
    ADD CONSTRAINT timetable_pkey PRIMARY KEY (id);


--
-- Name: timetablevehiclejourney_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY timetablevehiclejourney
    ADD CONSTRAINT timetablevehiclejourney_pkey PRIMARY KEY (id);


--
-- Name: vehiclejourney_objectid_key; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY vehiclejourney
    ADD CONSTRAINT vehiclejourney_objectid_key UNIQUE (objectid);


--
-- Name: vehiclejourney_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY vehiclejourney
    ADD CONSTRAINT vehiclejourney_pkey PRIMARY KEY (id);


--
-- Name: vehiclejourneyatstop_pkey; Type: CONSTRAINT; Schema: public; Owner: sim; Tablespace: 
--

ALTER TABLE ONLY vehiclejourneyatstop
    ADD CONSTRAINT vehiclejourneyatstop_pkey PRIMARY KEY (id);


--
-- Name: index_address_sections_on_address_id; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_address_sections_on_address_id ON road_sections USING btree (road_id);


--
-- Name: index_cities_on_insee_code; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_cities_on_insee_code ON cities USING btree (insee_code);


--
-- Name: index_cities_on_name; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_cities_on_name ON cities USING btree (name);


--
-- Name: index_journey_pattern_stop_points_on_commercial_stop_area_id; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_journey_pattern_stop_points_on_commercial_stop_area_id ON journey_pattern_stop_points USING btree (commercial_stop_area_id);


--
-- Name: index_journey_pattern_stop_points_on_journey_pattern_id; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_journey_pattern_stop_points_on_journey_pattern_id ON journey_pattern_stop_points USING btree (journey_pattern_id);


--
-- Name: index_journey_pattern_stop_points_on_stop_point_id; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_journey_pattern_stop_points_on_stop_point_id ON journey_pattern_stop_points USING btree (stop_point_id);


--
-- Name: index_route_on_lineid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_route_on_lineid ON route USING btree (lineid);


--
-- Name: index_stoparea_on_parentid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_stoparea_on_parentid ON stoparea USING btree (parentid);


--
-- Name: index_stoppoint_on_stopareaid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_stoppoint_on_stopareaid ON stoppoint USING btree (stopareaid);


--
-- Name: index_timetable_date_on_timetableid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_timetable_date_on_timetableid ON timetable_date USING btree (timetableid);


--
-- Name: index_timetable_period_on_timetableid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_timetable_period_on_timetableid ON timetable_period USING btree (timetableid);


--
-- Name: index_timetablevehiclejourney_on_timetableid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_timetablevehiclejourney_on_timetableid ON timetablevehiclejourney USING btree (timetableid);


--
-- Name: index_timetablevehiclejourney_on_vehiclejourneyid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_timetablevehiclejourney_on_vehiclejourneyid ON timetablevehiclejourney USING btree (vehiclejourneyid);


--
-- Name: index_vehiclejourney_on_routeid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_vehiclejourney_on_routeid ON vehiclejourney USING btree (routeid);


--
-- Name: index_vehiclejourneyatstop_on_stoppointid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_vehiclejourneyatstop_on_stoppointid ON vehiclejourneyatstop USING btree (stoppointid);


--
-- Name: index_vehiclejourneyatstop_on_vehiclejourneyid; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE INDEX index_vehiclejourneyatstop_on_vehiclejourneyid ON vehiclejourneyatstop USING btree (vehiclejourneyid);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: sim; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fkaed4a10b1b0d1d48; Type: FK CONSTRAINT; Schema: public; Owner: sim
--

ALTER TABLE ONLY routingconstraint_stoparea
    ADD CONSTRAINT fkaed4a10b1b0d1d48 FOREIGN KEY (routingconstraintid) REFERENCES routingconstraint(id);


--
-- Name: fkb0847a9f5cb6a412; Type: FK CONSTRAINT; Schema: public; Owner: sim
--

ALTER TABLE ONLY timetable_period
    ADD CONSTRAINT fkb0847a9f5cb6a412 FOREIGN KEY (timetableid) REFERENCES timetable(id);


--
-- Name: fkd767940c5cb6a412; Type: FK CONSTRAINT; Schema: public; Owner: sim
--

ALTER TABLE ONLY timetable_date
    ADD CONSTRAINT fkd767940c5cb6a412 FOREIGN KEY (timetableid) REFERENCES timetable(id);


--
-- PostgreSQL database dump complete
--

