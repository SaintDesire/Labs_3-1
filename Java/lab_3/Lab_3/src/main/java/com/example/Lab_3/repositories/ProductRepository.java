package com.example.Lab_3.repositories;

import com.example.Lab_3.models.Product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {
    Page<Product> findByTitle(String title, Pageable pageable);
    Page<Product> findByType(String type, Pageable pageable);
    Page<Product> findByTitleAndType(String title,String type, Pageable pageable);
    Page<Product> findAll( Pageable pageable);
    List<Product>findAll();
}
