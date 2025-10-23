package com.example.utils;

import java.util.HashMap;
import java.util.Map;

public class IdGenerator {
    private static IdGenerator instance;
    private Map<String, Integer> counters;

    private IdGenerator() {
        counters = new HashMap<>();
    }

    public static synchronized IdGenerator getInstance() {
        if (instance == null) {
            instance = new IdGenerator();
        }
        return instance;
    }

    public synchronized int getNextId(String entityType) {
        counters.putIfAbsent(entityType, 0);
        int nextId = counters.get(entityType) + 1;
        counters.put(entityType, nextId);
        return nextId;
    }
}