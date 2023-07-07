package com.example.demo.controller;

import com.example.demo.dto.CaviarRequest;
import com.example.demo.dto.JobData;
import com.example.demo.dto.JobResponse;
import com.example.demo.mapper.JobMapper;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.service.CaviarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
public class CaviarController {
    @Autowired
    UserFileMapper userfileMapper;

    @Autowired
    JobMapper jobMapper;

    @Autowired
    CaviarService caviarService;

    @PostMapping("/api/v1/finemapping/caviar")
    public JobResponse runCaviar(@RequestBody CaviarRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            String ld_path = userfileMapper.selectByID(request.getFiles().getLd()).getFile_path();
            System.out.println(gwas_path +" "+ ld_path);
            caviarService.caviar(gwas_path, ld_path, request.getZscore(), request.getRsid(),
                    request.getArgs().getC(), jobid, request.getEmail());

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("CAVIAR failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("CAVIAR success");
        return response;
    }
}
