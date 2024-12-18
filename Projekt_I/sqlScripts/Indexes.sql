IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_users_lastname' AND object_id = OBJECT_ID('Shelter.Users'))
BEGIN
    DROP INDEX idx_users_lastname ON Shelter.Users;
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_adoptionrecords_card_status' AND object_id = OBJECT_ID('Shelter.AdoptionRecords'))
BEGIN
    DROP INDEX idx_adoptionrecords_card_status ON Shelter.AdoptionRecords;
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_adoptionrecords_dogid' AND object_id = OBJECT_ID('Shelter.AdoptionRecords'))
BEGIN
    DROP INDEX idx_adoptionrecords_dogid ON Shelter.AdoptionRecords;
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_dogs_name' AND object_id = OBJECT_ID('Shelter.Dogs'))
BEGIN
    DROP INDEX idx_dogs_name ON Shelter.Dogs;
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_dogs_breed_shelterid' AND object_id = OBJECT_ID('Shelter.Dogs'))
BEGIN
    DROP INDEX idx_dogs_breed_shelterid ON Shelter.Dogs;
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_familiarizationvisits_date' AND object_id = OBJECT_ID('Shelter.FamiliarizationVisits'))
BEGIN
    DROP INDEX idx_familiarizationvisits_date ON Shelter.FamiliarizationVisits;
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_familiarizationvisits_visitorid' AND object_id = OBJECT_ID('Shelter.FamiliarizationVisits'))
BEGIN
    DROP INDEX idx_familiarizationvisits_visitorid ON Shelter.FamiliarizationVisits;
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_medicalcards_dogid' AND object_id = OBJECT_ID('Shelter.MedicalCards'))
BEGIN
    DROP INDEX idx_medicalcards_dogid ON Shelter.MedicalCards;
END

-- indeksy do tabeli Users
CREATE INDEX idx_users_lastname ON Shelter.Users(LastName);

-- indeksy do tabli AdoptionRecords 
CREATE INDEX idx_adoptionrecords_card_status ON Shelter.AdoptionRecords(AdoptionCardId, AdoptionStatusId);
CREATE INDEX idx_adoptionrecords_dogid ON Shelter.AdoptionRecords(DogId);

-- indeksy do tabli Dogs 
CREATE INDEX idx_dogs_name ON Shelter.Dogs(Name);
CREATE INDEX idx_dogs_breed_shelterid ON Shelter.Dogs(Breed, ShelterId);

-- indeksy do tabli FamiliarizationVisits 
CREATE INDEX idx_familiarizationvisits_date ON Shelter.FamiliarizationVisits(DateOfVisit);
CREATE INDEX idx_familiarizationvisits_visitorid ON Shelter.FamiliarizationVisits(VisitorId);

-- indeksy do tabli MedicalCards 
CREATE INDEX idx_medicalcards_dogid ON Shelter.MedicalCards(DogId);