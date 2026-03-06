package egovframework.ncts.mngr.edcOperMngr.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.com.SessionUtil;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.exception.ErrorExcetion;
import egovframework.com.security.vo.CustomUser;
import egovframework.com.vo.PageInfoVO;
import egovframework.com.vo.ProcType;
import egovframework.ncts.mngr.edcOperMngr.mapper.EgovNctsFrmatnEvlMapper;
import egovframework.ncts.mngr.edcOperMngr.service.EgovNctsFrmatnEvlService;
import egovframework.ncts.mngr.edcOperMngr.vo.MngrFrmatnEvlVO;

@Service
public class EgovNctsFrmatnEvlImpl<E> implements EgovNctsFrmatnEvlService{
    /** log */
    private static final Logger LOGGER = LoggerFactory.getLogger(EgovNctsFrmatnEvlImpl.class);
    
    @Autowired
    private EgovNctsFrmatnEvlMapper egovNctsFrmatnEvlMapper;
    
    @Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
    
    @Override
    public List<HashMap<String, Object>> selectFrmatnEvlList(PageInfoVO pageVO)throws Exception {
        int cnt = egovNctsFrmatnEvlMapper.selecFrmatnEvlCnt(pageVO);
        pageVO.setTotalRecordCount(cnt);
        
        return egovNctsFrmatnEvlMapper.selectFrmatnEvlList(pageVO);
    }
    
    public List<HashMap<String, Object>> selectLctreList(PageInfoVO pageVO)throws Exception{
        
        return egovNctsFrmatnEvlMapper.selectLctreList(pageVO);
    }
    
    @Override
    public List<HashMap<String, Object>> selectFrmatnEvlDetailList(MngrFrmatnEvlVO param)throws Exception{
        
        return egovNctsFrmatnEvlMapper.selectFrmatnEvlDetailList(param);
    }
    
    @Override
    public HashMap<String, Object> selectFrmatnEvlSeDetail(MngrFrmatnEvlVO param)throws Exception{
        HashMap<String, Object> result = egovNctsFrmatnEvlMapper.selectFrmatnEvlSeDetail(param);
        return result;
    }
     
    public void delEvl(MngrFrmatnEvlVO param)throws Exception{
        ProcType procType = ProcType.findByProcType(param.getProcType());
        
        if(ProcType.DELETE.equals(procType)){
        	egovNctsFrmatnEvlMapper.delEvlItem(param);
            egovNctsFrmatnEvlMapper.delEvl(param);
        } else {
        	throw new ErrorExcetion(egovMessageSource.getMessage("errors.proctype"));
        }
    }
    
    public void mngrProgressFrmatn(HttpServletRequest request, MngrFrmatnEvlVO param)throws Exception {
        ProcType procType = ProcType.findByProcType(param.getProcType());
        CustomUser user =  SessionUtil.getProperty(request);
        if(null != user) {
        	param.setFrstRegisterId(user.getUserId());
        	param.setLastUpdusrId(user.getUserId());
        }
        
        int examSqno = 0;
        int itemNo = 0;
        
        for(int i=0; i < param.getExamNoList().size(); i++){
            param.setExamNo(Integer.parseInt(param.getExamNoList().get(i)));
            
            param.setExamNm(checkNull(param.getExamNmList()).get(i));
            param.setExamTypeCd(checkNull(param.getExamTypeCdList()).get(i));
            param.setCorrectAnswer(checkNull(param.getCorrectAnswerList()).get(i));
            
            if(0 == param.getExamSqno()){
                examSqno = egovNctsFrmatnEvlMapper.selectExamSqno(param);
                param.setExamSqno(examSqno);
                examSqno = 0;
            }
            
            if(1 == param.getExamNoList().size()){
                param.setExamWransNote(combineArray(param.getExamWransNoteListSnapshot()));
                
                egovNctsFrmatnEvlMapper.frmatnInsertExamProc(param);
                
                String[] itemNm;
                String [] itemNoList;
                itemNm = combineArray(param.getItemNmList()).split("\\|");
                itemNoList = combineArray(param.getItemNoList()).split("\\|");
                
                for(int j=0; j<itemNm.length; j++){
                    param.setItemNm(itemNm[j]);
                    int itemListNo = Integer.parseInt(itemNoList[j]);
                    
                    if(0 < itemListNo){
                        itemNo = itemListNo; 
                    }else{
                        itemNo = egovNctsFrmatnEvlMapper.selectExamItemNo(param);
                    }
                    param.setItemNo(itemNo);
                    egovNctsFrmatnEvlMapper.frmatnInsertExamItemProc(param);
                }
                
                param.setExamSqno(0);
            }else{
                param.setExamWransNote(param.getExamWransNoteListSnapshot().get(i));
                
                egovNctsFrmatnEvlMapper.frmatnInsertExamProc(param);
                
                String[] itemNm;
                String [] itemNoList;
                itemNm = param.getItemNmList().get(i).split("\\|");
                itemNoList = combineArray(param.getItemNoList()).split("\\|");
                for(int j=0; j<itemNm.length; j++){
                    param.setItemNm(itemNm[j]);
                    int itemListNo = Integer.parseInt(itemNoList[j]);
                    if(0 < itemListNo){
                        itemNo = itemListNo; 
                    }else{
                        itemNo = egovNctsFrmatnEvlMapper.selectExamItemNo(param);
                    }
                    itemNo = egovNctsFrmatnEvlMapper.selectExamItemNo(param);
                    param.setItemNo(itemNo);
                    egovNctsFrmatnEvlMapper.frmatnInsertExamItemProc(param);
                }
                    
                param.setExamSqno(0);
            } 
        }
    }
    
    private ArrayList<String> checkNull(ArrayList<String> val){
        if(val != null && val.size() > 0){
            return val;
        }else{
            val = new ArrayList<String>();
            val.add(0, "");
            return val;
        }
    }
    
    private String combineArray(ArrayList<String> listVal){
        String returnText = "";
        
        for(int i = 0; i < listVal.size(); i++){
            if(0==i){
                returnText = listVal.get(i);
            }else{
                returnText += "," + listVal.get(i);
            }
        }
        
        return returnText;
    }
}
