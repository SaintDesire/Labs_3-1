package com.example.Lab_3.controllers;


import com.example.Lab_3.models.User;
import com.example.Lab_3.services.UserService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/users")
public class UserRest {

    @Autowired
    private UserService userService;

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    List<User> getUsers(){
        return userService.list();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.OK)
    User saveUser(@RequestBody User user){
        userService. createUser(user);
        return user;
    }

}
