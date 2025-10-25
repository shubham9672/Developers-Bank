package com.example;
import com.example.services.MovieTicketPlatformService;
public class MovieTicketBookingSystem {
    public static void main(String[] args) {
        MovieTicketPlatformService platform = new MovieTicketPlatformService();

        System.out.println("=== Movie Ticket Booking Platform (Design Patterns Demo) ===\n");
        platform.executeCommand("CreateUser John");
        platform.executeCommand("CreateUser Alice");
        platform.executeCommand("CreateUser Bob");
        platform.executeCommand("AddMovie Final-Destination");
        platform.executeCommand("AddMovie Inception");
        platform.executeCommand("AddMovie Avatar");
        platform.executeCommand("ListMovie");
        platform.executeCommand("AddTheatre PVR 5 20 100");
        platform.executeCommand("AddTheatre INOX 10 15 120");
        platform.executeCommand("GenerateShows 1 1 3");
        platform.executeCommand("GenerateShows 2 1 2");
        platform.executeCommand("ListShows theatre 1");
        platform.executeCommand("ListShows movie 1");
        platform.executeCommand("BookTicket 1 1 [1,2]");
        platform.executeCommand("BookTicket 2 1 [3,4,5]");
        platform.executeCommand("ListUserBookings 1");
        platform.executeCommand("ListUserBookings 2");
        platform.executeCommand("CancelBooking 1");
        platform.executeCommand("ListUserBookings 1");
        platform.executeCommand("ListShows theatre 1");
    }
}