package egovframework.com.security;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import egovframework.com.security.mapper.CustomUserMapper;
import egovframework.com.security.vo.CustomUser;

@Service
public class CustomizeUserDetailService implements UserDetailsService{
	
	@Autowired
	private CustomUserMapper customUserMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		CustomUser user = customUserMapper.selectUserDetail(username);
		if(null != user) user.setAuthorities(customUserMapper.selectUserRole(username));
		return user;
	}
	
	public List<HashMap<String, Object>> selectUserMacAddress(String user_id) {
		return customUserMapper.selectUserMacAddress(user_id);
	}
}
