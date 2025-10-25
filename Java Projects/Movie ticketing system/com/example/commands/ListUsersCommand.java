package com.example.commands;

import java.util.List;

import com.example.entities.User;
import com.example.repo.UserRepository;

public class ListUsersCommand implements Command {
    private UserRepository userRepository;

    public ListUsersCommand(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public void execute() {
        List<User> users = (List<User>) userRepository.findAll();
        if (users.isEmpty()) {
            System.out.println("No users found.");
            return;
        }
        System.out.println("Users:");
        for (User user : users) {
            System.out.println("  ID: " + user.getId() + " - " + user.getName());
        }
    }
    
}
