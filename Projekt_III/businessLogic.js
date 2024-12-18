function addGame(game) {
    if (!game || typeof game !== "object") {
        throw new Error("Invalid game object provided.");
    }

    if (!game.name) {
        throw new Error("Game name is required.");
    }

    var existingGame = db.games.findOne({name: game.name})

    if(existingGame){
        throw new Error(`Game: ${game.name} already exists.`);
    }

    if (game.publisherId) {
        var publisher = db.publishers.findOne({ _id: game.publisherId });
        if (!publisher) {
            throw new Error(`Publisher with id: ${game.publisherId} does not exist.`);
        }
    }

    if (game.developerId) {
        var developer = db.developers.findOne({ _id: game.developerId });
        if (!developer) {
            throw new Error(`Developer with id: ${game.developerId} does not exist.`);
        }
    }

    var result = db.games.insertOne(game);

    return result.insertedId;
}


function modifyGame(gameId, updatedGame) {
    if (!gameId || !updatedGame || typeof updatedGame !== "object") {
        throw new Error("Invalid game ID or game object provided.");
    }

    var existingGame = db.games.findOne({ _id: ObjectId(gameId) });
    if (!existingGame) {
        throw new Error(`Game with id: ${gameId} does not exist.`);
    }

    if (updatedGame.name && updatedGame.name !== existingGame.name) {
        var gameWithNewName = db.games.findOne({ name: updatedGame.name });
        if (gameWithNewName) {
            throw new Error(`Given game name: ${updatedGame.name} is already taken.`);
        }
    }

    if (updatedGame.publisherId) {
        var publisher = db.publishers.findOne({ _id: updatedGame.publisherId });
        if (!publisher) {
            throw new Error(`Publisher with id: ${updatedGame.publisherId} does not exist.`);
        }
    }

    if (updatedGame.developerId) {
        var developer = db.developers.findOne({ _id: updatedGame.developerId });
        if (!developer) {
            throw new Error(`Developer with id: ${updatedGame.developerId} does not exist.`);
        }
    }

    db.games.updateOne(
        { _id: ObjectId(gameId) },
        { $set: updatedGame }
    );
}

function deleteGame(gameId) {
    var existingGame = db.games.findOne({ _id: gameId });
    if (!existingGame) {
        throw new Error(`Game with id: ${gameId} does not exist.`);
    }

    var result = db.games.deleteOne({ _id: gameId });

    if (result.deletedCount === 1) {
        return `Game with id: ${gameId} successfully deleted.`;
    } else {
        throw new Error(`Failed to delete game with id: ${gameId}.`);
    }
}

function findGamesByName(name) {
    if (!name || typeof name !== "string") {
        throw new Error("Invalid or missing game name parameter.");
    }

    var games = db.games.find(
        { name: { $regex: name, $options: "i" } },
        {
            name: 1,
            price: 1,
            date: 1,
        }
    );

    return games;
}

function advancedFindGames({ categories = [], maxPrice, releaseDate }) {
    if (!maxPrice && !releaseDate && (!categories || categories.length === 0)) {
        throw new Error("At least one filter condition must be provided.");
    }

    var query = {};

    if (categories.length > 0) {
        query.categories = { $all: categories };
    }

    if (maxPrice !== undefined) {
        query.price = { $lte: maxPrice };
    }

    if (releaseDate) {
        query.date = { $gt: new Date(releaseDate) };
    }

    var games = db.games.find(
        query,
        {
            name: 1,
            price: 1,
            date: 1,
            categories: 1,
            _id: 0
        }
    );

    return games;
}
