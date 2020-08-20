package ch.sokube.employee.resources;


import ch.sokube.employee.entities.Person;
import ch.sokube.employee.entities.Status;
import ch.sokube.employee.repos.PersonRepo;
import ch.sokube.employee.services.PersonnesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST Controller for crud on Persons
 */
@RestController
@RequestMapping("/hello")
public class PersonsResource {

    @Autowired
    PersonnesService personnesService;

    @Autowired
    PersonRepo repo;
    
    @GetMapping
    public String hello() {
        return "hello";
    }

    @PostMapping(path="create")
    public void createPerson(@RequestBody Person p) {
        repo.save(p);
    }

    @GetMapping(path = "listEmployee")
    public List<Person> listEmployee() {
        return repo.findPersonByStatusEquals(Status.EMPLOYEE);
    }

    @GetMapping(path = "listPersons")
    public Iterable<Person> listPersons() {
        return repo.findAll();
    }

    @GetMapping(path = "generate")
    public void generateEmployee() {
        personnesService.generateEmployee();
    }

}
