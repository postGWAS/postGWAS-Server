<template>
    <h2>eCAVIAR Analysis</h2>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 1: Upload the input data</span>
    </el-divider>

    <img src="../../assets/tutorial/ecaviar/0.png" alt="step1" style="width: 80%;">
    <p>Please note that the uploaded ﬁle size should not exceed 500 Mb. It must be a space-separated
        text
        ﬁle with the ﬁrst row being the column name of each column. SNPrsID and zscore columns should be
        included in
        the GWAS summary statistics as a minimum.
    </p>
    <p>
        An example of the GWAS summary statistics format is shown below:
    </p>

    <div class="data">
        <text>
            rs_id zscore<br>
            11:121353016:T:C 2.5<br>
            11:121361398:C:T 2.62427<br>
            11:121364027:G:A 2.51546<br>
            ...
        </text>
    </div>

    <p>
        The LD matrix does not need a header, but each row in the LD matrix should correspond to a
        corresponding SNP in the GWAS summary statistics and each column to a corresponding SNP in the GWAS
        summary
        statistics.
    </p>
    <p>An example of the LD matrix format is shown below:</p>
    <div class="data">
        <text>
            1 0.945376 0.936653 ...<br>
            0.945376 1 0.991296 ...<br>
            0.936653 0.991296 1 ...<br>
            ...
        </text>
    </div>
    <p>SNPrsID and zscore columns should be included in the eQTL data as a minimum. You can obtain eQTL data from databases
        such as GTEx and eQTL Catalogue.
    </p>
    <p>An example of the eQTL data format is shown below:</p>
    <div class="data">
        <text>
            rs_id zscore<br>
            11:121353016:T:C 0.15744964043519<br>
            11:121361398:C:T -0.1319060244648<br>
            11:121364027:G:A -0.134400458168381<br>
            ...
        </text>
    </div>
    <p>The eQTL LD matrix does not need a header, but each row in the LD matrix should correspond to a corresponding SNP in
        the eQTL data and each column to a corresponding SNP in the eQTL data.</p>
    <p>An example of the eQTL LD matrix format is shown below:</p>
    <div class="data">
        <text>
            1 0.943601 0.943601 ...<br>
            0.943601 1 1 ...<br>
            0.943601 1 1 ...<br>
            ...
        </text>
    </div>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 2: Specify the corresponding parameter</span>
    </el-divider>
    <img src="../../assets/tutorial/ecaviar/1.png" alt="step2" style="width: 80%;">
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
                <td>The zscore column name in the input GWAS file</td>
                <td>Specify the zscore column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input GWAS file</td>
                <td>Specify the SNPrsID column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The zscore column name in the input eQTL file</td>
                <td>Specify the zscore column of your uploaded eQTL file.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input eQTL file</td>
                <td>Specify the rs_id column of your uploaded eQTL file.</td>
            </tr>
            <tr>
                <td>Set the maximum number of causal SNP</td>
                <td>The maximum number of causal SNPs had better not exceed 5.</td>
            </tr>
        </tbody>
    </table>
    <p>It is crucial to carefully configure these parameters to ensure the accuracy and reliability of the analysis process.
    </p>
    <p>In order to receive an email about the results, you can enter your email at the mail icon in the top
        right hand
        corner of the website:
    </p>
    <img src="../../assets/tutorial/ecaviar/2.png" alt="step2" style="width: 80%;">
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 3: Run and get a job ID</span>
    </el-divider>
    <img src="../../assets/tutorial/ecaviar/3.png" alt="step3" style="width: 80%;">
    <p>Then you will get a job id like this:</p>
    <img src="../../assets/tutorial/ecaviar/4.png" alt="step3" style="width: 80%;">
    <p>You can click on the Check result button to jump directly to the results page to see the status of
        the job. You can also click on the Copy Job ID button to copy the job ID, or click on the cancel
        button to close the window.
    </p>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 4: Receive an email with download link or download in the
            result page</span>
    </el-divider>
    <p>If you enter your email address, you will receive an email like the following:</p>
    <img src="../../assets/tutorial/ecaviar/5.png" alt="step4" style="width: 80%;">
    <p>There will also be run fail emails.</p>
    <p>You can also preview and download the results ﬁle on the Result page:</p>
    <img src="../../assets/tutorial/ecaviar/6.png" alt="step4" style="width: 80%;">
    <p>The Status column allows you to view the status of the job, and the Create Time and Finish Time columns allow you to
        view the running time of the job. Clicking on the display button, you can preview the result files and download the
        files you want:</p>
    <img src="../../assets/tutorial/ecaviar/7.png" alt="step4" style="width: 80%;">
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
                <td>log_1_set_sorted</td>
                <td>Causal SNPs in GWAS. The causal SNPs are ranked according to the posterior probabilities.</td>
            </tr>
            <tr>
                <td>img3.png</td>
                <td>The results are visualised in this file. The y-axis is the CLPP in the log_col_sorted file and the
                    x-axis is the snpID column in that file.</td>
            </tr>
            <tr>
                <td>log_2_set_sorted</td>
                <td>Causal SNPs in eQTL. The causal SNPs are ranked according to the posterior probabilities.</td>
            </tr>
            <tr>
                <td>log_col_sorted</td>
                <td>Sorted by size of CLPP.</td>
            </tr>
            <tr>
                <td>log_1_set</td>
                <td>(Original output)Causal SNPs in GWAS.</td>
            </tr>
            <tr>
                <td>Img2.png</td>
                <td>The results are visualised in this file. Y-axis represents the posterior probabilities in the
                    log_2_post_sorted file and x-axis represents each SNP. The SNPs in the log_2_set_sorted file are
                    highlighted in red and the rest are marked in light blue.</td>
            </tr>
            <tr>
                <td>Img1.png</td>
                <td>The results are visualised in this file. Y-axis represents the posterior probabilities in the
                    log_1_post_sorted file and x-axis represents each SNP. The SNPs in the log_1_set_sorted file are
                    highlighted in red and the rest are marked in light blue.</td>
            </tr>
            <tr>
                <td>log_1_post</td>
                <td>(Original output)Causal posterior probability for each SNP in GWAS.</td>
            </tr>
            <tr>
                <td>log_2_post_sorted</td>
                <td>Causal posterior probability for each SNP in eQTL. The causal SNPs are ranked according to the posterior
                    probabilities.</td>
            </tr>
            <tr>
                <td>log_col</td>
                <td>(Original output)This file contains the colocalization posterior probability(CLPP). CLPP is equal to the
                    product of the posterior probability that the variant is causal in the GWAS and the posterior
                    probability that the variant is causal in the eQTL study.</td>
            </tr>
            <tr>
                <td>log_2_post</td>
                <td>(Original output)Causal posterior probability for each SNP in eQTL.</td>
            </tr>
            <tr>
                <td>log_2_set</td>
                <td>(Original output)Causal SNPs in eQTL.</td>
            </tr>
            <tr>
                <td>log_1_post_sorted</td>
                <td>Causal posterior probability for each SNP in GWAS. The causal SNPs are ranked according to the posterior
                    probabilities.</td>
            </tr>
        </tbody>
    </table>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 5: Browse the visualization of results</span>
    </el-divider>
    <p>In the Charts page, you can browse the visualization of results:</p>
    <img src="../../assets/tutorial/ecaviar/8.png" alt="step5" style="width: 80%;">
    <p>Y-axis represents the posterior probabilities in the log_1_post_sorted file and x-axis represents each SNP. The SNPs
        in the log_1_set_sorted file are highlighted in red and the rest are marked in light blue. Click on each point to
        see the details of the SNP.</p>
    <img src="../../assets/tutorial/ecaviar/9.png" alt="step5" style="width: 80%;">
    <p>Y-axis represents the posterior probabilities in the log_2_post_sorted file and x-axis represents each SNP. The SNPs
        in the log_2_set_sorted file are highlighted in red and the rest are marked in light blue. Click on each point to
        see the details of the SNP. </p>
    <img src="../../assets/tutorial/ecaviar/10.png" alt="step5" style="width: 80%;">
    <p>The y-axis is the CLPP in the log_col_sorted file and the x-axis is the snpID column in that file. Click on each
        point to see the details of the SNP. </p>
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