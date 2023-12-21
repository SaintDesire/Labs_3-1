package com.example.Lab_3.controllers;

import com.example.Lab_3.models.User;
import com.example.Lab_3.models.enums.Role;
import com.example.Lab_3.services.UserService;
import io.swagger.annotations.Api;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.security.Principal;
import java.util.Map;
import java.util.Set;

@RestController
@PreAuthorize("hasAuthority('ROLE_ADMIN')")
public class AdminController {
    @Autowired
    private UserService userService;

    @GetMapping("/admin")
    public ModelAndView admin(Model model, Principal principal) {
        ModelAndView modelAndView = new ModelAndView();
        model.addAttribute("users", userService.list());
        model.addAttribute("user", userService.getUserByPrincipal(principal));
        modelAndView.setViewName("admin");
        return modelAndView;
    }

    @PostMapping("/admin/user/ban/{id}")
    public ModelAndView userBan(@PathVariable("id") Long id) {
        ModelAndView modelAndView = new ModelAndView();
        userService.banUser(id);
        modelAndView.setViewName("redirect:/admin");
       return modelAndView;
    }

    @GetMapping("/admin/user/edit/{user}")
    public ModelAndView userEdit(@PathVariable("user") User user, Model model, Principal principal) {
        ModelAndView modelAndView = new ModelAndView();
        model.addAttribute("user", user);
        model.addAttribute("roles", Role.values());
        modelAndView.setViewName("user-edit");
        return modelAndView;
    }

    @PostMapping("/admin/user/edit")
    public  ModelAndView userEdit(@RequestParam("userId") User user, @RequestParam(name = "roles", required = false) Set<Role> role, @RequestParam Map<String, String> form) {
        ModelAndView modelAndView = new ModelAndView();
        userService.changeUserRoles(user, role);
        modelAndView.setViewName( "redirect:/admin");
        return modelAndView;
    }
}
