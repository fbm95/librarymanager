package com.example.books.dao;

import com.example.books.dto.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class DepartmentRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Department> findAll(){
        List<Department> result = jdbcTemplate.query(
                "SELECT deptno, dname, loc FROM dept",
                (rs, rowNum) -> new Department(rs.getInt("deptno"),
                        rs.getString("dname"),
                        rs.getString("loc"))
        );

        return result;
    }
}
