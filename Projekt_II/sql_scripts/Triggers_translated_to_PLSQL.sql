-- Trigger_OnAdoptionRecordStatusChange
CREATE OR REPLACE FUNCTION shelter.triggeronadoptionrecordstatuschangefunction()
RETURNS TRIGGER AS $$
DECLARE
    oldstatus UUID;
    newstatus UUID;
BEGIN
    oldstatus := OLD.adoptionstatusid;
    newstatus := NEW.adoptionstatusid;

    IF oldstatus = '1d02b09e-ce00-4cef-af57-9ee0084476d5' AND newstatus = '494d8c27-ad71-43e3-a216-f0be0450f135' THEN
        UPDATE shelter.adoptionrecords
        SET adoptionstatusid = '0e5add7b-d4af-4a39-9a49-ee76e22ed69b',
            rejectionreason = 'Wniosek innego klienta dla tego psa został zaakceptowany.',
            lastupdatedate = CURRENT_TIMESTAMP
        WHERE dogid = NEW.dogid
          AND adoptionstatusid = '1d02b09e-ce00-4cef-af57-9ee0084476d5'
          AND id != NEW.id;

        UPDATE shelter.familiarizationvisits
        SET visitstatusid = '30349b10-1911-44ba-98b6-b02a3cb9403a',
            rejectionreason = 'Wniosek innego klienta dla tego psa został zaakceptowany.'
        WHERE dogid = NEW.dogid
          AND visitstatusid = '07fa688a-f536-4b3d-a286-828bc032a588';

        UPDATE shelter.dogs
        SET dogstatusid = '1adf5a5b-342e-4341-9d37-9796367ab0a5'
        WHERE id = NEW.dogid;

    ELSIF oldstatus = '494d8c27-ad71-43e3-a216-f0be0450f135' AND newstatus = 'e9497513-d728-4221-b48e-5b34d022b387' THEN
        UPDATE shelter.adoptionrecords
        SET lastupdatedate = CURRENT_TIMESTAMP
        WHERE id = NEW.id;

        UPDATE shelter.dogs
        SET dogstatusid = '43051a55-003b-4f4b-a43d-2bff8f43027c'
        WHERE id = NEW.dogid;
    END IF;

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in Trigger_OnAdoptionRecordStatusChange: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER triggeronadoptionrecordstatuschange
AFTER UPDATE ON shelter.adoptionrecords
FOR EACH ROW
EXECUTE FUNCTION shelter.triggeronadoptionrecordstatuschangefunction();


-- Trigger_UpdateDogStatus
CREATE OR REPLACE FUNCTION shelter.triggerupdatedogstatusfunction()
RETURNS TRIGGER AS $$
DECLARE
    newstatus UUID;
BEGIN
    newstatus := NEW.dogstatusid;

    IF newstatus = 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692' THEN
        UPDATE shelter.adoptionrecords
        SET adoptionstatusid = '0e5add7b-d4af-4a39-9a49-ee76e22ed69b',
            rejectionreason = 'Wniosek został odrzucony w związku z uśpieniem psa.',
            lastupdatedate = CURRENT_TIMESTAMP
        WHERE dogid = NEW.id;

        UPDATE shelter.familiarizationvisits
        SET visitstatusid = '30349b10-1911-44ba-98b6-b02a3cb9403a',
            rejectionreason = 'Wniosek został odrzucony w związku z uśpieniem psa.'
        WHERE dogid = NEW.id;
    END IF;

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in Trigger_UpdateDogStatus: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER triggerupdatedogstatus
AFTER UPDATE ON shelter.dogs
FOR EACH ROW
EXECUTE FUNCTION shelter.triggerupdatedogstatusfunction();