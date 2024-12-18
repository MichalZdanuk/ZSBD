import json
import random
from bson import ObjectId
from datetime import datetime, timedelta
from faker import Faker

fake = Faker()

def generate_random_datetime(start_year=1900, end_year=2020):
    start_date = datetime(start_year, 1, 1)
    end_date = datetime(end_year, 1, 1)
    random_days = random.randint(0, (end_date - start_date).days)
    return (start_date + timedelta(days=random_days)).strftime("%Y-%m-%d")

def generate_dummy_publisher_data(name):
    return {
        "publisherId": str(ObjectId()),
        "name": name,
        "dateOfFounding": generate_random_datetime(1900, 2020),
        "ceo": fake.name(),
        "country": fake.country()
    }

def generate_dummy_developer_data(name):
    return {
        "developerId": str(ObjectId()),
        "name": name,
        "dateOfFounding": generate_random_datetime(1980, 2020),
        "lead_developer": fake.name(),
        "studio_size": random.randint(10, 1000),
        "headquarters": fake.city()
    }

def generate_unique_entities(input_data):
    publishers = {}
    developers = {}
    updated_games = []

    for game in input_data:
        publisher_name = game.get("publisher")
        if publisher_name:
            if publisher_name not in publishers:
                publishers[publisher_name] = generate_dummy_publisher_data(publisher_name)
            game["publisherId"] = publishers[publisher_name]["publisherId"]

        developer_name = game.get("developer")
        if developer_name:
            if developer_name not in developers:
                developers[developer_name] = generate_dummy_developer_data(developer_name)
            game["developerId"] = developers[developer_name]["developerId"]

        updated_games.append(game)

    return updated_games, list(publishers.values()), list(developers.values())

def process_json_file(file_path):
    with open(file_path, "r") as file:
        input_data = json.load(file)

    updated_games, publishers, developers = generate_unique_entities(input_data)

    with open("games.json", "w") as games_file:
        json.dump(updated_games, games_file, default=str, indent=4)

    with open("publishers.json", "w") as publishers_file:
        json.dump(publishers, publishers_file, default=str, indent=4)

    with open("developers.json", "w") as developers_file:
        json.dump(developers, developers_file, default=str, indent=4)

    print("Data files created: games.json, publishers.json, developers.json")

process_json_file("final_data_new.json")