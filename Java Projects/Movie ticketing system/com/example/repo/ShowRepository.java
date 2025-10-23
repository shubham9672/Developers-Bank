package com.example.repo;

import java.util.List;
import java.util.stream.Collectors;

import com.example.entities.Show;

public class ShowRepository extends InMemoryRepository<Show> {
    public ShowRepository() {
        super(Show::getId);
    }

    public List<Show> findByMovie(int movieId) {
        return findAll().stream()
                .filter(s -> s.getMovie().getId() == movieId)
                .collect(Collectors.toList());
    }

    public List<Show> findByTheatre(int theatreId) {
        return findAll().stream()
                .filter(s -> s.getTheatre().getId() == theatreId)
                .collect(Collectors.toList());
    }
}
