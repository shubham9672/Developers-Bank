package com.example.repo;

import com.example.entities.Theatre;

public class TheatreRepository extends InMemoryRepository<Theatre> {
    public TheatreRepository() {
        super(Theatre::getId);
    }

    public Theatre findByName(String name) {
        return findAll().stream()
                .filter(t -> t.getName().equalsIgnoreCase(name))
                .findFirst()
                .orElse(null);
    }
}