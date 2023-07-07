package com.example.demo.service;

import com.example.demo.dto.ColocChartData;
import com.example.demo.dto.EcaviarChartData;
import com.example.demo.mapper.ColocMapper;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;

@Service
public class ColocChartService {
    @Autowired
    JobMapper jobMapper;

    @Autowired
    ColocMapper colocMapper;
    @Autowired
    SplitDataService service;

    public ColocChartData getColocChartData(String jobid, String dir) throws FileNotFoundException {
        ColocChartData data = new ColocChartData();
        String result_path = dir + "result.txt";
        data.setResultArray(service.splitData(result_path));
        data.setThreshold(colocMapper.selectByJobid(jobid).getThreshold());
        return data;
    }
}
