package com.example.demo.dto;

public class FusionChartData {
    /**
     * result.top.analysis.loc_1.pdf文件的preview预览地址
     */
    private String[] previewUrl;
    /**
     * 链接数量
     */
    private long size;

    public String[] getPreviewUrl() { return previewUrl; }
    public void setPreviewUrl(String[] value) { this.previewUrl = value; }

    public long getSize() { return size; }
    public void setSize(long value) { this.size = value; }
}
