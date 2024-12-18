import json
import uuid
from collections import defaultdict

def generate_id():
    return str(uuid.uuid4())

def process_restaurant_data(input_file, output_directory):
    with open(input_file, 'r', encoding='utf-8') as file:
        data = json.load(file)

    restaurant_nodes = []
    description_nodes = []
    meal_option_nodes = []
    review_nodes = []
    contact_nodes = []
    schedule_nodes = []
    cuisine_nodes = {}
    relationships = []

    for restaurant in data:
        restaurant_id = generate_id()

        # Restaurant Node
        restaurant_node = {
            "id": restaurant_id,
            "name": restaurant["name"],
            "locality": restaurant["locality"],
            "region": restaurant["region"],
            "country": restaurant["country"],
            "rating": restaurant["rating"]
        }
        restaurant_nodes.append(restaurant_node)

        # Cuisine Nodes and Relationships
        for cuisine in restaurant.get("cuisine", []):
            if cuisine not in cuisine_nodes:
                cuisine_id = generate_id()
                cuisine_node = {
                    "id": cuisine_id,
                    "name": cuisine
                }
                cuisine_nodes[cuisine] = cuisine_node
            else:
                cuisine_id = cuisine_nodes[cuisine]["id"]

            relationships.append({
                "from": restaurant_id,
                "to": cuisine_id,
                "type": "SERVES_CUISINE"
            })

        # Description Node
        description_id = generate_id()
        description_node = {
            "id": description_id,
            "parking": restaurant.get("parking"),
            "wifi": restaurant.get("wifi"),
            "smoking": restaurant.get("smoking"),
            "accessible_wheelchair": restaurant.get("accessible_wheelchair")
        }
        description_nodes.append(description_node)
        relationships.append({"from": restaurant_id, "to": description_id, "type": "HAS_DESCRIPTION"})

        # MealOption Node
        meal_option_id = generate_id()
        meal_option_node = {
            "id": meal_option_id,
            "meal_breakfast": restaurant.get("meal_breakfast"),
            "meal_deliver": restaurant.get("meal_deliver"),
            "meal_dinner": restaurant.get("meal_dinner"),
            "meal_lunch": restaurant.get("meal_lunch"),
            "meal_takeout": restaurant.get("meal_takeout"),
            "meal_cater": restaurant.get("meal_cater")
        }
        meal_option_nodes.append(meal_option_node)
        relationships.append({"from": restaurant_id, "to": meal_option_id, "type": "OFFERS"})

        # Contact Node
        contact_id = generate_id()
        contact_node = {
            "id": contact_id,
            "tel": restaurant.get("tel"),
            "fax": restaurant.get("fax"),
            "website": restaurant.get("website"),
            "email": restaurant.get("email"),
            "latitude": restaurant.get("latitude"),
            "longitude": restaurant.get("longitude")
        }
        contact_nodes.append(contact_node)
        relationships.append({"from": restaurant_id, "to": contact_id, "type": "HAS_CONTACT"})

        # Schedule Node
        schedule_id = generate_id()
        schedule_node = {"id": schedule_id}

        for day, hours in restaurant.get("hours", {}).items():
            flattened_hours = "; ".join([f"{start}-{end}" for start, end in hours])
            schedule_node[day] = flattened_hours

        schedule_nodes.append(schedule_node)
        relationships.append({"from": restaurant_id, "to": schedule_id, "type": "HAS_SCHEDULE"})


        # Review Nodes
        for review in restaurant.get("reviews", []):
            review_id = generate_id()
            review_node = {
                "id": review_id,
                "review_website": review["review_website"],
                "review_title": review["review_title"],
                "review_text": review["review_text"],
                "review_rating": review["review_rating"],
                "review_date": review["review_date"]
            }
            review_nodes.append(review_node)
            relationships.append({"from": review_id, "to": restaurant_id, "type": "REVIEWS"})

    with open(f"{output_directory}/restaurants.json", "w") as file:
        json.dump(restaurant_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/descriptions.json", "w") as file:
        json.dump(description_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/mealoptions.json", "w") as file:
        json.dump(meal_option_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/contacts.json", "w") as file:
        json.dump(contact_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/schedules.json", "w") as file:
        json.dump(schedule_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/reviews.json", "w") as file:
        json.dump(review_nodes, file, default=str, indent=4)

    with open(f"{output_directory}/relationships.json", "w") as file:
        json.dump(relationships, file, default=str, indent=4)

    cuisine_node_list = list(cuisine_nodes.values())
    with open(f"{output_directory}/cuisines.json", "w") as file:
        json.dump(cuisine_node_list, file, default=str, indent=4)

# Process data
process_restaurant_data("initialDataset.json", "transformedData")
