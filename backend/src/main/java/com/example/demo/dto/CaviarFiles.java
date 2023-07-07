package com.example.demo.dto;

public class CaviarFiles {
    /**
     * GWAS输入文件
     */
    private String gwas;
    /**
     * LD输入矩阵文件
     */
    private String ld;

    public String getGwas() { return gwas; }
    public void setGwas(String value) { this.gwas = value; }

    public String getLd() { return ld; }
    public void setLd(String value) { this.ld = value; }
}
