-- ClientAvailableDogsView
CREATE OR REPLACE VIEW shelter.clientavailabledogsview AS
SELECT 
    d.name AS dogname,
    d.breed AS dogbreed,
    EXTRACT(YEAR FROM d.estimatedbirthdate) AS estimatedbirthyear,
    EXTRACT(MONTH FROM d.estimatedbirthdate) AS estimatedbirthmonth,
    dch.weight AS dogweight,
    dch.description AS dogdescription,
    s.name AS sheltername,
    a.street || ', ' || a.city || ', ' || a.postalcode AS shelteraddress,
    mc.creationdate AS medicalcardregistrationdate,
    mcr.description AS latestmedicalrecord
FROM 
    shelter.dogs d
    INNER JOIN shelter.shelters s ON s.id = d.shelterid
    INNER JOIN shelter.addresses a ON a.id = s.addressid
    LEFT JOIN shelter.dogcharacteristics dch ON dch.dogid = d.id
    LEFT JOIN shelter.medicalcards mc ON mc.dogid = d.id
    LEFT JOIN shelter.medicalcardrecords mcr ON mcr.medicalcardid = mc.id
    LEFT JOIN shelter.dogstatuses ds ON ds.id = d.dogstatusid
WHERE 
    ds.name = 'Available'
    AND (mcr.date = (SELECT MAX(date) FROM shelter.medicalcardrecords WHERE medicalcardid = mc.id) OR mcr.date IS NULL);


-- ClientAdoptionHistoryView
CREATE OR REPLACE VIEW shelter.clientadoptionhistoryview AS
SELECT 
    u.firstname AS clientfirstname,
    u.lastname AS clientlastname,
    d.name AS dogname,
    ar.lastupdatedate AS requestlastupdate,
    ast.name AS adoptionstatus,
    ar.rejectionreason
FROM 
    shelter.adoptionrecords ar
    INNER JOIN shelter.adoptioncards ac ON ac.id = ar.adoptioncardid
    INNER JOIN shelter.users u ON u.id = ac.userid
    INNER JOIN shelter.dogs d ON d.id = ar.dogid
    INNER JOIN shelter.adoptionstatuses ast ON ast.id = ar.adoptionstatusid
WHERE 
    u.roleid = 'DA3609E9-9CFE-4940-BEE7-6BFF6695A3D9';


-- EmployeeDogManagementView
CREATE OR REPLACE VIEW shelter.employeedogmanagementview AS
SELECT 
    d.name AS dogname,
    d.breed,
    EXTRACT(YEAR FROM d.estimatedbirthdate) AS estimatedbirthyear,
    EXTRACT(MONTH FROM d.estimatedbirthdate) AS estimatedbirthmonth,
    ds.name AS dogstatus,
    dch.weight AS dogweight,
    dch.description AS dogdescription,
    mc.creationdate AS medicalcardcreateddate,
    latestmedicalrecord.description AS latestmedicalrecord,
    latestmedicalrecord.date AS latestmedicalrecorddate,
    s.name AS sheltername,
    a.street || ', ' || a.city || ', ' || a.postalcode AS shelteraddress
FROM 
    shelter.dogs d
    INNER JOIN shelter.shelters s ON s.id = d.shelterid
    INNER JOIN shelter.addresses a ON a.id = s.addressid
    LEFT JOIN shelter.dogcharacteristics dch ON d.id = dch.dogid
    LEFT JOIN shelter.dogstatuses ds ON ds.id = d.dogstatusid
    LEFT JOIN shelter.medicalcards mc ON mc.dogid = d.id
    LEFT JOIN (
        SELECT 
            mcr.medicalcardid,
            mcr.description,
            mcr.date
        FROM 
            shelter.medicalcardrecords mcr
        WHERE 
            mcr.date = (
                SELECT MAX(innermcr.date)
                FROM shelter.medicalcardrecords innermcr
                WHERE innermcr.medicalcardid = mcr.medicalcardid
            )
    ) AS latestmedicalrecord ON latestmedicalrecord.medicalcardid = mc.id;


-- EmployeeVisitSupervisionView
CREATE OR REPLACE VIEW shelter.employeevisitsupervisionview AS
SELECT 
    employeeuser.firstname AS employeefirstname,
    employeeuser.lastname AS employeelastname,
    clientuser.firstname AS clientfirstname,
    clientuser.lastname AS clientlastname,
    fv.startdate,
    fv.enddate,
    v.name AS visitstatus,
    d.name AS dogname,
    EXTRACT(YEAR FROM d.estimatedbirthdate) AS estimatedbirthyear,
    EXTRACT(MONTH FROM d.estimatedbirthdate) AS estimatedbirthmonth,
    s.name AS shelter_name,
    a.street || ', ' || a.city || ', ' || a.postalcode AS shelteraddress
FROM 
    shelter.familiarizationvisits fv
    INNER JOIN shelter.users employeeuser ON employeeuser.id = fv.employeeid
    INNER JOIN shelter.users clientuser ON clientuser.id = fv.visitorid
    INNER JOIN shelter.dogs d ON d.id = fv.dogid
    INNER JOIN shelter.shelters s ON s.id = d.shelterid
    INNER JOIN shelter.addresses a ON a.id = s.addressid
    INNER JOIN shelter.visitstatuses v ON v.id = fv.visitstatusid
WHERE 
    employeeuser.roleid = '5D5A0648-4ADC-40F8-883F-FB9D9E4E4CE3';