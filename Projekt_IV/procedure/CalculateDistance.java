package example;

import java.util.stream.Stream;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.spatial.Point;
import org.neo4j.graphdb.spatial.Coordinate;
import org.neo4j.logging.Log;
import org.neo4j.procedure.Context;
import org.neo4j.procedure.Description;
import org.neo4j.procedure.Name;
import org.neo4j.procedure.Procedure;

public class CalculateDistance {

    @Context
    public Log log;

    @Procedure(name = "example.calculateDistance")
    @Description("Calculates distance between two specified nodes taht contain point property. Result returned in kilometres.")
    public Stream<DistanceResult> calculateDistance(
            @Name("node1") Node node1, 
            @Name("node2") Node node2) {

        Point location1 = (Point) node1.getProperty("location", null);
        Point location2 = (Point) node2.getProperty("location", null);

        if (location1 == null || location2 == null) {
            log.warn("Invalid node! Not found geolocation data in nodes.");
            return Stream.of(new DistanceResult(-1.0));
        }

        Coordinate cord1 = location1.getCoordinate();
        Coordinate cord2 = location2.getCoordinate();

        double lon1 = cord1.getCoordinate()[0];
        double lat1 = cord1.getCoordinate()[1];

        double lon2 = cord2.getCoordinate()[0];
        double lat2 = cord2.getCoordinate()[1];

        double distance = calculateHaversineDistance(lat1, lon1, lat2, lon2);
        return Stream.of(new DistanceResult(distance));
    }

    private double calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371;

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                 + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                 * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c; // Wynik w kilometrach
    }

    public static class DistanceResult {
        public Double distance;

        public DistanceResult(Double distance) {
            this.distance = distance;
        }
    }
}
