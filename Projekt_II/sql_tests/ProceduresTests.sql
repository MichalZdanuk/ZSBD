USE ShelterDB
GO

-- procedura do dodawania klientów schroniska - Shelter.AddClient
EXEC Shelter.AddClient 
    @FirstName = 'Jan',
    @LastName = 'Nowak',
    @Email = 'jan.nowak@example.com',
    @PhoneNumber = '123456789',
	@DateOfBirth = '2001-09-21'
GO

SELECT *
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE u.FirstName='Jan' AND u.LastName = 'Nowak'
GO


-- procedura do dodawania psów do systemu - Shelter.AddDog
EXEC Shelter.AddDog
    @Name = 'Max',
    @Breed = 'Bulldog',
    @EstimatedBirthDate = '2020-07-07',
    @ShelterId = '20C49F67-764B-4E80-969F-9EE046B4548A',
    @Weight = 5
GO

SELECT COUNT(DISTINCT d.[Name])
	FROM Shelter.Dogs AS d
		JOIN Shelter.DogCharacteristics AS dc ON dc.DogId = d.Id
		JOIN Shelter.MedicalCards AS mc ON mc.DogId = d.Id
	WHERE d.[Name] = 'Max' AND d.Breed='Bulldog'
GO


-- procedura do dodawania schroniska - Shelter.AddShelter
EXEC Shelter.AddShelter
    @Name = 'Safe Haven for Hounds',
	@AddressId = '1D7A7639-89F1-4051-8B2B-6B73781B035A'
GO

SELECT COUNT(*)
	FROM Shelter.Shelters AS s
		WHERE s.[Name] = 'Safe Haven for Hounds'
GO



-- procedura do sk³adania wniosków adopcyjnych - Shelter.SubmitAdoptionRequest
-- Scenariusz pozytywny (pies istnieje i jest dostêpny, uzytkownik istnieje, jest klientem schroniska i ma za³o¿on¹ kartê adopcyjn¹)
EXEC Shelter.SubmitAdoptionRequest
    @UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2',
	@DogId = '3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'
GO

SELECT COUNT(*)
	FROM Shelter.AdoptionRecords AS ar
		JOIN Shelter.AdoptionCards AS ac ON ac.Id = ar.AdoptionCardId
	WHERE ac.UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2' ANd ar.DogId='3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'

-- Scenariusz negatywny (pies nie istnieje)
EXEC Shelter.SubmitAdoptionRequest
    @UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2',
	@DogId = '00000000-1111-2222-3333-444444444444'
GO

-- Scenariusz negatywny (pies nie jest dostêpny - inny status ni¿ Available)
EXEC Shelter.SubmitAdoptionRequest
    @UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2',
	@DogId = 'A13791B6-B9B8-40B6-8F63-0290BE97F9A6'
GO

-- Scenariusz negatywny (u¿ytkownik nie istnieje)
EXEC Shelter.SubmitAdoptionRequest
    @UserId = '00000000-1111-2222-3333-444444444444',
	@DogId = '3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'
GO

-- Scenariusz negatywny (u¿ytkownik nie jest klientem)
EXEC Shelter.SubmitAdoptionRequest
    @UserId = '5459FD6A-EC98-4E04-9CCE-83E04B9AE948',
	@DogId = '3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'
GO



-- procedura do aktualizacji wniosków adopcyjnych - Shelter.UpdateAdoptionRecordStatus
-- przygotowanie wniosku:
EXEC Shelter.SubmitAdoptionRequest
	@UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2',
	@DogId = '4DE75DBC-9136-4952-83E1-C13CED7D1EC9'

DECLARE @SubmittedAdoptionRequestId uniqueidentifier
SELECT @SubmittedAdoptionRequestId = ar.Id
	FROM Shelter.AdoptionRecords AS ar
		JOIN Shelter.AdoptionCards AS ac ON ac.Id = ar.AdoptionCardId
WHERE DogId = '4DE75DBC-9136-4952-83E1-C13CED7D1EC9' AND ac.UserId='470E2057-1FD6-48BA-BA75-2C4C1303A5D2'

-- Scenariusz negatywny (wniosek adopcyjny nie istnieje)
EXEC Shelter.UpdateAdoptionRecordStatus
    @AdoptionRecordId = '00000000-1111-2222-3333-444444444444',
	@NewStatusId = '494d8c27-ad71-43e3-a216-f0be0450f135'

