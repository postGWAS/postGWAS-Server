package com.example.demo.controller;

import com.example.demo.dto.*;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.mapper.JobMapper;
import com.example.demo.service.FinemapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
public class FinemapController {

    @Autowired
    UserFileMapper userfileMapper;

    @Autowired
    JobMapper jobMapper;

    @Autowired
    FinemapService finemapService;

    @PostMapping("/api/v1/finemapping/finemap")
    public JobResponse runFinemap(@RequestBody FinemapRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            String ld_path = userfileMapper.selectByID(request.getFiles().getLd()).getFile_path();
            System.out.println(gwas_path +" "+ ld_path);
            finemapService.finemap(gwas_path, ld_path, request.getBeta(), request.getRsid(), request.getChr(),
                    request.getPos(), request.getA1(), request.getA2(), request.getMaf(), request.getse(),
                    request.getNgwas(), request.getC(), jobid, request.getEmail());

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("FINEMAP failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("FINEMAP success");
        return response;
    }


}
