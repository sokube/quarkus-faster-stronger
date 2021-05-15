package ch.sokube.employee.resources;


import ch.sokube.employee.entities.Competency;
import ch.sokube.employee.entities.Person;
import ch.sokube.employee.entities.Status;
import ch.sokube.employee.repos.PersonRepo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

/**
 * REST Controller for crud on Persons
 */
@RestController
@RequestMapping("/hello")
public class PersonsResource {

    private static final Logger LOGGER = LoggerFactory.getLogger(PersonsResource.class);

    PersonRepo repo;

    private final static List<String> competencies = Arrays.asList("KUBE","ANSIBLE","JAVA","ANGULAR","KAFKA","ELASTIC");


    PersonsResource(PersonRepo repo) {
        this.repo = repo;
    }

    
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
        LocalDate d1 = LocalDate.of(1980,1,1);
        // Random on 10 years = 3600 days
        for(int i = 0; i < 100; i++) {
            LocalDate birthDate =  d1.plusDays(getRandom(3600));

            Person p = new Person();
            p.name = "Person " + i;
            p.birth = birthDate;
            p.status = i%2==0? Status.CANDIDATE : Status.EMPLOYEE;
            p.competencies.addAll(competencies.stream().map(aComp -> new Competency(aComp, getRandom(10), p)).collect(Collectors.toList()));
            repo.save(p);
        }
    }
    public static int getRandom(int max) {
        return (int) (Math.random()*max);
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
