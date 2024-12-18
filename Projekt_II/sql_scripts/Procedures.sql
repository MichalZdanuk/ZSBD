USE ShelterDB
GO

-- Procedury
-- Dodawanie klienta schroniska (dodajemy równie¿ jego dane kontaktowe)
CREATE OR ALTER PROCEDURE Shelter.AddClient
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(9),
    @DateOfBirth DATETIME2
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    DECLARE @UserCredentialsId uniqueidentifier
    DECLARE @AdoptionCardId uniqueidentifier

    SET @UserId = NEWID()
    SET @UserCredentialsId = NEWID()
	SET @AdoptionCardId = NEWID()

    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
			VALUES (@UserId, @FirstName, @LastName, 'DA3609E9-9CFE-4940-BEE7-6BFF6695A3D9')

        INSERT INTO Shelter.UserCredentials (Id, Email, PhoneNumber, DateOfBirth, UserId)
			VALUES (@UserCredentialsId, @Email, @PhoneNumber, @DateOfBirth, @UserId)

		INSERT INTO Shelter.AdoptionCards (Id, RegistrationDate, UserId)
			VALUES (@AdoptionCardId, GETDATE(), @UserId)

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO



-- Dodawanie psa do systemu (rejestrujemy mu od razu kartê medyczn¹)
CREATE OR ALTER PROCEDURE Shelter.AddDog
    @Name NVARCHAR(50),
    @Breed NVARCHAR(50),
	@EstimatedBirthDate DATE,
    @ShelterId uniqueidentifier,
	@Weight INT,
    @Description NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @DogId uniqueidentifier;
	DECLARE @DogCharacteristicsId uniqueidentifier;
	DECLARE @MedicalCardId uniqueidentifier;

    SET @DogId = NEWID();
    SET @DogCharacteristicsId = NEWID();
    SET @MedicalCardId = NEWID();


    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO Shelter.Dogs (Id, [Name], Breed, EstimatedBirthDate, DogStatusId, ShelterId)
			VALUES (@DogId, @Name, @Breed, @EstimatedBirthDate, 'E3DB7A04-A42B-4820-B3F2-B6C29DFCA8C7', @ShelterId)

		INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
			VALUES (@DogCharacteristicsId, @Weight, @Description, @DogId)

        INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
			VALUES (@MedicalCardId, GETDATE(), @DogId)

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO



-- Dodawanie schroniska do systemu
CREATE OR ALTER PROCEDURE Shelter.AddShelter
    @Name NVARCHAR(200),
    @AddressId uniqueidentifier
AS
BEGIN
    DECLARE @ShelterId uniqueidentifier;
    SET @ShelterId = NEWID();

	INSERT INTO Shelter.Shelters (Id, [Name], AddressId)
        VALUES (@ShelterId, @Name, @AddressId)
END
GO



-- Zgloszenie chêci adopcji przez u¿ytkownika
CREATE OR ALTER PROCEDURE Shelter.SubmitAdoptionRequest
    @UserId uniqueidentifier,
    @DogId uniqueidentifier
AS
BEGIN
	DECLARE @AdoptionCardId uniqueidentifier
    DECLARE @AdoptionRecordId uniqueidentifier
    DECLARE @DogStatusId uniqueidentifier
    DECLARE @UserRoleId uniqueidentifier

	SET @AdoptionRecordId = NEWID()

    BEGIN TRY
	    BEGIN TRANSACTION

        IF NOT EXISTS (SELECT 1 FROM Shelter.Dogs WHERE Id = @DogId)
        BEGIN
            RAISERROR('Pies o podanym ID nie istnieje.', 16, 1)
        END

        SELECT @DogStatusId = d.DogStatusId
			FROM Shelter.Dogs AS d
		WHERE d.Id = @DogId

        IF @DogStatusId != '568AC4DD-5FA2-4D0D-B1C6-E13BE5663D4C'
        BEGIN
            RAISERROR('Pies nie jest dostêpny do adopcji.', 16, 1)
        END

		IF NOT EXISTS (SELECT 1 FROM Shelter.Users WHERE Id = @UserId)
        BEGIN
            RAISERROR('U¿ytkownik o podanym ID nie istnieje.', 16, 1)
        END

		SELECT @UserRoleId = u.RoleId
			FROM Shelter.Users AS u
		WHERE u.Id = @UserId

		IF @UserRoleId != 'da3609e9-9cfe-4940-bee7-6bff6695a3d9'
        BEGIN
            RAISERROR('U¿ytkownik nie jest klientem schroniska.', 16, 1)
        END

        SELECT @AdoptionCardId = Id
			FROM Shelter.AdoptionCards
		WHERE UserId = @UserId;

        IF @AdoptionCardId IS NULL
        BEGIN
            RAISERROR('U¿ytkownik nie posiada za³o¿onej karty adopcyjnej', 16, 1)
        END

        INSERT INTO Shelter.AdoptionRecords (Id, LastUpdateDate, RejectionReason, DogId, AdoptionCardId, AdoptionStatusId)
			VALUES (@AdoptionRecordId, GETDATE(), NULL, @DogId, @AdoptionCardId, '1D02B09E-CE00-4CEF-AF57-9EE0084476D5')

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
		 DECLARE @ErrorLine INT = ERROR_LINE();
		 DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		 DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		 DECLARE @ErrorState INT = ERROR_STATE();

		 IF @@TRANCOUNT > 0
			  ROLLBACK TRANSACTION;

		 RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO



