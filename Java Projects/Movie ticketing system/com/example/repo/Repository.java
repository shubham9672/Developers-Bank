package com.example.repo;

import java.util.Collection;

public interface Repository<T> {
    void save(T entity);

    T findById(int id);

    Collection<T> findAll();
}


