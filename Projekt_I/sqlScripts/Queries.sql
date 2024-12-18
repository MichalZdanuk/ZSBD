-- Nietrywialne przyk³adowe zapytania SQL

-- lista u¿ytkowników z rol¹ klienta, którym przynajmniej raz odrzucono wniosek o adopcjê,
-- wraz ze szczegó³ami ich ostatniej odrzuconej adopcji i zwi¹zanego z ni¹ psa.
-- (zapytanie przydatne pracownikom/analitykom pod k¹tem analizy statystyk), dane posortowane wzglêdem daty ostatniego rekordu adopcyjnego
SELECT
	u.FirstName AS [ClientFirstName],
	u.LastName AS [ClientLastName],
	d.[Name] AS [DogName],
	ar.LastUpdateDate AS [RejectionDate],
	ar.RejectionReason
FROM Shelter.Users AS u
	INNER JOIN Shelter.AdoptionCards AS ac ON ac.UserId = u.Id
	INNER JOIN Shelter.AdoptionRecords AS ar ON ar.AdoptionCardId = ac.Id
	INNER JOIN Shelter.Dogs AS d ON d.Id = ar.DogId
WHERE
	u.RoleId = 'DA3609E9-9CFE-4940-BEE7-6BFF6695A3D9' -- Client role
	AND ar.AdoptionStatusId = '0E5ADD7B-D4AF-4A39-9A49-EE76E22ED69B' -- -- Rjected status
	AND ar.LastUpdateDate = (
		SELECT MAX(LastUpdateDate)
		FROM Shelter.AdoptionRecords AS ar2
			WHERE ar2.AdoptionCardId = ac.Id
				AND ar2.AdoptionStatusId = ar.AdoptionStatusId
	)
	ORDER BY ar.LastUpdateDate DESC;
GO

-- zapytanie zwraca pogrupowane wyniki wizyt zapoznawczych dokonanych przez pracowników. Wyniki posortowane od najwiêkszej
-- liczby wizyt zapoznawczych do najmniejszej. Poza tym zwrócone s¹  szczegó³y ostatnich wizyt prowadzonych
-- przez pracowników (data wizyty oraz jaki pies uczestniczy³ w wizycie).
WITH EmployeeVisitCount AS (
    SELECT 
        fv.EmployeeId,
        COUNT(fv.Id) AS SupervisedVisitsCount
    FROM 
        Shelter.FamiliarizationVisits AS fv
		INNER JOIN Shelter.Users AS u ON u.Id = fv.EmployeeId
    WHERE 
        u.RoleId = '5D5A0648-4ADC-40F8-883F-FB9D9E4E4CE3' -- Employee role
        AND fv.VisitStatusId = '15FC7712-0554-48BD-B56F-B2F079FE5DC1' -- Completed visits
    GROUP BY 
        fv.EmployeeId
)
SELECT 
    u.FirstName AS EmployeeFirstName,
    u.LastName AS EmployeeLastName,
    evc.SupervisedVisitsCount,
    fv.DateOfVisit AS LastVisitDate,
    d.[Name] AS LastVisitedDog
FROM 
    EmployeeVisitCount evc
    INNER JOIN Shelter.Users AS u ON u.Id = evc.EmployeeId 
    INNER JOIN Shelter.FamiliarizationVisits AS fv ON fv.EmployeeId = u.Id
    INNER JOIN Shelter.Dogs AS d ON d.Id = fv.DogId
    INNER JOIN Shelter.VisitStatuses AS v ON v.Id = fv.VisitStatusId
WHERE 
    fv.VisitStatusId = '15FC7712-0554-48BD-B56F-B2F079FE5DC1' AND
	fv.DateOfVisit = (
        SELECT MAX(DateOfVisit)
			FROM Shelter.FamiliarizationVisits AS fv2
        WHERE fv2.EmployeeId = u.Id AND
			fv2.VisitStatusId = '15FC7712-0554-48BD-B56F-B2F079FE5DC1'
    )
ORDER BY 
    evc.SupervisedVisitsCount DESC;
GO