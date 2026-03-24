package egovframework.com.security;

import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import egovframework.com.Sha256Crypto;
import egovframework.com.security.vo.CustomUser;

public class CustomAuthenticationProvider implements AuthenticationProvider {

	@Autowired
	private CustomizeUserDetailService customizeUserDetailService;

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		String user_id = (String) authentication.getPrincipal();
		String user_pw = (String) authentication.getCredentials();
		CustomUser user = null;
		Collection<? extends GrantedAuthority> authorities = null;
		
		try {
			user = (CustomUser) customizeUserDetailService.loadUserByUsername(user_id);
			user_pw = (String) authentication.getCredentials();
			
			if(null == user)                         								throw new UsernameNotFoundException("아이디 또는 비밀번호가 일치하지 않습니다.");
			else if("Y".equals(user.getLockAt()) && "5".equals(user.getFailrCnt())) throw new LockedException("로그인 5회 이상 실패로 잠긴 계정입니다.\n시스템관리자에게 문의하시기 바랍니다.");
			else if("Y".equals(user.getLockAt()))          							throw new LockedException("장기 미사용(90일) 동안 사용하지 않았거나 관리자에 의해 접속이 차단되었습니다.\n시스템관리자에게 문의하시기 바랍니다.");
			else if (!Sha256Crypto.authenticate(user_pw, user.getUserPw())) 		throw new CredentialsExpiredException("아이디 또는 비밀번호가 일치하지 않습니다.");
			else if("N".equals(user.getUseYn()))          							throw new DisabledException("사용이 중지된 회원입니다.");
			
			authorities = user.getAuthorities();
			if(authorities.size() <=0)               								throw new BadCredentialsException("권한이 존재하지 않습니다.");
		
		} catch (CredentialsExpiredException  e) {
			throw new CredentialsExpiredException (e.getMessage());
		} catch (LockedException e) {
			throw new LockedException(e.getMessage());	
		} catch (DisabledException e) {
			throw new DisabledException(e.getMessage());		
		} catch (UsernameNotFoundException e) {
			throw new UsernameNotFoundException(e.getMessage());
		} catch (BadCredentialsException e) {
			throw new BadCredentialsException(e.getMessage());
		} catch (Exception e) {
			throw new RuntimeException(e.getMessage());
		}

		return new UsernamePasswordAuthenticationToken(user, user_pw, authorities);
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

}
