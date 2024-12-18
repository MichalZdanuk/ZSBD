USE ShelterDB
GO

-- DaysSinceLastMedicalProcedure - funkcja dedykowana g³ównie pracownikom
-- pozwala sprawdziæ ile dni up³ynê³o od ostatniego zabiegu (z filtrem nazwy zabiegu)
-- dla danego psa. Pozwala to planowaæ kolejne zabiegi i decydowaæ o tym, czy
-- nie jest za wczeœnie na kolejny zabieg

DROP FUNCTION IF EXISTS Shelter.DaysSinceLastMedicalProcedure
GO

CREATE FUNCTION Shelter.DaysSinceLastMedicalProcedure (
    @DogId uniqueidentifier,
    @ProcedureName NVARCHAR(1000) = NULL
)
RETURNS INT
AS
BEGIN
    DECLARE @DaysSinceLastProcedure INT;
    
    SELECT @DaysSinceLastProcedure = DATEDIFF(DAY, MAX(mcr.Date), GETDATE())
		FROM Shelter.MedicalCardRecords AS mcr
			JOIN Shelter.MedicalCards AS mc ON mc.Id = mcr.MedicalCardId
		WHERE mc.DogId = @DogId
		  AND (@ProcedureName IS NULL OR mcr.[Description] LIKE '%' + @ProcedureName + '%');
    
    RETURN ISNULL(@DaysSinceLastProcedure, -1);
END;
GO


-- DaysSinceLastAdoptionRequest - funkcja dedykowana pracownikom
-- pozwala sprawdziæ ile dni up³ynê³o od ostatniego zg³oszenia adopcyjnego dla wybranego pas
DROP FUNCTION IF EXISTS Shelter.DaysSinceLastAdoptionRequest
GO

CREATE FUNCTION Shelter.DaysSinceLastAdoptionRequest (
    @DogId uniqueidentifier
)
RETURNS INT
AS
BEGIN
    DECLARE @DaysSinceLastRequest INT;
    
    SELECT @DaysSinceLastRequest = DATEDIFF(DAY, MAX(ar.LastUpdateDate), GETDATE())
		FROM Shelter.AdoptionRecords AS ar
			JOIN Shelter.Dogs AS d ON d.Id = ar.DogId
    WHERE ar.DogId = @DogId AND d.DogStatusId = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c';
    
    RETURN ISNULL(@DaysSinceLastRequest, -1);
END;
GO

-- Ile dni up³ynê³o od ostatniego odrobaczania psa X
SELECT Shelter.DaysSinceLastMedicalProcedure('4DE75DBC-9136-4952-83E1-C13CED7D1EC9', 'Flea & Tick Prevention')

-- Ile dni up³ynê³o od ostatniego zabiegu psa X
SELECT Shelter.DaysSinceLastMedicalProcedure('4DE75DBC-9136-4952-83E1-C13CED7D1EC9', NULL)

-- Ile dni up³ynê³o od ostatniego z³o¿onego zg³oszenia adopcyjnego psa X
-- widzimy, ¿e jeszcze nikt nie zg³asza³ siê po tego psa
SELECT Shelter.DaysSinceLastAdoptionRequest('4DE75DBC-9136-4952-83E1-C13CED7D1EC9')

-- ten pies otrzyma³ wniosek o adopcjê x dni temu 
SELECT Shelter.DaysSinceLastAdoptionRequest('4A6871FB-BBA7-45AA-ADF7-63FA689F83FA')
