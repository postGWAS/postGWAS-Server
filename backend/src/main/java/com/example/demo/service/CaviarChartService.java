package com.example.demo.service;

import com.example.demo.dto.CaviarChartData;
import com.example.demo.dto.FinemapChartData;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

@Service
public class CaviarChartService {
    @Autowired
    JobMapper jobMapper;
    public CaviarChartData getCaviarChartData(String dir) throws FileNotFoundException {
        CaviarChartData data = new CaviarChartData();
        String log_set_path = dir + "log_set_sorted";
        String log_post_path = dir + "log_post_sorted";
        // 读取文件
        File setFile = new File(log_set_path);
        Scanner setScanner = new Scanner(setFile);
        // 分割文件第一行的key值
        String[] setParameters = setScanner.nextLine().split("\\s+");
        System.out.println(setParameters.length + " " + Arrays.toString(setParameters));

        // 将数据封装
        List<Map<String, String>> setList = new ArrayList<>();
        while (setScanner.hasNextLine()) {
            Map<String, String> map = new HashMap<>();
            String[] vals = setScanner.nextLine().split("\\s+");
            for (int i = 0; i < setParameters.length; i++) {
                map.put(setParameters[i], vals[i]);
            }
            setList.add(map);
        }
        Map<String, Object>[] setMap = new HashMap[setList.size()];
        int seti = 0;
        for (Map<String, String> set : setList) {
            Map<String, Object> objectMap = new HashMap<>();
            for (Map.Entry<String, String> entry : set.entrySet()) {
                objectMap.put(entry.getKey(), entry.getValue());
            }
            setMap[seti++] = objectMap;
        }

        File postFile = new File(log_post_path);
        Scanner postScanner = new Scanner(postFile);
        // 分割文件第一行的key值
        String[] postParameters = postScanner.nextLine().split("\\s+");
        System.out.println(postParameters.length + " " + Arrays.toString(postParameters));

        // 将数据封装
        List<Map<String, String>> postList = new ArrayList<>();
        while (postScanner.hasNextLine()) {
            Map<String, String> map = new HashMap<>();
            String[] vals = postScanner.nextLine().split("\\s+");
            for (int i = 0; i < postParameters.length; i++) {
                map.put(postParameters[i], vals[i]);
            }
            postList.add(map);
        }
        Map<String, Object>[] postMap = new HashMap[postList.size()];
        int configi = 0;
        for (Map<String, String> config : postList) {
            Map<String, Object> objectMap = new HashMap<>();
            for (Map.Entry<String, String> entry : config.entrySet()) {
                objectMap.put(entry.getKey(), entry.getValue());
            }
            postMap[configi++] = objectMap;
        }
        data.setSetArray(setMap);
        data.setPostArray(postMap);

        return data;
    }
}
