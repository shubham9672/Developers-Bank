package com.example.commands;

import java.util.List;

import com.example.entities.Movie;
import com.example.repo.MovieRepository;

public class ListMoviesCommand implements Command {
    private MovieRepository movieRepository;

    public ListMoviesCommand(MovieRepository movieRepository) {
        this.movieRepository = movieRepository;
    }

    @Override
    public void execute() {
        List<Movie> movies = (List<Movie>) movieRepository.findAll();
        if (movies.isEmpty()) {
            System.out.println("No movies available.");
            return;
        }
        System.out.println("Available Movies:");
        for (Movie movie : movies) {
            System.out.println("  ID: " + movie.getId() + " - " + movie.getName());
        }
    }
}
