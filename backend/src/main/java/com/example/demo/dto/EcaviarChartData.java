package com.example.demo.dto;

import java.util.Map;

public class EcaviarChartData {
    /**
     * log_col_sorted
     */
    private Map<String, Object>[] colArray;
    /**
     * log_1_post_sorted
     */
    private Map<String, Object>[] post1Array;
    /**
     * log_2_post_sorted
     */
    private Map<String, Object>[] post2Array;
    /**
     * log_1_set_sorted
     */
    private Map<String, Object>[] set1Array;
    /**
     * log_2_set_sorted
     */
    private Map<String, Object>[] set2Array;

    public Map<String, Object>[] getColArray() { return colArray; }
    public void setColArray(Map<String, Object>[] value) { this.colArray = value; }

    public Map<String, Object>[] getPost1Array() { return post1Array; }
    public void setPost1Array(Map<String, Object>[] value) { this.post1Array = value; }

    public Map<String, Object>[] getPost2Array() { return post2Array; }
    public void setPost2Array(Map<String, Object>[] value) { this.post2Array = value; }

    public Map<String, Object>[] getSet1Array() { return set1Array; }
    public void setSet1Array(Map<String, Object>[] value) { this.set1Array = value; }

    public Map<String, Object>[] getSet2Array() { return set2Array; }
    public void setSet2Array(Map<String, Object>[] value) { this.set2Array = value; }
}
