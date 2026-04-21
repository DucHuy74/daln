import math
import numpy as np


class PriorityService:

    def __init__(self, neo4j_service, db):
        self.neo4j_service = neo4j_service
        self.db = db

    # CENTRALITY
    def compute_centrality(self):
        print("[PRIORITY] Computing centrality...")

        # Degree
        self.neo4j_service.run_query("""
        MATCH (n:Term)
        OPTIONAL MATCH (n)--()
        WITH n, count(*) as deg
        SET n.degree = deg
        """)

        # Betweenness (simple approx: normalize degree)
        self.neo4j_service.run_query("""
        MATCH (n:Term)
        SET n.betweenness = n.degree * 1.0
        """)

        print("[PRIORITY] Centrality done")

    # LOAD STORY OBJECTS
    def load_story_objects(self, workspace_id):
        return self.neo4j_service.run_query("""
        MATCH (sub:Term {workspace_id: $ws})-[r:PERFORM]->(act:Term)
        WHERE r.story_id IS NOT NULL

        MATCH (act)-[:TARGET]->(obj:Term)

        RETURN 
            r.story_id as story_id, 
            collect(DISTINCT obj.name) as objects
        """, {"ws": workspace_id})

    # LOAD CACHE
    def load_all_object_scores(self):
        result = self.neo4j_service.run_query("""
        MATCH (o:Term)
        RETURN o.name as name, 
               coalesce(o.degree,0) as degree, 
               coalesce(o.betweenness,0) as betweenness
        """)

        cache = {}
        for r in result:
            cache[r["name"]] = (r["degree"], r["betweenness"])

        return cache

    # SCALING
    def compute_scaling(self, scores):
        values = [x[1] for x in scores]

        if not values:
            return 1, 0

        median = np.median(values)
        q1 = np.percentile(values, 25)
        q3 = np.percentile(values, 75)
        iqr = q3 - q1

        if iqr == 0:
            return 1, -median

        alpha = 4 / iqr
        beta = -alpha * median

        return alpha, beta

    # SIGMOID
    def sigmoid(self, x):
        return 1 / (1 + math.exp(-x))

    # UPDATE
    def update_priority(self, story_id, priority):
        self.neo4j_service.run_query("""
        MERGE (s:UserStory {id: $id})
        SET s.priority = $priority
        """, {
            "id": story_id,
            "priority": priority
        })

    # MAIN
    def compute_priority_for_workspace(self, workspace_id):
        print(f"[PRIORITY] Start workspace={workspace_id}")

        # 1. centrality
        self.compute_centrality()

        # 2. load story objects
        stories = self.load_story_objects(workspace_id)

        if not stories:
            print("[PRIORITY] No stories found")
            return

        # 3. load cache
        object_cache = self.load_all_object_scores()

        struct_scores = []

        for s in stories:
            story_id = s["story_id"]
            objects = s["objects"]

            if not objects:
                struct_scores.append((story_id, 0))
                continue

            degree_sum = 0
            between_sum = 0

            for obj in objects:
                degree, between = object_cache.get(obj, (0, 0))
                degree_sum += degree
                between_sum += between

            degree_avg = degree_sum / len(objects)
            between_avg = between_sum / len(objects)

            x = 0.5 * degree_avg + 0.5 * between_avg

            struct_scores.append((story_id, x))

        # 4. scaling
        alpha, beta = self.compute_scaling(struct_scores)
        print(f"[PRIORITY] alpha={alpha}, beta={beta}")

        # 5. final priority
        for story_id, x in struct_scores:
            priority = self.sigmoid(alpha * x + beta)
            self.update_priority(story_id, priority)

        print("[PRIORITY] Done")