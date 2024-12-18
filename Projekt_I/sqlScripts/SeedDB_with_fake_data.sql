USE ShelterDB
GO
--- Seed Dictionaries ---

-- Seed UserRoles (3 records)
INSERT INTO Shelter.UserRoles (Id, [Name]) VALUES ('da3609e9-9cfe-4940-bee7-6bff6695a3d9', 'Client')
INSERT INTO Shelter.UserRoles (Id, [Name]) VALUES ('5d5a0648-4adc-40f8-883f-fb9d9e4e4ce3', 'Employee')
INSERT INTO Shelter.UserRoles (Id, [Name]) VALUES ('11de32bd-c7e1-4456-8c89-2de81af19ea2', 'Admin')
GO

-- Seed VisitStatuses (3 records)
INSERT INTO Shelter.VisitStatuses (Id, [Name]) VALUES ('07fa688a-f536-4b3d-a286-828bc032a588', 'Planned')
INSERT INTO Shelter.VisitStatuses (Id, [Name]) VALUES ('15fc7712-0554-48bd-b56f-b2f079fe5dc1', 'Completed')
INSERT INTO Shelter.VisitStatuses (Id, [Name]) VALUES ('30349b10-1911-44ba-98b6-b02a3cb9403a', 'Rejected')
GO

-- Seed AdoptionStatuses (4 records)
INSERT INTO Shelter.AdoptionStatuses(Id, [Name]) VALUES ('1d02b09e-ce00-4cef-af57-9ee0084476d5', 'FormApplied')
INSERT INTO Shelter.AdoptionStatuses(Id, [Name]) VALUES ('494d8c27-ad71-43e3-a216-f0be0450f135', 'Accepted')
INSERT INTO Shelter.AdoptionStatuses(Id, [Name]) VALUES ('e9497513-d728-4221-b48e-5b34d022b387', 'Realised')
INSERT INTO Shelter.AdoptionStatuses(Id, [Name]) VALUES ('0e5add7b-d4af-4a39-9a49-ee76e22ed69b', 'Rejected')
GO

-- Seed DogStatuses (4 records)
INSERT INTO Shelter.DogStatuses(Id, [Name]) VALUES ('e3db7a04-a42b-4820-b3f2-b6c29dfca8c7', 'Registered')
INSERT INTO Shelter.DogStatuses(Id, [Name]) VALUES ('568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', 'Available')
INSERT INTO Shelter.DogStatuses(Id, [Name]) VALUES ('43051a55-003b-4f4b-a43d-2bff8f43027c', 'Adopted')
INSERT INTO Shelter.DogStatuses(Id, [Name]) VALUES ('c482f14b-eb89-4c65-bb2c-2ef7b9fbf692', 'Euthanized')
GO

--- Seed other tables with fake data ---

-- Seed Users (7 records)
-- four clients 
INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
	VALUES ('9077731a-2cdd-4ead-94b6-ae1642a61882', 'Timofei', 'Frudd', 'da3609e9-9cfe-4940-bee7-6bff6695a3d9');
INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
	VALUES ('0cd4715a-f71f-4275-abb6-901c53d562ff', 'Son', 'Ardling', 'da3609e9-9cfe-4940-bee7-6bff6695a3d9');
INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
	VALUES ('470e2057-1fd6-48ba-ba75-2c4c1303a5d2', 'Karylin', 'Freire', 'da3609e9-9cfe-4940-bee7-6bff6695a3d9');
INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
	VALUES ('9809b169-812d-4773-99cf-cf130f926cb5', 'Waylon', 'Hause', 'da3609e9-9cfe-4940-bee7-6bff6695a3d9');
-- two employees
INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
	VALUES ('5459fd6a-ec98-4e04-9cce-83e04b9ae948', 'Addison', 'Grigorkin', '5d5a0648-4adc-40f8-883f-fb9d9e4e4ce3');
INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
	VALUES ('5f5e17ba-ad01-4693-b561-d1af584d55b9', 'Gigi', 'Scrymgeour', '5d5a0648-4adc-40f8-883f-fb9d9e4e4ce3');
