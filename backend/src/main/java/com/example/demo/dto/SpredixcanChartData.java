package com.example.demo.dto;

import java.util.Map;

public class SpredixcanChartData {
    /**
     * 输出文件result.csv
     */
    private Map<String, Object>[] resultArray;

    public Map<String, Object>[] getResultArray() { return resultArray; }
    public void setResultArray(Map<String, Object>[] value) { this.resultArray = value; }
}
