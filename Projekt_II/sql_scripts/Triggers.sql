USE ShelterDB
GO

-- Triggery

-- Trigger_OnAdoptionRecordStatusChange - pilnuje sp�jno�ci wniosk�w adopcyjnych
-- w przypadku, gdy zaakceptujemy wniosek o adopcj� psa, w�wczas musimy odrzuci� wszelkie
-- pozosta�e wnioski i wizyty oraz zmieni� status psa + zaktualizowa� daty
-- gdy zmienimy status wniosku na Realised, w�wczas aktualizujemy wniosek oraz status psa
CREATE OR ALTER TRIGGER Shelter.Trigger_OnAdoptionRecordStatusChange
	ON Shelter.AdoptionRecords AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @OldStatus uniqueidentifier
    DECLARE @NewStatus uniqueidentifier

	BEGIN TRY
		BEGIN TRANSACTION
		
		SELECT @OldStatus = d.AdoptionStatusId, @NewStatus = i.AdoptionStatusId
        FROM inserted i
        JOIN deleted d ON d.Id = i.Id;

        IF @OldStatus = '1d02b09e-ce00-4cef-af57-9ee0084476d5' AND @NewStatus = '494d8c27-ad71-43e3-a216-f0be0450f135'
        BEGIN
            UPDATE Shelter.AdoptionRecords
            SET AdoptionStatusId = '0e5add7b-d4af-4a39-9a49-ee76e22ed69b',
                RejectionReason = 'Wniosek innego klienta dla tego psa zosta� zaakceptowany.',
                LastUpdateDate = GETDATE()
            FROM Shelter.AdoptionRecords ar
                JOIN inserted i ON ar.DogId = i.DogId
            WHERE ar.AdoptionStatusId = '1d02b09e-ce00-4cef-af57-9ee0084476d5'
              AND ar.Id != i.Id;

            UPDATE Shelter.FamiliarizationVisits
				SET VisitStatusId = '30349b10-1911-44ba-98b6-b02a3cb9403a',
					RejectionReason = 'Wniosek innego klienta dla tego psa zosta� zaakceptowany.'
            FROM Shelter.FamiliarizationVisits fv
                JOIN inserted i ON fv.DogId = i.DogId
            WHERE fv.VisitStatusId = '07fa688a-f536-4b3d-a286-828bc032a588';

            UPDATE Shelter.Dogs
            SET DogStatusId = '1adf5a5b-342e-4341-9d37-9796367ab0a5'
            FROM Shelter.Dogs d
                JOIN inserted i ON d.Id = i.DogId;
        END
        ELSE IF @OldStatus = '494d8c27-ad71-43e3-a216-f0be0450f135' AND @NewStatus = 'e9497513-d728-4221-b48e-5b34d022b387'
        BEGIN
            UPDATE Shelter.AdoptionRecords
            SET LastUpdateDate = GETDATE()
            FROM Shelter.AdoptionRecords ar
                JOIN inserted i ON ar.Id = i.Id;

            UPDATE Shelter.Dogs
            SET DogStatusId = '43051a55-003b-4f4b-a43d-2bff8f43027c'
            FROM Shelter.Dogs d
                JOIN inserted i ON d.Id = i.DogId;
        END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Trigger_UpdateDogStatus - r�wnie� pilnuje sp�jno�ci wniosk�w adopcyjnych oraz wizyt
-- trigger powinien reagowa� tylko na zmian� statusu na Euthanized :(. W nieszcz�liwej
-- sytuacji, gdy u�pimy psa musimy anulowa� wszelkie interakcje z nim zwi�zane.
CREATE OR ALTER TRIGGER Shelter.Trigger_UpdateDogStatus
	ON Shelter.Dogs AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @OldStatus uniqueidentifier
    DECLARE @NewStatus uniqueidentifier

	BEGIN TRY
		BEGIN TRANSACTION
		
		SELECT @NewStatus = i.DogStatusId
			FROM inserted i

        IF @NewStatus = 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692'
        BEGIN
            UPDATE Shelter.AdoptionRecords
            SET AdoptionStatusId = '0e5add7b-d4af-4a39-9a49-ee76e22ed69b',
                RejectionReason = 'Wniosek zosta� odrzucony w zwi�zku z u�pieniem psa.',
                LastUpdateDate = GETDATE()
            FROM Shelter.AdoptionRecords ar
                JOIN inserted i ON ar.DogId = i.Id

            UPDATE Shelter.FamiliarizationVisits
	            SET VisitStatusId = '30349b10-1911-44ba-98b6-b02a3cb9403a',
					RejectionReason = 'Wniosek zosta� odrzucony w zwi�zku z u�pieniem psa.'
            FROM Shelter.FamiliarizationVisits fv
                JOIN inserted i ON fv.DogId = i.Id
        END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO