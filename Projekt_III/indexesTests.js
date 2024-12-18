db.games.getIndexes()

// testy indeksu prostego (date: 1) - gra starszych niż 2020
db.games.find({ "date": { $lt: new ISODate("2020-01-01T00:00:00Z") } }).explain("executionStats")
db.games.createIndex({ "date": 1 })
db.games.find({ "date": { $lt: new ISODate("2020-01-01T00:00:00Z") } }).explain("executionStats")

db.games.dropIndex("date_1")


// testy indeksu prostego (date: 1) - gra starszych niż 2016
db.games.find({ "date": { $lt: new ISODate("2016-01-01T00:00:00Z") } }).explain("executionStats")
db.games.createIndex({ "date": 1 })
db.games.find({ "date": { $lt: new ISODate("2016-01-01T00:00:00Z") } }).explain("executionStats")

db.games.dropIndex("date_1")



// testy indeksu prostego (name: 1) = gra o podanej nazwie 
db.collection.find({ nameOfGame: { $regex: "Counter-Str", $options: "i" } });
db.games.createIndex({ "name": 1 })
db.collection.find({ nameOfGame: { $regex: "Counter-Str", $options: "i" } });

db.games.dropIndex("name_1")



// testy indeksu tekstowego (name: "text") = gra o podanej nazwie 
db.games.createIndex({ "name": "text" })
db.games.find({ $text: { $search: "counter-str" } }).explain("executionStats")

db.games.dropIndex("name_text")



// testy indeksu kompozytowego (name: 1, date: 1) = gra o podanej nazwie nowsza niż
db.games.find({ date: { $gte: ISODate("2019-01-01") }, name: { $regex: "craft", $options: "i" } });
db.games.find({ date: { $gte: ISODate("2019-01-01") } }).sort({ date: 1, name: 1 });

db.games.createIndex({ date: 1, name: 1 });

db.games.find({ date: { $gte: ISODate("2019-01-01") }, name: { $regex: "craft", $options: "i" } });
db.games.find({ date: { $gte: ISODate("2019-01-01") } }).sort({ date: 1, name: 1 });
