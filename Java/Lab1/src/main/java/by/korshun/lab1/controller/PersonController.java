package by.korshun.lab1.controller;
import by.korshun.lab1.forms.PersonForm;
import by.korshun.lab1.model.Person;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@Controller
public class PersonController {
    private static List<Person> people = new ArrayList<Person>();

    static {
        people.add(new Person("Kate", 24));
        people.add(new Person("Alex", 22));
    }

    // Вводится (inject) из application.properties.
    @Value("${welcome.message}")
    private String message;

    @Value("${error.message}")
    private String errorMessage;

    @GetMapping(value = {"/", "/index"})
    public ModelAndView index(Model model) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("index");
        model.addAttribute("message", message);

        return modelAndView;
    }

    @GetMapping(value = {"/allpeople"})
    public ModelAndView personList(Model model) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("personlist");
        model.addAttribute("people", people);
        return modelAndView;
    }

    @GetMapping(value = {"/addperson"})
    public  ModelAndView showAddPersonPage(Model model) {
        ModelAndView modelAndView = new ModelAndView("addperson");
        PersonForm personForm = new PersonForm();
        model.addAttribute("personform", personForm);

        return modelAndView;
    }

    @PostMapping(value = {"/addperson"})
    public ModelAndView savePerson(Model model, //
                                   @ModelAttribute("personform") PersonForm personForm) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("personlist");
        String name = personForm.getName();
        int age = personForm.getAge();

        if (name != null && name.length() > 0 && age > 0) {
            Person newPerson = new Person(name, age);
            people.add(newPerson);
            model.addAttribute("people",people);
            return modelAndView;
        }
        model.addAttribute("errorMessage", errorMessage);
        modelAndView.setViewName("addperson");
        return modelAndView;
    }

    @GetMapping(value = "/deleteperson/{index}")
    public ModelAndView deletePerson(Model model, @PathVariable int index) {
        ModelAndView modelAndView = new ModelAndView("redirect:/allpeople");
        if (index >= 0 && index < people.size()) {
            people.remove(index);
        }
        return modelAndView;
    }

    @GetMapping(value = "/editperson/{index}")
    public ModelAndView showEditPersonPage(Model model, @PathVariable int index) {
        ModelAndView modelAndView = new ModelAndView("editperson");
        if (index >= 0 && index < people.size()) {
            Person person = people.get(index);
            PersonForm personForm = new PersonForm();
            personForm.setName(person.getName());
            personForm.setAge(person.getAge());
            model.addAttribute("personform", personForm);
            model.addAttribute("index", index);
            return modelAndView;
        } else {
            return new ModelAndView("redirect:/allpeople");
        }
    }

    @PostMapping(value = "/editperson/{index}")
    public ModelAndView editPerson(Model model, @ModelAttribute("personform") PersonForm personForm, @PathVariable int index) {
        ModelAndView modelAndView = new ModelAndView("redirect:/allpeople");
        String name = personForm.getName();
        int age = personForm.getAge();

        if (index >= 0 && index < people.size() && name != null && name.length() > 0 && age > 0) {
            Person updatedPerson = new Person(name, age);
            people.set(index, updatedPerson);
        }

        return modelAndView;
    }


}
