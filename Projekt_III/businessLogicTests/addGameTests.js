// test case: valid game object
var newGame = {
    name: "Galaxy Raiders: Infinite Void",
    date: ISODate("2023-07-15T00:00:00.000Z"),
    developer: "StarForge Studios",
    publisher: "Void Entertainment",
    full_desc: {
        sort: "game",
        desc: "A sci-fi action RPG where players explore uncharted galaxies, battle alien forces, and uncover ancient secrets."
    },
    requirements: {
        minimum: {
            windows: {
                processor: "Intel Core i3",
                memory: "4 GB RAM",
                graphics: "Intel HD Graphics 620",
                os: "Windows 8/10"
            }
        },
        recommended: {
            windows: {
                processor: "Intel Core i7",
                memory: "8 GB RAM",
                graphics: "NVIDIA GeForce GTX 1060",
                os: "Windows 10"
            }
        }
    },
    popu_tags: ["Sci-fi", "RPG", "Space Exploration", "Action"],
    price: 29.99,
    url_info: {
        url: "https://store.fakegames.com/app/1234/Galaxy_Raiders_Infinite_Void/",
        id: "1234",
        type: "app",
        url_name: "Galaxy Raiders Infinite Void"
    },
    categories: ["Sci-fi", "RPG", "Action", "Space Exploration"],
    publisherId: ObjectId("67476474fd11e1c9aeb5929f"),
    developerId: ObjectId("6747641874388b0176d4af31")
};
var addedGame = addGame(newGame);

// test case: game without name
var gameWithNoName = {
    date: ISODate("2023-07-15T00:00:00.000Z"),
    developer: "StarForge Studios",
    publisher: "Void Entertainment",
    full_desc: {
        sort: "game",
        desc: "A sci-fi action RPG where players explore uncharted galaxies, battle alien forces, and uncover ancient secrets."
    },
    categories: ["Sci-fi", "RPG", "Action", "Space Exploration"],
    publisherId: ObjectId("67476474fd11e1c9aeb5929f"),
    developerId: ObjectId("6747641874388b0176d4af31")
};

var addedGame = addGame(gameWithNoName);

// test case: game that already exists
var addedGame = addGame(newGame);

// test case: game with not existing publisher
var gameWithNotExistingPublisher = {
    name: "New Game!",
    date: ISODate("2023-07-15T00:00:00.000Z"),
    developer: "StarForge Studios",
    publisher: "Void Entertainment",
    full_desc: {
        sort: "game",
        desc: "A sci-fi action RPG where players explore uncharted galaxies, battle alien forces, and uncover ancient secrets."
    },
    categories: ["Sci-fi", "RPG", "Action", "Space Exploration"],
    publisherId: ObjectId("aaaaaaaaaaaaaaaaaaaaaaaa"),
    developerId: ObjectId("aaaaaaaaaaaaaaaaaaaaaaaa")
};

var addedGame = addGame(gameWithNotExistingPublisher);