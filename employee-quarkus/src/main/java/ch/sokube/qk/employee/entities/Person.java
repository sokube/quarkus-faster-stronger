package ch.sokube.qk.employee.entities;

import io.quarkus.hibernate.orm.panache.Panache;
import io.quarkus.hibernate.orm.panache.PanacheEntity;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Person extends PanacheEntity {
    public String name;
    public LocalDate birth;
    public Status status;

    @OneToMany(cascade = CascadeType.ALL)
    public List<Competency> competencies = new ArrayList<>();

    public static Person findByName(String name){
        return find("name", name).firstResult();
    }

    public static void createEmployee(Person e) {
        persist(e);
    }

    public static Person updateEmployee(Person e) {
        return Panache.getEntityManager().merge(e);
    }

    public static List<Person> findEmployees(){
        return list("status", Status.EMPLOYEE);
    }

    public static void deleteStefs(){
        delete("name", "Stef");
    }

    public static List<Person> findPersons() {
        return listAll();
    }
}
