package com.example.Lab_3.services;

import com.example.Lab_3.exceptions.NotFound;
import com.example.Lab_3.models.*;
import com.example.Lab_3.repositories.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final OrderRepositories orderRepository;

    public Page<Product> listProducts(String title, String type, Pageable pageable) {
      if(title!=null&&type!=null){
        if (!title.equals("")){
            if(!type.equals("Категория"))
            {return productRepository.findByTitleAndType(title,type, pageable);}
            else
            {
                return productRepository.findByTitle(title,pageable);
            }
        }
      }
      if (type!=null)
        if (!type.equals("Категория"))return productRepository.findByType(type, pageable);
        return productRepository.findAll(pageable);
    }
    public List<Product> listProductsforall() {
        return productRepository.findAll();
    }
    public void saveProduct(Principal principal, Product product, MultipartFile file1, MultipartFile file2, MultipartFile file3) throws IOException {
        product.setUser(getUserByPrincipal(principal));
        Image image1;
        Image image2;
        Image image3;
        if (file1.getSize() != 0) {
            image1 = toImageEntity(file1);
            image1.setPreviewImage(true);
            product.addImageToProduct(image1);
        }
        if (file2.getSize() != 0) {
            image2 = toImageEntity(file2);
            product.addImageToProduct(image2);
        }
        if (file3.getSize() != 0) {
            image3 = toImageEntity(file3);
            product.addImageToProduct(image3);
        }
        log.info("Saving new Product. Title: {}; Author email: {}", product.getTitle(), product.getUser().getEmail());
        Product productFromDb = productRepository.save(product);
        productFromDb.setPreviewImageId(productFromDb.getImages().get(0).getId());
        productRepository.save(product);
    }
    public void addtoorder(Order order, Long product,  Principal principal) throws IOException {
        Long ID_order= order.getId();
        User user=getUserByPrincipal(principal);
        Product product1 = productRepository.findById(product)
                .orElse(null);
        Order order1=orderRepository.findByUserAndProduct(user, product1);
        if (order1==null){
        order.setUser(getUserByPrincipal(principal));

        order.setProduct(product1);
        order.setActive(true);
        order.setCount(1);
        orderRepository.save(order);
        }
        else
        {
            orderRepository.deleteById(order1.getId());

            order1.setCount(order1.getCount()+1);
            orderRepository.save(order1);
        }
    }
    public User getUserByPrincipal(Principal principal) {
        if (principal == null) return new User();
        return userRepository.findByEmail(principal.getName());
    }

    private Image toImageEntity(MultipartFile file) throws IOException {
        Image image = new Image();
        image.setName(file.getName());
        image.setOriginalFileName(file.getOriginalFilename());
        image.setContentType(file.getContentType());
        image.setSize(file.getSize());
        image.setBytes(file.getBytes());
        return image;
    }

    public void deleteProduct( Long id) {
        Product product = productRepository.findById(id)
                .orElse(null);
        if (product != null) {
                productRepository.delete(product);
            }
        }

    public Product getProductById(Long id) throws NotFound {

        return productRepository.findById(id).orElseThrow(()-> new NotFound());
    }
}
