package com.example.demo.dto;

public class FinemapRequest {
    /**
     * effect allele，GWAS输入文件的allele1所在列的列名，默认值为allele1。
     */
    private String a1;
    /**
     * non-effect allele，GWAS输入文件的allele2所在列的列名，默认值为allele2。
     */
    private String a2;
    /**
     * GWAS输入文件的beta所在列的列名，默认值为beta。
     */
    private String beta;
    /**
     * GWAS输入文件的chromosome所在列的列名，默认值为chromosome。
     */
    private String chr;
    private FinemapFiles files;
    /**
     * GWAS输入文件的maf所在列的列名，默认值为maf。
     */
    private String maf;
    /**
     * GWAS样本数量。
     */
    private long ngwas;
    /**
     * GWAS输入文件的position所在列的列名，默认值为position。
     */
    private String pos;
    /**
     * GWAS输入文件的rs_id所在列的列名，默认值为rs_id。
     */
    private String rsid;
    /**
     * GWAS输入文件的se所在列的列名，默认值为se。
     */
    private String se;

    /**
     * specify the maximum number of allowed causal SNPs.
     */
    private long c;

    /**
     * 邮箱
     */
    private String email;

    public String getA1() { return a1; }
    public void setA1(String value) { this.a1 = value; }

    public String getA2() { return a2; }
    public void setA2(String value) { this.a2 = value; }

    public String getBeta() { return beta; }
    public void setBeta(String value) { this.beta = value; }

    public String getChr() { return chr; }
    public void setChr(String value) { this.chr = value; }

    public FinemapFiles getFiles() { return files; }
    public void setFiles(FinemapFiles value) { this.files = value; }

    public String getMaf() { return maf; }
    public void setMaf(String value) { this.maf = value; }

    public long getNgwas() { return ngwas; }
    public void setNgwas(long value) { this.ngwas = value; }

    public String getPos() { return pos; }
    public void setPos(String value) { this.pos = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public String getse() { return se; }
    public void setse(String value) { this.se = value; }

    public long getC() { return c; }
    public void setC(long value) { this.c = value; }

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }
}
