<template>
    <h2>CAVIAR Analysis</h2>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 1: Upload the input data</span>
    </el-divider>

    <img src="../../assets/tutorial/caviar/1.png" alt="step1" style="width: 80%;">
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
            rs3809630 -11.917<br>
            rs1113232 -0.011<br>
            rs145322388 -0.102903<br>
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
            1 -0.07590886111456 -0.07590886111456 ...<br>
            -0.07590886111456 1 1 0.964767461986443 ...<br>
            -0.07590886111456 1 1 ...<br>
            ...
        </text>
    </div>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 2: Specify the corresponding parameter</span>
    </el-divider>
    <img src="../../assets/tutorial/caviar/2.png" alt="step2" style="width: 80%;">
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
                <td>The zscore column name in the input GWAS ﬁle.</td>
                <td>Specify the zscore column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input GWAS ﬁle.</td>
                <td>Specify the SNPrsID column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>Set the maximum size of causal SNP.</td>
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
    <img src="../../assets/tutorial/caviar/3.png" alt="step2" style="width: 80%;">
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 3: Run and get a job ID</span>
    </el-divider>
    <img src="../../assets/tutorial/caviar/4.png" alt="step3" style="width: 80%;">
    <p>Then you will get a job id like this:</p>
    <img src="../../assets/tutorial/caviar/5.png" alt="step3" style="width: 80%;">
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
    <img src="../../assets/tutorial/caviar/6.png" alt="step4" style="width: 80%;">
    <p>There will also be run fail emails.</p>
    <p>You can also preview and download the results ﬁle on the Result page:</p>
    <img src="../../assets/tutorial/caviar/7.png" alt="step4" style="width: 80%;">
    <p>Clicking on the display button, you can preview the result ﬁles and download the ﬁles you want:</p>
    <img src="../../assets/tutorial/caviar/8.png" alt="step4" style="width: 80%;">
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
                <td>img.png</td>
                <td>The results are visualised in this ﬁle. Y-axis represents the posterior probabilities in
                    the log_post_sorted ﬁle and x-axis represents each SNP. The SNPs in the
                    log_set_sorted ﬁle are highlighted in red and the rest are marked in light blue.</td>
            </tr>
            <tr>
                <td>log_post</td>
                <td>(Original output)Causal posterior probability for each SNP.</td>
            </tr>
            <tr>
                <td>log_post_sorted</td>
                <td>All SNPs were ranked according to their posterior probabilities.</td>
            </tr>
            <tr>
                <td>log_set</td>
                <td>(Original output)Causal SNP set.</td>
            </tr>
            <tr>
                <td>log_set_sorted</td>
                <td>The causal SNPs are ranked according to the posterior probabilities and the
                    posterior probabilities are added to the ﬁle.</td>
            </tr>
        </tbody>
    </table>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 5: Browse the visualization of results</span>
    </el-divider>
    <p>In the Charts page, you can browse the visualization of results:</p>
    <img src="../../assets/tutorial/caviar/9.png" alt="step5" style="width: 80%;">
    <p>Y-axis represents the posterior probabilities in the log_post_sorted ﬁle and x-axis represents each
        SNP. The SNPs in the log_set_sorted ﬁle are highlighted in red and the rest are marked in light
        blue. Click
        on each point to see the details of the SNP.</p>
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