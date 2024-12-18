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
})