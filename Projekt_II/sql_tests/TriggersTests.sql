USE ShelterDB
GO

-- testy triggerów

-- Trigger_OnAdoptionRecordStatusChange

-- test: dodanie dwóch u¿ytkowników i za³o¿enie ich wniosków o adopcjê
-- wniosek pierwszego u¿ytkownika zostanie zaakceptowany

DECLARE @UserId1 uniqueidentifier, @UserId2 uniqueidentifier, @UserId3 uniqueidentifier
DECLARE @PixieDogId uniqueidentifier;

EXEC Shelter.AddClient
    @FirstName = 'Marzena',
    @LastName = 'Kaszkowiak',
    @Email = 'marzena.kaszkowiak@example.com',
    @PhoneNumber = '123456789',
    @DateOfBirth = '2001-09-21';

SELECT @UserId1 = u.Id
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE uc.Email = 'marzena.kaszkowiak@example.com'

EXEC Shelter.AddClient 
    @FirstName = 'Stanis³aw ',
    @LastName = 'Jakubek',
    @Email = 'stanis³aw.jakubek@example.com',
    @PhoneNumber = '123456789',
    @DateOfBirth = '2000-07-11';

SELECT @UserId2 = u.Id
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE uc.Email = 'stanis³aw.jakubek@example.com'

EXEC Shelter.AddClient 
    @FirstName = 'Beata',
    @LastName = 'Choszcz',
    @Email = 'beata.choszcz@example.com',
    @PhoneNumber = '123456789',
    @DateOfBirth = '2000-07-11';

SELECT @UserId3 = u.Id
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE uc.Email = 'beata.choszcz@example.com'

EXEC Shelter.AddDog
    @Name = 'Pixie',
    @Breed = 'Chiuaua',
    @EstimatedBirthDate = '2021-07-07',
    @ShelterId = '20C49F67-764B-4E80-969F-9EE046B4548A',
    @Weight = 5

SELECT @PixieDogId = Id
	FROM Shelter.Dogs AS d
WHERE d.[Name] = 'Pixie' AND d.Breed = 'Chiuaua';

-- zmiana statusu z 'Registered' na 'Available'
EXEC Shelter.UpdateDogStatus
	@DogId = @PixieDogId,
	@NewStatusId = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c'

EXEC Shelter.SubmitAdoptionRequest
    @UserId = @UserId1,
    @DogId = @PixieDogId;

EXEC Shelter.SubmitAdoptionRequest
    @UserId = @UserId2,
    @DogId = @PixieDogId;

EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = @UserId3,
    @DogId = @PixieDogId;

DECLARE @ExampleAdoptionRecordId uniqueidentifier;
SELECT @ExampleAdoptionRecordId = Id
	FROM Shelter.AdoptionRecords 
		WHERE AdoptionCardId = (SELECT Id FROM Shelter.AdoptionCards WHERE UserId = @UserId1);

-- akceptacja wniosku pierwszego u¿ytkownika
EXEC Shelter.UpdateAdoptionRecordStatus
	@AdoptionRecordId = @ExampleAdoptionRecordId,
	@NewStatusId='494d8c27-ad71-43e3-a216-f0be0450f135'

SELECT ar.Id, ar.RejectionReason, ads.[Name], ar.LastUpdateDate
	FROM Shelter.AdoptionRecords AS ar
		JOIN Shelter.AdoptionStatuses AS ads ON ads.Id = ar.AdoptionStatusId
WHERE DogId = @PixieDogId

SELECT fv.Id, fv.EmployeeId, fv.VisitorId, fv.StartDate, fv.EndDate, fv.RejectionReason, vs.[Name]
	FROM Shelter.FamiliarizationVisits AS fv
		JOIN Shelter.VisitStatuses As vs ON vs.Id = fv.VisitStatusId
WHERE DogId = @PixieDogId

SELECT d.Id, d.[Name], ds.[Name]
	FROM Shelter.Dogs AS d
		JOIN Shelter.DogStatuses AS ds ON ds.Id = d.DogStatusId
WHERE d.Id = @PixieDogId
GO

-- test: zmiana statusu wniosku na zrealizowany
DECLARE @UserId1 uniqueidentifier, @ExampleAdoptionRecordId uniqueidentifier, @DogId uniqueidentifier

SELECT @UserId1 = u.Id
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE uc.Email = 'marzena.kaszkowiak@example.com'

SELECT @DogId = Id
	FROM Shelter.Dogs AS d
