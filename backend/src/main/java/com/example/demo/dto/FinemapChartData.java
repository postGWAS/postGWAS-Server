package com.example.demo.dto;
import java.util.Map;

public class FinemapChartData {
    /**
     * 以data.config作为数据源
     */
    private Map<String, Object>[] finemapConfig;
    /**
     * 以data.snp作为数据源
     */
    private Map<String, Object>[] finemapSnp;

    public Map<String, Object>[] getFinemapConfig() { return finemapConfig; }
    public void setFinemapConfig(Map<String, Object>[] value) { this.finemapConfig = value; }

    public Map<String, Object>[] getFinemapSnp() { return finemapSnp; }
    public void setFinemapSnp(Map<String, Object>[] value) { this.finemapSnp = value; }
}
