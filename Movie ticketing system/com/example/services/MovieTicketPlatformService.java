package com.example.services;

import com.example.commands.*;
import com.example.repo.MovieRepository;
import com.example.repo.ShowRepository;
import com.example.repo.TheatreRepository;
import com.example.repo.UserRepository;


public class MovieTicketPlatformService {
    private UserRepository userRepository;
    private MovieRepository movieRepository;
    private TheatreRepository theatreRepository;
    private ShowRepository showRepository;
    private SeatService seatFactory;
    private PricingService pricingStrategy;

    public MovieTicketPlatformService() {
        this.userRepository = new UserRepository();
        this.movieRepository = new MovieRepository();
        this.theatreRepository = new TheatreRepository();
        this.showRepository = new ShowRepository();
        this.seatFactory = new SeatServiceImpl();
        this.pricingStrategy = new PriceServiceImpl();
    }
        

    public void executeCommand(String commandStr) {
        String[] parts = commandStr.trim().split("\\s+");
        if (parts.length == 0)
            return;

        try {
            Command command = null;

            switch (parts[0]) {
                case "CreateUser":
                    if (parts.length < 2) {
                        System.out.println("Usage: CreateUser <user_name>");
                        return;
                    }
                    command = new CreateUserCommand(userRepository, parts[1]);
                    break;
                case "AddMovie":
                    if (parts.length < 2) {
                        System.out.println("Usage: AddMovie <movie_name>");
                        return;
                    }
                    command = new AddMovieCommand(movieRepository, parts[1]);
                    break;

                case "ListMovie":
                    command = new ListMoviesCommand(movieRepository);
                    break;
                case "AddTheatre":
                    if (parts.length < 5) {
                        System.out.println("Usage: AddTheatre <name> <normal_seats> <premium_seats> <base_price>");
                        return;
                    }
                    command = new AddTheatreCommand(theatreRepository, parts[1],
                            Integer.parseInt(parts[2]),
                            Integer.parseInt(parts[3]),
                            Double.parseDouble(parts[4]));
                    break;
                case "GenerateShows":
                    if (parts.length < 4) {
                        System.out.println("Usage: GenerateShows <movie_id/name> <theatre_id/name> <number_of_shows>");
                        return;
                    }
                    command = new GenerateShowsCommand(showRepository, movieRepository,
                            theatreRepository, parts[1], parts[2],
                            Integer.parseInt(parts[3]),
                            seatFactory, pricingStrategy);
                    break;


                default:
                    System.out.println("Unknown command: " + parts[0]);
                    return;
            }

            if (command != null) {
                command.execute();
            }

        } catch (Exception e) {
            System.out.println("Error executing command: " + e.getMessage());
        }
        System.out.println();
    }
}
