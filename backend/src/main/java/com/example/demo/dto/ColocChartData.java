package com.example.demo.dto;

import java.util.Map;

public class ColocChartData {
    /**
     * 输出文件result.txt
     */
    private Map<String, Object>[] resultArray;
    /**
     * 用户之前输入的门限值, 通常是0.95
     */
    private String threshold;

    public Map<String, Object>[] getResultArray() { return resultArray; }
    public void setResultArray(Map<String, Object>[] value) { this.resultArray = value; }

    public String getThreshold() { return threshold; }
    public void setThreshold(String value) { this.threshold = value; }
}
