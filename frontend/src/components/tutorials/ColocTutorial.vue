<template>
    <h2>Coloc Analysis</h2>
    <p>Note when using the coloc method: A single genomic region does not correspond to the whole genome, nor to a whole
        chromosome. Coloc also does not automatically split chromosomes or a genome into regions. It is assumed the user can
        look at their data, identify a region with overlapping GWAS signals between two studies, and decide on the set of
        SNPs to include.</p>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 1: Upload the input data</span>
    </el-divider>

    <img src="../../assets/tutorial/coloc/0.png" alt="step1" style="width: 80%;">
    <p>Please note that the uploaded file size should not exceed 500 Mb. It must be a space-separated text file with the
        first row being the column name of each column. SNPrsID, beta, pvalue and varbeta columns should be included in the
        GWAS summary statistics as a minimum.
    </p>
    <p>
        An example of the GWAS summary statistics with SNPrsID is shown below:
    </p>

    <div class="data">
        <text>
            rs_id pval beta varbeta <br>
            rs13211945 0.3359306 -0.028824 0.0299551999887014 <br>
            rs1812241 0.0306283 -0.020067 0.00928224789319786 <br>
            rs210911 0.3475316 -0.011784 0.0125443384785354 <br>
            …
        </text>
    </div>

    <p>If you choose to use your own eQTL data, SNPrsID, pvalue, maf and geneID columns should be included in the eQTL data
        as a minimum. The first line of the file is the header. Additionally, you can choose to use GTEx v8 eQTL data at
        significant loci provided by us.</p>
    <p>An example of the eQTL data is shown below:</p>
    <div class="data">
        <text>
            rs_id gene_id maf pval<br>
            rs6933892 ENSG00000112137.12 0.376289 0.0972054<br>
            rs6934084 ENSG00000112137.12 0.376289 0.0972054<br>
            rs210910 ENSG00000112137.12 0.158505 0.218505<br>
            …
        </text>
    </div>

    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 2: Specify the corresponding parameter</span>
    </el-divider>
    <p>If you choose to use your own eQTL data, you could specify the parameters like this:</p>
    <img src="../../assets/tutorial/coloc/1.png" alt="step2" style="width: 80%;">
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
                <td>Size of GWAS samples</td>
                <td>Specify the GWAS sample size.</td>
            </tr>
            <tr>
                <td>Size of eQTL samples</td>
                <td>Specify the eQTL sample size.</td>
            </tr>
            <tr>
                <td>The gene id column of eQTL input ﬁle</td>
                <td>Specify the gene id column of your uploaded eQTL file.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input GWAS file</td>
                <td>Specify the SNPrsID column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The beta column name in the input GWAS file</td>
                <td>Specify the beta column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The pvalue column name in the input GWAS file</td>
                <td>Specify the pvalue column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The varbeta column name in the input GWAS file</td>
                <td>Specify the varbeta column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The rs_id column of eQTL input ﬁle</td>
                <td>Specify the SNPrsID column of your uploaded eQTL file.</td>
            </tr>
            <tr>
                <td>The rs_id column of eQTL input ﬁle</td>
                <td>Specify the SNPrsID column of your uploaded eQTL file.</td>
            </tr>
            <tr>
                <td>The pvalue column of eQTL input ﬁle</td>
                <td>Specify the pvalue column of your uploaded eQTL file.</td>
            </tr>
            <tr>
                <td>The minor allele frequency column of eQTL input ﬁle</td>
                <td>Specify the minor allele frequency column of your uploaded eQTL file.</td>
            </tr>
            <tr>
                <td>Choose tissue</td>
                <td>No need to select.</td>
            </tr>
            <tr>
                <td>Set the threshold</td>
                <td>Posterior probabilities of H4 (one common causal variant) above this threshold were considered
                    colocalization signals.The default value is 0.95.</td>
            </tr>
        </tbody>
    </table>
    <p>It is crucial to carefully configure these parameters to ensure the accuracy and reliability of the analysis process.
    </p>
    <p>If you choose to use GTEx v8 eQTL data provided by us, you could specify the parameters like this:</p>
    <img src="../../assets/tutorial/coloc/2.png" alt="step2" style="width: 80%;">
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
                <td>Size of GWAS samples</td>
                <td>Specify the GWAS sample size.</td>
            </tr>
            <tr>
                <td>Size of eQTL samples</td>
                <td>No need to specify.</td>
            </tr>
            <tr>
                <td>The gene id column of eQTL input ﬁle</td>
                <td>No need to specify.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input GWAS file</td>
                <td>Specify the SNPrsID column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The beta column name in the input GWAS file</td>
                <td>Specify the beta column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The pvalue column name in the input GWAS file</td>
                <td>Specify the pvalue column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The varbeta column name in the input GWAS file</td>
                <td>Specify the varbeta column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The rs_id column of eQTL input ﬁle</td>
                <td>No need to specify.</td>
            </tr>
            <tr>
                <td>The pvalue column of eQTL input ﬁle</td>
                <td>No need to specify.</td>
            </tr>
            <tr>
                <td>The minor allele frequency column of eQTL input ﬁle</td>
                <td>No need to specify.</td>
            </tr>
            <tr>
                <td>Choose tissue</td>
                <td>A total of 47 tissues can be selected.</td>
            </tr>
            <tr>
                <td>Set the threshold</td>
                <td>Posterior probabilities of H4 (one common causal variant) above this threshold were considered
                    colocalization signals.The default value is 0.95.</td>
            </tr>
        </tbody>
    </table>
    <p>It is crucial to carefully configure these parameters to ensure the accuracy and reliability of the analysis process.
    </p>
    <p>In order to receive an email about the results, you can enter your email at the mail icon in the top
        right hand
        corner of the website:
    </p>
    <img src="../../assets/tutorial/coloc/3.png" alt="step2" style="width: 80%;">
    <p>The following sections will introduce the use of S-PrediXcan using your own eQTL data. The use of GTEx v8 eQTL data
        at significant loci is similar.</p>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 3: Run and get a job ID</span>
    </el-divider>
    <img src="../../assets/tutorial/coloc/4.png" alt="step3" style="width: 80%;">
    <p>Then you will get a job id like this:</p>
    <img src="../../assets/tutorial/coloc/5.png" alt="step3" style="width: 80%;">
    <p>You can click on the Check result button to jump directly to the results page to see the status of the job. You can
        also click on the Copy Job ID button to copy the job ID, or click on the cancel button to close the window.
    </p>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 4: Receive an email with download link or download in the
            result page</span>
    </el-divider>
    <p>If you enter your email address, you will receive an email like the following:</p>
    <img src="../../assets/tutorial/coloc/6.png" alt="step4" style="width: 80%;">
    <p>There will also be run fail emails.</p>
    <p>You can also preview and download the results ﬁle on the Result page:</p>
    <img src="../../assets/tutorial/coloc/7.png" alt="step4" style="width: 80%;">
    <p>The Status column allows you to view the status of the job, and the Create Time and Finish Time columns allow you to
        view the running time of the job. Clicking on the display button, you can preview the result files and download the
        files you want:</p>
    <img src="../../assets/tutorial/coloc/8.png" alt="step4" style="width: 80%;">
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
                <td>result.txt</td>
                <td>This file contains snp, gene, SNP.PP.H4(one common causal variant) and so on.</td>
            </tr>
            <tr>
                <td>need_result.txt</td>
                <td>This file contains SNPs and corresponding genes that exceed a given threshold of posterior probabilities
                    of H4 (one common causal variant).</td>
            </tr>
            <tr>
                <td>readme.txt</td>
                <td>A brief description of the method and results.</td>
            </tr>
            <tr>
                <td>img.png</td>
                <td>The results are visualised in this file. The x-axis is the snp data in the result.txt file and the
                    y-axis is the SNP.PP.H4 data in the result.txt file. Points that exceed the user-set threshold for the
                    posterior probability that the GWAS summary statistics and eQTL data share the same causal variant are
                    shown in red, and the remaining points are shown in blue. A dashed straight line is also drawn to
                    indicate the line y = threshold, with above the dashed line being above the threshold and below the
                    dashed line being below the threshold.</td>
            </tr>
        </tbody>
    </table>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 5: Browse the visualization of results</span>
    </el-divider>
    <p>In the Charts page, you can browse the visualization of results:</p>
    <img src="../../assets/tutorial/coloc/9.png" alt="step5" style="width: 80%;">
    <p>The x-axis is the snp data in the result.txt file and the y-axis is the SNP.PP.H4 data in the result.txt file. Points
        that exceed the user-set threshold for the posterior probability that the GWAS summary statistics and eQTL data
        share the same causal variant are shown in red, and the remaining points are shown in blue. A dashed straight line
        is also drawn to indicate the line y = threshold, with above the dashed line being above the threshold and below the
        dashed line being below the threshold. Click on each point to see the details of the SNPs.</p>
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
}</style>