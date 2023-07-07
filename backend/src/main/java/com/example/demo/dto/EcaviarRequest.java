package com.example.demo.dto;

import java.nio.file.Files;

public class EcaviarRequest {
    /**
     * 邮箱
     */
    private String email;
    /**
     * eQTL输入文件中的rs_id列名
     */
    private String ersid;
    /**
     * eQTL输入文件中的zscore列名
     */
    private String ezscore;
    private EcaviarFiles files;
    /**
     * GWAS输入文件中的rs_id列名
     */
    private String rsid;
    /**
     * GWAS输入文件中的zscore列名
     */
    private String zscore;
    /**
     * 设定casual SNP 的最大数量
     */
    private long c;


    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public String getErsid() { return ersid; }
    public void setErsid(String value) { this.ersid = value; }

    public String getEzscore() { return ezscore; }
    public void setEzscore(String value) { this.ezscore = value; }

    public EcaviarFiles getFiles() { return files; }
    public void setFiles(EcaviarFiles value) { this.files = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }

    public long getC() { return c; }
    public void setC(long value) { this.c = value; }
}
