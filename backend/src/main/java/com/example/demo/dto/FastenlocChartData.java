package com.example.demo.dto;

import java.util.Map;

public class FastenlocChartData {
    /**
     * .enloc.gene.out输出文件数据
     */
    private Map<String, Object>[] geneArray;
    /**
     * .enloc.gene.extract.out输出文件数据
     */
    private Map<String, Object>[] geneExtractArray;
    /**
     * .enloc.gene.extract.out的文件名
     */
    private String geneExtractName;
    /**
     * .enloc.gene.out的文件名
     */
    private String geneName;
    /**
     * .enloc.sig.out输出文件数据
     */
    private Map<String, Object>[] sigArray;
    /**
     * .enloc.sig.extract.out输出文件数据
     */
    private Map<String, Object>[] sigExtractArray;
    /**
     * .enloc.sig.extract.out的文件名
     */
    private String sigExtractName;
    /**
     * .enloc.sig.out的文件名
     */
    private String sigName;

    public Map<String, Object>[] getGeneArray() { return geneArray; }
    public void setGeneArray(Map<String, Object>[] value) { this.geneArray = value; }

    public Map<String, Object>[] getGeneExtractArray() { return geneExtractArray; }
    public void setGeneExtractArray(Map<String, Object>[] value) { this.geneExtractArray = value; }

    public String getGeneExtractName() { return geneExtractName; }
    public void setGeneExtractName(String value) { this.geneExtractName = value; }

    public String getGeneName() { return geneName; }
    public void setGeneName(String value) { this.geneName = value; }

    public Map<String, Object>[] getSigArray() { return sigArray; }
    public void setSigArray(Map<String, Object>[] value) { this.sigArray = value; }

    public Map<String, Object>[] getSigExtractArray() { return sigExtractArray; }
    public void setSigExtractArray(Map<String, Object>[] value) { this.sigExtractArray = value; }

    public String getSigExtractName() { return sigExtractName; }
    public void setSigExtractName(String value) { this.sigExtractName = value; }

    public String getSigName() { return sigName; }
    public void setSigName(String value) { this.sigName = value; }
}
