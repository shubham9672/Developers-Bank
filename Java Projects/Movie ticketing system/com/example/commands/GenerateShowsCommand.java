package com.example.commands;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import com.example.dto.ShowDto;
import com.example.entities.Movie;
import com.example.entities.Show;
import com.example.entities.Theatre;
import com.example.enums.ShowType;
import com.example.repo.MovieRepository;
import com.example.repo.ShowRepository;
import com.example.repo.TheatreRepository;
import com.example.services.PricingService;
import com.example.services.SeatService;
import com.example.utils.IdGenerator;

public class GenerateShowsCommand implements Command {
    private ShowRepository showRepository;
    private MovieRepository movieRepository;
    private TheatreRepository theatreRepository;
    private String movieIdentifier;
    private String theatreIdentifier;
    private int numberOfShows;
    private SeatService seatFactory;
    private PricingService pricingStrategy;

    public GenerateShowsCommand(ShowRepository showRepository, MovieRepository movieRepository,
            TheatreRepository theatreRepository, String movieIdentifier,
            String theatreIdentifier, int numberOfShows,
            SeatService seatFactory, PricingService pricingStrategy) {
        this.showRepository = showRepository;
        this.movieRepository = movieRepository;
        this.theatreRepository = theatreRepository;
        this.movieIdentifier = movieIdentifier;
        this.theatreIdentifier = theatreIdentifier;
        this.numberOfShows = numberOfShows;
        this.seatFactory = seatFactory;
        this.pricingStrategy = pricingStrategy;
    }

    @Override
    public void execute() {
        Movie movie = findMovie(movieIdentifier);
        Theatre theatre = findTheatre(theatreIdentifier);

        if (movie == null) {
            System.out.println("Error: Movie not found.");
            return;
        }
        if (theatre == null) {
            System.out.println("Error: Theatre not found.");
            return;
        }

        ShowType[] showTypes = ShowType.values();
        List<ShowType> availableShowTypes = new ArrayList<>(Arrays.asList(showTypes));
        Random random = new Random();

        for (int i = 0; i < numberOfShows && !availableShowTypes.isEmpty(); i++) {
            ShowType showType = availableShowTypes.remove(random.nextInt(availableShowTypes.size()));
            int showId = IdGenerator.getInstance().getNextId("Show");

            Show show = new ShowDto()
                    .setId(showId)
                    .setMovie(movie)
                    .setTheatre(theatre)
                    .setShowType(showType)
                    .setSeatFactory(seatFactory)
                    .setPricingStrategy(pricingStrategy)
                    .build();

            showRepository.save(show);
            System.out.println("Show created! Show ID: " + show.getId() +
                    ", Movie: " + movie.getName() +
                    ", Theatre: " + theatre.getName() +
                    ", Type: " + showType +
                    ", Total Seats: " + show.getSeats().size());
        }
    }

    private Movie findMovie(String identifier) {
        try {
            int id = Integer.parseInt(identifier);
            return movieRepository.findById(id);
        } catch (NumberFormatException e) {
            return movieRepository.findByName(identifier);
        }
    }

    private Theatre findTheatre(String identifier) {
        try {
            int id = Integer.parseInt(identifier);
            return theatreRepository.findById(id);
        } catch (NumberFormatException e) {
            return theatreRepository.findByName(identifier);
        }
    }
}


