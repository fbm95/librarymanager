package com.example.books.controller;

import com.example.books.dao.DepartmentRepository;
import com.example.books.dto.Department;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class DepartmentController {

    @Autowired
    DepartmentRepository departmentRepository;

    @GetMapping("/dept")
    public String getAllDept() {
        List<Department> departmentList = departmentRepository.findAll();
        Gson gson = new Gson();
        String deptJson = gson.toJson(departmentList);

        return deptJson;
    }



}
