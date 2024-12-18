import json
import uuid
from faker import Faker
import random

def generate_id():
    return str(uuid.uuid4())

def generate_synthetic_data(input_restaurants_file, input_reviews_file, output_directory, seed=42, num_users=2000, num_chefs=100):
    fake = Faker()
    Faker.seed(seed)
    random.seed(seed)

    dishes = [
        "Spaghetti Carbonara", "Salmon with Spinach", "Grilled Chicken", "Beef Stroganoff", "Vegetable Curry",
        "Tacos al Pastor", "Shrimp Scampi", "Eggplant Parmesan", "Chicken Alfredo", "Lamb Chops"
    ]

    # Generate Users
    user_nodes = []
    for _ in range(num_users):
        user_id = generate_id()
        user_nodes.append({
            "id": user_id,
            "name": fake.name(),
            "email": fake.email(),
            "address": fake.address()
        })

    # Generate Chefs
    chef_nodes = []
    for _ in range(num_chefs):
        chef_id = generate_id()
        chef_nodes.append({
            "id": chef_id,
            "name": fake.name(),
            "specialty": random.choice(dishes)
        })

    # Assign Users to Reviews
    with open(input_reviews_file, "r", encoding='utf-8') as file:
        reviews = json.load(file)

    review_user_relationships = []
    available_users = user_nodes[:]
    for review in reviews:
        if not available_users:
            available_users = user_nodes[:]
        user = available_users.pop()
        review_user_relationships.append({"from": review["id"], "to": user["id"], "type": "POSTED_BY"})

    # Assign Chefs to Restaurants
    with open(input_restaurants_file, "r") as file:
        restaurants = json.load(file)

    chef_restaurant_relationships = []
    available_chefs = chef_nodes[:]
    for restaurant in restaurants:
        if not available_chefs:
            available_chefs = chef_nodes[:]
        chef = available_chefs.pop()
        chef_restaurant_relationships.append({"from": chef["id"], "to": restaurant["id"], "type": "WORKS_AT"})

    with open(f"{output_directory}/users.json", "w") as file:
        json.dump(user_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/chefs.json", "w") as file:
        json.dump(chef_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/review_user_relationships.json", "w") as file:
        json.dump(review_user_relationships, file, default=str, indent=4)

    with open(f"{output_directory}/chef_restaurant_relationships.json", "w") as file:
        json.dump(chef_restaurant_relationships, file, default=str, indent=4)

# generate second dataset
generate_synthetic_data("transformedData/restaurants.json", "transformedData/reviews.json", "secondDataset", seed=42)