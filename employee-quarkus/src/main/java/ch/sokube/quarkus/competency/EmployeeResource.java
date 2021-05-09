package ch.sokube.quarkus.competency;



import ch.sokube.employee.entities.Person;
import ch.sokube.employee.entities.service.PersonnesService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;


import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.*;
import java.util.List;
import java.util.Map;
import java.util.Random;
import javax.ws.rs.core.MediaType;
import org.jboss.logging.Logger;


@Path("hello")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class EmployeeResource {

    private static final Logger LOGGER = Logger.getLogger(EmployeeResource.class.getName());
    private static final int HUGE_SIZE = 5_000;

    @Inject
    PersonnesService personnesService;

    @GET
    public String hello() {
        return "hello";
    }

    @POST
    @Path("create")
    public void createPerson(Person p) {
        Person.createEmployee(p);
    }

    @GET
    @Path("listEmployee")
    public List<Person> listEmployee() {
        return Person.findEmployees();
    }

    @GET
    @Path("listPersons")
    public List<Person> listPersons() {
        return Person.findPersons();
    }

    @GET
    @Path("generate")
    public void generateEmployee() {
        personnesService.generateEmployee();
    }


    @GET
    @Path("load")
    @Produces(MediaType.TEXT_PLAIN)
    public void load() {
        LOGGER.info("start load memory");
        Map<Integer, Object> leakMap = new HashMap<>();
        for (int i = 0; i < HUGE_SIZE; ++i) {
            LOGGER.info("leak map iteration " + i);
            leakMap.put(i * 2, getListWithRandomNumber());
        }
        LOGGER.info("end load memory");
    }

    private List<Integer> getListWithRandomNumber() {
        final List<Integer> originalHugeIntList = new ArrayList<>();
        for (int i = 0; i < HUGE_SIZE; ++i) {
            originalHugeIntList.add(new Random().nextInt());
        }
        return originalHugeIntList.subList(0, 1);
    }
}
