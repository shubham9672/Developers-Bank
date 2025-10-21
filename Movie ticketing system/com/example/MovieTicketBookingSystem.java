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
       
    }
}