package com.example.services;

import com.example.enums.SeatType;
import com.example.enums.ShowType;

public class PriceServiceImpl implements PricingService {
    @Override
    public double calculatePrice(double basePrice, SeatType seatType, ShowType showType) {
        double showSurcharge = getShowCharge(showType);
        double seatSurcharge = getSeatCharge(seatType);
        return basePrice + showSurcharge + seatSurcharge;
    }

    private double getShowCharge(ShowType showType) {
        switch (showType) {
            case MORNING:
                return 50;
            case AFTERNOON:
                return 70;
            case EVENING:
                return 90;
            default:
                return 0;
        }
    }

    private double getSeatCharge(SeatType seatType) {
        switch (seatType) {
            case NORMAL:
                return 20;
            case PREMIUM:
                return 40;
            default:
                return 0;
        }
    }
}