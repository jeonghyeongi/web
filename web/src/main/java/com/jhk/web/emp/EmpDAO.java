package com.jhk.web.emp;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class EmpDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public List<EmpVO> selectJob(String ename){
		return sqlSession.selectList("emp.selectJob", ename);
	}
	
	public List<EmpVO> selectDname(){
		return sqlSession.selectList("emp.selectDname");
	}
	
	public int updateDname(EmpVO vo) {
		return sqlSession.update("emp.updateDname", vo);
	}
}
