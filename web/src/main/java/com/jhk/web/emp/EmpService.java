package com.jhk.web.emp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EmpService {
	
	@Autowired
	EmpDAO dao;

	public List<EmpVO> selectJob(String ename){
		return dao.selectJob(ename);
	}
	
	public List<EmpVO> selectDname(){
		return dao.selectDname();
	}
	
	
	public int updateDname(EmpVO vo) {
		return dao.updateDname(vo);
	}
}
