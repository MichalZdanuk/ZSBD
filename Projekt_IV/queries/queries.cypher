// top 5 restauracji z członem "restaurant" wraz z danymi kontaktowymi
MATCH (r:Restaurant)-[:HAS_CONTACT]->(c:Contact)
WHERE r.name =~ '(?i).*restaurant.*'
RETURN r.name, r.rating, c.tel, c.website, c.email, c.latitude, c.longitude
ORDER BY r.rating DESC
LIMIT 5

// restauracje o podanym rodzaju kuchni z oceną powyżej określonego progu wraz z dodatkowymi informacjami - dostępność parkingu, przystosowanie dla niepełnosprawnych
MATCH (r:Restaurant)-[:SERVES_CUISINE]->(c:Cuisine {name: "Cafe"})
MATCH (r)-[:HAS_DESCRIPTION]->(d:Description)
MATCH (chef:Chef)-[:WORKS_AT]->(r)
WHERE r.rating > 4.5
MATCH (r)-[:HAS_CONTACT]->(contact:Contact)
RETURN r.name AS Restaurant, chef.name AS MainChef, r.rating AS Rating,
contact.tel AS Phone, contact.website AS Website, d.parking AS isAvalaibleParking, d.accessible_wheelchair AS wheelchairAccessible
ORDER BY r.rating DESC

// zliczenie liczby restauracji dla każdego rodzaju kuchni jednocześnie wyliczając średnią ocenę restauracji z kategorii, wyniki posortowane po liczności restauracji, a następnie po średniej ocenie
MATCH (r:Restaurant)-[:SERVES_CUISINE]->(c:Cuisine)
WITH c.name AS cuisine, COUNT(r) AS restaurant_count, AVG(r.rating) AS average_rating
RETURN cuisine, restaurant_count, apoc.number.format(average_rating, '0.00') AS average_rating
ORDER BY restaurant_count DESC, average_rating DESC

// zwrócenie nazw restauracji (z wykorzystaniem UNION), które [mają ocenę powyżej 4.5 i dostępny parking] lub [serwują włoską kuchnią bądź owoce morze]
MATCH (r:Restaurant)-[:HAS_DESCRIPTION]->(d:Description)
WHERE r.rating > 4.5 AND d.parking = true
RETURN r.name
UNION DISTINCT
MATCH (r:Restaurant)-[:SERVES_CUISINE]->(c:Cuisine)
WHERE c.name IN ['Italian','Seafood']
RETURN r.name

// utworzenie recenzji i podpięcie pod nią użytkownika dla restauracji o podanej nazwie (wykorzystanie MERGE)
MERGE (r:Restaurant{name: 'Amber India Restaurant'})
MERGE (rev:Review{id: '12345abcdef'})
SET rev.review_website = 'website_url',
    rev.review_title = 'Fantastic Meal',
    rev.review_text = 'The food was excellent!',
    rev.review_rating = 5,
    rev.review_date = '2024-12-15'
MERGE (u:User{id: 'userid'})
    SET u.name = 'User Name',
    u.email = 'user@example.com',
    u.address = '123 Main St'