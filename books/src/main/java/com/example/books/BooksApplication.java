package com.example.books;

import com.example.books.dao.DepartmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;

import javax.sql.DataSource;

@SpringBootApplication
public class BooksApplication extends SpringBootServletInitializer{

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application){
		return application.sources(BooksApplication.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(BooksApplication.class, args);
	}
}