-- Zmiana statusu wniosku adopcyjnego przez pracownika
CREATE OR ALTER PROCEDURE Shelter.UpdateAdoptionRecordStatus
    @AdoptionRecordId uniqueidentifier,
	@NewStatusId uniqueidentifier
AS
BEGIN
    DECLARE @CurrentAdoptionStatusId uniqueidentifier;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Shelter.AdoptionRecords WHERE Id = @AdoptionRecordId)
        BEGIN
            RAISERROR('Wniosek adopcyjny o podanym Id nie istnieje.', 16, 1)
        END

		IF @NewStatusId NOT IN ('1d02b09e-ce00-4cef-af57-9ee0084476d5', '494d8c27-ad71-43e3-a216-f0be0450f135',
			'e9497513-d728-4221-b48e-5b34d022b387', '0e5add7b-d4af-4a39-9a49-ee76e22ed69b')
        BEGIN
            RAISERROR('Nieznany status adopcji.', 16, 1)
        END

		SELECT @CurrentAdoptionStatusId = AdoptionStatusId
			FROM Shelter.AdoptionRecords
        WHERE Id = @AdoptionRecordId

        IF @CurrentAdoptionStatusId IN ('e9497513-d728-4221-b48e-5b34d022b387', '0e5add7b-d4af-4a39-9a49-ee76e22ed69b')
        BEGIN
            RAISERROR('Wniosek adopcyjny jest ju¿ zamkniêty.', 16, 1)
        END

        UPDATE Shelter.AdoptionRecords
			SET AdoptionStatusId = @NewStatusId,
				LastUpdateDate = GETDATE()
		WHERE Id=@AdoptionRecordId

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO



-- Zgloszenie chêci odbycia wizyty zapoznawczej z psem
CREATE OR ALTER PROCEDURE Shelter.SubmitFamiliarizationVisitRequest
    @UserId uniqueidentifier,
    @DogId uniqueidentifier
AS
BEGIN
    DECLARE @VisitId uniqueidentifier = NEWID();
    DECLARE @DogStatusId uniqueidentifier;
    DECLARE @UserRoleId uniqueidentifier;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Shelter.Dogs WHERE Id = @DogId)
        BEGIN
            RAISERROR('Pies o podanym ID nie istnieje.', 16, 1)
        END

        SELECT @DogStatusId = DogStatusId
			FROM Shelter.Dogs
        WHERE Id = @DogId

        IF @DogStatusId != '568AC4DD-5FA2-4D0D-B1C6-E13BE5663D4C'
        BEGIN
            RAISERROR('Pies nie jest dostêpny do wizyt.', 16, 1)
        END

        IF NOT EXISTS (SELECT 1 FROM Shelter.Users WHERE Id = @UserId)
        BEGIN
            RAISERROR('U¿ytkownik o podanym ID nie istnieje.', 16, 1)
        END

        SELECT @UserRoleId = RoleId
			FROM Shelter.Users
        WHERE Id = @UserId;

        IF @UserRoleId != 'da3609e9-9cfe-4940-bee7-6bff6695a3d9'
        BEGIN
            RAISERROR('U¿ytkownik nie jest klientem schroniska.', 16, 1);
        END

        INSERT INTO Shelter.FamiliarizationVisits (Id, StartDate, EndDate, RejectionReason, DogId, VisitorId, EmployeeId, VisitStatusId)
			VALUES (@VisitId, NULL, NULL, NULL, @DogId, @UserId, NULL, '07fa688a-f536-4b3d-a286-828bc032a588');

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO



