package com.example.demo.dto;

import java.nio.file.Files;

public class PaintorRequest {
    /**
     * 要包含在模型中的注释的名称
     */
    private String annotations;
    /**
     * 可选参数
     */
    private PaintorArgs args;
    /**
     * 邮箱
     */
    private String email;
    private PaintorFiles files;
    /**
     * GWAS输入文件的rs_id所在列的列名
     */
    private String rsid;
    /**
     * GWAS输入文件的zscore所在列的列名
     */
    private String zscore;

    public String getAnnotations() { return annotations; }
    public void setAnnotations(String value) { this.annotations = value; }

    public PaintorArgs getArgs() { return args; }
    public void setArgs(PaintorArgs value) { this.args = value; }

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public PaintorFiles getFiles() { return files; }
    public void setFiles(PaintorFiles value) { this.files = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }
}
