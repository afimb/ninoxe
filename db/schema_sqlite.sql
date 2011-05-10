BEGIN TRANSACTION;
CREATE TABLE company (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE connectionlink (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE routingconstraint (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    objectid character varying(255),
    lineid bigint,
    name character varying(255)
);
CREATE TABLE routingconstraint_stoparea (
    routingconstraintid INTEGER PRIMARY KEY AUTOINCREMENT,
    stopareaid bigint,
    "position" integer NOT NULL
);
CREATE TABLE journeypattern (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    registrationnumber character varying(255),
    name character varying(255),
    publishedname character varying(255),
    comment character varying(255)
);
CREATE TABLE line (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE ptnetwork (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE route (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE stoparea (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE stoppoint (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    routeid bigint,
    stopareaid bigint,
    ismodified boolean,
    "position" integer,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255)
);
CREATE TABLE timetable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    version character varying(255),
    comment character varying(255),
    intdaytypes integer
);
CREATE TABLE timetable_date (
    timetableid INTEGER PRIMARY KEY AUTOINCREMENT,
    date date,
    "position" integer NOT NULL
);
CREATE TABLE timetable_period (
    timetableid INTEGER PRIMARY KEY AUTOINCREMENT,
    periodstart date,
    periodend date,
    "position" integer NOT NULL
);
CREATE TABLE timetablevehiclejourney (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timetableid bigint,
    vehiclejourneyid bigint
);
CREATE TABLE vehiclejourney (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE vehiclejourneyatstop (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);
COMMIT;
