package ch.sokube.employee.services;


import ch.sokube.employee.entities.Competency;
import ch.sokube.employee.entities.Person;
import ch.sokube.employee.entities.Status;
import ch.sokube.employee.repos.PersonRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Service for generation of persons.
 */
@Component
public class PersonnesService {

    @Autowired
    PersonRepo repo;

    private final static List<String> competencies = Arrays.asList("KUBE","ANSIBLE","JAVA","ANGULAR","KAFKA","ELASTIC");

    @Transactional
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

}
