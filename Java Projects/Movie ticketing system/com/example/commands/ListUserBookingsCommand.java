package com.example.commands;

import java.util.List;

import com.example.entities.Booking;
import com.example.entities.User;
import com.example.repo.BookingRepository;
import com.example.repo.UserRepository;

public class ListUserBookingsCommand implements Command {
    private BookingRepository bookingRepository;
    private UserRepository userRepository;
    private int userId;

    public ListUserBookingsCommand(BookingRepository bookingRepository,
            UserRepository userRepository, int userId) {
        this.bookingRepository = bookingRepository;
        this.userRepository = userRepository;
        this.userId = userId;
    }

    @Override
    public void execute() {
        User user = userRepository.findById(userId);
        if (user == null) {
            System.out.println("Error: User not found.");
            return;
        }

        List<Booking> userBookings = bookingRepository.findByUser(userId);

        if (userBookings.isEmpty()) {
            System.out.println("No bookings found for user: " + user.getName());
            return;
        }

        System.out.println("Bookings for " + user.getName() + ":");
        for (Booking booking : userBookings) {
            System.out.println("  Booking ID: " + booking.getId() +
                    " | Movie: " + booking.getShow().getMovie().getName() +
                    " | Theatre: " + booking.getShow().getTheatre().getName() +
                    " | Seats: " + booking.getSeatNumbers() +
                    " | Total: Rs" + booking.getTotalPrice());
        }
    }
}
