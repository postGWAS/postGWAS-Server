package com.example.demo.dto;

import java.util.Map;

public class PaintorChartData {
    /**
     * 以locus.results作为数据源
     */
    private Map<String, Object>[] locusResults;

    public Map<String, Object>[] getLocusResults() { return locusResults; }
    public void setLocusResults(Map<String, Object>[] value) { this.locusResults = value; }
}