-- one admin
INSERT INTO Shelter.Users (Id, FirstName, LastName, RoleId)
	VALUES ('1ceae619-8621-443b-b225-84411ab00170', 'Ketti', 'Siddon', '11de32bd-c7e1-4456-8c89-2de81af19ea2');
GO

-- Seed UserCredentials (7 records)
-- four clients
INSERT INTO Shelter.UserCredentials(Id, Email, PhoneNumber, DateOfBirth, UserId)
	VALUES ('3afc025b-04ae-45ab-82f4-376612a3eff0', 'tfrudd0@miibeian.gov.cn', '482639157', '8/25/1996', '9077731a-2cdd-4ead-94b6-ae1642a61882');
INSERT INTO Shelter.UserCredentials(Id, Email, PhoneNumber, DateOfBirth, UserId)
	VALUES ('b783cc1e-0838-4ce9-8f8c-f94e18dab5cf', 'sardling1@histats.com', '749281593', '11/28/1998', '0cd4715a-f71f-4275-abb6-901c53d562ff');
INSERT INTO Shelter.UserCredentials(Id, Email, PhoneNumber, DateOfBirth, UserId)
	VALUES ('38ff0415-7db1-4d89-9719-5078aee3f40c', 'kfreire2@ox.ac.uk', '628957341', '4/19/1980', '470e2057-1fd6-48ba-ba75-2c4c1303a5d2');
INSERT INTO Shelter.UserCredentials(Id, Email, PhoneNumber, DateOfBirth, UserId)
	VALUES ('81ac1827-c009-432d-8667-40f192a8f9bd', 'whause4@bizjournals.com', '195463728', '8/14/1998', '9809b169-812d-4773-99cf-cf130f926cb5');
-- two employees
INSERT INTO Shelter.UserCredentials(Id, Email, PhoneNumber, DateOfBirth, UserId)
	VALUES ('313dcb56-b22e-48f3-bec9-d7a68664e61e', 'agrigorkin3@slashdot.org', '583714926', '9/29/1985', '5459fd6a-ec98-4e04-9cce-83e04b9ae948');
INSERT INTO Shelter.UserCredentials(Id, Email, PhoneNumber, DateOfBirth, UserId)
	VALUES ('453c7cf6-0e9c-4261-a68a-9f4eb347f3b6', 'gscrymgeour4@skype.com', '271890345', '9/21/1987', '5f5e17ba-ad01-4693-b561-d1af584d55b9');
-- one admin
INSERT INTO Shelter.UserCredentials(Id, Email, PhoneNumber, DateOfBirth, UserId)
	VALUES ('7783c604-2051-4e84-a549-4d269623563d', 'ksiddon5@hc360.com', '946325781', '6/26/1979', '1ceae619-8621-443b-b225-84411ab00170');
GO


-- Seed AdoptionCards (4 records)
INSERT INTO Shelter.AdoptionCards(Id, RegistrationDate, UserId)
	VALUES ('bdc5cfbe-125b-44cf-8cad-6d4f45d0371b', '8/25/2020', '9077731a-2cdd-4ead-94b6-ae1642a61882')
INSERT INTO Shelter.AdoptionCards(Id, RegistrationDate, UserId)
	VALUES ('bc835bed-39fc-4928-a7e7-c5523977ec4f', '9/29/2021', '0cd4715a-f71f-4275-abb6-901c53d562ff')
INSERT INTO Shelter.AdoptionCards(Id, RegistrationDate, UserId)
	VALUES ('ad381d24-2982-4435-b21d-c3732740baff', '9/21/2022', '470e2057-1fd6-48ba-ba75-2c4c1303a5d2')
INSERT INTO Shelter.AdoptionCards(Id, RegistrationDate, UserId)
	VALUES ('0a622e21-bf6f-46db-8e50-e4377072294a', '9/21/2023', '9809b169-812d-4773-99cf-cf130f926cb5')
GO

-- Seed Addresses (6 records)
INSERT INTO Shelter.Addresses (Id, Street, City, PostalCode, AdditionalDescription)
	VALUES ('7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62', 'Lillian', 'Kremenki', '15-333', null);
