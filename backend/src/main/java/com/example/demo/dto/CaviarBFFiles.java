package com.example.demo.dto;

public class CaviarBFFiles {
    /**
     * GWAS summary statistics（txt格式），无默认值。
     */
    private String gwas;
    /**
     * LD matrix（txt格式），无默认值。
     */
    private String ld;

    public String getGwas() { return gwas; }
    public void setGwas(String value) { this.gwas = value; }

    public String getLd() { return ld; }
    public void setLd(String value) { this.ld = value; }
}
