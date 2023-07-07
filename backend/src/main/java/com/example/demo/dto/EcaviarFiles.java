package com.example.demo.dto;

public class EcaviarFiles {
    /**
     * eQTL文件ID
     */
    private String eqtl;
    /**
     * eQTL LD矩阵ID
     */
    private String eqtlld;
    /**
     * GWAS文件ID
     */
    private String gwas;
    /**
     * GWAS LD矩阵文件ID
     */
    private String gwasld;

    public String getEqtl() { return eqtl; }
    public void setEqtl(String value) { this.eqtl = value; }

    public String getEqtlld() { return eqtlld; }
    public void setEqtlld(String value) { this.eqtlld = value; }

    public String getGwas() { return gwas; }
    public void setGwas(String value) { this.gwas = value; }

    public String getGwasld() { return gwasld; }
    public void setGwasld(String value) { this.gwasld = value; }
}
