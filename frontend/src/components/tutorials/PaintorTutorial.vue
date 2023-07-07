<template>
    <h2>Paintor Analysis</h2>
    <br>
    <p>
        Since PAINTOR is intended to be used with annotations, it requires an annotation file as input. You can also run
        PAINTOR without annotations. In the backend analysis, we hack this by feeding it a dummy annotation file with all
        1's.
    </p>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 1: Upload the input data</span>
    </el-divider>

    <p>You can choose to upload GWAS summary statistics, LD matrix and functional annotation matrix:
    </p>

    <img src="../../assets/tutorial/paintor/1.png" alt="step1" style="width: 80%;">
    <p>You can also choose to upload GWAS summary statistics and LD matrix:</p>
    <img src="../../assets/tutorial/paintor/2.png" alt="step1" style="width: 80%;">
    <p>Please note that the uploaded file size should not exceed 500 Mb. It must be a space-separated text file with the
        first row being the column name of each column. SNPrsID and zscore columns should be included in the GWAS summary
        statistics as a minimum.
    </p>
    <p>
        An example of the GWAS summary statistics format is shown below:
    </p>

    <div class="data">
        <text>
            SNP_ID Zscore<br>
            rs701 -0.208<br>
            rs368 0.6746<br>
            rs867 -0.6049<br>
            ...
        </text>
    </div>

    <p>
        The LD matrix does not need a header, but each row in the LD matrix should correspond to a corresponding SNP in the
        GWAS summary statistics and each column to a corresponding SNP in the GWAS summary statistics.
    </p>
    <p>An example of the LD matrix format is shown below:</p>
    <div class="data">
        <text>
            1.01 0.6189567 0.1044918 ...<br>
            0.6189567 1.01 0.1296157 ...<br>
            0.1044918 0.1296157 1.01 ...<br>
            ...
        </text>
    </div>
    <p>There should be an annotation file for each locus that contains a matrix of annotations that are typically binary
        although continous annotations are allowed as well. Each row in the matrix corresponds to a specific SNP at the
        locus, while each column represents a unique annotation. For instance, if the first column of the matrix represented
        "coding" region, and entry [1,1] of the matrix was equal to 1, this would signify that SNP 1 falls within a coding
        region.</p>
    <p>An example of the fuctional annotation matrix is shown below(it is not necessary to include all of the following
        columns):</p>
    <div class="data">
        <text>
            Coding Promoter UTR DHS Intron Intergenic<br>
            0 0 0 1 0 0<br>
            0 0 0 1 0 0<br>
            0 0 0 0 1 0<br>
            ...
        </text>
    </div>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 2: Specify the corresponding parameter</span>
    </el-divider>
    <img src="../../assets/tutorial/paintor/3.png" alt="step2" style="width: 80%;">
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
                <td>Input the name of the annotation to include in the model</td>
                <td>(not required)The names of the annotations to include in model. This parameter is to be specified when
                    uploading the function annotation matrix. Otherwise it is not required.</td>
            </tr>
            <tr>
                <td>The zscore column name in the input GWAS file</td>
                <td>Specify the zscore column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input GWAS file</td>
                <td>Specify the SNPrsID column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>Specify this flag to enumerate all possible configurations followed by the max number of causal SNPs
                </td>
                <td>Specify this flag if you want to enumerate all possible configurations followed by the max number of
                    causal SNPs (eg. -enumerate 3 considers up to 3 causals at each locus)</td>
            </tr>
            <tr>
                <td>specify the size of causals to pre-compute enrichments with</td>
                <td>(not required)Specify the number of causals to pre-compute enrichments with. The default value is 2.
                </td>
            </tr>
        </tbody>
    </table>
    <p>It is crucial to carefully configure these parameters to ensure the accuracy and reliability of the analysis process.
    </p>
    <p>In order to receive an email about the results, you can enter your email at the mail icon in the top
        right hand
        corner of the website:
    </p>
    <img src="../../assets/tutorial/paintor/4.png" alt="step2" style="width: 80%;">
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 3: Run and get a job ID</span>
    </el-divider>
    <img src="../../assets/tutorial/paintor/5.png" alt="step3" style="width: 80%;">
    <p>Then you will get a job id like this:</p>
    <img src="../../assets/tutorial/paintor/6.png" alt="step3" style="width: 80%;">
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
    <img src="../../assets/tutorial/paintor/7.png" alt="step4" style="width: 80%;">
    <p>There will also be run fail emails.</p>
    <p>You can also preview and download the results ﬁle on the Result page:</p>
    <img src="../../assets/tutorial/paintor/8.png" alt="step4" style="width: 80%;">
    <p>Clicking on the display button, you can preview the result ﬁles and download the ﬁles you want:</p>
    <img src="../../assets/tutorial/paintor/9.png" alt="step4" style="width: 80%;">
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
                <td>Log.BayesFactor</td>
                <td>This file contains the sum of the log bayes factors.</td>
            </tr>
            <tr>
                <td>Enrichment.Values</td>
                <td>A file that has the effect size estimates for each of the annotation(s) used. PAINTOR automatically
                    estimates the baseline annotation (A0) and will always output this values as the first line in the file.
                    These effect sizes can be converted to probabilities using the expit transformation.</td>
            </tr>
            <tr>
                <td>img.png</td>
                <td>The results are visualised in this file. The x-axis is the rs_id data in locus.results and the y-axis is
                    the Posterior_Prob data in that file.</td>
            </tr>
            <tr>
                <td>locus.results</td>
                <td>This file contains the posterior probabilities for snps to be causal. It will contain the input data
                    with an additional Posterior_Prob column appended.</td>
            </tr>
            <tr>
                <td>locus.enrich</td>
                <td>This file contains gamma estimates.</td>
            </tr>
        </tbody>
    </table>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 5: Browse the visualization of results</span>
    </el-divider>
    <p>In the Charts page, you can browse the visualization of results:</p>
    <img src="../../assets/tutorial/paintor/10.png" alt="step5" style="width: 80%;">
    <p>The x-axis is the rs_id data in locus.results and the y-axis is the Posterior_Prob data in that file. Click on each
        point to see the details of the SNP.</p>
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