package com.example.commands;

import java.util.ArrayList;
import java.util.List;

import com.example.entities.Booking;
import com.example.entities.Seat;
import com.example.entities.Show;
import com.example.entities.User;
import com.example.enums.SeatStatus;
import com.example.repo.BookingRepository;
import com.example.repo.ShowRepository;
import com.example.repo.UserRepository;
import com.example.utils.IdGenerator;

public class BookTicketCommand implements Command {
    private BookingRepository bookingRepository;
    private UserRepository userRepository;
    private ShowRepository showRepository;
    private int userId;
    private int showId;
    private List<Integer> seatNumbers;

    public BookTicketCommand(BookingRepository bookingRepository, UserRepository userRepository,
            ShowRepository showRepository, int userId, int showId,
            List<Integer> seatNumbers) {
        this.bookingRepository = bookingRepository;
        this.userRepository = userRepository;
        this.showRepository = showRepository;
        this.userId = userId;
        this.showId = showId;
        this.seatNumbers = seatNumbers;
    }

    @Override
    public void execute() {
        User user = userRepository.findById(userId);
        Show show = showRepository.findById(showId);

        if (user == null) {
            System.out.println("Error: User not found.");
            return;
        }
        if (show == null) {
            System.out.println("Error: Show not found.");
            return;
        }

        List<Seat> seatsToBook = new ArrayList<>();
        double totalPrice = 0;

        for (int seatNum : seatNumbers) {
            Seat seat = show.getSeats().stream()
                    .filter(s -> s.getSeatNumber() == seatNum)
                    .findFirst()
                    .orElse(null);

            if (seat == null) {
                System.out.println("Error: Seat " + seatNum + " does not exist.");
                return;
            }
            if (seat.getStatus() == SeatStatus.BOOKED) {
                System.out.println("Error: Seat " + seatNum + " is already booked.");
                return;
            }
            seatsToBook.add(seat);
            totalPrice += seat.getPrice();
        }

        for (Seat seat : seatsToBook) {
            seat.setStatus(SeatStatus.BOOKED);
        }

        int bookingId = IdGenerator.getInstance().getNextId("Booking");
        Booking booking = new Booking(bookingId, user, show, seatNumbers, totalPrice);
        bookingRepository.save(booking);

        System.out.println("Booking successful!");
        System.out.println("  Booking ID: " + booking.getId());
        System.out.println("  User: " + user.getName());
        System.out.println("  Movie: " + show.getMovie().getName());
        System.out.println("  Theatre: " + show.getTheatre().getName());
        System.out.println("  Show Type: " + show.getShowType());
        System.out.println("  Seats: " + seatNumbers);
        System.out.println("  Total Price: Rs" + totalPrice);
    }
}
