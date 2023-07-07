package com.example.demo.dto;

public class CaviarBFRequest {
    /**
     * 邮箱地址
     */
    private String email;
    private CaviarBFFiles files;
    /**
     * specify the maximum number of causal variants，默认值为1。
     */
    private String maxCasual;
    /**
     * rs_id column name in GWAS summary statistics，默认值为rs_id。
     */
    private String rsid;
    /**
     * Zscore column name in GWAS summary statistics，默认值为zscore。
     */
    private String zscore;

    private String ng;

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public CaviarBFFiles getFiles() { return files; }
    public void setFiles(CaviarBFFiles value) { this.files = value; }

    public String getMaxCasual() { return maxCasual; }
    public void setMaxCasual(String value) { this.maxCasual = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }

    public String getNg() { return ng; }
    public void setNg(String value) { this.ng = value; }
}
