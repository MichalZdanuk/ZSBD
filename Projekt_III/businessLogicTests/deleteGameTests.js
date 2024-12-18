// test case: game exists
var newGame = {
    name: "Test game to delete",
    date: ISODate("2023-07-15T00:00:00.000Z"),
    full_desc: {
        sort: "game",
        desc: "A game!"
    },
    categories: ["Sci-fi", "RPG", "Action", "Space Exploration"]
};

addGame(newGame);
var game = db.games.findOne({name: "Test game to delete"})
var result = deleteGame(game._id);

// test case: game not exist
var notExistingGameId = ObjectId("aaaaaaaaaaaaaaaaaaaaaaaa");
deleteGame(notExistingGameId);