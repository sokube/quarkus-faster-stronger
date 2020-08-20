package ch.sokube.employee.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

/**
 * Define a competency for a person, with the level of a person in this competency
 */
@Entity
public class Competency  {

    public String name;

    public int level;

    @JsonIgnore
    @ManyToOne
    public Person personWithCompetency;

    @Id
    @GeneratedValue
    public Long id;

    /**
     * JPA need the default constructor
     */
    public Competency(){}

    /**
     * Constructor with fields
     * @param name The name of the competency
     * @param level The level of the person for the skill
     * @param personWithCompetency The owner of the competency
     */
    public Competency(final String name, final int level, final Person personWithCompetency) {
        this.name = name;
        this.level = level;
        this.personWithCompetency = personWithCompetency;
    }

}
