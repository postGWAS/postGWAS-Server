package com.example.demo.controller;

import com.example.demo.dto.ColocRequest;
import com.example.demo.dto.JobData;
import com.example.demo.dto.JobResponse;
import com.example.demo.entity.Coloc;
import com.example.demo.mapper.ColocMapper;
import com.example.demo.mapper.JobMapper;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.service.ColocService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
public class ColocController {
    @Autowired
    UserFileMapper userfileMapper;

    @Autowired
    JobMapper jobMapper;

    @Autowired
    ColocMapper colocMapper;

    @Autowired
    ColocService colocService;

    @PostMapping("/api/v1/colocalization/coloc")
    public JobResponse runColoc(@RequestBody ColocRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            String eqtl_path = "";
            if(request.getFiles().getEqtl() != null){
                eqtl_path = userfileMapper.selectByID(request.getFiles().getEqtl()).getFile_path();
            }
            System.out.println(gwas_path +" "+ eqtl_path);
            colocService.coloc(gwas_path, eqtl_path, request.getNgwas(), request.getNeqtl(),
                    request.getRsid(), request.getBeta(), request.getPval(), request.getVarbeta(),
                    request.getErsid(), request.getEpval(), request.getEmaf(), request.getGeneId(),
                    request.getThreshold(), request.getFlag(), request.getTissue(), jobid, request.getEmail());
            Coloc coloc = new Coloc();
            coloc.setJobid(jobid);
            coloc.setThreshold(String.valueOf(request.getThreshold()));
            colocMapper.insert(coloc);

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("COLOC failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("COLOC success");
        return response;
    }
}
