package com.example.services;

import com.example.enums.SeatType;
import com.example.enums.ShowType;

public interface PricingService {
    double calculatePrice(double basePrice, SeatType seatType, ShowType showType);
}