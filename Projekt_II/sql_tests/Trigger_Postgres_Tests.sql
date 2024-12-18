DO $$
DECLARE
    user_id1 UUID;
    user_id2 UUID;
    user_id3 UUID;
    example_adoption_record_id UUID;
BEGIN

    CALL shelter.addclient(
        'Katarzyna',
        'Nowicka',
        'katarzyna.nowicka@example.com',
        '9876543210',
        '1988-03-12'
    );

    SELECT u.id INTO user_id1
    	FROM shelter.users AS u
    		JOIN shelter.usercredentials AS uc ON uc.userid = u.id
    WHERE uc.email = 'katarzyna.nowicka@example.com';

    CALL shelter.addclient(
        'Michał',
        'Wiśniewski',
        'michal.wisniewski@example.com',
        '1234567890',
        '1982-07-22'
    );

    SELECT u.id INTO user_id2
    	FROM shelter.users AS u
    		JOIN shelter.usercredentials AS uc ON uc.userid = u.id
    WHERE uc.email = 'michal.wisniewski@example.com';

    CALL shelter.addclient(
        'Agnieszka',
        'Kowalska',
        'agnieszka.kowalska@example.com',
        '2345678901',
        '1995-11-30'
    );

    SELECT u.id INTO user_id3
    	FROM shelter.users AS u
    		JOIN shelter.usercredentials AS uc ON uc.userid = u.id
    WHERE uc.email = 'agnieszka.kowalska@example.com';

    CALL shelter.updatedogstatus(
        '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B',
        '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c'
    );

    CALL shelter.submitadoptionrequest(
        user_id1,
        '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B'
    );

    CALL shelter.submitadoptionrequest(
        user_id2,
        '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B'
    );

    CALL shelter.submitfamiliarizationvisitrequest(
        user_id3,
        '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B'
    );

    SELECT ar.id INTO example_adoption_record_id
    	FROM shelter.adoptionrecords AS ar
    		JOIN shelter.adoptioncards AS ac ON ac.id = ar.adoptioncardid
    WHERE ac.userid = user_id1 AND ar.dogid = '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B';

    CALL shelter.updateadoptionrecordstatus(
        example_adoption_record_id,
        '494d8c27-ad71-43e3-a216-f0be0450f135'
    );

END $$;

SELECT ar.id, ar.rejectionreason, ads.name AS status_name, ar.lastupdatedate
    FROM shelter.adoptionrecords AS ar
    	JOIN shelter.adoptionstatuses AS ads ON ads.id = ar.adoptionstatusid
WHERE ar.dogid = '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B';
	
SELECT fv.id, fv.employeeid, fv.visitorid, fv.startdate, fv.enddate, fv.rejectionreason, vs.name AS visit_status
	FROM shelter.familiarizationvisits AS fv
		JOIN shelter.visitstatuses AS vs ON vs.id = fv.visitstatusid
WHERE fv.dogid = '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B';
	
SELECT d.id, d.name, ds.name AS status_name
	FROM shelter.dogs AS d
		JOIN shelter.dogstatuses AS ds ON ds.id = d.dogstatusid
WHERE d.id = '94C56C5C-2E53-4BDA-A64A-F75AB0A9F16B';
