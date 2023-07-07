<template>
    <h2>fastENLOC Analysis</h2>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 1: Upload the input data</span>
    </el-divider>

    <img src="../../assets/tutorial/fastenloc/0.png" alt="step1" style="width: 80%;">
    <p>Please note that the uploaded file size should not exceed 500 Mb. It must be a space-separated text file with the
        first row being the column name of each column. If you choose to use the multi-tissue eQTL annotation data with hg38
        position ID, variant_id, loc_id and zscore columns should be included in the GWAS summary statistics as a minimum.
        Additionally, if you choose to use the multi-tissue eQTL annotation data with SNPrsID, SNPrsID, loc_id and zscore
        columns should be included in the GWAS summary statistics as a minimum.
    </p>
    <p>
        An example of the GWAS summary statistics with hg38 position ID format is shown below:
    </p>

    <div class="data">
        <text>
            variant_id loc_id zscore<br>
            chr1_1000079_A_G_b38 Loc1 -0.109163982314723<br>
            chr1_1000112_G_T_b38 Loc1 -0.109163982314723<br>
            chr1_1000291_C_G_b38 Loc1 -0.360495525717311<br>
            …
        </text>
    </div>

    <p>
        An example of the GWAS summary statistics with SNPrsID format is shown below:
    </p>

    <div class="data">
        <text>
            loc_id zscore rsid<br>
            Loc1 -0.109163982314723 rs3128113<br>
            Loc1 -0.109163982314723 rs3121571<br>
            Loc1 -0.360495525717311 rs116904365<br>
            …
        </text>
    </div>

    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 2: Specify the corresponding parameter</span>
    </el-divider>
    <img src="../../assets/tutorial/fastenloc/1.png" alt="step2" style="width: 80%;">
    <p>A full description of the parameters is shown in the table below:</p>
    <table>
        <thead>
            <tr>
                <th>Parameter</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>The eQTL file options</td>
                <td>You can use multi-tissue eQTL annotation with hg38 position ID and also multi-tissue eQTL annotation
                    with SNPrsID. Note that the variant IDs or SNPrsID have to match in your uploaded GWAS summary
                    statistics and eQTL annotations.</td>
            </tr>
            <tr>
                <td>Choose tissue</td>
                <td>A total of 47 tissues can be selected.</td>
            </tr>
            <tr>
                <td>The zscore column name in input GWAS file</td>
                <td>Specify the zscore column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The prefix name of output file</td>
                <td>Specify the prefix name of output files. For example, if you input prefix, the final output file name
                    will be prefix.enloc.gene.out etc.</td>
            </tr>
            <tr>
                <td>The rs_id (or variant_id) column name in the input GWAS file</td>
                <td>If you choose to use the multi-tissue eQTL annotation data with hg38 position ID, please specify the
                    vatiant_id column of your uploaded GWAS file. If you choose to use the multi-tissue eQTL annotation data
                    with SNPrsID, please specify the rs_id column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The loc_id column name in the input GWAS file</td>
                <td>Specify the loc_id column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>Total size of SNP in GWAS</td>
                <td>(Not required)Input the total SNP size of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>Regional co-location probability (RCP) threshold</td>
                <td>Specify the threshold of regional co-location probability (RCP). The default value is 0.5.</td>
            </tr>
            <tr>
                <td>Gene variant-level colocalization probability(GRCP) thresholds</td>
                <td>Specify the threshold of Gene variant-level colocalization probability(GRCP). The default value is 0.5.
                </td>
            </tr>
            <tr>
                <td>Gene locus-level colocalization probability(GLCP) thresholds</td>
                <td>Specify the threshold of Gene locus-level colocalization
                    probability(GLCP). The default value is 0.5.</td>
            </tr>
        </tbody>
    </table>
    <p>It is crucial to carefully configure these parameters to ensure the accuracy and reliability of the analysis process.
    </p>
    <p>In order to receive an email about the results, you can enter your email at the mail icon in the top
        right hand
        corner of the website:
    </p>
    <img src="../../assets/tutorial/fastenloc/2.png" alt="step2" style="width: 80%;">
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 3: Run and get a job ID</span>
    </el-divider>
    <p>The following sections will introduce the use of fastENLOC using the multi-tissue eQTL annotation data with hg38
        position ID. The use of multi-tissue eQTL annotation with SNPrsID is similar.</p>
    <img src="../../assets/tutorial/fastenloc/3.png" alt="step3" style="width: 80%;">
    <p>Then you will get a job id like this:</p>
    <img src="../../assets/tutorial/fastenloc/4.png" alt="step3" style="width: 80%;">
    <p>You can click on the Check result button to jump directly to the results page to see the status of the job. You can
        also click on the Copy Job ID button to copy the job ID, or click on the cancel button to close the window.
    </p>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 4: Receive an email with download link or download in the
            result page</span>
    </el-divider>
    <p>If you enter your email address, you will receive an email like the following:</p>
    <img src="../../assets/tutorial/fastenloc/5.png" alt="step4" style="width: 80%;">
    <p>There will also be run fail emails.</p>
    <p>You can also preview and download the results ﬁle on the Result page:</p>
    <img src="../../assets/tutorial/fastenloc/6.png" alt="step4" style="width: 80%;">
    <p>The Status column allows you to view the status of the job, and the Create Time and Finish Time columns allow you to
        view the running time of the job. Clicking on the display button, you can preview the result files and download the
        files you want:</p>
    <img src="../../assets/tutorial/fastenloc/7.png" alt="step4" style="width: 80%;">
    <p>A full description of the result ﬁles is shown in the table below:</p>
    <table>
        <thead>
            <tr>
                <th>File name</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Height_Blood.enloc.gene.out</td>
                <td>(Original output)Gene-level colocalization output. This file contains gene name, gene variant-level
                    colocalization probability (GRCP) and gene locus-level colocalization probability (GLCP).</td>
            </tr>
            <tr>
                <td>Height_Blood.enloc.gene.extract.out</td>
                <td>Filtering based on gene variant-level colocalization probability (GRCP) thresholds, gene locus-level
                    colocalization probability (GLCP) thresholds and so on.</td>
            </tr>
            <tr>
                <td>img2.png</td>
                <td>The results are visualised in this file. The y-axis is the GRCP in Height_Blood.enloc.gene.out and the
                    x-axis is the GLCP in that file, with each point representing a gene. Genes that exceed the GRCP
                    threshold and GLCP threshold are highlighted in red and the rest are marked in light blue.</td>
            </tr>
            <tr>
                <td>Height_Blood.enloc.enrich.out</td>
                <td>(Original output) Enrichment analysis result. This file contains estimated enrichment parameters and
                    standard errors.</td>
            </tr>
            <tr>
                <td>Height_Blood.enloc.sig.extract.out</td>
                <td>Filtering based on regional co-location probability (RCP) thresholds.</td>
            </tr>
            <tr>
                <td>Height_Blood.enloc.sig.out</td>
                <td>(Original output) The main output from the colocalization analysis. This file contains signal cluster
                    name (from eQTL analysis), number of member SNPs, regional co-location probability (RCP), locus-level
                    colocalization probability (LCP) and so on.</td>
            </tr>
            <tr>
                <td>Img1.png</td>
                <td>The results are visualised in this file. The y-axis is the RCP in Height_Blood.enloc.sig.out and the
                    x-axis is the LCP in that file, with each point representing a signal. Signals that exceed the RCP
                    threshold are highlighted in red and the rest are marked in light blue.</td>
            </tr>
            <tr>
                <td>Height_Blood.enloc.snp.out</td>
                <td>(Original output)SNP-level colocalization output. This file contains SNP name, SNP-level colocalization
                    probability and so on.</td>
            </tr>
        </tbody>
    </table>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 5: Browse the visualization of results</span>
    </el-divider>
    <p>In the Charts page, you can browse the visualization of results:</p>
    <img src="../../assets/tutorial/fastenloc/8.png" alt="step5" style="width: 80%;">
    <p>The y-axis is the RCP in Height_Blood.enloc.sig.out and the x-axis is the LCP in that file, with each point
        representing a signal. Signals that exceed the RCP threshold are highlighted in red and the rest are marked in light
        blue. Click on each point to see the details of the signal. </p>
    <img src="../../assets/tutorial/fastenloc/9.png" alt="step5" style="width: 80%;">
    <p>The y-axis is the GRCP in Height_Blood.enloc.gene.out and the x-axis is the GLCP in that file, with each point
        representing a gene. Genes that exceed the GRCP threshold and GLCP threshold are highlighted in red and the rest are
        marked in light blue. Click on each point to see the details of the gene. </p>
</template>

<script setup>

</script>
<style scoped>
h2 {
    font-family: "Trebuchet MS", sans-serif;
    font-size: 24px;
    letter-spacing: 2px;
}

p {
    width: 80%;
    margin-left: 10%;
    text-align: justify;
    text-justify: inter-ideograph;
    line-height: 1.5em;
}

.data {
    width: 80%;
    margin-left: 10%;
    text-align: justify;
    text-justify: inter-ideograph;
    border: 2px solid azure;
    border-radius: 5px;
    background-color: #f2f2f2;
    padding: 5px;
    font-size: small;
    font-weight: 330;
    /* 内容与边框10px的间距 */
    word-spacing: 25px;
}

table {
    font-family: "Times New Roman";
    font-style: normal;
    line-height: 1.5em;
    font-size: medium;
    font-weight: 200;
    margin-left: 10%;
    width: 80%;
}

tbody tr:nth-child(odd) {
    background-color: #f2f2f2;
}

td,
th {
    border: 1px solid #f2f2f2;
}
</style>