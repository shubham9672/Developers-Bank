package com.example.commands;

import com.example.entities.Theatre;
import com.example.repo.TheatreRepository;
import com.example.utils.IdGenerator;

public class AddTheatreCommand implements Command {
    private TheatreRepository theatreRepository;
    private String theatreName;
    private int normalSeats;
    private int premiumSeats;
    private double baseSeatPrice;

    public AddTheatreCommand(TheatreRepository theatreRepository, String theatreName,
            int normalSeats, int premiumSeats, double baseSeatPrice) {
        this.theatreRepository = theatreRepository;
        this.theatreName = theatreName;
        this.normalSeats = normalSeats;
        this.premiumSeats = premiumSeats;
        this.baseSeatPrice = baseSeatPrice;
    }

    @Override
    public void execute() {
        int id = IdGenerator.getInstance().getNextId("Theatre");
        Theatre theatre = new Theatre(id, theatreName, normalSeats, premiumSeats, baseSeatPrice);
        theatreRepository.save(theatre);
        System.out.println("Theatre added successfully! Theatre ID: " + id +
                ", Name: " + theatreName + ", Normal Seats: " + normalSeats +
                ", Premium Seats: " + premiumSeats + ", Base Price: " + baseSeatPrice);
    }
}
