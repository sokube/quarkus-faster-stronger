package ch.sokube.employee.entities;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

import javax.json.bind.annotation.JsonbTransient;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;

@Entity
public class Competency extends PanacheEntity {
    public String name;
    public int level;
    @JsonbTransient
    @ManyToOne
    public Person personWithCompetency;

    public Competency(){}
    public Competency(String name, int level, Person personWithCompetency) {
        this.name = name;
        this.level = level;
        this.personWithCompetency = personWithCompetency;
    }

}
