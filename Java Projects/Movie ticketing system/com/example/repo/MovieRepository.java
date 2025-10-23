package com.example.repo;
import com.example.entities.Movie;
public class MovieRepository extends InMemoryRepository<Movie> {
    public MovieRepository() {
        super(Movie::getId);
    }

    public Movie findByName(String name) {
        return findAll().stream()
                .filter(m -> m.getName().equalsIgnoreCase(name))
                .findFirst()
                .orElse(null);
    }
}