WHERE d.[Name] = 'Pixie' AND d.Breed = 'Chiuaua';

SELECT @ExampleAdoptionRecordId = Id
	FROM Shelter.AdoptionRecords 
		WHERE AdoptionCardId = (SELECT Id FROM Shelter.AdoptionCards WHERE UserId = @UserId1);

EXEC Shelter.UpdateAdoptionRecordStatus
	@AdoptionRecordId = @ExampleAdoptionRecordId,
	@NewStatusId='e9497513-d728-4221-b48e-5b34d022b387'

SELECT ar.Id, ar.DogId, ads.[Name], ar.LastUpdateDate
	FROM Shelter.AdoptionRecords AS ar
		JOIN Shelter.AdoptionStatuses AS ads ON ads.Id = ar.AdoptionStatusId
WHERE ar.Id = @ExampleAdoptionRecordId

SELECT d.Id, d.[Name], ds.[Name]
	FROM Shelter.Dogs AS d
		JOIN Shelter.DogStatuses AS ds ON ds.Id = d.DogStatusId
WHERE d.Id = @DogId
GO




-- Trigger_UpdateDogStatus

-- test: zmiana statusu na 'Euthanized' powinna spowodowaæ, anuluowanie istniej¹cych wizyt i wniosków
DECLARE @UserId1 uniqueidentifier, @UserId2 uniqueidentifier, @UserId3 uniqueidentifier
DECLARE @HippieDogId uniqueidentifier;

EXEC Shelter.AddClient
    @FirstName = 'sylwester',
    @LastName = 'nycz',
    @Email = 'sylwester.nycz@example.com',
    @PhoneNumber = '123456789',
    @DateOfBirth = '2001-09-21';

SELECT @UserId1 = u.Id
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE uc.Email = 'sylwester.nycz@example.com'

EXEC Shelter.AddClient 
    @FirstName = 'mateusz',
    @LastName = 'woronko',
    @Email = 'mateusz.woronko@example.com',
    @PhoneNumber = '123456789',
    @DateOfBirth = '2000-07-11';

SELECT @UserId2 = u.Id
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE uc.Email = 'mateusz.woronko@example.com'

EXEC Shelter.AddClient 
    @FirstName = 'marcel',
    @LastName = 'perski',
    @Email = 'marcel.perski@example.com',
    @PhoneNumber = '123456789',
    @DateOfBirth = '2000-07-11';

SELECT @UserId3 = u.Id
	FROM Shelter.Users AS u
		JOIN Shelter.UserCredentials AS uc ON uc.UserId = u.Id
	WHERE uc.Email = 'marcel.perski@example.com'

EXEC Shelter.AddDog
    @Name = 'Hippie',
    @Breed = 'Pomeranian',
    @EstimatedBirthDate = '2021-07-07',
    @ShelterId = '20C49F67-764B-4E80-969F-9EE046B4548A',
    @Weight = 3

SELECT @HippieDogId = Id
	FROM Shelter.Dogs AS d
WHERE d.[Name] = 'Hippie' AND d.Breed = 'Pomeranian';

-- zmiana statusu z 'Registered' na 'Available'
EXEC Shelter.UpdateDogStatus
	@DogId = @HippieDogId,
	@NewStatusId = '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c'

EXEC Shelter.SubmitAdoptionRequest
    @UserId = @UserId1,
    @DogId = @HippieDogId;

EXEC Shelter.SubmitAdoptionRequest
    @UserId = @UserId2,
    @DogId = @HippieDogId;

EXEC Shelter.SubmitFamiliarizationVisitRequest
    @UserId = @UserId3,
    @DogId = @HippieDogId;

-- zmiana statusu na 'Euthanized'
EXEC Shelter.UpdateDogStatus
	@DogId = @HippieDogId,
	@NewStatusId = 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692'

SELECT ar.Id, ar.RejectionReason, ads.[Name], ar.LastUpdateDate
	FROM Shelter.AdoptionRecords AS ar
		JOIN Shelter.AdoptionStatuses AS ads ON ads.Id = ar.AdoptionStatusId
WHERE DogId = @HippieDogId

SELECT fv.Id, fv.EmployeeId, fv.VisitorId, fv.StartDate, fv.EndDate, fv.RejectionReason, vs.[Name]
	FROM Shelter.FamiliarizationVisits AS fv
		JOIN Shelter.VisitStatuses As vs ON vs.Id = fv.VisitStatusId
WHERE DogId = @HippieDogId