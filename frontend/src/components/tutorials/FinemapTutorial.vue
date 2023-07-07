<template>
    <h2>FINEMAP Analysis</h2>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 1: Upload the input data</span>
    </el-divider>

    <img src="../../assets/tutorial/finemap/1.png" alt="step1" style="width: 80%;">
    <p>Please note that the uploaded ﬁle size should not exceed 500 Mb. It must be a space-separated text ﬁle with the ﬁrst
        row being the column name of each column. SNPrsID, chromosome, position, allele1, allele2, maf, beta and se columns
        should be included in the GWAS summary statistics as a minimum.
    </p>
    <p>
        An example of the GWAS summary statistics format is shown below:
    </p>

    <div class="data">
        <text>
            rsid chromosome position allele1 allele2 maf beta se<br>
            rs1 01 1 A G 0.225992914413574 -0.0694412046752001 0.0233439234331889<br>
            rs2 01 2 A G 0.415625582696252 -0.0044399436444764 0.0197571804747788<br>
            rs3 01 3 A G 0.471844117098639 0.0475792027169957 0.0196367515381518<br>
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
            1 0.597672916350786 0.339387856703675 ...<br>
            0.597672916350786 1 0.622540962863562 ...<br>
            0.339387856703675 0.622540962863562 1 ...<br>
            ...
        </text>
    </div>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 2: Specify the corresponding parameter</span>
    </el-divider>
    <img src="../../assets/tutorial/finemap/2.png" alt="step2" style="width: 80%;">
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
                <td>The beta column name in the input GWAS ﬁle</td>
                <td>Specify the beta column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The rs_id column name in the input GWAS ﬁle</td>
                <td>Specify the SNPrsID column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The chromosome column name in the input GWAS ﬁle</td>
                <td>Specify the chromosome column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The position column name in the input GWAS ﬁle</td>
                <td>Specify the position column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The effect allele column name in the input GWAS ﬁle</td>
                <td>Specify the eﬀect allele column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The non-eﬀect allele column name in the input GWAS ﬁle</td>
                <td>Specify the non-eﬀect allele column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The maf column name in the input GWAS ﬁle</td>
                <td>Specify the maf column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The se column name in the input GWAS ﬁle</td>
                <td>Specify the se column of your uploaded GWAS ﬁle.</td>
            </tr>
            <tr>
                <td>The size of GWAS samples</td>
                <td>Specify the size of GWAS samples.</td>
            </tr>
            <tr>
                <td>Specify the maximum number of allowed causal SNPs</td>
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
    <img src="../../assets/tutorial/finemap/3.png" alt="step2" style="width: 80%;">
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 3: Run and get a job ID</span>
    </el-divider>
    <img src="../../assets/tutorial/finemap/4.png" alt="step3" style="width: 80%;">
    <p>Then you will get a job id like this:</p>
    <img src="../../assets/tutorial/finemap/5.png" alt="step3" style="width: 80%;">
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
    <img src="../../assets/tutorial/finemap/6.png" alt="step4" style="width: 80%;">
    <p>There will also be run fail emails.</p>
    <p>You can also preview and download the results ﬁle on the Result page:</p>
    <img src="../../assets/tutorial/finemap/7.png" alt="step4" style="width: 80%;">
    <p>Clicking on the display button, you can preview the result ﬁles and download the ﬁles you want:</p>
    <img src="../../assets/tutorial/finemap/8.png" alt="step4" style="width: 80%;">
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
                <td>data.conﬁg</td>
                <td>This ﬁle contains the posterior summaries for each causal conﬁguration one per line. Prob column
                    contains the posterior probabilities that conﬁgurations are the causal conﬁguration.</td>
            </tr>
            <tr>
                <td>data.cred3/data.cred2</td>
                <td>The ﬁle will be followed by a number which represents the number of causal SNPs. For example, a 2 in
                    .cred2 means that the number of causal SNPs is 2. It contains posterior probabilities for each SNP of
                    being in the credible set, log10 Bayes factors and so on. For speciﬁc k, FINEMAP takes the k-SNP causal
                    conﬁguration with highest posterior probability and then asks, for the l th SNP in that set, which are
                    the other candidates that could possibly replace that SNP in this causal conﬁguration. The l th credible
                    set shows the best candidate SNPs and their posterior probability of being in a k-SNP causal
                    conﬁguration that additionally contains k - 1 SNPs.</td>
            </tr>
            <tr>
                <td>img2.png</td>
                <td>The results are visualised in this ﬁle. The conﬁg data (SNP identiﬁer) in the data.conﬁg ﬁle is used as
                    the x-axis and the rank (if more than ﬁve rows, only the ﬁrst ﬁve rows are displayed) data in the
                    data.conﬁg ﬁle is used as the y-axis. The conﬁguration data (SNP identiﬁer) in the data.conﬁg ﬁle is
                    displayed on the bar of the bar, and the speciﬁc probability value that the conﬁguration is a causal
                    conﬁguration is displayed on the left side of the bar.</td>
            </tr>
            <tr>
                <td>data.log_sss</td>
                <td>This ﬁle contains log information about the operation of FINEMAP.</td>
            </tr>
            <tr>
                <td>data.snp</td>
                <td>Each row is a SNP, and diﬀerent results are obtained when diﬀerent causal SNPs are assumed. This ﬁle
                    contains the GWAS summary statistics and model-averaged posterior summaries for each SNP one per line.
                    Prob column contains the marginal Posterior Inclusion Probabilities (PIP).</td>
            </tr>
            <tr>
                <td>img.png</td>
                <td>The results are visualised in this ﬁle. The x-axis is the SNPrsID data in the data.snp ﬁle and the
                    y-axis is the prob data in the data.snp ﬁle.</td>
            </tr>
        </tbody>
    </table>
    <br>
    <el-divider content-position="left">
        <span style="font-size: large;">Step 5: Browse the visualization of results</span>
    </el-divider>
    <p>In the Charts page, you can browse the visualization of results:</p>
    <img src="../../assets/tutorial/finemap/9.png" alt="step5" style="width: 80%;">
    <p>The x-axis is the SNPrsID data in the data.snp ﬁle and the y-axis is the prob data in the data.snp ﬁle. Click on each
        point to see the details of the SNP.</p>
    <img src="../../assets/tutorial/finemap/10.png" alt="step5" style="width: 80%;">
    <p>The conﬁg data (SNP identiﬁer) in the data.conﬁg ﬁle is used as the x-axis and the rank (if more than ﬁve rows, only
        the ﬁrst ﬁve rows are displayed) data in the data.conﬁg ﬁle is used as the y-axis. Click on the bars of the bar
        graph to see the details of each causal conﬁguration.</p>
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