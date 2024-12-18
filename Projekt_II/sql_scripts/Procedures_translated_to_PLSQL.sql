CREATE OR REPLACE PROCEDURE shelter.addclient(
	IN paramfirstname character varying,
	IN paramlastname character varying,
	IN paramemail character varying,
	IN paramphonenumber character varying,
	IN paramdateofbirth date)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS
DECLARE
    userid UUID := gen_random_uuid();
    usercredentialsid UUID := gen_random_uuid();
    adoptioncardid UUID := gen_random_uuid();
BEGIN
	INSERT INTO shelter.users (id, firstname, lastname, roleid)
		VALUES (userid, paramfirstname, paramlastname, 'da3609e9-9cfe-4940-bee7-6bff6695a3d9');

	INSERT INTO shelter.usercredentials (id, email, phonenumber, dateofbirth, userid)
		VALUES (usercredentialsid, paramemail, paramphonenumber, paramdateofbirth, userid);

	INSERT INTO shelter.adoptioncards (id, registrationdate, userid)
		VALUES (adoptioncardid, CURRENT_TIMESTAMP, userid);

EXCEPTION
	WHEN OTHERS THEN
		RAISE EXCEPTION 'Error in add_client: %', SQLERRM;
END;



CREATE OR REPLACE PROCEDURE shelter.adddog(
	IN paramname character varying,
	IN parambreed character varying,
	IN paramestimatedbirthdate date,
	IN paramshelterid uuid,
	IN paramweight integer,
	IN paramdescription character varying DEFAULT NULL::character varying)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS
DECLARE
    dogid UUID := gen_random_uuid();
    dogcharacteristicsid UUID := gen_random_uuid();
    medicalcardid UUID := gen_random_uuid();
BEGIN
	INSERT INTO shelter.dogs (id, name, breed, estimatedbirthdate, dogstatusid, shelterid)
		VALUES (dogid, paramname, parambreed, paramestimatedbirthdate, 'e3db7a04-a42b-4820-b3f2-b6c29dfca8c7', paramshelterid);

	INSERT INTO shelter.dogcharacteristics (id, weight, description, dogid)
		VALUES (dogcharacteristicsid, paramweight, paramdescription, dogid);

	INSERT INTO shelter.medicalcards (id, creationdate, dogid)
		VALUES (medicalcardid, CURRENT_TIMESTAMP, dogid);

EXCEPTION
	WHEN OTHERS THEN
		RAISE EXCEPTION 'Error in add_dog: %', SQLERRM;
END;



CREATE OR REPLACE PROCEDURE shelter.addshelter(
	IN paramname character varying,
	IN paramaddressid uuid)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS
DECLARE
    shelterid UUID := gen_random_uuid();
BEGIN
	INSERT INTO shelter.shelters (id, name, addressid)
		VALUES (shelterid, paramname, paramaddressid);

EXCEPTION
	WHEN OTHERS THEN
		RAISE EXCEPTION 'Error in add_shelter: %', SQLERRM;
END;



CREATE OR REPLACE PROCEDURE shelter.submitadoptionrequest(
	IN paramuserid uuid,
	IN paramdogid uuid)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS
DECLARE
    adoptioncardid UUID;
    adoptionrecordid UUID := gen_random_uuid();
    dogstatusid UUID;
    userroleid UUID;
