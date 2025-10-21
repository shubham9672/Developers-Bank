package com.example.commands;

import com.example.entities.Movie;
import com.example.repo.MovieRepository;
import com.example.utils.IdGenerator;

public class AddMovieCommand implements Command {
    private MovieRepository movieRepository;
    private String movieName;

    public AddMovieCommand(MovieRepository movieRepository, String movieName) {
        this.movieRepository = movieRepository;
        this.movieName = movieName;
    }

    @Override
    public void execute() {
        int id = IdGenerator.getInstance().getNextId("Movie");
        Movie movie = new Movie(id, movieName);
        movieRepository.save(movie);
        System.out.println("Movie added successfully! Movie ID: " + id + ", Name: " + movieName);
    }
}