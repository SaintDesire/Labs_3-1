package com.example.Lab_3.controllers;

import com.example.Lab_3.models.Order;
import com.example.Lab_3.models.User;
import com.example.Lab_3.repositories.OrderRepositories;
import com.example.Lab_3.services.EmailSenderService;
import com.example.Lab_3.services.OrderService;
import com.example.Lab_3.services.ProductService;
import com.example.Lab_3.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@Controller
public class OrderController {
    @Autowired
    private EmailSenderService senderService;
    @Autowired
    private  UserService userService;
    @Autowired
    private  ProductService productService;
    @Autowired
    private  OrderService orderService;
    @Autowired
    private OrderRepositories orderRepositories;
    @GetMapping("/cart")
    public String cart(Model model, Principal principal) {
        User user=productService.getUserByPrincipal(principal);
        List<Order> orders=orderRepositories.findByUser(user);
        model.addAttribute("user", user);
        model.addAttribute("orders", orders);
        if(orders.size()!=0)
        {
            model.addAttribute("button", orders);
        }
        return "cart";
    }
    @PostMapping("/cart/delete/{id}")
    public String deleteOrder(@PathVariable Long id) {
        orderRepositories.deleteById(id);
        return "redirect:/cart";
    }
    @PostMapping("/cart/deletecount/{id}")
    public String deletecountOrder(@PathVariable Long id) {
            orderService.deletecount(id);
        return "redirect:/cart";
    }
    @PostMapping("/cart/addcount/{id}")
    public String addcountOrder(@PathVariable Long id) {
        orderService.addcount(id);
        return "redirect:/cart";
    }
    @GetMapping("/cart/createorders")
    public String createorder(Model model, Principal principal) {
        User user=productService.getUserByPrincipal(principal);
        String body = "";
        List<Order> orders=orderRepositories.findByUser(user);
        for (Order order: orders) {
            body=body+order.getProduct().getTitle()+" "+" количество: "+order.getCount()+";\n";
            Long id=order.getId();
            orderRepositories.deleteById(id);
        }
        senderService.sendSimpleEmail(user.getEmail(),
                "Спасибо за заказ!",
                "Ваш заказ успешно оформлен !\n" +
                        "Ваши позиции:\n" + body);
        return "redirect:/cart";
    }
}