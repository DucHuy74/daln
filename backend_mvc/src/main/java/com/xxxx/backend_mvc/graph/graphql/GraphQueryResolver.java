package com.xxxx.backend_mvc.graph.graphql;

import com.xxxx.backend_mvc.graph.dto.GraphEdgeDTO;
import com.xxxx.backend_mvc.graph.dto.GraphNodeDTO;
import com.xxxx.backend_mvc.graph.dto.GraphResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.neo4j.core.Neo4jClient;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class GraphQueryResolver {

    private final Neo4jClient neo4jClient;

    @QueryMapping
    public GraphResponse userStoryGraph(@Argument String storyId) {

        //Query nodes (anchor từ UserStory)
        List<GraphNodeDTO> nodes =
                neo4jClient.query("""
            MATCH (us:UserStory {id:$storyId})-[*1..2]-(n)
            RETURN DISTINCT
                coalesce(n.id, n.name) AS id,
                labels(n)[0] AS label,
                labels(n)[0] AS type
        """)
                        .bind(storyId).to("storyId")
                        .fetchAs(GraphNodeDTO.class)
                        .mappedBy((ts, rec) -> new GraphNodeDTO(
                                rec.get("id").asString(),
                                rec.get("label").asString(),
                                rec.get("type").asString()
                        ))
                        .all()
                        .stream()
                        .toList();

        // Query edges (chỉ các cạnh liên quan tới story)
        List<GraphEdgeDTO> edges =
                neo4jClient.query("""
            MATCH (us:UserStory {id:$storyId})-[r]-(n)
            RETURN
                coalesce(us.id, us.name) AS from,
                coalesce(n.id, n.name) AS to,
                type(r) AS type
            UNION
            MATCH (a:Actor)-[r:ACTION]-(o:Object)
            WHERE r.storyId = $storyId
            RETURN
                a.name AS from,
                o.name AS to,
                r.name AS type
        """)
                        .bind(storyId).to("storyId")
                        .fetchAs(GraphEdgeDTO.class)
                        .mappedBy((ts, rec) -> new GraphEdgeDTO(
                                rec.get("from").asString(),
                                rec.get("to").asString(),
                                rec.get("type").asString()
                        ))
                        .all()
                        .stream()
                        .toList();


        return new GraphResponse(nodes, edges);
    }
}
