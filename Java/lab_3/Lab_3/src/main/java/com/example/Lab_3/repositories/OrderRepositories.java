package com.example.Lab_3.repositories;

import com.example.Lab_3.models.*;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepositories extends JpaRepository<Order, Long> {
    Order findByUserAndProduct(User user, Product Product);
    List<Order> findByUser(User user);
}
