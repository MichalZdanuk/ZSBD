// indeks tekstowy do wyszukiwania po nazwie restauracji
CREATE TEXT INDEX restaurant_name_index FOR (r:Restaurant) ON (r.name);

// indeks do filtrowania po ocenie restauracji
CREATE INDEX restaurant_rating_index FOR (r:Restaurant) ON (r.rating);

// indeks do filtrowania po nazwach kuchni
CREATE INDEX cuisine_name_index FOR (c:Cuisine) ON (c.name)

// indeksy na flagi w description
CREATE INDEX description_parking_index FOR (d:Description) ON (d.parking);
CREATE INDEX description_accessible_index FOR (d:Description) ON (d.accessible_wheelchair);