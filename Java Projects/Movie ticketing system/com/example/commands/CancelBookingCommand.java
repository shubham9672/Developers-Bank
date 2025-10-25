package com.example.commands;

import com.example.entities.Booking;
import com.example.entities.Show;
import com.example.enums.SeatStatus;
import com.example.repo.BookingRepository;

public class CancelBookingCommand implements Command {
    private BookingRepository bookingRepository;
    private int bookingId;

    public CancelBookingCommand(BookingRepository bookingRepository, int bookingId) {
        this.bookingRepository = bookingRepository;
        this.bookingId = bookingId;
    }

    @Override
    public void execute() {
        Booking booking = bookingRepository.findById(bookingId);

        if (booking == null) {
            System.out.println("Error: Booking not found.");
            return;
        }

        if (booking.isCancelled()) {
            System.out.println("Error: Booking already cancelled.");
            return;
        }

        Show show = booking.getShow();
        for (int seatNum : booking.getSeatNumbers()) {
            show.getSeats().stream()
                    .filter(s -> s.getSeatNumber() == seatNum)
                    .findFirst()
                    .ifPresent(s -> s.setStatus(SeatStatus.AVAILABLE));
        }

        booking.cancel();
        System.out.println("Booking cancelled successfully!");
        System.out.println("  Booking ID: " + bookingId);
        System.out.println("  Refund Amount: Rs" + booking.getTotalPrice());
    }
}
