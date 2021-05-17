package ch.sokube.qk.employee.entities.service;

import ch.sokube.qk.employee.entities.Competency;
import ch.sokube.qk.employee.entities.Person;
import ch.sokube.qk.employee.entities.Status;

import javax.enterprise.context.ApplicationScoped;
import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class PersonnesService {

    List<String> competencies = Arrays.asList(new String [] {"KUBE","ANSIBLE","JAVA","ANGULAR","KAFKA","ELASTIC"});

    // See powerful jta :)
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
            Person.createEmployee(p);
        }
    }

    public static int getRandom(int max) {
        return (int) (Math.random()*max);
    }

}
