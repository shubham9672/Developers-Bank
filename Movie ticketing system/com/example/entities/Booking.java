package com.example.entities;

import java.util.List;

public class Booking {
    private int id;
    private User user;
    private Show show;
    private List<Integer> seatNumbers;
    private double totalPrice;
    private boolean cancelled;

    public Booking(int id, User user, Show show, List<Integer> seatNumbers, double totalPrice) {
        this.id = id;
        this.user = user;
        this.show = show;
        this.seatNumbers = seatNumbers;
        this.totalPrice = totalPrice;
        this.cancelled = false;
    }

    public int getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public Show getShow() {
        return show;
    }

    public List<Integer> getSeatNumbers() {
        return seatNumbers;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public boolean isCancelled() {
        return cancelled;
    }

    public void cancel() {
        this.cancelled = true;
    }
}
