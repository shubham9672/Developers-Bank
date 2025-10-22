package com.example.entities;

import java.util.List;

import com.example.enums.ShowType;

public class Show {
    private int id;
    private Movie movie;
    private Theatre theatre;
    private ShowType showType;
    private List<Seat> seats;

    public Show(int id, Movie movie, Theatre theatre, ShowType showType, List<Seat> seats) {
        this.id = id;
        this.movie = movie;
        this.theatre = theatre;
        this.showType = showType;
        this.seats = seats;
    }

    public int getId() {
        return id;
    }

    public Movie getMovie() {
        return movie;
    }

    public Theatre getTheatre() {
        return theatre;
    }

    public ShowType getShowType() {
        return showType;
    }

    public List<Seat> getSeats() {
        return seats;
    }
}

