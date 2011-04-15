BEGIN TRANSACTION;
CREATE TABLE road_sections (
    id integer NOT NULL,
    road_id integer,
    ign_route_id integer,
    number_begin integer,
    number_end integer
);
CREATE TABLE roads (
    id integer NOT NULL,
    name character varying(255),
    number_begin integer,
    number_end integer,
    city_id integer
);
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
CREATE TABLE geocoder_locations (
    id integer NOT NULL,
    name character varying(255),
    zone_id integer,
    stored_words character varying(255),
    stored_phonetics character varying(255),
    reference_id integer,
    reference_type character varying(255)
);
CREATE TABLE geocoder_zones (
    id integer NOT NULL,
    name character varying(255),
    uid integer,
    stored_words character varying(255),
    zip_code character varying(255)
);
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
CREATE TABLE journeypattern (
    id integer NOT NULL,
    name character varying(255),
    publishedname character varying(255),
    registrationnumber character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
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
CREATE TABLE place_types (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
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
CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);
CREATE TABLE stop_area_places (
    id integer NOT NULL,
    stop_area_id integer,
    place_id integer,
    duration integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
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
CREATE TABLE timetable_date (
    id integer NOT NULL,
    timetableid integer NOT NULL,
    date date,
    "position" integer NOT NULL
);
CREATE TABLE timetable_period (
    id integer NOT NULL,
    timetableid integer NOT NULL,
    periodstart date,
    periodend date,
    "position" integer NOT NULL
);
CREATE TABLE timetablevehiclejourney (
    id integer NOT NULL,
    timetableid integer,
    vehiclejourneyid integer
);
CREATE TABLE vehiclejourney (
    id integer NOT NULL,
    routeid integer,
    journeypatternid integer,
    transportmode character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    vehicletypeidentifier character varying(255)
);
CREATE TABLE vehiclejourneyatstop (
    id integer NOT NULL,
    vehiclejourneyid integer,
    stoppointid integer,
    arrivaltime timestamp without time zone,
    departuretime timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
COMMIT;
