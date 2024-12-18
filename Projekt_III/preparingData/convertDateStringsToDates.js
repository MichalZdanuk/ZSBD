db.games.find().forEach(function(game) {
    if (game.date && typeof game.date === "string") {
        let parsedDate = new Date(game.date);

        if (!isNaN(parsedDate.getTime())) {
            db.games.updateOne(
                { _id: game._id },
                { $set: { date: parsedDate } }
            );
        } else {
            print("Invalid date format for _id:", game._id, "date:", game.date);
        }
    }
})

// Invalid date format for _id: ObjectId('67476414a61317cb22ce1d48') date: Q1 2021
// Invalid date format for _id: ObjectId('67476414a61317cb22ce1d66') date: Q1 2021
// Invalid date format for _id: ObjectId('67476415a61317cb22ce34dc') date: 30th October 2020
// Invalid date format for _id: ObjectId('67476415a61317cb22ce3749') date: As soon as the unicorns allow it


db.games.updateOne(
    { _id: ObjectId("67476414a61317cb22ce1d48") },
    { $set: { date: new Date("2021-01-01") } }
)

db.games.updateOne(
    { _id: ObjectId("67476414a61317cb22ce1d66") },
    { $set: { date: new Date("2021-01-01") } }
)

db.games.updateOne(
    { _id: ObjectId("67476415a61317cb22ce34dc") },
    { $set: { date: new Date("2020-10-30") } }
)

db.games.updateOne(
    { _id: ObjectId("67476415a61317cb22ce3749") },
    { $set: { date: null } }
)



