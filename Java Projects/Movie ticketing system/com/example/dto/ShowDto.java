package com.example.dto;

import java.util.List;

import com.example.entities.Movie;
import com.example.entities.Seat;
import com.example.entities.Show;
import com.example.entities.Theatre;
import com.example.enums.ShowType;
import com.example.services.PricingService;
import com.example.services.SeatService;

public class ShowDto {
    private int id;
    private Movie movie;
    private Theatre theatre;
    private ShowType showType;
    private SeatService seatFactory;
    private PricingService pricingStrategy;

    public ShowDto setId(int id) {
        this.id = id;
        return this;
    }

    public ShowDto setMovie(Movie movie) {
        this.movie = movie;
        return this;
    }

    public ShowDto setTheatre(Theatre theatre) {
        this.theatre = theatre;
        return this;
    }

    public ShowDto setShowType(ShowType showType) {
        this.showType = showType;
        return this;
    }

    public ShowDto setSeatFactory(SeatService seatFactory) {
        this.seatFactory = seatFactory;
        return this;
    }

    public ShowDto setPricingStrategy(PricingService pricingStrategy) {
        this.pricingStrategy = pricingStrategy;
        return this;
    }

    public Show build() {
        List<Seat> seats = seatFactory.createSeats(theatre, showType, pricingStrategy);
        return new Show(id, movie, theatre, showType, seats);
    }
}
