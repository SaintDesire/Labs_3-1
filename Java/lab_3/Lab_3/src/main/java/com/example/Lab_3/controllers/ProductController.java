package com.example.Lab_3.controllers;

import com.example.Lab_3.exceptions.NotFound;
import com.example.Lab_3.models.Order;
import com.example.Lab_3.models.Product;
import com.example.Lab_3.models.User;
import com.example.Lab_3.services.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.data.domain.Sort;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.io.IOException;
import java.security.Principal;

@Controller
public class ProductController {
    @Autowired
    private ProductService productService;

    @GetMapping("/")
    public ModelAndView products(@RequestParam(name = "searchWord", required = false) String title, @RequestParam(name = "searchType", required = false) String type, Principal principal, Model model, @PageableDefault(sort = { "id" }, direction = Sort.Direction.DESC) Pageable pageable) {
        ModelAndView modelAndView = new ModelAndView();
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        model.addAttribute("products", productService.listProducts(title, type, pageable));
        model.addAttribute("url", "/");
        model.addAttribute("searchWord", title);
        model.addAttribute("searchType", type);
        modelAndView.setViewName("products");
        return modelAndView;
    }

    @GetMapping("/product/{id}")
    public ModelAndView productInfo(@PathVariable Long id, Model model, Principal principal) throws NotFound {
        ModelAndView modelAndView = new ModelAndView();
        Product product = productService.getProductById(id);
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        model.addAttribute("product", product);
        model.addAttribute("images", product.getImages());
        model.addAttribute("authorProduct", product.getUser());
        modelAndView.setViewName("product-info");
        return modelAndView;
    }

    @PostMapping("/product/create")
    public String createProduct(@RequestParam("file1") MultipartFile file1, @RequestParam("file2") MultipartFile file2,
                                @RequestParam("file3") MultipartFile file3,Product product, Principal principal, Model model) throws IOException {
        productService.saveProduct(principal, product, file1, file2, file3);
        return "redirect:/my/products";
    }

    @PostMapping("/product/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return "redirect:/my/products";
    }
    @PostMapping("/product/addtocart/{id}")
    public String addtocartProduct(@PathVariable Long id, Principal principal,Order order) throws IOException {
        productService.addtoorder(order, id, principal);
        return "redirect:/";
    }
    @GetMapping("/my/products")
    public String userProducts(Principal principal, Model model) {
        User user = productService.getUserByPrincipal(principal);
        model.addAttribute("user", user);
        model.addAttribute("products", productService.listProductsforall());
        return  "my-products";
    }
}
