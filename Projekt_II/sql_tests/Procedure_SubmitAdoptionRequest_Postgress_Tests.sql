-- procedura do składania wniosków adopcyjnych - Shelter.SubmitAdoptionRequest
-- Scenariusz pozytywny (pies istnieje i jest dostępny, uzytkownik istnieje, jest klientem schroniska i ma założoną kartę adopcyjną)
CALL shelter.submitadoptionrequest(
    paramuserid := '470e2057-1fd6-48ba-ba75-2c4c1303a5d2',
    paramdogid := '3daec742-0fbb-4bef-a7cb-22b18275a50f'
);

SELECT COUNT(*)
	FROM shelter.adoptionrecords AS ar
JOIN shelter.adoptioncards AS ac ON ac.id = ar.adoptioncardid
WHERE ac.userid = '470e2057-1fd6-48ba-ba75-2c4c1303a5d2' 
  AND ar.dogid = '3daec742-0fbb-4bef-a7cb-22b18275a50f';

-- Scenariusz negatywny (pies nie istnieje)
CALL shelter.submitadoptionrequest(
    paramuserid := '470e2057-1fd6-48ba-ba75-2c4c1303a5d2',
    paramdogid := '00000000-1111-2222-3333-444444444444'
);

-- Scenariusz negatywny (pies nie jest dostępny - inny status niż Available)
CALL shelter.submitadoptionrequest(
    paramuserid := '470e2057-1fd6-48ba-ba75-2c4c1303a5d2',
    paramdogid := 'a13791b6-b9b8-40b6-8f63-0290be97f9a6'
);

-- Scenariusz negatywny (użytkownik nie jest klientem)
CALL shelter.submitadoptionrequest(
    paramuserid := '5459fd6a-ec98-4e04-9cce-83e04b9ae948',
    paramdogid := '3daec742-0fbb-4bef-a7cb-22b18275a50f'
);
