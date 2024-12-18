// 1. map/reduce
// przykład 1: zliczenie występowania odpowiednich tagów w grach, aby określić częstotliwość popularnych tag'ów

db.games.mapReduce(
    function () {
        if (this.popu_tags && Array.isArray(this.popu_tags)) {
            this.popu_tags.forEach(tag => emit(tag, 1));
        }
    },
    function (key, values) {
        return Array.sum(values);
    },
    {
        out: "tagCounts"
    }
);

db.tagCounts.find().sort({ value: -1 }).limit(5); 

// przykład 2: policzenie ile gier zostało wydanych w kolejnych latach
db.games.mapReduce(
    function () {
        if (this.date) {
            const year = this.date.getFullYear();
            emit(year, 1);
        }
    },
    function (key, values) {
        return Array.sum(values);
    },
    {
        out: "games_by_year"
    }
);

db.games_by_year.find().sort({ _id: 1 });

// 2. capped collections
// przykład: utworzenie kolekcji do przechowywania logów z operacji na grach
db.createCollection("gameLogs", {capped: true, size: 10000, max: 3})
db.gameLogs.insertMany([
    {details: "Game with id: 1 was added to store"},
    {details: "Game with id: 2 was added to store"},
    {details: "Game with id: 1 was removed from store"}
])
db.gameLogs.find()

//nadpisanie najstarszego log'a
db.gameLogs.insertOne({details: "Game with id: 3 was added to store"})
db.gameLogs.find()

// 3. zapytania ad-hoc
var req = {query:{
    afterDate: new Date("2018-01-01"),
    beforeDate: new Date("2020-01-01"),
    count: 5
}};

var games = db.games.find({
    date: {
        $gte: req.query.afterDate,
        $lt: req.query.beforeDate
    }},
    {
        _id: 1,
        name: 1,
        date: 1,
        price: 1
    }).limit(req.query.count);