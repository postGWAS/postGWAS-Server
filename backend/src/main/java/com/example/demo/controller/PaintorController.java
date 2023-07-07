package com.example.demo.controller;

import com.example.demo.dto.*;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.mapper.JobMapper;
import com.example.demo.service.PaintorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
public class PaintorController {

    @Autowired
    UserFileMapper userfileMapper;

    @Autowired
    JobMapper jobMapper;

    @Autowired
    PaintorService paintorService;

    @PostMapping("/api/v1/finemapping/paintor")
    public JobResponse runPaintor(@RequestBody PaintorRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            String ld_path = userfileMapper.selectByID(request.getFiles().getLd()).getFile_path();
            String annots_path = "";
            if(request.getFiles().getAnnots() != null){
                annots_path = userfileMapper.selectByID(request.getFiles().getAnnots()).getFile_path();
            }
            System.out.println(request);
            paintorService.paintor(gwas_path, ld_path, annots_path, request.getAnnotations(), request.getZscore(),
                    request.getRsid(), request.getArgs().getEnumerate(), request.getArgs().getMaxCasual(),
                    jobid, request.getEmail());

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("Paintor failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("Paintor success");
        return response;
    }


}
