package ch.sokube.employee.repos;

import ch.sokube.employee.entities.Person;
import ch.sokube.employee.entities.Status;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Person CRUD repository
 */
public interface PersonRepo extends CrudRepository<Person, Long> {
     // Find a person by its status
    List<Person> findPersonByStatusEquals(Status status);
}
