package com.jhk.web;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class WebApplication extends SpringBootServletInitializer{
	
	@Override
    protected SpringApplicationBuilder configure(
    		SpringApplicationBuilder application) {
        return application.sources(WebApplication.class);
    }
	

	public static void main(String[] args) {
		SpringApplication.run(WebApplication.class, args);
	}
}
