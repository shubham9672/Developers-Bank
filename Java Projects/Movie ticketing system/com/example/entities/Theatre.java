package com.example.entities;

public class Theatre {
    private int id;
    private String name;
    private int normalSeats;
    private int premiumSeats;
    private double baseSeatPrice;

    public Theatre(int id, String name, int normalSeats, int premiumSeats, double baseSeatPrice) {
        this.id = id;
        this.name = name;
        this.normalSeats = normalSeats;
        this.premiumSeats = premiumSeats;
        this.baseSeatPrice = baseSeatPrice;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getNormalSeats() {
        return normalSeats;
    }

    public int getPremiumSeats() {
        return premiumSeats;
    }

    public double getBaseSeatPrice() {
        return baseSeatPrice;
    }
}

