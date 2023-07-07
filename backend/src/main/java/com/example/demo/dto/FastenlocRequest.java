package com.example.demo.dto;

import java.nio.file.Files;

public class FastenlocRequest {
    /**
     * 邮箱
     */
    private String email;
    private FastenlocFiles files;
    /**
     * 0:使用用户上传的文件；1:使用基于hg38 position ID的多组织eQTL注释文件；2:使用基 于rs_id的多组织eQTL注释文件；
     */
    private long flag;
    /**
     * 基因位点水平的共定位概率（GLCP）阈值，默认值为0.5。
     */
    private double glcp;
    /**
     * 基因变异水平的共定位概率（GRCP）阈值，默认值为0.5。
     */
    private double grcp;
    /**
     * variant_id或者rs_id二选一
     */
    private String idType;
    /**
     * id对应具体的值
     */
    private String idValue;
    /**
     * GWAS输入文件中的loc_id列名，无默认值。
     */
    private String locid;
    /**
     * GWAS中SNP的总数，无默认值。
     */
    private long ngwas = -1;
    /**
     * 输出文件前缀名，默认值为preﬁx。
     */
    private String prefix;
    /**
     * 区域共定位概率（RCP）阈值，默认值为0.5。
     */
    private double rcp;
    /**
     * flag=0/1时必须指定组织名
     */
    private String tissue;
    /**
     * 用户输入gwas文件zscore列名
     */
    private String zscore;

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public FastenlocFiles getFiles() { return files; }
    public void setFiles(FastenlocFiles value) { this.files = value; }

    public long getFlag() { return flag; }
    public void setFlag(long value) { this.flag = value; }

    public double getGlcp() { return glcp; }
    public void setGlcp(double value) { this.glcp = value; }

    public double getGrcp() { return grcp; }
    public void setGrcp(double value) { this.grcp = value; }

    public String getidType() { return idType; }
    public void setidType(String value) { this.idType = value; }

    public String getidValue() { return idValue; }
    public void setidValue(String value) { this.idValue = value; }

    public String getLocid() { return locid; }
    public void setLocid(String value) { this.locid = value; }

    public long getNgwas() { return ngwas; }
    public void setNgwas(long value) { this.ngwas = value; }

    public String getPrefix() { return prefix; }
    public void setPrefix(String value) { this.prefix = value; }

    public double getRcp() { return rcp; }
    public void setRcp(double value) { this.rcp = value; }

    public String getTissue() { return tissue; }
    public void setTissue(String value) { this.tissue = value; }

    public String getZscore() { return zscore; }
    public void setZscore(String value) { this.zscore = value; }
}
