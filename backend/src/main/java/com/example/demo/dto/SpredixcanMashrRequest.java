package com.example.demo.dto;

import java.nio.file.Files;

public class SpredixcanMashrRequest {
    /**
     * eﬀect等位基因
     */
    private String a1;
    /**
     * non-eﬀect等位基因
     */
    private String a2;
    /**
     * The chromosome column name in the input GWAS file. 默认值为chromosome。(当且仅当flag = 1时需要指定
     */
    private String chr;
    /**
     * 邮箱
     */
    private String email;
    private SpredixcanFiles files;
    /**
     * 1 indicates GWAS summary statistics with rs ID；0 indicates GWAS summary statistics with
     * hg38 position ID.
     */
    private long flag;
    /**
     * The position column name in the input GWAS file. 默认值为position。(当且仅当flag = 1时需要指定
     */
    private String pos;
    /**
     * GWAS输入文件中的rs_id列名
     */
    private String rsid;
    /**
     * 组织名，默认值为Whole_Blood
     */
    private String tissue;
    /**
     * GWAS输入文件中的zscore列名
     */
    private String zscore;

    public String getA1() { return a1; }
    public void setA1(String value) { this.a1 = value; }

    public String getA2() { return a2; }
    public void setA2(String value) { this.a2 = value; }

    public String getChr() { return chr; }
    public void setChr(String value) { this.chr = value; }

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public SpredixcanFiles getFiles() { return files; }
    public void setFiles(SpredixcanFiles value) { this.files = value; }

    public long getFlag() { return flag; }
    public void setFlag(long value) { this.flag = value; }

    public String getPos() { return pos; }
    public void setPos(String value) { this.pos = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getTissue() { return tissue; }
    public void setTissue(String value) { this.tissue = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }
}
