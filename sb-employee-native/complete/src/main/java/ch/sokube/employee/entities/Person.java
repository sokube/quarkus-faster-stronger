package ch.sokube.employee.entities;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Define a person in the system
 * Person has a name, a birthdate, a status (employee or candidate) and a list of skills
 */
@Entity
public class Person {
    public String name;
    
    public LocalDate birth;
    
    public Status status;

    @Id
    @GeneratedValue
    public Long id;

    @OneToMany(cascade = CascadeType.ALL)
    public List<Competency> competencies = new ArrayList<>();


}