BEGIN
        IF NOT EXISTS (SELECT 1 FROM shelter.dogs AS d WHERE d.id = paramdogid) THEN
            RAISE EXCEPTION 'Pies o podanym ID nie istnieje.';
        END IF;

        SELECT d.dogstatusid INTO dogstatusid
        	FROM shelter.dogs AS d
        WHERE d.id = paramdogid;

        IF dogstatusid != '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c' THEN
            RAISE EXCEPTION 'Pies nie jest dostępny do adopcji.';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM shelter.users AS u WHERE u.id = paramuserid) THEN
            RAISE EXCEPTION 'Użytkownik o podanym ID nie istnieje.';
        END IF;

        SELECT u.roleid INTO userroleid
        	FROM shelter.users AS u
        WHERE u.id = paramuserid;

        IF userroleid != 'da3609e9-9cfe-4940-bee7-6bff6695a3d9' THEN
            RAISE EXCEPTION 'Użytkownik nie jest klientem schroniska.';
        END IF;

        SELECT ac.id INTO adoptioncardid
        	FROM shelter.adoptioncards AS ac
        WHERE ac.userid = paramuserid;

        IF adoptioncardid IS NULL THEN
            RAISE EXCEPTION 'Użytkownik nie posiada założonej karty adopcyjnej.';
        END IF;

        INSERT INTO shelter.adoptionrecords (id, lastupdatedate, rejectionreason, dogid, adoptioncardid, adoptionstatusid)
	        VALUES (
	            adoptionrecordid, 
	            NOW(), 
	            NULL, 
	            paramdogid, 
	            adoptioncardid, 
	            '1d02b09e-ce00-4cef-af57-9ee0084476d5'
	        );

EXCEPTION
	WHEN OTHERS THEN
		RAISE EXCEPTION 'Error in submit_adoption_request: %', SQLERRM;
END;



CREATE OR REPLACE PROCEDURE shelter.submitfamiliarizationvisitrequest(
	IN paramuserid uuid,
	IN paramdogid uuid)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS
DECLARE
    visitid UUID := gen_random_uuid();
    dogstatusid UUID;
    userroleid UUID;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM shelter.dogs AS d WHERE d.id = paramdogid) THEN
        RAISE EXCEPTION 'Pies o podanym ID nie istnieje.';
    END IF;

    SELECT d.dogstatusid INTO dogstatusid
    	FROM shelter.dogs AS d
    WHERE d.id = paramdogid;

    IF dogstatusid != '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c' THEN
        RAISE EXCEPTION 'Pies nie jest dostępny do wizyt.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM shelter.users AS u WHERE u.id = paramuserid) THEN
        RAISE EXCEPTION 'Użytkownik o podanym ID nie istnieje.';
    END IF;

    SELECT u.roleid INTO userroleid
    	FROM shelter.users AS u
    WHERE u.id = paramuserid;

    IF userroleid != 'da3609e9-9cfe-4940-bee7-6bff6695a3d9' THEN
        RAISE EXCEPTION 'Użytkownik nie jest klientem schroniska.';
    END IF;

    INSERT INTO shelter.familiarizationvisits AS fv (
        id, startdate, enddate, rejectionreason, dogid, visitorid, employeeid, visitstatusid
    )
    VALUES (
        visitid, NULL, NULL, NULL, paramdogid, paramuserid, NULL, '07fa688a-f536-4b3d-a286-828bc032a588'
    );

END;



CREATE OR REPLACE PROCEDURE shelter.updateadoptionrecordstatus(
	IN paramadoptionrecordid uuid,
	IN paramnewstatusid uuid)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS
DECLARE
    currentadoptionstatusid UUID;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM shelter.adoptionrecords WHERE id = paramadoptionrecordid) THEN
        RAISE EXCEPTION 'Wniosek adopcyjny o podanym Id nie istnieje.';
    END IF;

    IF paramnewstatusid NOT IN ('1d02b09e-ce00-4cef-af57-9ee0084476d5', 
                                '494d8c27-ad71-43e3-a216-f0be0450f135',
                                'e9497513-d728-4221-b48e-5b34d022b387', 
                                '0e5add7b-d4af-4a39-9a49-ee76e22ed69b') THEN
        RAISE EXCEPTION 'Nieznany status adopcji.';
    END IF;

    SELECT ar.adoptionstatusid INTO currentadoptionstatusid
    	FROM shelter.adoptionrecords AS ar
    WHERE ar.id = paramadoptionrecordid;

    IF currentadoptionstatusid IN ('e9497513-d728-4221-b48e-5b34d022b387', 
                                   '0e5add7b-d4af-4a39-9a49-ee76e22ed69b') THEN
        RAISE EXCEPTION 'Wniosek adopcyjny jest już zamknięty.';
    END IF;

    UPDATE shelter.adoptionrecords
    SET adoptionstatusid = paramnewstatusid,
        lastupdatedate = NOW()
    WHERE id = paramadoptionrecordid;

