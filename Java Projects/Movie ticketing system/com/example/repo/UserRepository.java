package com.example.repo;

import com.example.entities.User;

public class UserRepository extends InMemoryRepository<User> {
    public UserRepository() {
        super(User::getId);
    }

    public User findByName(String name) {
        return findAll().stream()
                .filter(u -> u.getName().equalsIgnoreCase(name))
                .findFirst()
                .orElse(null);
    }
}