package com.example.repo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class InMemoryRepository<T> implements Repository<T> {
    private List<T> storage = new ArrayList<>();
    private java.util.function.Function<T, Integer> idExtractor;

    public InMemoryRepository(java.util.function.Function<T, Integer> idExtractor) {
        this.idExtractor = idExtractor;
    }

    @Override
    public void save(T entity) {
        storage.add(entity);
    }

    @Override
    public T findById(int id) {
        return storage.stream()
                .filter(e -> idExtractor.apply(e) == id)
                .findFirst()
                .orElse(null);
    }

    @Override
    public Collection<T> findAll() {
        return new ArrayList<>(storage);
    }
}