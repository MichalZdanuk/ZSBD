-- Skrypt do utworzenia perpektyw

-- perspektywy udostêpnione klientom schroniska

-- ClientAvailableDogsView
-- perspektywa umo¿liwia klientom przegl¹danie dostêpnych psów w schroniskach wraz z informacjami o ich rasie,
-- statusie zdrowotnym oraz lokalizacj¹ schroniska, w którym siê znajduj¹
CREATE OR ALTER VIEW Shelter.ClientAvailableDogsView
AS
	SELECT 
		d.[Name] AS DogName,
		d.Breed AS DogBreed,
		dch.[Weight] AS DogWeight,
		dch.[Description] AS DogDescription,
		s.[Name] AS ShelterName,
		CONCAT(a.Street, ', ', a.City, ', ', a.PostalCode) AS ShelterAddress,
		mc.CreationDate AS MedicalCardRegistrationDate,
		mcr.[Description] AS LatestMedicalRecord
	FROM 
		Shelter.Dogs d
		INNER JOIN Shelter.Shelters AS s ON s.Id = d.ShelterId 
		INNER JOIN Shelter.Addresses AS a ON a.Id = s.AddressId
		LEFT JOIN Shelter.DogCharacteristics AS dch ON dch.DogId = d.Id
		LEFT JOIN Shelter.MedicalCards AS mc ON mc.DogId = d.Id
		LEFT JOIN Shelter.MedicalCardRecords AS mcr ON mcr.MedicalCardId = mc.Id
		LEFT JOIN Shelter.DogStatuses AS ds ON ds.Id = d.DogStatusId
	WHERE 
		ds.[Name] = 'Available'
		AND (mcr.Date = (SELECT MAX(Date) FROM Shelter.MedicalCardRecords WHERE MedicalCardId = mc.Id) OR mcr.Date IS NULL)
GO


-- ClientAdoptionHistoryView
-- perspektywa umo¿liwia klientom schroniska przegl¹danie historii adopcji, w tym statusu wniosków,
-- przyczyny odrzucenia, czy informacji o zaakceptowanej adopcji.
CREATE OR ALTER VIEW Shelter.ClientAdoptionHistoryView
AS
	SELECT 
		u.FirstName AS ClientFirstName,
		u.LastName AS ClientLastName,
		d.[Name] AS DogName,
		ar.LastUpdateDate AS RequestLastUpdate,
		ast.[Name] AS AdoptionStatus,
		ar.RejectionReason
	FROM 
		Shelter.AdoptionRecords ar
		INNER JOIN Shelter.AdoptionCards AS ac ON ac.Id = ar.AdoptionCardId
		INNER JOIN Shelter.Users AS u ON u.Id = ac.UserId
		INNER JOIN Shelter.Dogs AS d ON d.Id = ar.DogId
		INNER JOIN Shelter.AdoptionStatuses AS ast ON ast.Id = ar.AdoptionStatusId
	WHERE 
		u.RoleId = 'DA3609E9-9CFE-4940-BEE7-6BFF6695A3D9'
GO

-- perspektywy udostêpnione pracownikom schroniska

-- EmployeeDogManagementView
-- perspektywa dostarcza listê psów przypisanych do danego schroniska, wraz z ich aktualnym statusem,
-- charakterystyk¹ oraz ostatnim wpisem w karcie medycznej.
CREATE OR ALTER VIEW Shelter.EmployeeDogManagementView
AS
	SELECT 
		d.[Name] AS DogName,
		d.Breed,
		ds.[Name] AS DogStatus,
		dch.[Weight] AS DogWeight,
		dch.[Description] AS DogDescription,
		mc.CreationDate AS MedicalCardCreatedDate,
		mcr.[Description] AS LatestMedicalRecord,
		s.[Name] AS ShelterName,
		CONCAT(a.Street, ', ', a.City, ', ', a.PostalCode) AS ShelterAddress
	FROM 
		Shelter.Dogs d
		INNER JOIN Shelter.Shelters AS s ON s.Id = d.ShelterId
		INNER JOIN Shelter.Addresses AS a ON a.Id = s.AddressId
		LEFT JOIN Shelter.DogCharacteristics AS dch ON d.Id = dch.DogId 
		LEFT JOIN Shelter.DogStatuses AS ds ON ds.Id = d.DogStatusId
		LEFT JOIN Shelter.MedicalCards AS mc ON mc.DogId = d.Id
		LEFT JOIN Shelter.MedicalCardRecords AS mcr ON mcr.MedicalCardId = mc.Id
GO

-- EmployeeVisitSupervisionView
-- perspektywa umo¿liwia pracownikom œledzenie i nadzorowanie wizyt zapoznawczych,
-- którymi siê zajmuj¹.
CREATE OR ALTER VIEW Shelter.EmployeeVisitSupervisionView
AS
	SELECT 
		employeeUser.FirstName AS EmployeeFirstName,
		employeeUser.LastName AS EmployeeLastName,
		clientUser.FirstName AS ClientFirstName,
		clientUser.LastName AS ClientLastName,
		fv.DateOfVisit,
		v.[Name] AS VisitStatus,
		d.[Name] AS DogName,
		s.[Name] AS ShelterName,
		CONCAT(a.Street, ', ', a.City, ', ', a.PostalCode) AS ShelterAddress
	FROM 
		Shelter.FamiliarizationVisits fv
		INNER JOIN Shelter.Users AS employeeUser ON employeeUser.Id = fv.EmployeeId
		INNER JOIN Shelter.Users AS clientUser ON clientUser.Id = fv.VisitorId
		INNER JOIN Shelter.Dogs AS d ON d.Id = fv.DogId 
		INNER JOIN Shelter.Shelters AS s ON s.Id = d.ShelterId
		INNER JOIN Shelter.Addresses AS a ON a.Id = s.AddressId
		INNER JOIN Shelter.VisitStatuses AS v ON v.Id = fv.VisitStatusId
	WHERE 
		employeeUser.RoleId = '5D5A0648-4ADC-40F8-883F-FB9D9E4E4CE3'
GO