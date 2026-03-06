package egovframework.com.security.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.com.security.vo.CustomUser;
import egovframework.com.security.vo.Role;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface CustomUserMapper {
	public CustomUser selectUserDetail(String username);
	public List<Role> selectUserRole(String username);
	public List<HashMap<String, Object>> selectUserMacAddress(String user_id);
}