-- Modyfikacja wizyty zapoznawczej (przypisanie terminu, odrzucenie wizyty)
CREATE OR ALTER PROCEDURE Shelter.UpdateFamiliarizationVisit
    @FamiliarizationVisitId uniqueidentifier,
    @EmployeeId uniqueidentifier,
    @StartDate DATETIME2,
    @EndDate DATETIME2,
    @VisitStatusId uniqueidentifier,
    @RejectionReason NVARCHAR(500) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Shelter.FamiliarizationVisits WHERE Id = @FamiliarizationVisitId)
        BEGIN
            RAISERROR('Wizyta zapoznawcza o podanym ID nie istnieje.', 16, 1)
        END

		IF EXISTS (SELECT 1 FROM Shelter.FamiliarizationVisits AS fv
			WHERE fv.Id = @FamiliarizationVisitId AND fv.VisitStatusId IN ('15fc7712-0554-48bd-b56f-b2f079fe5dc1', '30349b10-1911-44ba-98b6-b02a3cb9403a'))
        BEGIN
            RAISERROR('Nie mo¿na edytowaæ zamkniêtej wizyty.', 16, 1)
        END

        IF NOT EXISTS (SELECT 1 FROM Shelter.Users AS u WHERE u.Id = @EmployeeId AND u.RoleId = '5d5a0648-4adc-40f8-883f-fb9d9e4e4ce3')
        BEGIN
            RAISERROR('Pracownik o podanym ID nie istnieje.', 16, 1)
        END

        IF @EndDate <= @StartDate
        BEGIN
            RAISERROR('Podano nieprawid³owy zakres dat', 16, 1)
        END

        IF NOT EXISTS (SELECT 1 FROM Shelter.VisitStatuses WHERE Id = @VisitStatusId)
        BEGIN
            RAISERROR('Podano nieprawid³owy status wizyty.', 16, 1)
        END

        IF EXISTS (
            SELECT 1
				FROM Shelter.FamiliarizationVisits AS fv
            WHERE fv.EmployeeId = @EmployeeId
              AND fv.Id != @FamiliarizationVisitId
              AND (
                  (@StartDate BETWEEN fv.StartDate AND fv.EndDate) OR
                  (@EndDate BETWEEN fv.StartDate AND fv.EndDate) OR
                  (fv.StartDate BETWEEN @StartDate AND @EndDate)
              )
        )
        BEGIN
            RAISERROR('Wyst¹pi³a kolizja dat. W podanym terminie pracownik odbywa inn¹ wizytê.', 16, 1)
        END

        UPDATE Shelter.FamiliarizationVisits
        SET StartDate = @StartDate,
            EndDate = @EndDate,
            EmployeeId = @EmployeeId,
            VisitStatusId = @VisitStatusId,
            RejectionReason = @RejectionReason
        WHERE Id = @FamiliarizationVisitId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END
GO



-- Zmiana statusu psa
CREATE OR ALTER PROCEDURE Shelter.UpdateDogStatus
    @DogId uniqueidentifier,
	@NewStatusId uniqueidentifier
AS
BEGIN
	DECLARE @CurrentDogStatusId uniqueidentifier;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Shelter.Dogs WHERE Id = @DogId)
        BEGIN
            RAISERROR('Pies o podanym Id nie istnieje.', 16, 1)
        END

		IF @NewStatusId NOT IN ('568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692')
        BEGIN
            RAISERROR('Niepoprawny status psa.', 16, 1)
        END

        SELECT @CurrentDogStatusId = DogStatusId
			FROM Shelter.Dogs
        WHERE Id = @DogId

        IF @CurrentDogStatusId = '43051a55-003b-4f4b-a43d-2bff8f43027c'
        BEGIN
            RAISERROR('Pies zosta³ ju¿ oddany do adopcji.', 16, 1)
        END

        UPDATE Shelter.Dogs
			SET DogStatusId = @NewStatusId
		WHERE Id=@DogId

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO