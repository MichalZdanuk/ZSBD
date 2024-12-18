// test case: existing game, valid update object
var existingGame = db.games.findOne({name: "Galaxy Raiders: Infinite Void"});

var validGame = {
    name: "UPDATED: Galaxy Raiders: Infinite Void",
    publisherId: ObjectId("67476474fd11e1c9aeb5929f"),
    developerId: ObjectId("6747641874388b0176d4af31")
};

modifyGame(existingGame._id, validGame);


// test case: not existing game
var nonExistingGameId = ObjectId("aaaaaaaaaaaaaaaaaaaaaaaa");

var validUpdateGame = {
    name: "Non-Existing Game"
};

modifyGame(nonExistingGameId, validUpdateGame);

// test case: try to update with name that is taken
var existingGame = db.games.findOne({name: "UPDATED: Galaxy Raiders: Infinite Void"});
var game = db.games.findOne();

var gameWithTakenName = {
    name: game.name
};

modifyGame(existingGame._id, gameWithTakenName);


// test case: not existing publisher
var existingGame = db.games.findOne({name: "UPDATED: Galaxy Raiders: Infinite Void"});

var invalidPublisherUpdate = {
    publisherId: ObjectId("aaaaaaaaaaaaaaaaaaaaaaaa")
};

modifyGame(existingGame._id, invalidPublisherUpdate);
