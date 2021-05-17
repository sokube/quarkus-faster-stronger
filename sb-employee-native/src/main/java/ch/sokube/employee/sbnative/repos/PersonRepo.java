package ch.sokube.employee.sbnative.repos;

import ch.sokube.employee.sbnative.entities.Person;
import ch.sokube.employee.sbnative.entities.Status;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Person CRUD repository
 */
public interface PersonRepo extends CrudRepository<Person, Long> {
     // Find a person by its status
    List<Person> findPersonByStatusEquals(Status status);
}
