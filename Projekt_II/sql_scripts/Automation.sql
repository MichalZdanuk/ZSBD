USE ShelterDB
GO

CREATE TABLE Shelter.ShelterStatistics (
    Id UNIQUEIDENTIFIER NOT NULL,
    ShelterId UNIQUEIDENTIFIER NOT NULL,
    MetricsDate DATE NOT NULL,
    TotalDogs INT DEFAULT 0,
    RegisteredDogsCount INT DEFAULT 0,
    AvailableDogsCount INT DEFAULT 0,
    AcceptedToAdoptionCount INT DEFAULT 0,
    AdoptedDogsCount INT DEFAULT 0,
    EuthanizedDogsCount INT DEFAULT 0,
    MicrochippedDogsCount INT DEFAULT 0
);

ALTER TABLE
    Shelter.ShelterStatistics ADD CONSTRAINT pk_shelterstatistics_id PRIMARY KEY(Id)
GO

ALTER TABLE Shelter.ShelterStatistics 
    ADD CONSTRAINT fk_shelterstatistics_shelter_shelterid 
    FOREIGN KEY(ShelterId) REFERENCES Shelter.Shelters(Id)
GO

CREATE OR ALTER PROCEDURE Shelter.CalculateShelterStatistics
AS
BEGIN
    DECLARE @CurrentDate DATE = GETDATE();

    INSERT INTO Shelter.ShelterStatistics (
        Id, 
        ShelterId, 
        MetricsDate, 
        TotalDogs, 
        RegisteredDogsCount, 
        AvailableDogsCount, 
        AcceptedToAdoptionCount, 
        AdoptedDogsCount, 
        EuthanizedDogsCount, 
        MicrochippedDogsCount
    )
    SELECT
        NEWID() AS Id,
        s.Id AS ShelterId,
        @CurrentDate AS MetricsDate,
        
        COUNT(d.Id) AS TotalDogs,

        COUNT(CASE WHEN d.DogStatusId = 'e3db7a04-a42b-4820-b3f2-b6c29dfca8c7' THEN 1 END) AS RegisteredDogsCount,
        COUNT(CASE WHEN d.DogStatusId = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c' THEN 1 END) AS AvailableDogsCount,
        COUNT(CASE WHEN d.DogStatusId = '1adf5a5b-342e-4341-9d37-9796367ab0a5' THEN 1 END) AS AcceptedToAdoptionCount,
        COUNT(CASE WHEN d.DogStatusId = '43051a55-003b-4f4b-a43d-2bff8f43027c' THEN 1 END) AS AdoptedDogsCount,
        COUNT(CASE WHEN d.DogStatusId = 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692' THEN 1 END) AS EuthanizedDogsCount,

        COUNT(
            CASE 
                WHEN d.DogStatusId IN ('e3db7a04-a42b-4820-b3f2-b6c29dfca8c7', '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', '1adf5a5b-342e-4341-9d37-9796367ab0a5')
                AND mcr.MedicalCardId IS NOT NULL THEN d.Id 
            END
        ) AS MicrochippedDogsCount
    FROM 
        Shelter.Shelters AS s
        LEFT JOIN Shelter.Dogs AS d ON d.ShelterId = s.Id
        LEFT JOIN Shelter.MedicalCards AS mc ON mc.DogId = d.Id
        LEFT JOIN Shelter.MedicalCardRecords AS mcr ON mcr.MedicalCardId = mc.Id AND mcr.[Description] = 'Microchipping'
    GROUP BY 
        s.Id;
END;