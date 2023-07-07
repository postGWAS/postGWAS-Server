package com.example.demo.dto;

import java.util.Map;

public class CaviarChartData {
    /**
     * 输出文件log_post_sorted
     */
    private Map<String, Object>[] postArray;
    /**
     * 输出文件log_set_sorted
     */
    private Map<String, Object>[] setArray;

    public Map<String, Object>[] getPostArray() { return postArray; }
    public void setPostArray(Map<String, Object>[] value) { this.postArray = value; }

    public Map<String, Object>[] getSetArray() { return setArray; }
    public void setSetArray(Map<String, Object>[] value) { this.setArray = value; }
}
