-- Michal Zdanuk, 311615
USE master

-- Create DataBase
DROP DATABASE IF EXISTS ShelterDB
CREATE DATABASE ShelterDB
GO

USE ShelterDB
GO

DROP SCHEMA IF EXISTS Shelter
GO

CREATE SCHEMA Shelter

--- Create Tables and set up constraints ---

-- Users table
CREATE TABLE Shelter.Users(
    Id uniqueidentifier NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    RoleId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.Users ADD CONSTRAINT pk_users_id PRIMARY KEY(Id)
GO

-- UserCredentials table
CREATE TABLE Shelter.UserCredentials(
    Id uniqueidentifier NOT NULL,
    Email NVARCHAR(100) NOT NULL,
	PhoneNumber NVARCHAR(9) NOT NULL,
    DateOfBirth DATETIME2 NOT NULL,
    UserId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.UserCredentials ADD CONSTRAINT pk_usercredentials_id PRIMARY KEY(Id)
GO

-- UserRoles table
CREATE TABLE Shelter.UserRoles(
    Id uniqueidentifier NOT NULL,
    Name NVARCHAR(255) NOT NULL
)
GO

ALTER TABLE
    Shelter.UserRoles ADD CONSTRAINT pk_userroles_id PRIMARY KEY(Id)
GO

-- AdoptionCards table
CREATE TABLE Shelter.AdoptionCards(
    Id uniqueidentifier NOT NULL,
    RegistrationDate DATETIME2 NOT NULL,
    UserId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.AdoptionCards ADD CONSTRAINT pk_adoptioncards_id PRIMARY KEY(Id)
GO

-- AdoptionRecords table
CREATE TABLE Shelter.AdoptionRecords(
    Id uniqueidentifier NOT NULL,
    LastUpdateDate DATETIME2 NOT NULL,
    RejectionReason NVARCHAR(500) NULL,
    DogId uniqueidentifier NOT NULL,
    AdoptionCardId uniqueidentifier NOT NULL,
    AdoptionStatusId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.AdoptionRecords ADD CONSTRAINT pk_adoptionrecords_id PRIMARY KEY(Id)
GO

-- AdoptionStatuses table
CREATE TABLE Shelter.AdoptionStatuses(
    Id uniqueidentifier NOT NULL,
    Name NVARCHAR(255) NOT NULL
)
GO

ALTER TABLE
    Shelter.AdoptionStatuses ADD CONSTRAINT pk_adoptionstatuses_id PRIMARY KEY(Id)
GO

-- Dogs table
CREATE TABLE Shelter.Dogs(
    Id uniqueidentifier NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    Breed NVARCHAR(50) NOT NULL,
    DogStatusId uniqueidentifier NOT NULL,
    ShelterId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.Dogs ADD CONSTRAINT pk_dogs_id PRIMARY KEY(Id)
GO

-- DogStatuses table
CREATE TABLE Shelter.DogStatuses(
    Id uniqueidentifier NOT NULL,
    Name NVARCHAR(255) NOT NULL
)
GO

ALTER TABLE
    Shelter.DogStatuses ADD CONSTRAINT pk_dogstatuses_id PRIMARY KEY(Id)
GO

-- Shelters table
CREATE TABLE Shelter.Shelters(
    Id uniqueidentifier NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    AddressId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.Shelters ADD CONSTRAINT pk_shelters_id PRIMARY KEY(Id)
GO

-- Addresses table
CREATE TABLE Shelter.Addresses(
    Id uniqueidentifier NOT NULL,
    Street NVARCHAR(200) NOT NULL,
    City NVARCHAR(200) NOT NULL,
    PostalCode NVARCHAR(20) NOT NULL,
    AdditionalDescription NVARCHAR(500) NULL
)
GO

ALTER TABLE
    Shelter.Addresses ADD CONSTRAINT pk_addresses_id PRIMARY KEY(Id)
GO

-- DogCharacteristics table
CREATE TABLE Shelter.DogCharacteristics(
    Id uniqueidentifier NOT NULL,
    Weight INT NOT NULL,
    Description NVARCHAR(500) NULL,
	DogId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.DogCharacteristics ADD CONSTRAINT pk_dogcharacteristics_id PRIMARY KEY(Id)
GO

-- MedicalCards table
CREATE TABLE Shelter.MedicalCards(
    Id uniqueidentifier NOT NULL,
    CreationDate DATETIME2 NOT NULL,
	DogId uniqueidentifier NOT NULL,
)
GO

ALTER TABLE
    Shelter.MedicalCards ADD CONSTRAINT pk_medicalcards_id PRIMARY KEY(Id)
GO

-- MedicalCardRecords table
CREATE TABLE Shelter.MedicalCardRecords(
    Id uniqueidentifier NOT NULL,
    MedicalCardId uniqueidentifier NOT NULL,
    Description NVARCHAR(1000) NOT NULL,
    Date DATETIME2 NOT NULL
)
GO

ALTER TABLE
    Shelter.MedicalCardRecords ADD CONSTRAINT pk_medicalcardrecords_id PRIMARY KEY(Id)
GO

-- FamiliarizationVisits table
CREATE TABLE Shelter.FamiliarizationVisits(
    Id uniqueidentifier NOT NULL,
    DateOfVisit DATETIME2 NOT NULL,
    DogId uniqueidentifier NOT NULL,
    VisitorId uniqueidentifier NOT NULL,
    EmployeeId uniqueidentifier NOT NULL,
    VisitStatusId uniqueidentifier NOT NULL
)
GO

ALTER TABLE
    Shelter.FamiliarizationVisits ADD CONSTRAINT pk_familiarizationvisits_id PRIMARY KEY(Id)
GO

-- VisitStatuses table
CREATE TABLE Shelter.VisitStatuses(
    Id uniqueidentifier NOT NULL,
    Name NVARCHAR(255) NOT NULL
)
GO

ALTER TABLE
    Shelter.VisitStatuses ADD CONSTRAINT pk_visitstatuses_id PRIMARY KEY(Id)
GO

--- add foreign keys ---

-- Users
ALTER TABLE Shelter.Users 
    ADD CONSTRAINT fk_users_userroles_roleid 
    FOREIGN KEY(RoleId) REFERENCES Shelter.UserRoles(Id)
GO

-- Users
ALTER TABLE Shelter.UserCredentials 
    ADD CONSTRAINT fk_usercredentials_users_userid 
    FOREIGN KEY(UserId) REFERENCES Shelter.Users(Id)
GO

-- AdoptionCards
ALTER TABLE Shelter.AdoptionCards 
    ADD CONSTRAINT fk_adoptioncards_users_userid 
    FOREIGN KEY(UserId) REFERENCES Shelter.Users(Id)
GO

-- AdoptionRecords
ALTER TABLE Shelter.AdoptionRecords 
    ADD CONSTRAINT fk_adoptionrecords_adoptioncards_adoptioncardid 
    FOREIGN KEY(AdoptionCardId) REFERENCES Shelter.AdoptionCards(Id)
GO

ALTER TABLE Shelter.AdoptionRecords 
    ADD CONSTRAINT fk_adoptionrecords_dogs_dogid 
    FOREIGN KEY(DogId) REFERENCES Shelter.Dogs(Id)
GO

ALTER TABLE Shelter.AdoptionRecords 
    ADD CONSTRAINT fk_adoptionrecords_adoptionstatuses_adoptionstatusid 
    FOREIGN KEY(AdoptionStatusId) REFERENCES Shelter.AdoptionStatuses(Id)
GO

-- Dogs
ALTER TABLE Shelter.Dogs 
    ADD CONSTRAINT fk_dogs_dogstatuses_dogstatusid 
    FOREIGN KEY(DogStatusId) REFERENCES Shelter.DogStatuses(Id);
GO

ALTER TABLE Shelter.Dogs 
    ADD CONSTRAINT fk_dogs_shelters_shelterid 
    FOREIGN KEY(ShelterId) REFERENCES Shelter.Shelters(Id)
GO

-- DogCharacteristics
ALTER TABLE Shelter.DogCharacteristics 
    ADD CONSTRAINT fk_dogcharacteristics_dogs_dogid 
    FOREIGN KEY(DogId) REFERENCES Shelter.Dogs(Id)
GO

-- MedicalCards
ALTER TABLE Shelter.MedicalCards 
    ADD CONSTRAINT fk_medicalcards_dogs_dogid 
    FOREIGN KEY(DogId) REFERENCES Shelter.Dogs(Id)
GO

-- MedicalCardRecords
ALTER TABLE Shelter.MedicalCardRecords 
    ADD CONSTRAINT fk_medicalcardrecords_medicalcards_medicalcardid 
    FOREIGN KEY(MedicalCardId) REFERENCES Shelter.MedicalCards(Id)
GO

-- FamiliarizationVisits
ALTER TABLE Shelter.FamiliarizationVisits 
    ADD CONSTRAINT fk_familiarizationvisits_users_employeeid 
    FOREIGN KEY(EmployeeId) REFERENCES Shelter.Users(Id)
GO

ALTER TABLE Shelter.FamiliarizationVisits 
    ADD CONSTRAINT fk_familiarizationvisits_users_visitorid 
    FOREIGN KEY(VisitorId) REFERENCES Shelter.Users(Id)
GO

ALTER TABLE Shelter.FamiliarizationVisits 
    ADD CONSTRAINT fk_familiarizationvisits_dogs_dogid 
    FOREIGN KEY(DogId) REFERENCES Shelter.Dogs(Id)
GO

ALTER TABLE Shelter.FamiliarizationVisits 
    ADD CONSTRAINT fk_familiarizationvisits_visitstatuses_visitstatusid 
    FOREIGN KEY(VisitStatusId) REFERENCES Shelter.VisitStatuses(Id)
GO

-- Shelters
ALTER TABLE Shelter.Shelters 
    ADD CONSTRAINT fk_shelters_addresses_addressid 
    FOREIGN KEY(AddressId) REFERENCES Shelter.Addresses(Id)
GO


