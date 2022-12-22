CREATE DATABASE DEMO;
USE DEMO;
CREATE TABLE IF NOT EXISTS PAGEVIEWS (
    VIEWTIME INT,
    USERID VARCHAR(255),
    PAGEID VARCHAR(255),
    CONSTRAINT PK_PAGEVIEWS PRIMARY KEY (VIEWTIME, USERID, PAGEID)
);