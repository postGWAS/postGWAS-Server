package com.example.demo.service;

import com.example.demo.dto.FinemapChartData;
import com.example.demo.dto.FusionChartData;
import com.example.demo.dto.ResultDownloadFile;
import com.example.demo.entity.Job;
import com.example.demo.entity.ResultFile;
import com.example.demo.mapper.JobMapper;
import com.example.demo.mapper.ResultFileMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FusionChartService {

    @Autowired
    JobMapper jobMapper;
    @Autowired
    ResultFileMapper resultFileMapper;

    public FusionChartData getFusionChartData(String jobid) {
        Job job = jobMapper.selectByJobid(jobid);
        List<ResultFile> allFiles = resultFileMapper.selectAll();
        FusionChartData fusionChartData = new FusionChartData();
        String[] previewUrl = new String[1024];
        long size = 0;
        for(int i = 0; i < allFiles.size(); i ++){
            ResultFile file = allFiles.get(i);
            if(file.getJobid().equals(jobid) && file.getFilename().substring(file.getFilename().length() - 3)
                    .equals("pdf")){
                previewUrl[(int)size] = "http://biographml.com/g2gdemo/api/v1/result/previewFile?fileId=" + file.getFileid();
                size ++;
            }
        }
        String[] previewUrl1 = new String[(int)size];
        for(int i = 0; i < size; i ++){
            previewUrl1[i] = previewUrl[i];
        }
        fusionChartData.setPreviewUrl(previewUrl1);
        fusionChartData.setSize(size);
        return fusionChartData;
    }

}
