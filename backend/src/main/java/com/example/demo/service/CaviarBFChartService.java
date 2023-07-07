package com.example.demo.service;

import com.example.demo.dto.CaviarBFChartData;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

@Service
public class CaviarBFChartService {
    @Autowired
    JobMapper jobMapper;
    public CaviarBFChartData getCaviarBFChartData(String dir) throws FileNotFoundException {
        CaviarBFChartData data = new CaviarBFChartData();
        String result_path = dir + "myfile.bf.prior0.rsid.marginal";
        // 读取文件
        File resultFile = new File(result_path);
        Scanner resultScanner = new Scanner(resultFile);
        // 分割文件第一行的key值
        String[] resultParameters = resultScanner.nextLine().split("\\s+");
        System.out.println(resultParameters.length + " " + Arrays.toString(resultParameters));

        // 将数据封装
        List<Map<String, String>> resultList = new ArrayList<>();
        while (resultScanner.hasNextLine()) {
            Map<String, String> map = new HashMap<>();
            String[] vals = resultScanner.nextLine().split("\\s+");
            for (int i = 0; i < resultParameters.length; i++) {
                map.put(resultParameters[i], vals[i]);
            }
            resultList.add(map);
        }
        Map<String, Object>[] resultMap = new HashMap[resultList.size()];
        int resulti = 0;
        for (Map<String, String> Results : resultList) {
            Map<String, Object> objectMap = new HashMap<>();
            for (Map.Entry<String, String> entry : Results.entrySet()) {
                objectMap.put(entry.getKey(), entry.getValue());
            }
            resultMap[resulti++] = objectMap;
        }
        data.setCaviarbfArray(resultMap);

        return data;
    }
}
