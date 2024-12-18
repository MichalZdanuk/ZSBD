// zapytanie wykorzystujace zagnieżdżenia
// zwraca grę, która została otagowana jako "Multiplayer" i "Shooter"; jest droższa niż 100 euro, a minimalne
// wymagania systemowe to Windows 7

db.games.find({ "popu_tags": { $all: ["Shooter", "Multiplayer"] }, "price": { $gte: 100 }, "requirements.minimum.windows.os": { $regex: /Windows\s*7/i } }, {"full_desc.desc": 0}).sort({ date: -1 }).limit(1)


// zapytanie z użyciem referencji
// zwraca grę z połączonym przez referencję publisherem, dane są odpowiednio projektowane, aby zwrócić lekki obiekt,
// tylko z tymi danymi, które nas interesują

db.games.aggregate([{ $lookup: { from: "publishers", localField: "publisherId", foreignField: "_id", as: "publisherDetails"}}, {$unwind: "$publisherDetails"}, {$project: {name: 1, date: 1, requirements: 1, popu_tags: 1, publisherDetails: 1}}, {$limit: 1}])