package com.example.demo.service;

import com.example.demo.dto.EcaviarChartData;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;

@Service
public class EcaviarChartService {

    @Autowired
    JobMapper jobMapper;

    @Autowired
    SplitDataService service;
    public EcaviarChartData getEcaviarChartData(String dir) throws FileNotFoundException {
        EcaviarChartData data = new EcaviarChartData();
        String log_1_set_sorted_path = dir + "log_1_set_sorted";
        String log_1_post_sorted_path = dir + "log_1_post_sorted";
        String log_2_set_sorted_path = dir + "log_2_set_sorted";
        String log_2_post_sorted_path = dir + "log_2_post_sorted";
        String log_col_sorted_path = dir + "log_col_sorted";
        data.setSet1Array(service.splitData(log_1_set_sorted_path));
        data.setPost1Array(service.splitData(log_1_post_sorted_path));
        data.setSet2Array(service.splitData(log_2_set_sorted_path));
        data.setPost2Array(service.splitData(log_2_post_sorted_path));
        data.setColArray(service.splitData(log_col_sorted_path));

        return data;
    }
}
