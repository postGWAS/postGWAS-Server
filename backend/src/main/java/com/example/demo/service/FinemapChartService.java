package com.example.demo.service;

import com.example.demo.dto.FinemapChartData;
import com.example.demo.dto.FinemapChartResponse;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;
import java.util.*;
import java.io.File;

@Service
public class FinemapChartService {

    @Autowired
    JobMapper jobMapper;
    public FinemapChartData getFinemapChartData(String dir) throws FileNotFoundException {
        FinemapChartData data = new FinemapChartData();
        String snp_path = dir + "data.snp";
        String config_path = dir + "data.config";
        // 读取文件
        File snpFile = new File(snp_path);
        Scanner snpScanner = new Scanner(snpFile);
        // 分割文件第一行的key值
        String[] snpParameters = snpScanner.nextLine().split("\\s+");
        System.out.println(snpParameters.length + " " + Arrays.toString(snpParameters));

        // 将数据封装
        List<Map<String, String>> snpList = new ArrayList<>();
        while (snpScanner.hasNextLine()) {
            Map<String, String> map = new HashMap<>();
            String[] vals = snpScanner.nextLine().split("\\s+");
            for (int i = 0; i < snpParameters.length; i++) {
                map.put(snpParameters[i], vals[i]);
            }
            snpList.add(map);
        }
        Map<String, Object>[] snpMap = new HashMap[snpList.size()];
        int snpi = 0;
        for (Map<String, String> snp : snpList) {
            Map<String, Object> objectMap = new HashMap<>();
            for (Map.Entry<String, String> entry : snp.entrySet()) {
                objectMap.put(entry.getKey(), entry.getValue());
            }
            snpMap[snpi++] = objectMap;
        }

        File configFile = new File(config_path);
        Scanner configScanner = new Scanner(configFile);
        // 分割文件第一行的key值
        String[] configParameters = configScanner.nextLine().split("\\s+");
        System.out.println(configParameters.length + " " + Arrays.toString(configParameters));

        // 将数据封装
        List<Map<String, String>> configList = new ArrayList<>();
        while (configScanner.hasNextLine()) {
            Map<String, String> map = new HashMap<>();
            String[] vals = configScanner.nextLine().split("\\s+");
            for (int i = 0; i < configParameters.length; i++) {
                map.put(configParameters[i], vals[i]);
            }
            configList.add(map);
        }
        Map<String, Object>[] configMap = new HashMap[configList.size()];
        int configi = 0;
        for (Map<String, String> config : configList) {
            Map<String, Object> objectMap = new HashMap<>();
            for (Map.Entry<String, String> entry : config.entrySet()) {
                objectMap.put(entry.getKey(), entry.getValue());
            }
            configMap[configi++] = objectMap;
        }
        data.setFinemapSnp(snpMap);
        data.setFinemapConfig(configMap);

        return data;
    }
}
