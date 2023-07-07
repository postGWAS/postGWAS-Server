package com.example.demo.controller;

import com.example.demo.dto.ColocRequest;
import com.example.demo.dto.FusionRequest;
import com.example.demo.dto.JobData;
import com.example.demo.dto.JobResponse;
import com.example.demo.mapper.JobMapper;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.service.FusionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
public class FusionController {
    @Autowired
    UserFileMapper userfileMapper;

    @Autowired
    JobMapper jobMapper;

    @Autowired
    FusionService fusionService;

    @PostMapping("/api/v1/twas/fusion")
    public JobResponse runColoc(@RequestBody FusionRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            System.out.println(gwas_path);
            fusionService.fusion(gwas_path, request.getTissue(), request.getZscore(), request.getRsid(),
                    request.getA1(), request.getA2(), request.getChr(), request.getModel(),
                    request.getThreshold(), jobid, request.getEmail());

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("FUSION failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("FUSION success");
        return response;
    }
}
