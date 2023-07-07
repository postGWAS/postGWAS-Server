package com.example.demo.dto;

import java.util.Map;

public class CaviarBFChartData {
    /**
     * 输出文件myﬁle.bf.prior0.rsid.marginal为绘图的源数据集
     */
    private Map<String, Object>[] caviarbfArray;

    public Map<String, Object>[] getCaviarbfArray() { return caviarbfArray; }
    public void setCaviarbfArray(Map<String, Object>[] value) { this.caviarbfArray = value; }
}
