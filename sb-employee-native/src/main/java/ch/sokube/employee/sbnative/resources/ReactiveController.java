package ch.sokube.employee.sbnative.resources;

import org.reactivestreams.Publisher;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.Exceptions;
import reactor.core.publisher.Flux;
import reactor.util.retry.Retry;

import javax.websocket.server.PathParam;
import java.time.Duration;
import java.util.Random;

@RestController
@RequestMapping("/reactive")
public class ReactiveController {

    @GetMapping("randomflux/{iterations}/{duration}")
    public Flux<String> getRandom(@PathVariable Integer iterations, @PathVariable Integer duration) {
        return Flux.fromArray(new String[iterations])
                .interval(Duration.ofMillis(duration))
                .onBackpressureBuffer(250)
                .take(iterations)
                .map(n -> "hello - " + n + ": " + new Random().nextInt());
    }

}