-- Scenariusz negatywny (niepoprawne Id nowego statusu)
EXEC Shelter.UpdateAdoptionRecordStatus
    @AdoptionRecordId = @SubmittedAdoptionRequestId,
	@NewStatusId = '00000000-1111-2222-3333-444444444444'

-- Scenariusz negatywny (wniosek ju¿ odrzucony albo sfinalizowany)
--najpierw odrzucony
EXEC Shelter.UpdateAdoptionRecordStatus
	@AdoptionRecordId = @SubmittedAdoptionRequestId,
	@NewStatusId = '0e5add7b-d4af-4a39-9a49-ee76e22ed69b'

--próba zmiany odrzuconego na inny
EXEC Shelter.UpdateAdoptionRecordStatus
    @AdoptionRecordId = @SubmittedAdoptionRequestId,
	@NewStatusId = '494d8c27-ad71-43e3-a216-f0be0450f135'
GO



-- procedura do sk³adania propozycji odbycia wizyty zapoznawczej przez klienta - Shelter.SubmitFamiliarizationVisitRequest
-- Scenariusz pozytywny (pies istnieje i jest dostêpny, uzytkownik istnieje i jest klientem schroniska)
EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2',
	@DogId = '3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'
GO

SELECT COUNT(*)
	FROM Shelter.FamiliarizationVisits AS fv
	WHERE fv.VisitorId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2' ANd fv.DogId='3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'

-- Scenariusz negatywny (pies nie istnieje)
EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2',
	@DogId = '00000000-1111-2222-3333-444444444444'
GO

-- Scenariusz negatywny (pies nie jest dostêpny - inny status ni¿ Available)
EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = '470E2057-1FD6-48BA-BA75-2C4C1303A5D2',
	@DogId = 'A13791B6-B9B8-40B6-8F63-0290BE97F9A6'
GO

-- Scenariusz negatywny (u¿ytkownik nie istnieje)
EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = '00000000-1111-2222-3333-444444444444',
	@DogId = '3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'
GO

-- Scenariusz negatywny (u¿ytkownik nie jest klientem)
EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = '5459FD6A-EC98-4E04-9CCE-83E04B9AE948',
	@DogId = '3DAEC742-0FBB-4BEF-A7CB-22B18275A50F'
GO



-- procedura do aktualizacji wizyty zapoznawczej - Shelter.UpdateFamiliarizationVisit
-- przygotowanie danych
-- Adding test data for a dog, employee, and familiarization visit
DECLARE @TestDogId uniqueidentifier
DECLARE @TestEmployeeId uniqueidentifier = '5F5E17BA-AD01-4693-B561-D1AF584D55B9'
DECLARE @VisitorId uniqueidentifier
DECLARE @FamiliarizationVisitId uniqueidentifier

EXEC Shelter.AddDog
    @Name = 'Buddy',
    @Breed = 'Golden Retriever',
    @EstimatedBirthDate = '2022-07-07',
    @ShelterId = '20C49F67-764B-4E80-969F-9EE046B4548A',
    @Weight = 6

SELECT @TestDogId = d.Id
	FROM Shelter.Dogs AS d
WHERE d.[Name] = 'Buddy' AND d.Breed = 'Golden Retriever'

EXEC Shelter.UpdateDogStatus
	@DogId = @TestDogId,
	@NewStatusId = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c'

EXEC Shelter.AddClient 
    @FirstName = 'Jan',
    @LastName = 'Nowicki',
    @Email = 'jan.nowicki@example.com',
    @PhoneNumber = '123456789',
	@DateOfBirth = '2001-09-21'

SELECT @VisitorId = u.Id
	FROM Shelter.Users AS u
WHERE u.[FirstName] = 'Jan' AND u.[LastName] = 'Nowicki'

EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = @VisitorId,
	@DogId = @TestDogId

SELECT @FamiliarizationVisitId = fv.Id
	FROM Shelter.FamiliarizationVisits AS fv
WHERE fv.VisitorId = @VisitorId AND fv.DogId = @TestDogId

-- Scenariusz negatywny (nieistniej¹cy pracownik)
EXEC Shelter.UpdateFamiliarizationVisit
    @FamiliarizationVisitId = @FamiliarizationVisitId,
    @EmployeeId = '00000000-0000-0000-0000-000000000000',
    @StartDate = '2024-12-03 12:00',
    @EndDate = '2024-12-03 13:00',
    @VisitStatusId = '15fc7712-0554-48bd-b56f-b2f079fe5dc1';

