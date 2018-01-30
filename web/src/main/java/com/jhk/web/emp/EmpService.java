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
	
	public List<EmpVO> selectDname(EmpSVO svo){
		return dao.selectDname(svo);
	}
	
	
	public int updateDname(EmpVO vo) {
		return dao.updateDname(vo);
	}
	
	public int insertApply(ApplyVO vo) {
		return dao.insertApply(vo);
	}
	
	public List<EmpVO> selectTotalSal(){
		return dao.selectTotalSal();
	}
	
	
	
	
	
	
	
}
