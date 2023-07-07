package com.example.demo.service;

import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

@Service
public class SplitDataService {
    public Map<String, Object>[] splitData(String filePath) throws FileNotFoundException {
        File resultFile = new File(filePath);
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
        return resultMap;
    }
}
