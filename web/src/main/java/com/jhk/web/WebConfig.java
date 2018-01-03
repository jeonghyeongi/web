package com.jhk.web;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.jhk.web.common.CommonInterceptor;

@Configuration
@EnableWebMvc
@ComponentScan
public class WebConfig extends WebMvcConfigurerAdapter{
	private int maxUploadSizeInMb = 10 * 1024 * 1024;
	
	@Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new 
        		InternalResourceViewResolver();
        viewResolver.setViewClass(JstlView.class);
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");
        return viewResolver;
    }
	
	/**
	 * 파일업로드 설정
	 * */
	@Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver cmr = new CommonsMultipartResolver();
        cmr.setMaxUploadSize(maxUploadSizeInMb * 2);
        cmr.setMaxUploadSizePerFile(maxUploadSizeInMb); //bytes
        return cmr;
    }
	
	/**
	 * 디폴트 뷰 설정
	 * */
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
	     registry.viewResolver(viewResolver());
	}
	
	/**
	 * json 사용 설정
	 * */
	@Bean
	public MappingJackson2JsonView jsonView(){
	    return new MappingJackson2JsonView();
	}
	
	/**
	 * 마이바티스 사용 설정
	 * */
	@Bean
	public SqlSessionFactory sqlSessionFactory
	(DataSource dataSource, ApplicationContext applicationContext) 
		   throws Exception{
       
       SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
       sessionFactory.setDataSource(dataSource);
       sessionFactory.setConfigLocation(
    		   applicationContext.getResource("classpath:mybatis/mybatis-config.xml"));
       
       return sessionFactory.getObject();
	}
	
	/*
    * 한글 필터
    * */
   @Bean
   public CharacterEncodingFilter characterEncodingFilter() {
       CharacterEncodingFilter characterEncodingFilter = 
    		   new CharacterEncodingFilter();
       characterEncodingFilter.setEncoding("UTF-8");
       characterEncodingFilter.setForceEncoding(true);
       return characterEncodingFilter;
   }
	
   /**
    * 인터셉터 설정
    * */
   
   @Override
   public void addInterceptors(InterceptorRegistry registry) {
       registry.addInterceptor(new CommonInterceptor())
               .addPathPatterns("/**");
   }
	
	
}