-- Scenariusz negatywny (nieprawid³owy zakres dat)
EXEC Shelter.UpdateFamiliarizationVisit
    @FamiliarizationVisitId = @FamiliarizationVisitId,
    @EmployeeId = @TestEmployeeId,
    @StartDate = '2024-12-04 14:00',
    @EndDate = '2024-12-04 13:00',
    @VisitStatusId = '15fc7712-0554-48bd-b56f-b2f079fe5dc1';

-- Scenariusz negatywny (kolizja wizyt)
DECLARE @ConflictingVisitId uniqueidentifier = NEWID();
INSERT INTO Shelter.FamiliarizationVisits (Id, StartDate, EndDate, DogId, VisitorId, EmployeeId, VisitStatusId)
	VALUES (@ConflictingVisitId, '2024-12-02 12:30', '2024-12-02 13:30', @TestDogId, @VisitorId, @TestEmployeeId, '07fa688a-f536-4b3d-a286-828bc032a588');

EXEC Shelter.UpdateFamiliarizationVisit
    @FamiliarizationVisitId = @FamiliarizationVisitId,
    @EmployeeId = @TestEmployeeId,
    @StartDate = '2024-12-02 13:00',
    @EndDate = '2024-12-02 14:00',
    @VisitStatusId = '15fc7712-0554-48bd-b56f-b2f079fe5dc1';


-- Scenariusz pozytywny
EXEC Shelter.UpdateFamiliarizationVisit
    @FamiliarizationVisitId = @FamiliarizationVisitId,
    @EmployeeId = @TestEmployeeId,
    @StartDate = '2025-12-02 12:00',
    @EndDate = '2025-12-02 13:00',
    @VisitStatusId = '15fc7712-0554-48bd-b56f-b2f079fe5dc1';

SELECT fv.Id, fv.StartDate, fv.EndDate, fv.EmployeeId, vs.[Name], fv.RejectionReason
	FROM Shelter.FamiliarizationVisits AS fv
		JOIN Shelter.VisitStatuses AS vs ON vs.Id = fv.VisitStatusId
WHERE fv.Id = @FamiliarizationVisitId;




-- procedura do zmiany statusu psa - Shelter.UpdateDogStatus
-- przygotowanie psa do testów
EXEC Shelter.AddDog
    @Name = 'Alex',
    @Breed = 'German Shepherd',
    @EstimatedBirthDate = '2022-07-07',
    @ShelterId = '20C49F67-764B-4E80-969F-9EE046B4548A',
    @Weight = 6
GO

DECLARE @AlexDogId uniqueidentifier
SELECT @AlexDogId = d.Id
	FROM Shelter.Dogs AS d
		WHERE d.[Name] = 'Alex' AND d.[Breed] = 'German Shepherd'

-- Scenariusz pozytywny: zmiana statusu dla nowo dodanego psa na dostêpny (Available)
EXEC Shelter.UpdateDogStatus
	@DogId = @AlexDogId,
	@NewStatusId = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c'

SELECT d.Id, d.[Name], d.[Breed], ds.[Name]
	FROM Shelter.Dogs AS d
		JOIN Shelter.DogStatuses AS ds ON ds.Id = d.DogStatusId
	WHERE d.[Name] = 'Alex' AND d.[Breed] = 'German Shepherd' 
-- Scenariusz negatywny: pies o podanym Id nie istnieje
EXEC Shelter.UpdateDogStatus
	@DogId = '00000000-1111-2222-3333-444444444444',
	@NewStatusId = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c'

-- Scenariusz negatywny: próba zmiany statusu na inny ni¿ "Avaialable" lub "Euthanized"
EXEC Shelter.UpdateDogStatus
	@DogId = @AlexDogId,
	@NewStatusId = '1adf5a5b-342e-4341-9d37-9796367ab0a5'

-- Scenariusz negatywny: próba edycji statusu psa oddanego do adopcji
EXEC Shelter.UpdateDogStatus
	@DogId = 'BE2ECF0A-8A1E-4D30-B42A-945FAF8EE0A1',
	@NewStatusId = '1adf5a5b-342e-4341-9d37-9796367ab0a5'