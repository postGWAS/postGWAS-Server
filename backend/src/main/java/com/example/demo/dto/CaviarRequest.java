package com.example.demo.dto;

import java.nio.file.Files;

public class CaviarRequest {
    /**
     * 可选参数
     */
    private CaviarArgs args;
    /**
     * 邮箱
     */
    private String email;
    private CaviarFiles files;
    /**
     * GWAS输入文件的rs_id所在列的列名
     */
    private String rsid;
    /**
     * GWAS输入文件的zscore所在列的列名
     */
    private String zscore;

    public CaviarArgs getArgs() { return args; }
    public void setArgs(CaviarArgs value) { this.args = value; }

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public CaviarFiles getFiles() { return files; }
    public void setFiles(CaviarFiles value) { this.files = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }
}
