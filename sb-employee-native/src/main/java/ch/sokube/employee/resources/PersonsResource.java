package ch.sokube.employee.resources;


import ch.sokube.employee.entities.Person;
import ch.sokube.employee.entities.Status;
import ch.sokube.employee.repos.PersonRepo;
import ch.sokube.employee.services.PersonnesService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * REST Controller for crud on Persons
 */
@RestController
@RequestMapping("/hello")
public class PersonsResource {

    private static final Logger LOGGER = LoggerFactory.getLogger(PersonsResource.class);

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

    private static final int HUGE_SIZE = 5_000;

    @GetMapping(path = "load", produces = "text/plain")
    public void load() {
        LOGGER.info("start load memory");
        Map<Integer, Object> leakMap = new HashMap<>();
        for (int i = 0; i < HUGE_SIZE; ++i) {
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
