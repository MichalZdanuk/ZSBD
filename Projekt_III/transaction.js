var session = db.getMongo().startSession();

session.startTransaction();

try {
    var publishersCollection = session.getDatabase("zsbd").publishers;
    var gamesCollection = session.getDatabase("zsbd").games;

    var newPublisher = {
        name: 'Test publisher',
        dateOfFounding: ISODate("1932-11-06"),
        ceo: 'Anthony Golden',
        country: 'Uganda'
    };
    var publisherInsertResult = publishersCollection.insertOne(newPublisher);
    var publisherId = publisherInsertResult.insertedId;

    var newGame = {
        name: "Test game in transaction",
        date: ISODate("2023-07-15T00:00:00.000Z"),
        full_desc: {
            sort: "game",
            desc: "A game!"
        },
        categories: ["Sci-fi", "RPG", "Action", "Space Exploration"],
        publisherId: publisherId
    };
    gamesCollection.insertOne(newGame);

    session.commitTransaction();
    console.log("Transaction committed successfully.");
} catch (error) {
    session.abortTransaction();
    console.error("Transaction aborted due to:", error);
    throw error;
} finally {
    session.endSession();
}
