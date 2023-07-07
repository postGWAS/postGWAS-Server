package com.example.demo.dto;

import java.nio.file.Files;

public class FusionRequest {
    /**
     * effect allele，GWAS输入文件中的A1列名
     */
    private String a1;
    /**
     * non-effect allele，GWAS输入文件中的A2列名
     */
    private String a2;
    /**
     * 指定染色体
     */
    private long chr;
    /**
     * 邮箱
     */
    private String email;
    private FusionFiles files;
    /**
     * 基因表达模型
     */
    private String model = "lasso";
    /**
     * GWAS输入文件中的rs_id列名
     */
    private String rsid;
    /**
     * 组织名称
     */
    private String tissue = "Whole_Blood";
    /**
     * GWAS输入文件中的zscore列名
     */
    private String zscore;
    /**
     * spicify the threshold of pvalue，默认值为0.01
     */
    private String threshold = "0.01";

    public String getA1() { return a1; }
    public void setA1(String value) { this.a1 = value; }

    public String getA2() { return a2; }
    public void setA2(String value) { this.a2 = value; }

    public long getChr() { return chr; }
    public void setChr(long value) { this.chr = value; }

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public FusionFiles getFiles() { return files; }
    public void setFiles(FusionFiles value) { this.files = value; }

    public String getModel() { return model; }
    public void setModel(String value) { this.model = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getTissue() { return tissue; }
    public void setTissue(String value) { this.tissue = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }

    public String getThreshold() { return threshold; }
    public void setThreshold(String value) { this.threshold = value; }
}
