package com.example.services;

import java.util.ArrayList;
import java.util.List;

import com.example.entities.Seat;
import com.example.entities.Theatre;
import com.example.enums.SeatType;
import com.example.enums.ShowType;

public class SeatServiceImpl implements SeatService {
    @Override
    public List<Seat> createSeats(Theatre theatre, ShowType showType, PricingService pricingStrategy) {
        List<Seat> seats = new ArrayList<>();
        int seatNumber = 1;
        double basePrice = theatre.getBaseSeatPrice();

        // Create normal seats
        for (int i = 0; i < theatre.getNormalSeats(); i++) {
            double price = pricingStrategy.calculatePrice(basePrice, SeatType.NORMAL, showType);
            seats.add(new Seat(seatNumber++, SeatType.NORMAL, price));
        }

        // Create premium seats
        for (int i = 0; i < theatre.getPremiumSeats(); i++) {
            double price = pricingStrategy.calculatePrice(basePrice, SeatType.PREMIUM, showType);
            seats.add(new Seat(seatNumber++, SeatType.PREMIUM, price));
        }

        return seats;
    }
}