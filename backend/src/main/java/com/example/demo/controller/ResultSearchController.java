package com.example.demo.controller;

import com.example.demo.dto.ResultData;
import com.example.demo.dto.ResultResponse;
import com.example.demo.entity.Job;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ResultSearchController {
    @Autowired
    JobMapper jobMapper;

    @GetMapping("/api/v1/result/jobInfo")
    public ResultResponse getJobInfo(@RequestParam("jobId") String jobId) {
        ResultResponse response = new ResultResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            ResultData data = new ResultData();
            data.setJobId(jobId);
            data.setJobType(job.gettype());
            data.setJobStatus(job.getStatus());
            data.setJobCreateTime(job.getCreate_time());
            if(job.getFinish_time() == null) {
                data.setJobFinishTime("");
            }
            else {
                data.setJobFinishTime(job.getFinish_time());
            }
            data.setJobDownload("biographml.com/g2gdemo/api/v1/result/downloadAllFiles?jobId=" + jobId);
            data.setJobDisplay("");
            response.setCode(200);
            response.setData(data);
            response.setMessage("success");
        } catch (Exception e){
            response.setCode(400);
            response.setMessage("failed");
        }
        return response;
    }

}
