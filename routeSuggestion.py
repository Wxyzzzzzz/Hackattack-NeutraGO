import googlemaps
import networkx as nx
from haversine import haversine
import heapq
import random

# === Step 1: Connect to Google Maps ===
API_KEY = "AIzaSyCp0J_hsaPdeyjtkJrBw8bmXHYET4o75rQ"  # Replace with your real API key
gmaps = googlemaps.Client(key=API_KEY)

# === Step 2: Get route steps with congestion-aware duration ===
def get_route_steps(origin, destination, mode="driving"):
    directions = gmaps.directions(
        origin,
        destination,
        mode=mode,
        departure_time="now"
        traffic_model="best_guess"
    )
    steps = directions[0]['legs'][0]['steps']
    path = []

    for step in steps:
        start = (step['start_location']['lat'], step['start_location']['lng'])
        end = (step['end_location']['lat'], step['end_location']['lng'])
        distance_km = step['distance']['value'] / 1000
        duration_sec = step.get('duration_in_traffic', step['duration'])['value']
        duration_min = duration_sec / 60
        mode = step.get('travel_mode', 'driving')
        path.append((start, end, distance_km, duration_min, mode))

    return path

# === Step 3: Build graph ===
def build_graph(steps, emission_rate=180):
    G = nx.DiGraph()
    for start, end, dist, time, mode in steps:
        emission = dist * emission_rate
        G.add_edge(start, end, distance=dist, time=time, emission=emission, mode=mode)
    return G

# === Step 4: User profiles and scoring ===
def simulate_user_profiles():
    return {
        'user_1': {'alpha': 0.6, 'beta': 0.4},  # prefers green
        'user_2': {'alpha': 0.3, 'beta': 0.7},  # prefers speed
    }

def score_path(graph, path, alpha, beta, max_time, max_emission):
    total_time = 0
    total_emission = 0
    steps = []

    for i in range(len(path) - 1):
        data = graph[path[i]][path[i + 1]]
        steps.append(f"{path[i]} → {path[i+1]} via {data['mode']}")
        total_time += data['time']
        total_emission += data['emission']

    norm_time = total_time / max_time
    norm_emission = total_emission / max_emission
    score = alpha * norm_emission + beta * norm_time

    return {
        "path": steps,
        "total_time": total_time,
        "total_emission": total_emission,
        "score": score
    }

def give_feedback(user_profiles, user_id, route, liked):
    profile = user_profiles[user_id]
    if liked:
        print(f"\u2705 User {user_id} liked the route.")
        if route['total_emission'] < 100:
            profile['alpha'] = min(profile['alpha'] + 0.05, 1.0)
            profile['beta'] = 1.0 - profile['alpha']
    else:
        print(f"❌ User {user_id} disliked the route.")
        profile['beta'] = min(profile['beta'] + 0.05, 1.0)
        profile['alpha'] = 1.0 - profile['beta']

# === Step 5: Run Program ===
if __name__ == "__main__":
    origin = "Penang Hill"
    destination = "Queensbay Mall, Penang"

    steps = get_route_steps(origin, destination)
    G = build_graph(steps)

    start_node = steps[0][0]
    end_node = steps[-1][1]

    try:
        all_paths = list(nx.all_simple_paths(G, source=start_node, target=end_node))
    except:
        print("\u26a0\ufe0f No paths found.")
        exit()

    if not all_paths:
        print("\u26a0\ufe0f No valid paths.")
        exit()

    user_profiles = simulate_user_profiles()

    for user_id in user_profiles:
        alpha = user_profiles[user_id]['alpha']
        beta = user_profiles[user_id]['beta']

        print(f"\n--- Recommendations for {user_id} (alpha={alpha:.2f}, beta={beta:.2f}) ---")

        # Calculate max values for normalization
        times = []
        emissions = []
        for path in all_paths:
            t, e = 0, 0
            for i in range(len(path)-1):
                edge = G[path[i]][path[i+1]]
                t += edge['time']
                e += edge['emission']
            times.append(t)
            emissions.append(e)
        max_time = max(times)
        max_emission = max(emissions)

        # Score and sort
        scored_routes = [score_path(G, p, alpha, beta, max_time, max_emission) for p in all_paths]
        scored_routes.sort(key=lambda r: r['score'])
        best_route = scored_routes[0]

        # Print all routes
        for i, route in enumerate(scored_routes, 1):
            print(f"\n🔹 Route {i}")
            for step in route["path"]:
                print("   ", step)
            print(f"   🕒 Time: {route['total_time']:.2f} min | ♻️ CO₂: {route['total_emission']:.2f} g | 💰 Score: {route['score']:.3f}")

        give_feedback(user_profiles, user_id, best_route, liked=(best_route['total_time'] < 20))

    print("\n🔄 Updated User Preferences:")
    for user_id, profile in user_profiles.items():
        print(f"{user_id}: alpha={profile['alpha']:.2f}, beta={profile['beta']:.2f}")