INSERT INTO Shelter.Addresses (Id, Street, City, PostalCode, AdditionalDescription)
	VALUES ('4e5b894b-c28f-4a93-9a01-77c5f56b80a9', 'Forster', 'Banjar Brahmanabukit', '14-234', null);
INSERT INTO Shelter.Addresses (Id, Street, City, PostalCode, AdditionalDescription)
	VALUES ('c24e37e6-f31c-4116-8247-85e4b3ef7a53', 'Meadow Ridge', 'Marseille', '13-123', 'First door on right at second floor.');
INSERT INTO Shelter.Addresses (Id, Street, City, PostalCode, AdditionalDescription)
	VALUES ('1d7a7639-89f1-4051-8b2b-6b73781b035a', 'Nelson', 'Sudimanik', '12-344', 'Level underground.');
INSERT INTO Shelter.Addresses (Id, Street, City, PostalCode, AdditionalDescription)
	VALUES ('70d1094f-1f68-4182-8b3f-0fe1abb0a3a5', 'Barnett', 'Puyang', '4-789', null);
INSERT INTO Shelter.Addresses (Id, Street, City, PostalCode, AdditionalDescription)
	VALUES ('bdb78af5-07e6-4345-89c2-249b02aedf06', 'Amoth', 'Xibin', '10-789', null);
GO

-- Seed Shelters (4 records)
INSERT INTO Shelter.Shelters (Id, [Name], AddressId)
	VALUES ('7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62', 'Paws & Haven Rescue Center', '7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62');
INSERT INTO Shelter.Shelters (Id, [Name], AddressId)
	VALUES ('c8eacdd5-23b5-4d87-a681-8f197121b37c', 'Happy Tails Dog Shelter', '4e5b894b-c28f-4a93-9a01-77c5f56b80a9');
INSERT INTO Shelter.Shelters (Id, [Name], AddressId)
	VALUES ('20c49f67-764b-4e80-969f-9ee046b4548a', 'Furry Friends Sanctuary', 'c24e37e6-f31c-4116-8247-85e4b3ef7a53');
INSERT INTO Shelter.Shelters (Id, [Name], AddressId)
	VALUES ('04408d9d-5a70-4a28-9f2c-3d71af43b293', 'Wagging Hearts Dog Rescue', '1d7a7639-89f1-4051-8b2b-6b73781b035a');
GO

