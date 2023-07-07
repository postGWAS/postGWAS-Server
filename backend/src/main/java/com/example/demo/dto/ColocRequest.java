package com.example.demo.dto;

import java.nio.file.Files;

public class ColocRequest {
    /**
     * GWAS输入文件的beta所在列的列名，默认值为beta。
     */
    private String beta;
    /**
     * The minor allele frequency column of eQTL input ﬁle，默认值为MAF。
     */
    private String emaf= "";
    /**
     * 邮箱
     */
    private String email;
    /**
     * The pvalue column of eQTL input ﬁle，默认值为pval。
     */
    private String epval= "";
    /**
     * The rs_id column of eQTL input ﬁle，默认值为rs_id。
     */
    private String ersid = "";
    private ColocFiles files;
    /**
     * 默认值为0      1 indicates using GTex v8 eQTL data; 0 indicates using your own eQTL data.
     * （另外，当用户指定1时不用指 定ersID、epval、emaf、geneID、neQTL这5个参数）
     */
    private double flag = 0;
    /**
     * The gene id column of eQTL input ﬁle，默认值为gene_id。
     */
    private String geneId = "";
    /**
     * eQTL数据数量
     */
    private long neqtl = 0;
    /**
     * GWAS数据数量
     */
    private long ngwas;
    /**
     * GWAS输入文件的pvalue所在列的列名，默认值为pval。
     */
    private String pval;
    /**
     * GWAS输入文件的rs_id所在列的列名，默认值为rs_id
     */
    private String rsid;
    /**
     * set the threshold.
     */
    private double threshold;
    /**
     * specify the tissue name，默认值为Whole_Blood.（取值包括Adipose_Subcutaneous、
     * Adipose_visceral_Omentum、Adrenal_Gland、Artery_Aorta、Artery_Coronary、Artery_Tibial、
     * Brain_Amygdala、Brain_Anterior_cingulate_cortex_BA24、Brain_Caudate_basal_ganglia、
     * Brain_Cerebellar_Hemisphere、Brain_Cerebellum、Brain_Cortex、Brain_Frontal_Cortex_BA9、
     * Brain_Hippocampus、Brain_Hypothalamus、Brain_Nucleus_accumbens_basal_ganglia、
     * Brain_Putamen_basal_ganglia、Brain_Spinal_cord_cervical_c_1（前端显示为Brain_Spinal_cord_cervical_c-
     * 1）、Brain_Substantia_nigra、Breast_Mammary_Tissue、Cells_Cultured_ﬁbroblasts、
     * Cells_EBV_transformed_lymphocytes（前端显示为Cells_EBV-transformed_lymphocytes）、Colon_Sigmoid、
     * Colon_Transverse、Esophagus_Gastroesophageal_Junction、Esophagus_Mucosa、Esophagus_Muscularis、
     * Heart_Atrial_Appendage、Heart_Left_Ventricle、Kidney_Cortex、Liver、Lung、Minor_Salivary_Gland、
     * Muscle_Skeletal、Nerve_Tibial、Ovary、Pancreas、Pituitary、Prostate、
     * Skin_Not_Sun_Exposed_Suprapubic、Skin_Sun_Exposed_Lower_leg、Small_Intestine_Terminal_Ileum、
     * Spleen、Stomach、Testis、Thyroid、Uterus、Vagina、Whole_Blood。
     */
    private String tissue;
    /**
     * GWAS输入文件的varbeta所在列的列名，默认值为varbeta。
     */
    private String varbeta;

    public String getBeta() { return beta; }
    public void setBeta(String value) { this.beta = value; }

    public String getEmaf() { return emaf; }
    public void setEmaf(String value) { this.emaf = value; }

    public String getEmail() { return email; }
    public void setEmail(String value) { this.email = value; }

    public String getEpval() { return epval; }
    public void setEpval(String value) { this.epval = value; }

    public String getErsid() { return ersid; }
    public void setErsid(String value) { this.ersid = value; }

    public ColocFiles getFiles() { return files; }
    public void setFiles(ColocFiles value) { this.files = value; }

    public double getFlag() { return flag; }
    public void setFlag(double value) { this.flag = value; }

    public String getGeneId() { return geneId; }
    public void setGeneId(String value) { this.geneId = value; }

    public long getNeqtl() { return neqtl; }
    public void setNeqtl(long value) { this.neqtl = value; }

    public long getNgwas() { return ngwas; }
    public void setNgwas(long value) { this.ngwas = value; }

    public String getPval() { return pval; }
    public void setPval(String value) { this.pval = value; }

    public String getRsid() { return rsid; }
    public void setRsid(String value) { this.rsid = value; }

    public double getThreshold() { return threshold; }
    public void setThreshold(double value) { this.threshold = value; }

    public String getTissue() { return tissue; }
    public void setTissue(String value) { this.tissue = value; }

    public String getVarbeta() { return varbeta; }
    public void setVarbeta(String value) { this.varbeta = value; }
}