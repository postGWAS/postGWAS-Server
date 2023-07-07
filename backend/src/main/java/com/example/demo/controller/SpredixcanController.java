package com.example.demo.controller;

import com.example.demo.dto.*;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.mapper.JobMapper;
import com.example.demo.service.SpredixcanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
public class SpredixcanController {

    @Autowired
    UserFileMapper userfileMapper;

    @Autowired
    JobMapper jobMapper;

    @Autowired
    SpredixcanService spredixcanService;

    @PostMapping("/api/v1/twas/s-predixcan-mashr")
    public JobResponse runSpredixcanMashr(@RequestBody SpredixcanMashrRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            System.out.println(gwas_path);
            spredixcanService.spredixcanMashr(gwas_path, request.getTissue(), request.getZscore(), request.getRsid(),
                    request.getA1(), request.getA2(), request.getFlag(), request.getChr(), request.getPos(),
                    jobid, request.getEmail());

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("S-PrediXcan mashr failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("S-PrediXcan mashr success");
        return response;
    }

    @PostMapping("/api/v1/twas/s-predixcan-enet")
    public JobResponse runSpredixcanEnet(@RequestBody SpredixcanEnetRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            System.out.println(gwas_path);
            spredixcanService.spredixcanEnet(gwas_path, request.getTissue(), request.getZscore(), request.getRsid(),
                    request.getA1(), request.getA2(), jobid, request.getEmail());

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("S-PrediXcan Elastic net failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("S-PrediXcan Elastic net success");
        return response;
    }

}
