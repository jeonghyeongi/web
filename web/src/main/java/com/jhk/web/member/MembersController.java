package com.jhk.web.member;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.jhk.web.common.FileVO;

@Controller
public class MembersController {
	
	@Autowired
	MembersService serivce;

	@GetMapping("/member/memberList")
	public String membersList(Model model) {
		List<MembersVO> list = serivce.selectMembersList();
		model.addAttribute("list", list);
		return "member/memberList";
	}
	
	//json 출력방법
	@GetMapping("/member/memberJsonList")
	public ModelAndView memberJsonList() {
		ModelAndView mav = new ModelAndView("jsonView");
		List<MembersVO> list = serivce.selectMembersList();
		mav.addObject("list", list);
		
		return mav;
	}
	
	
	@GetMapping("/member/memberJsonOne")
	public ModelAndView memberJsonOne(@ModelAttribute MembersVO paramVO) {
		ModelAndView mav = new ModelAndView("jsonView");
		MembersVO vo = serivce.selectMembersOne(paramVO);
		mav.addObject("member",vo);
		
		return mav;
	}
	
	@GetMapping("/member/name")
	@ResponseBody
	public String name(@RequestParam("id") String id){
		
		
		return id;
	} 
	
	@GetMapping("/fileForm")
	public String fileForm() {
		
		return "member/fileForm";
	}
	
	@PostMapping("/fileUpload")
	public String fileUpload(MultipartHttpServletRequest request, Model model) {
		MultipartFile file = request.getFile("file");
		try {
			byte[] bytes = file.getBytes();
            
            Path path = Paths.get("D:/eclipse_workspace/web.zip_expanded/web/src/main/resources/static/" + file.getOriginalFilename());
            Files.write(path, bytes);
		}catch(Exception e) {
			e.printStackTrace();
		}  
		
		
		//@ModelAttribute FileVO vo
		/*MultipartFile[] files = vo.getFile();
		for(int i = 0; i < files.length; i++) {
			if(files[i].isEmpty()) {
				continue;
			}
			
			try {
				byte[] bytes = files[i].getBytes();
	            
	            Path path = Paths.get("D:/eclipse_workspace/web.zip_expanded/web/src/main/resources/static/" + files[i].getOriginalFilename());
	            Files.write(path, bytes);
			}catch(Exception e) {
				e.printStackTrace();
			}   

		}*/
		
		model.addAttribute("msg", "file upload success");
		return "member/fileSuccess";
	}
	
	
	@GetMapping("/member/loginForm")
	public String loginForm() {
		return "member/loginForm";
	}
	
	//@RequestMapping(value="/member/procLogin", method = RequestMethod.POST)
	@PostMapping("/member/procLogin")
	public ModelAndView procLogin(@ModelAttribute MembersVO vo, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		int result = serivce.selectLogin(vo);
		if(result > 0) {
			session.setAttribute("id", vo.getmId());
			mav.addObject("result", "200");
			mav.addObject("desc", "login success");
		}else {
			mav.addObject("result", "101");
			mav.addObject("desc", "login fail");
		}
		return mav;
	}
	
	
	
}
