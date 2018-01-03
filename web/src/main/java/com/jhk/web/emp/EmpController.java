package com.jhk.web.emp;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.jhk.web.common.CommonCheck;

@Controller
@CommonCheck(isLogin="Y")
public class EmpController {

	@Autowired
	EmpService service;
	
	@GetMapping("/emp/searchForm")
	public String searchForm() {
		return "emp/searchForm";
	}
	
	@CommonCheck(isLogin="Y")
	@PostMapping("/emp/searchJob")
	public String searchJob(@RequestParam("ename") String ename, Model model) {
		List<EmpVO> list = service.selectJob(ename);
		model.addAttribute("jobList", list);
		return "emp/searchForm";
	}
	
	@GetMapping("/emp/dnameList")
	public ModelAndView dnameList() {
		
		ModelAndView mav = new ModelAndView();
		List<EmpVO> list = service.selectDname();
		mav.addObject("list", list);
		mav.setViewName("emp/dnameList");	
		return mav;
		
		//Model model
		/*List<EmpVO> list = service.selectDname();
		model.addAttribute("list", list);
		return "emp/dnameList";*/
	}
	
	
	@PostMapping("/emp/updateDname")
	public String updateDname(@ModelAttribute EmpVO vo) {
			
		service.updateDname(vo);
		
		return "redirect:/emp/dnameList";
	}
	
	
	
	
	
	
	
	
	
	@GetMapping("/test")
	public String test() {
		
		//return "forward:/emp/dnameList";
		return "redirect:/emp/dnameList";
	}
	
	@GetMapping("/login")
	@ResponseBody
	public String login(){
		
		return "login!";
	}
	
	
}
