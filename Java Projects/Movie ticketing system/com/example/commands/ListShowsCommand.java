package com.example.commands;

import java.util.ArrayList;
import java.util.List;

import com.example.entities.Movie;
import com.example.entities.Show;
import com.example.entities.Theatre;
import com.example.enums.SeatStatus;
import com.example.repo.MovieRepository;
import com.example.repo.ShowRepository;
import com.example.repo.TheatreRepository;

public class ListShowsCommand implements Command {
    private ShowRepository showRepository;
    private MovieRepository movieRepository;
    private TheatreRepository theatreRepository;
    private String type;
    private String identifier;

    public ListShowsCommand(ShowRepository showRepository, MovieRepository movieRepository,
            TheatreRepository theatreRepository, String type, String identifier) {
        this.showRepository = showRepository;
        this.movieRepository = movieRepository;
        this.theatreRepository = theatreRepository;
        this.type = type;
        this.identifier = identifier;
    }

    @Override
    public void execute() {
        List<Show> filteredShows = new ArrayList<>();

        if (type.equalsIgnoreCase("movie")) {
            Movie movie = findMovie(identifier);
            if (movie == null) {
                System.out.println("Error: Movie not found.");
                return;
            }
            filteredShows = showRepository.findByMovie(movie.getId());
        } else if (type.equalsIgnoreCase("theatre")) {
            Theatre theatre = findTheatre(identifier);
            if (theatre == null) {
                System.out.println("Error: Theatre not found.");
                return;
            }
            filteredShows = showRepository.findByTheatre(theatre.getId());
        }

        if (filteredShows.isEmpty()) {
            System.out.println("No shows found.");
            return;
        }

        System.out.println("Available Shows:");
        for (Show show : filteredShows) {
            long availableSeats = show.getSeats().stream()
                    .filter(s -> s.getStatus() == SeatStatus.AVAILABLE)
                    .count();
            System.out.println("  Show ID: " + show.getId() +
                    " | Movie: " + show.getMovie().getName() +
                    " | Theatre: " + show.getTheatre().getName() +
                    " | Type: " + show.getShowType() +
                    " | Available Seats: " + availableSeats + "/" + show.getSeats().size());
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
