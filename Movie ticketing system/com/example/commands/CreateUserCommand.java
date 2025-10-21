package com.example.commands;

import com.example.entities.User;
import com.example.repo.UserRepository;
import com.example.utils.IdGenerator;

public class CreateUserCommand implements Command {
    private UserRepository userRepository;
    private String userName;

    public CreateUserCommand(UserRepository userRepository, String userName) {
        this.userRepository = userRepository;
        this.userName = userName;
    }

    @Override
    public void execute() {
        if (userRepository.findByName(userName) != null) {
            System.out.println("Error: User '" + userName + "' already exists.");
            return;
        }
        int id = IdGenerator.getInstance().getNextId("User");
        User user = new User(id, userName);
        userRepository.save(user);
        System.out.println("User created successfully! User ID: " + id + ", Name: " + userName);
    }
}
