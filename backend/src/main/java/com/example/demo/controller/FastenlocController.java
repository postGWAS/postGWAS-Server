package com.example.demo.controller;

import com.example.demo.dto.ColocRequest;
import com.example.demo.dto.FastenlocRequest;
import com.example.demo.dto.JobData;
import com.example.demo.dto.JobResponse;
import com.example.demo.entity.Fastenloc;
import com.example.demo.mapper.FastenlocMapper;
import com.example.demo.mapper.JobMapper;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.service.FastenlocChartService;
import com.example.demo.service.FastenlocService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
public class FastenlocController {
    @Autowired
    UserFileMapper userfileMapper;

    @Autowired
    JobMapper jobMapper;

    @Autowired
    FastenlocService fastenlocService;

    @Autowired
    FastenlocMapper fastenlocMapper;

    @PostMapping("/api/v1/colocalization/fastenloc")
    public JobResponse runFastenloc(@RequestBody FastenlocRequest request){
        JobResponse response = new JobResponse();
        JobData data = new JobData();
        String jobid = UUID.randomUUID().toString().replace("-" ,"");
        try {
            String gwas_path = userfileMapper.selectByID(request.getFiles().getGwas()).getFile_path();
            fastenlocService.fastenloc(gwas_path, request.getFlag(), request.getTissue(),
                    request.getZscore(), request.getPrefix(), request.getLocid(), request.getNgwas(),
                    request.getRcp(), request.getGrcp(), request.getGlcp(), request.getidType(),
                    request.getidValue(), jobid, request.getEmail());
            Fastenloc fastenloc = new Fastenloc();
            fastenloc.setJobid(jobid);
            fastenloc.setPrefix(request.getPrefix());
            fastenlocMapper.insert(fastenloc);

        } catch(NullPointerException e) {
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("fastENLOC failed");
            return response;
        }
        data.setJobId(jobid);
        response.setCode(200);
        response.setData(data);
        response.setMessage("fastENLOC success");
        return response;
    }
}
