package com.jhk.web.emp;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.jhk.web.common.CommonCheck;

@Controller
public class EmpController {

	@Autowired
	EmpService service;
	
	@GetMapping("/emp/searchForm")
	public String searchForm() {
		return "emp/searchForm";
	}
	
	//@CommonCheck(isLogin="Y")
	@PostMapping("/emp/searchJob")
	public String searchJob(@RequestParam("ename") String ename, Model model) {
		List<EmpVO> list = service.selectJob(ename);
		model.addAttribute("jobList", list);
		return "emp/searchForm";
	}
	
	@GetMapping("/emp/dnameList")
	public ModelAndView dnameList(@ModelAttribute EmpSVO svo) {
		
		ModelAndView mav = new ModelAndView();
		List<EmpVO> list = service.selectDname(svo);
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
	
	
	@RequestMapping("/emp/searchEmp")
	public String searchEmp(Model model, @ModelAttribute EmpSVO svo) {
		List<EmpVO> list = service.selectDname(svo);
		model.addAttribute("list", list);
		return "emp/searchEmp";
	}
	
	@GetMapping("/emp/apply")
	public String apply() {
		
		return "emp/apply";
	}
	
	@PostMapping("/emp/procApply")
	@ResponseBody
	public String procApply(@ModelAttribute ApplyVO vo) {
		String result = "fail";
		
		//파일업로드 시작
		MultipartFile[] files = vo.getFile();
		for(int i = 0; i < files.length; i++) {
			if(files[i].isEmpty()) {
				continue;
			}
			
			try {
				byte[] bytes = files[i].getBytes();
				Path path = Paths.get("D:/eclipse_workspace/web.zip_expanded/web/src/main/resources/static/" 
										+ files[i].getOriginalFilename());
				vo.setUsrImg(files[i].getOriginalFilename());//이미지명 셋팅
	            Files.write(path, bytes); 
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		//파일업로드 끝
		service.insertApply(vo);
		result = "success";
		
		return result;
	}
	
	
	
	@GetMapping("/emp/selectTotalSal")
	public String selectTotalSal(Model model) {
		List<EmpVO> list = service.selectTotalSal();
		model.addAttribute("list",list);
		return "emp/selectTotalSal";
	}
	
	
	
	
	
}
