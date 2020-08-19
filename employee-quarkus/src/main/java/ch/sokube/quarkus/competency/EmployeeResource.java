package ch.sokube.quarkus.competency;



import ch.sokube.employee.entities.Person;
import ch.sokube.employee.entities.service.PersonnesService;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.*;
import java.util.List;

@Path("hello")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class EmployeeResource {

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

    @Inject
    PersonnesService personnesService;

    @GET
    @Path("generate")
    public void generateEmployee() {
        personnesService.generateEmployee();
    }

}