END;



CREATE OR REPLACE PROCEDURE shelter.updatefamiliarizationvisit(
	IN paramfamiliarizationvisitid uuid,
	IN paramemployeeid uuid,
	IN paramstartdate timestamp with time zone,
	IN paramenddate timestamp with time zone,
	IN paramvisitstatusid uuid,
	IN paramrejectionreason text DEFAULT NULL::text)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM shelter.familiarizationvisits AS fv WHERE fv.id = paramfamiliarizationvisitid) THEN
        RAISE EXCEPTION 'Wizyta zapoznawcza o podanym ID nie istnieje.';
    END IF;

    IF EXISTS (SELECT 1 FROM shelter.familiarizationvisits AS fv 
               WHERE fv.id = paramfamiliarizationvisitid 
                 AND fv.visitstatusid IN ('15fc7712-0554-48bd-b56f-b2f079fe5dc1', '30349b10-1911-44ba-98b6-b02a3cb9403a')) THEN
        RAISE EXCEPTION 'Nie można edytować zamkniętej wizyty.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM shelter.users AS u 
                   WHERE u.id = paramemployeeid 
                     AND u.roleid = '5d5a0648-4adc-40f8-883f-fb9d9e4e4ce3') THEN
        RAISE EXCEPTION 'Pracownik o podanym ID nie istnieje.';
    END IF;

    IF paramenddate <= paramstartdate THEN
        RAISE EXCEPTION 'Podano nieprawidłowy zakres dat';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM shelter.visitstatuses AS vs WHERE vs.id = paramvisitstatusid) THEN
        RAISE EXCEPTION 'Podano nieprawidłowy status wizyty.';
    END IF;

    -- Check for scheduling conflicts for the employee
    IF EXISTS (
        SELECT 1
        FROM shelter.familiarizationvisits AS fv
        WHERE fv.employeeid = paramemployeeid
          AND fv.id != paramfamiliarizationvisitid
          AND (
              (paramstartdate BETWEEN fv.startdate AND fv.enddate) OR
              (paramenddate BETWEEN fv.startdate AND fv.enddate) OR
              (fv.startdate BETWEEN paramstartdate AND paramenddate)
          )
    ) THEN
        RAISE EXCEPTION 'Wystąpiła kolizja dat. W podanym terminie pracownik odbywa inną wizytę.';
    END IF;

    UPDATE shelter.familiarizationvisits
    SET startdate = paramstartdate,
        enddate = paramenddate,
        employeeid = paramemployeeid,
        visitstatusid = paramvisitstatusid,
        rejectionreason = paramrejectionreason
    WHERE id = paramfamiliarizationvisitid;

END;



CREATE OR REPLACE PROCEDURE shelter.updatedogstatus(
	IN paramdogid uuid,
	IN paramnewstatusid uuid)
LANGUAGE 'plpgsql'
AS
DECLARE
    currentdogstatusid UUID;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM shelter.dogs AS d WHERE d.id = paramdogid) THEN
        RAISE EXCEPTION 'Pies o podanym Id nie istnieje.';
    END IF;

    IF paramnewstatusid NOT IN ('568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692') THEN
        RAISE EXCEPTION 'Niepoprawny status psa.';
    END IF;

    SELECT d.dogstatusid INTO currentdogstatusid
    	FROM shelter.dogs AS d
    WHERE d.id = paramdogid;

    IF currentdogstatusid = '43051a55-003b-4f4b-a43d-2bff8f43027c' THEN
        RAISE EXCEPTION 'Pies został już oddany do adopcji.';
    END IF;

    UPDATE shelter.dogs
    	SET dogstatusid = paramnewstatusid
    WHERE id = paramdogid;

END;