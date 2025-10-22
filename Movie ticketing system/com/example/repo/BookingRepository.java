package com.example.repo;

import java.util.List;
import java.util.stream.Collectors;

import com.example.entities.Booking;

public class BookingRepository extends InMemoryRepository<Booking> {
    public BookingRepository() {
        super(Booking::getId);
    }

    public List<Booking> findByUser(int userId) {
        return findAll().stream()
                .filter(b -> b.getUser().getId() == userId && !b.isCancelled())
                .collect(Collectors.toList());
    }
}
