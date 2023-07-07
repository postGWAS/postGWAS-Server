package com.example.demo.controller;

import com.example.demo.service.SendResultService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class test {
    @Autowired
    SendResultService sendResultService;
    @GetMapping("/test")
    public String test(){
        return "success";
    }
    @GetMapping("/email")
    public void email(){
        sendResultService.SendResultByEmail("realfrozen13@gmail.com", "123");
    }

}
