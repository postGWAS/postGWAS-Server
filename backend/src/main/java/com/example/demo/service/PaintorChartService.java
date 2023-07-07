package com.example.demo.service;

import com.example.demo.dto.FinemapChartData;
import com.example.demo.dto.PaintorChartData;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

@Service
public class PaintorChartService {
    @Autowired
    JobMapper jobMapper;
    public PaintorChartData getPaintorChartData(String dir) throws FileNotFoundException {
        PaintorChartData data = new PaintorChartData();
        String locusResults_path = dir + "locus.results";
        // 读取文件
        File locusResultsFile = new File(locusResults_path);
        Scanner locusResultsScanner = new Scanner(locusResultsFile);
        // 分割文件第一行的key值
        String[] locusResultsParameters = locusResultsScanner.nextLine().split("\\s+");
        System.out.println(locusResultsParameters.length + " " + Arrays.toString(locusResultsParameters));

        // 将数据封装
        List<Map<String, String>> locusResultsList = new ArrayList<>();
        while (locusResultsScanner.hasNextLine()) {
            Map<String, String> map = new HashMap<>();
            String[] vals = locusResultsScanner.nextLine().split("\\s+");
            for (int i = 0; i < locusResultsParameters.length; i++) {
                map.put(locusResultsParameters[i], vals[i]);
            }
            locusResultsList.add(map);
        }
        Map<String, Object>[] locusResultsMap = new HashMap[locusResultsList.size()];
        int locusResultsi = 0;
        for (Map<String, String> locusResults : locusResultsList) {
            Map<String, Object> objectMap = new HashMap<>();
            for (Map.Entry<String, String> entry : locusResults.entrySet()) {
                objectMap.put(entry.getKey(), entry.getValue());
            }
            locusResultsMap[locusResultsi++] = objectMap;
        }
        data.setLocusResults(locusResultsMap);

        return data;
    }
}
