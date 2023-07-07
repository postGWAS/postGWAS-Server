package com.example.demo.service;

import com.example.demo.dto.CaviarChartData;
import com.example.demo.dto.SpredixcanChartData;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

@Service
public class SpredixcanChartService {
    @Autowired
    JobMapper jobMapper;
    @Autowired
    SplitDataService service;
    public SpredixcanChartData getSpredixcanChartData(String dir) throws FileNotFoundException {
        SpredixcanChartData data = new SpredixcanChartData();
        String result_path = dir + "result.out";
        data.setResultArray(service.splitData(result_path));

        return data;
    }
}
