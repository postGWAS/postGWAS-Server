<template>
    <h2>S-Predixcan(Elastic net) Analysis</h2>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 1: Upload the input data</span>
    </el-divider>

    <img src="../../assets/tutorial/spredixcanenet/0.png" alt="step1" style="width: 80%;">
    <p>Please note that the uploaded file size should not exceed 500 Mb. It must be a space-separated text file with the
        first row being the column name of each column. SNPrsID, effect allele, non-effect allele and zscore columns should
        be included in the GWAS summary statistics as a minimum.
    </p>
    <p>
        An example of the GWAS summary statistics with SNPrsID is shown below:
    </p>

    <div class="data">
        <text>
            rs_id effect_allele non_effect_allele zscore chromosome position<br>
            rs6666923 T C -2.0826504 1 201248831<br>
            rs845202 A G -0.30275157 1 7404315<br>
            rs4950466 C T -0.5704896 1 147653385<br>
            …
        </text>
    </div>

    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 2: Specify the corresponding parameter</span>
    </el-divider>

    <img src="../../assets/tutorial/spredixcanenet/1.png" alt="step2" style="width: 80%;">
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
                <td>Choose tissue</td>
                <td>A total of 47 tissues can be selected.</td>
            </tr>

            <tr>
                <td>The zscore column name in the input GWAS file</td>
                <td>Specify the zscore column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input GWAS file.</td>
                <td>Specify the SNPrsID column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The effect allele name in the input GWAS file</td>
                <td>Specify the effect allele column of your uploaded GWAS file.</td>
            </tr>
            <tr>
                <td>The non-effect allele name in the input GWAS file</td>
                <td>Specify the non-effect allele column of your uploaded GWAS file.</td>
            </tr>
        </tbody>
    </table>
    <p>It is crucial to carefully configure these parameters to ensure the accuracy and reliability of the analysis process.
    </p>
    <p>In order to receive an email about the results, you can enter your email at the mail icon in the top
        right hand
        corner of the website:
    </p>
    <img src="../../assets/tutorial/spredixcanenet/2.png" alt="step2" style="width: 80%;">
    
    <el-divider content-position="left">
        <span style="font-size: large;">Step 3: Run and get a job ID</span>
    </el-divider>
    <img src="../../assets/tutorial/spredixcanenet/3.png" alt="step3" style="width: 80%;">
    <p>Then you will get a job id like this:</p>
    <img src="../../assets/tutorial/spredixcanenet/4.png" alt="step3" style="width: 80%;">
    <p>You can click on the Check result button to jump directly to the results page to see the status of the job. You can
        also click on the Copy Job ID button to copy the job ID, or click on the cancel button to close the window.
    </p>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 4: Receive an email with download link or download in the
            result page</span>
    </el-divider>
    <p>If you enter your email address, you will receive an email like the following:</p>
    <img src="../../assets/tutorial/spredixcanenet/5.png" alt="step4" style="width: 80%;">
    <p>There will also be run fail emails.</p>
    <p>You can also preview and download the results ﬁle on the Result page:</p>
    <img src="../../assets/tutorial/spredixcanenet/6.png" alt="step4" style="width: 80%;">
    <p>The Status column allows you to view the status of the job, and the Create Time and Finish Time columns allow you to
        view the running time of the job. Clicking on the display button, you can preview the result files and download the
        files you want:</p>
    <img src="../../assets/tutorial/spredixcanenet/7.png" alt="step4" style="width: 80%;">
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
                <td>result.out</td>
                <td>This file contains gene, gene_name, S-PrediXcan association results for this gene(zscore) and p-value.
                </td>
            </tr>
            <tr>
                <td>img.png</td>
                <td>The results are visualised in this file. The y-axis is the pvalue in the result.out file taken as its
                    negative logarithm, i.e. -log10(pvalue), and the x-axis is the gene_name column in that file.</td>
            </tr>
            <tr>
                <td>Readme.txt</td>
                <td>A brief description of the method and results.</td>
            </tr>
            <tr>
                <td>Img2.png</td>
                <td>The results are visualised in this file. The y-axis is the zscore column in the result.out file, and the
                    x-axis is the gene_name column.</td>
            </tr>
        </tbody>
    </table>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 5: Browse the visualization of results</span>
    </el-divider>
    <p>In the Charts page, you can browse the visualization of results:</p>
    <img src="../../assets/tutorial/spredixcanenet/8.png" alt="step5" style="width: 80%;">
    <p>The y-axis is the pvalue in the result.out file taken as its negative logarithm, i.e. -log10(pvalue), and the x-axis
        is the gene_name column in that file. Click on each point to see the details of the gene.</p>
    <img src="../../assets/tutorial/spredixcanenet/9.png" alt="step5" style="width: 80%;">
    <p>The y-axis is the zscore column in the result.out file, and the x-axis is the gene_name column. Click on each point
        to see the details of the gene.</p>
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