package com.example.demo.dto;

public class PaintorFiles {
    /**
     * 功能注释矩阵文件
     */
    private String annots;
    /**
     * GWAS输入文件
     */
    private String gwas;
    /**
     * LD输入矩阵文件
     */
    private String ld;

    public String getAnnots() { return annots; }
    public void setAnnots(String value) { this.annots = value; }

    public String getGwas() { return gwas; }
    public void setGwas(String value) { this.gwas = value; }

    public String getLd() { return ld; }
    public void setLd(String value) { this.ld = value; }
}
