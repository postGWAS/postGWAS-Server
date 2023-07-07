package com.example.demo.dto;

import java.nio.file.Files;

public class SpredixcanEnetRequest {
    /**
     * eﬀect等位基因
     */
    private String a1;
    /**
     * non-eﬀect等位基因
     */
    private String a2;
    /**
     * 邮箱
     */
    private String email;
    private SpredixcanFiles files;
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

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public SpredixcanFiles getFiles() { return files; }
    public void setFiles(SpredixcanFiles value) { this.files = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getTissue() { return tissue; }
    public void setTissue(String value) { this.tissue = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }
}
