package com.example.demo.controller;

import com.example.demo.dto.ResultDownloadData;
import com.example.demo.dto.ResultDownloadFile;
import com.example.demo.dto.ResultDownloadResponse;
import com.example.demo.dto.ResultResponse;
import com.example.demo.entity.Job;
import com.example.demo.entity.ResultFile;
import com.example.demo.mapper.JobMapper;
import com.example.demo.mapper.ResultFileMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.io.File;
import java.util.List;

@RestController
public class ResultDownloadController {

    @Autowired
    JobMapper jobMapper;
    @Autowired
    ResultFileMapper resultFileMapper;
    @GetMapping("/api/v1/result/getResultFiles")
    public ResultDownloadResponse getResultFiles(@RequestParam("jobId") String jobId) {

        ResultDownloadResponse response = new ResultDownloadResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String test = job.getJobid();
            ResultDownloadData data = new ResultDownloadData();
            List<ResultFile> allFiles = resultFileMapper.selectAll();
            ResultDownloadFile[] temp = new ResultDownloadFile[1024];
            int total = 0;
            for(int i = 0; i < allFiles.size(); i ++){
                ResultFile file = allFiles.get(i);
                if(file.getJobid().equals(jobId)){
                    ResultDownloadFile downloadFile = new ResultDownloadFile();
                    downloadFile.setFileId(file.getFileid());
                    downloadFile.setFileName(file.getFilename());
                    downloadFile.setFilePreview("biographml.com/g2gdemo/api/v1/result/previewFile?fileId=" + file.getFileid());
                    downloadFile.setFileDownload("biographml.com/g2gdemo/api/v1/result/getSingleFile?fileId=" + file.getFileid());
                    temp[total] = downloadFile;
                    total ++;
                }
            }
            ResultDownloadFile[] jobFiles = new ResultDownloadFile[total];
            for(int i = 0; i < total; i ++){
                jobFiles[i] = temp[i];
            }
            data.setFiles(jobFiles);
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