-- Seed Dogs (14 records)
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('cafe6b43-4bd7-400d-97b9-df9b2e4bbbfa', 'Padget', 'Labrador Retriever', 'e3db7a04-a42b-4820-b3f2-b6c29dfca8c7', '7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('4de75dbc-9136-4952-83e1-c13ced7d1ec9', 'Boone', 'German Shepherd', '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', 'c8eacdd5-23b5-4d87-a681-8f197121b37c');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('c1ef83d2-c69e-4fe0-8c61-9cb52a4aaafa', 'Austen', 'German Shepherd', '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', '7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('3daec742-0fbb-4bef-a7cb-22b18275a50f', 'Burton', 'Golden Retriever', '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', '20c49f67-764b-4e80-969f-9ee046b4548a');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('be2ecf0a-8a1e-4d30-b42a-945faf8ee0a1', 'Jilleen', 'Labrador Retriever', '43051a55-003b-4f4b-a43d-2bff8f43027c', '20c49f67-764b-4e80-969f-9ee046b4548a');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('7e3f6ce2-2b1e-4200-8780-f938a8f97c1d', 'Simon', 'Golden Retriever', 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692', '7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('a45e3d6a-94a0-4ded-8d4d-d44c8c32d645', 'Becky', 'Poodle', 'c482f14b-eb89-4c65-bb2c-2ef7b9fbf692', '7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('3d5e9852-66ac-45b6-9472-21de41a24a98', 'Veronique', 'Labrador Retriever', 'e3db7a04-a42b-4820-b3f2-b6c29dfca8c7', '04408d9d-5a70-4a28-9f2c-3d71af43b293');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('94c56c5c-2e53-4bda-a64a-f75ab0a9f16b', 'Fred', 'German Shepherd', '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', '04408d9d-5a70-4a28-9f2c-3d71af43b293');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('662b10f6-9d5f-40a7-94b0-5ae603f53360', 'Nikkie', 'Poodle', '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', '20c49f67-764b-4e80-969f-9ee046b4548a');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('a13791b6-b9b8-40b6-8f63-0290be97f9a6', 'Vassily', 'Beagle', '43051a55-003b-4f4b-a43d-2bff8f43027c', '7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('4a6871fb-bba7-45aa-adf7-63fa689f83fa', 'Earlie', 'German Shepherd', '568ac4dd-5fa2-4d0d-b1c6-e13be5663d4c', '7ae8b17d-5bb4-4e8c-9ee4-f6b79a8f7b62');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('20116b0f-1753-450e-a5aa-56b2b07c9abb', 'Belva', 'Golden Retriever', '43051a55-003b-4f4b-a43d-2bff8f43027c', '04408d9d-5a70-4a28-9f2c-3d71af43b293');
INSERT INTO Shelter.Dogs (Id, [Name], Breed, DogStatusId, ShelterId)
	VALUES ('44080fc9-1bb6-40fe-8438-a37766633d45', 'Hanson', 'Golden Retriever', '43051a55-003b-4f4b-a43d-2bff8f43027c', '20c49f67-764b-4e80-969f-9ee046b4548a');


-- Seed DogCharacteristics (14 records)
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('b2c4077a-594e-4ecd-8822-e793227f3002', 20, 'A friendly, outgoing dog known for its loyalty and love of play.', 'cafe6b43-4bd7-400d-97b9-df9b2e4bbbfa');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('c4ec51b8-c223-4549-bd63-4c8906bf66a8', 8, 'Affectionate and gentle, perfect for families and active owners.', '4de75dbc-9136-4952-83e1-c13ced7d1ec9');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('8bf376cf-6dd9-44e9-8fe6-db0d814ca402', 12, 'A small, sturdy dog with a lovable personality and signature bat-like ears.', 'c1ef83d2-c69e-4fe0-8c61-9cb52a4aaafa');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('e794d18d-691a-457e-b8f1-57ee1492f315', 14, 'Curious and energetic, known for its excellent sense of smell.', '3daec742-0fbb-4bef-a7cb-22b18275a50f');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('45199dfd-b478-4261-8340-50d648d24dec', 13, 'A highly intelligent and hypoallergenic breed that comes in various sizes.', 'be2ecf0a-8a1e-4d30-b42a-945faf8ee0a1');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('e86843fc-48b3-476c-be5f-69c77768397a', 12, 'Small with a long body, known for its bold and lively nature.', '7e3f6ce2-2b1e-4200-8780-f938a8f97c1d');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('1d3ac603-5e05-4f86-9de9-82f72acfd701', 21, 'A striking, wolf-like dog with a love for running and outdoor adventures.', 'a45e3d6a-94a0-4ded-8d4d-d44c8c32d645');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('313b9456-24d1-476b-8540-e6064b23f577', 7, 'Gentle and affectionate, often recognized by its long, floppy ears.', '3d5e9852-66ac-45b6-9472-21de41a24a98');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('1b76f4b6-9cd8-47fa-8e26-5904cb6299e8', 7, 'A small, cheerful dog known for its long, flowing coat.', '94c56c5c-2e53-4bda-a64a-f75ab0a9f16b');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('72e989db-e507-4ee0-9092-837884de7375', 8, 'Extremely smart and active, excelling in herding and agility tasks.', '662b10f6-9d5f-40a7-94b0-5ae603f53360');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('5de76c42-4efe-4e49-9aee-219af7966207', 5, null, 'a13791b6-b9b8-40b6-8f63-0290be97f9a6');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('3856af3a-e36a-4c42-8907-0a6d133b4826', 5, null, '4a6871fb-bba7-45aa-adf7-63fa689f83fa');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('ddede22a-a498-4637-878e-dd040fb36628', 7, null, '20116b0f-1753-450e-a5aa-56b2b07c9abb');
INSERT INTO Shelter.DogCharacteristics (Id, [Weight], [Description], DogId)
	VALUES ('4ff10a4a-4fe4-4d3d-a474-aa993e71b6c2', 8, null, '44080fc9-1bb6-40fe-8438-a37766633d45');


-- Seed MedicalCards (14 records)
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('55b3fb79-bfe6-4565-93d7-23fae0bf502d', '9/21/2023', 'cafe6b43-4bd7-400d-97b9-df9b2e4bbbfa')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('b22b1b30-3b44-430a-8521-7a846eaaf21e', '9/21/2023', '4de75dbc-9136-4952-83e1-c13ced7d1ec9')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('2d2980cf-f522-4ce3-80d7-90439f389bd5', '9/21/2023', 'c1ef83d2-c69e-4fe0-8c61-9cb52a4aaafa')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('5338003b-5376-4ec1-a5f0-6e842f87d403', '9/21/2023', '3daec742-0fbb-4bef-a7cb-22b18275a50f')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('c9b64b8d-3f42-4540-9170-dcea6cc4c442', '9/28/2023', 'be2ecf0a-8a1e-4d30-b42a-945faf8ee0a1')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('355f3a8a-c11d-4f4c-866d-f42b6c1ff7af', '9/28/2023', '7e3f6ce2-2b1e-4200-8780-f938a8f97c1d')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('27963a18-d1f7-4bb5-b2c7-c8c47cef1542', '9/28/2023', 'a45e3d6a-94a0-4ded-8d4d-d44c8c32d645')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('19dec680-1d63-4cb2-89d2-62ab2d6e4989', '9/28/2023', '3d5e9852-66ac-45b6-9472-21de41a24a98')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('daaded6c-ac8e-43c5-a053-856c3a0c3fca', '10/2/2023', '94c56c5c-2e53-4bda-a64a-f75ab0a9f16b')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('61aeb005-bbfa-46aa-bd79-e13e55ed1610', '10/4/2023', '662b10f6-9d5f-40a7-94b0-5ae603f53360')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('d989fec9-dc8e-40bd-9f1b-2cfdfb44310f', '10/20/2023', 'a13791b6-b9b8-40b6-8f63-0290be97f9a6')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('d333f0d5-5ec7-4e41-bc23-3373c1d7fe44', '10/22/2023', '4a6871fb-bba7-45aa-adf7-63fa689f83fa')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('3ad7ce09-0c50-41c6-9135-154252fab25b', '1/5/2024', '20116b0f-1753-450e-a5aa-56b2b07c9abb')
INSERT INTO Shelter.MedicalCards (Id, CreationDate, DogId)
	VALUES ('a094b76b-be49-4534-8417-8184e68d8535', '1/5/2024', '44080fc9-1bb6-40fe-8438-a37766633d45')
GO

-- Seed MedicalCardRecords (20 records)
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('e2110791-2ef7-43a2-a412-f524e81b2b9b', 'b22b1b30-3b44-430a-8521-7a846eaaf21e', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('bd389db4-1f39-421d-8c62-46c23c6fc3e7', 'b22b1b30-3b44-430a-8521-7a846eaaf21e', 'Flea & Tick Prevention', '3/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('77c5000e-350f-4a07-bdd7-349792ff3851', 'b22b1b30-3b44-430a-8521-7a846eaaf21e', 'Dental Cleaning', '4/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('42fca4f2-c5b1-4114-8f83-b5d11b71cb51', '2d2980cf-f522-4ce3-80d7-90439f389bd5', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('5404fad6-14c8-47d1-a58b-d92b8057a4fd', '2d2980cf-f522-4ce3-80d7-90439f389bd5', 'Flea & Tick Prevention', '3/7/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('a14d06a6-cce5-4a7b-b218-f90602249b9f', '2d2980cf-f522-4ce3-80d7-90439f389bd5', 'Dental Cleaning', '4/6/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('e6b6f8e9-82ee-4392-b35a-bd6c68754dd9', '5338003b-5376-4ec1-a5f0-6e842f87d403', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('e6eb86dd-002f-4caa-b749-e38a3744bbf0', '5338003b-5376-4ec1-a5f0-6e842f87d403', 'Dental Cleaning', '3/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('c13af392-72d9-4cc5-bcf6-c42f60b70d3b', 'c9b64b8d-3f42-4540-9170-dcea6cc4c442', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('26602a40-1990-44e1-a571-93361ef2b520', 'c9b64b8d-3f42-4540-9170-dcea6cc4c442', 'Dental Cleaning', '3/11/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('900cdd52-ac89-47d7-b18a-e6995048db97', '355f3a8a-c11d-4f4c-866d-f42b6c1ff7af', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('0e5200eb-c344-4550-b5f0-ff2d3285e9a6', '355f3a8a-c11d-4f4c-866d-f42b6c1ff7af', 'Allergy Treatment', '3/12/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('7570d67c-b3aa-43f1-b595-63803069991b', '27963a18-d1f7-4bb5-b2c7-c8c47cef1542', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('6ba39e10-6e77-43a5-8f98-8bee14382c9c', '27963a18-d1f7-4bb5-b2c7-c8c47cef1542', 'Allergy Treatment', '2/12/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('d1382bf7-eab7-46b8-8422-de02e32307e5', 'daaded6c-ac8e-43c5-a053-856c3a0c3fca', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('12ca9b37-ab8d-477d-bc2a-fadeef1f8e35', 'daaded6c-ac8e-43c5-a053-856c3a0c3fca', 'Heartworm Test', '2/14/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('227324e1-74f0-4dfd-8958-5146a02e5c48', '61aeb005-bbfa-46aa-bd79-e13e55ed1610', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('7b6c186a-e465-4259-b7b4-a45869eef0a0', 'd989fec9-dc8e-40bd-9f1b-2cfdfb44310f', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('abd00c56-a982-4229-94b9-ca91ea2f40d5', 'd333f0d5-5ec7-4e41-bc23-3373c1d7fe44', 'Microchipping', '2/5/2024');
INSERT INTO Shelter.MedicalCardRecords (Id, MedicalCardId, [Description], [Date])
	VALUES ('6cceadb8-4e6c-4268-9066-3e78bb95072f', 'a094b76b-be49-4534-8417-8184e68d8535', 'Microchipping', '2/5/2024');
GO

-- Seed FamiliarizationVisits (6 records)
INSERT INTO Shelter.FamiliarizationVisits (Id, DateOfVisit, DogId, VisitorId, EmployeeId, VisitStatusId)
	VALUES ('98de4668-378b-40eb-b86b-d39e1aa4d695', '6/26/2024', '4de75dbc-9136-4952-83e1-c13ced7d1ec9', '470e2057-1fd6-48ba-ba75-2c4c1303a5d2', '5f5e17ba-ad01-4693-b561-d1af584d55b9', '30349b10-1911-44ba-98b6-b02a3cb9403a');
INSERT INTO Shelter.FamiliarizationVisits (Id, DateOfVisit, DogId, VisitorId, EmployeeId, VisitStatusId)
	VALUES ('34e4af1a-ab52-4944-957d-bbde7e1b6969', '6/17/2024', 'c1ef83d2-c69e-4fe0-8c61-9cb52a4aaafa', '470e2057-1fd6-48ba-ba75-2c4c1303a5d2', '5f5e17ba-ad01-4693-b561-d1af584d55b9', '30349b10-1911-44ba-98b6-b02a3cb9403a');
INSERT INTO Shelter.FamiliarizationVisits (Id, DateOfVisit, DogId, VisitorId, EmployeeId, VisitStatusId)
	VALUES ('f1c9ba86-2892-46e1-a912-9e8a45ea833f', '6/12/2024', '3daec742-0fbb-4bef-a7cb-22b18275a50f', '9809b169-812d-4773-99cf-cf130f926cb5', '5f5e17ba-ad01-4693-b561-d1af584d55b9', '15fc7712-0554-48bd-b56f-b2f079fe5dc1');
INSERT INTO Shelter.FamiliarizationVisits (Id, DateOfVisit, DogId, VisitorId, EmployeeId, VisitStatusId)
	VALUES ('315c7674-70d7-46e7-9e1d-88503296b03a', '7/9/2024', '94c56c5c-2e53-4bda-a64a-f75ab0a9f16b', '9809b169-812d-4773-99cf-cf130f926cb5', '5459fd6a-ec98-4e04-9cce-83e04b9ae948', '15fc7712-0554-48bd-b56f-b2f079fe5dc1');
INSERT INTO Shelter.FamiliarizationVisits (Id, DateOfVisit, DogId, VisitorId, EmployeeId, VisitStatusId)
	VALUES ('600725fe-10d9-4076-afc1-78e62902b487', '7/12/2024', 'be2ecf0a-8a1e-4d30-b42a-945faf8ee0a1', '9077731a-2cdd-4ead-94b6-ae1642a61882', '5459fd6a-ec98-4e04-9cce-83e04b9ae948', '15fc7712-0554-48bd-b56f-b2f079fe5dc1');
INSERT INTO Shelter.FamiliarizationVisits (Id, DateOfVisit, DogId, VisitorId, EmployeeId, VisitStatusId)
	VALUES ('76415947-1604-469d-ae56-8dd74da060b8', '8/27/2024', 'a13791b6-b9b8-40b6-8f63-0290be97f9a6', '0cd4715a-f71f-4275-abb6-901c53d562ff', '5459fd6a-ec98-4e04-9cce-83e04b9ae948', '15fc7712-0554-48bd-b56f-b2f079fe5dc1');
GO

-- Seed AdoptionRecords (5 records)
INSERT INTO Shelter.AdoptionRecords (Id, LastUpdateDate, RejectionReason, DogId, AdoptionCardId, AdoptionStatusId)
	VALUES ('dbdebe13-9e08-44bb-a04a-c3754a5cc5b6', '9/5/2024', null, 'be2ecf0a-8a1e-4d30-b42a-945faf8ee0a1', 'BDC5CFBE-125B-44CF-8CAD-6D4F45D0371B', '494D8C27-AD71-43E3-A216-F0BE0450F135');
INSERT INTO Shelter.AdoptionRecords (Id, LastUpdateDate, RejectionReason, DogId, AdoptionCardId, AdoptionStatusId)
	VALUES ('35415718-51fd-49cd-92d7-0bcc3981f07c', '9/8/2024', null, 'a13791b6-b9b8-40b6-8f63-0290be97f9a6', 'BDC5CFBE-125B-44CF-8CAD-6D4F45D0371B', 'E9497513-D728-4221-B48E-5B34D022B387');
INSERT INTO Shelter.AdoptionRecords (Id, LastUpdateDate, RejectionReason, DogId, AdoptionCardId, AdoptionStatusId)
	VALUES ('30cf236c-d1db-434d-98c0-f014f3f19ab7', '10/2/2024', null, '20116b0f-1753-450e-a5aa-56b2b07c9abb', 'AD381D24-2982-4435-B21D-C3732740BAFF', 'E9497513-D728-4221-B48E-5B34D022B387');
INSERT INTO Shelter.AdoptionRecords (Id, LastUpdateDate, RejectionReason, DogId, AdoptionCardId, AdoptionStatusId)
	VALUES ('50c4ef25-b5e0-4437-99c8-6193a352dcec', '10/6/2024', null, '44080fc9-1bb6-40fe-8438-a37766633d45', 'BC835BED-39FC-4928-A7E7-C5523977EC4F', 'E9497513-D728-4221-B48E-5B34D022B387');
INSERT INTO Shelter.AdoptionRecords (Id, LastUpdateDate, RejectionReason, DogId, AdoptionCardId, AdoptionStatusId)
	VALUES ('f50cdeb4-d5b6-478d-b7ad-7bf6e732597e', '10/12/2024', 'Adoption request was denied due to the home not meeting necessary safety requirements for the dog.', '4a6871fb-bba7-45aa-adf7-63fa689f83fa', '0A622E21-BF6F-46DB-8E50-E4377072294A', '0E5ADD7B-D4AF-4A39-9A49-EE76E22ED69B');
GO