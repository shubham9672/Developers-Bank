package com.example.entities;

import com.example.enums.SeatStatus;
import com.example.enums.SeatType;

public class Seat {
    private int seatNumber;
    private SeatType seatType;
    private SeatStatus status;
    private double price;

    public Seat(int seatNumber, SeatType seatType, double price) {
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.status = SeatStatus.AVAILABLE;
        this.price = price;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public SeatType getSeatType() {
        return seatType;
    }

    public SeatStatus getStatus() {
        return status;
    }

    public double getPrice() {
        return price;
    }

    public void setStatus(SeatStatus status) {
        this.status = status;
    }
}

