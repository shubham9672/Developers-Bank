package com.example.services;

import java.util.List;

import com.example.entities.Seat;
import com.example.entities.Theatre;
import com.example.enums.ShowType;

public interface SeatService {
    List<Seat> createSeats(Theatre theatre, ShowType showType, PricingService pricingStrategy);
}


