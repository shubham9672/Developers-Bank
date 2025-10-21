package com.example.services;

import com.example.commands.Command;
import com.example.commands.CreateUserCommand;
import com.example.repo.UserRepository;

public class MovieTicketPlatformService {
    private UserRepository userRepository;

    public MovieTicketPlatformService() {
        this.userRepository = new UserRepository();
    }
        

    public void executeCommand(String commandStr) {
        String[] parts = commandStr.trim().split("\\s+");
        if (parts.length == 0)
            return;

        try {
            Command command = null;

            switch (parts[0]) {
                case "CreateUser":
                    if (parts.length < 2) {
                        System.out.println("Usage: CreateUser <user_name>");
                        return;
                    }
                    command = new CreateUserCommand(userRepository, parts[1]);
                    break;

                default:
                    System.out.println("Unknown command: " + parts[0]);
                    return;
            }

            if (command != null) {
                command.execute();
            }

        } catch (Exception e) {
            System.out.println("Error executing command: " + e.getMessage());
        }
        System.out.println();
    }
}
