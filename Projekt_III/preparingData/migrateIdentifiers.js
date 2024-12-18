const publisherMap = {};
const developerMap = {};

db.publishers.find({}).forEach(publisher => {
    publisherMap[publisher.publisherId] = publisher._id;
});

// Build developer mapping: developerId -> _id
db.developers.find({}).forEach(developer => {
    developerMap[developer.developerId] = developer._id;
});

db.games.find({}).forEach(game => {
    if (game.publisherId && publisherMap[game.publisherId]) {
        db.games.updateOne(
            { _id: game._id },
            { $set: { publisherId: publisherMap[game.publisherId] } }
        );
    }

    if (game.developerId && developerMap[game.developerId]) {
        db.games.updateOne(
            { _id: game._id },
            { $set: { developerId: developerMap[game.developerId] } }
        );
    }
});


db.publishers.updateMany({}, { $unset: { publisherId: "" } });
db.developers.updateMany({}, { $unset: { developerId: "" } });

db.games.find().forEach(function(game) {
    if (game.price && typeof game.price === "string") {
        let numericPrice = parseFloat(game.price);

        if (!isNaN(numericPrice)) {
            db.games.updateOne(
                { _id: game._id },
                { $set: { price: numericPrice } }
            );
        } else {
            db.games.updateOne(
                { _id: game._id },
                { $set: { price: 0 } }
            );
        }
    }
});



