package ch.sokube.qk.quarkus.competency;


import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.infrastructure.Infrastructure;
import org.jboss.resteasy.reactive.RestSseElementType;

import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.time.Duration;
import java.util.*;


@Path("reactive")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class RactiveResource {

    @GET
    @RestSseElementType(MediaType.TEXT_PLAIN)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("randomflux/{iterations}/{duration}")
    public Multi<String> getRandom(int iterations, int duration) {
        return Multi.createFrom().ticks().every(Duration.ofMillis(duration))
                .onItem()
                .transform(n -> "hello - "+ n + ": " + new Random().nextInt())
                .transform().byTakingFirstItems(iterations)
                .onOverflow().buffer(250)
                .emitOn(Infrastructure.getDefaultExecutor())
                ;
    }

}
