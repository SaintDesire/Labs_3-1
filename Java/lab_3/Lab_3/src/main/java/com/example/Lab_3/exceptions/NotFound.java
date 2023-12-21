package com.example.Lab_3.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

public class NotFound extends Exception{
    public NotFound() {super("Resource not found ");}
    public NotFound(String substr) {
        super("Resource not found " + substr);
    }
    public NotFound(Long id) {
        super("Resource not found " + id);
    }
}
