package com.jhk.web.member;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MembersDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public List<MembersVO> selectMembersList(){
		return sqlSession.selectList("members.selectList");
	}
	
	public MembersVO selectMembersOne(MembersVO vo) {
		return sqlSession.selectOne("members.selectMembersOne", vo);
	}
	
	public int selectLogin(MembersVO vo) {
		return sqlSession.selectOne("members.selectLogin", vo);
	}
	

}
