<!-- 关于页面 -->
<template>
    <div class="main">

        <h2>Introductions</h2>
        <el-divider content-position="left">
            <div class="divierName">Colocalization</div>
        </el-divider>
        <ul class="cards">
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>COLOC</h3>
                        <div class="card_text">
                            <p>A key feature of COLOC is the ability to derive the output statistics from
                                single SNP summary statistics, hence making it possible to perform
                                systematic meta-analysis type comparisons across multiple GWAS datasets.
                            </p>
                            <p>It
                                provides information about candidate causal genes in associated intervals
                                and has direct implications for the understanding of complex diseases as
                                well as the design of drugs to target disease pathways. It requires input
                                of GWAS data and eQTL data(including at least rs_id, pval, variant_id and
                                maf).Its output is need_result.txt(a file contains the causal SNP).
                            </p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/colocalization/coloc' })"
                                round>COLOC</el-button></div>
                    </div>
                </div>
            </li>
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>eCAVIAR</h3>
                        <div class="card_text">
                            <p>eCAVIAR is a probabilistic method that has several key advantages over
                                existing methods. First, it can account for more than one causal variant in
                                any given locus. Second, it can leverage summary statistics without
                                accessing the individual genotype data. eCAVIAR Computes the colocalization
                                posterior probability for a GWAS and eQTL Study.
                            </p>
                            <p>The goal of eCAVIAR is to
                                identify target genes and the most relevant tissues for a given GWAS risk
                                locus while accounting for the uncertainty of LD. eCAVIAR is a valuable
                                tool for finemapping complex trait loci, and can provide insights into the
                                genetic basis of complex diseases and traits. eCAVIAR requires the input of
                                GWAS data, eQTL data, GWAS LD matrix and eQTL LD matrix.
                            </p>
                            <p>Its output has①log_col: it contains the co-localization posterior probability (CLPP) for
                                each SNP. CLPP is equal to the product of the posterior probability that
                                the variant is causal in the GWAS and the posterior probability that the
                                variant is causal in the eQTL study.②log_col_sorted: sorted according to
                                the CLPP.③log_1_post: the causal posterior probability of each SNP in GWAS
                                data.④log_1_post_sorted: each SNP is ranked according to its causal
                                posterior probability in GWAS data.⑤log_2_post: the causal posterior
                                probability of each SNP in the eQTL data.⑥log_2_post_sorted: each SNP is
                                ranked according to its causal posterior probability in eQTL
                                data.⑦log_1_set: causal SNP in GWAS data.⑧log_1_set_sorted: causal SNP in
                                GWAS data and each SNP is ranked according to its causal posterior
                                probability in GWAS data.⑨log_2_set: causal SNP in eQTL
                                data.⑩log_2_set_sorted: causal SNP in eQTL data and each SNP is ranked
                                according to its causal posterior probability.
                            </p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/colocalization/ecaviar' })"
                                round>eCAVIAR</el-button></div>
                    </div>
                </div>
            </li>
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>fastENLOC</h3>
                        <div class="card_text">
                            <p>fastENLOC is a genomic method for identifying regulatory factors of gene
                                expression, based on gene expression and genotype data. fastENLOC is a
                                powerful genomic tool that can aid researchers in better understanding gene
                                expression regulation and disease mechanisms, providing new insights and
                                strategies for disease prediction, diagnosis, and treatment.</p>
                            <p>
                                It requires
                                the input of GWAS data(variant_id\rs_id, loc_id, zscore) and eQTL
                                annotation file. The eQTL annotation file can be specified by the user, or
                                you can use Multi-tissue eQTL annotation with hg38 position ID and also
                                Multi-tissue eQTL annotation with rs ID. </p>
                            <p>
                                Its output
                                has①Height_Blood.enloc.enrich.out: enrichment analysis
                                result.②Height_Blood.enloc.sig.out: signal-level colocalization
                                result.③Height_Blood.enloc.snp.out: SNP-level colocalization
                                result.④Height_Blood.enloc.gene.out: gene-level colocalization
                                result.⑤Height_Blood.enloc.sig.extract.out: screening based on regional
                                colocalization probability (RCP)
                                thresholds.⑥Height_Blood.enloc.gene.extract.out: screening based on gene
                                variant-level colocalization probability(GRCP) thresholds.</p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/colocalization/fastenloc' })"
                                round>fastENLOC</el-button></div>
                    </div>
                </div>
            </li>
        </ul>

        <el-divider content-position="left">
            <div class="divierName">Finemapping</div>
        </el-divider>
        <ul class="cards">
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>CAVIAR</h3>
                        <div class="card_text">
                            <p>CAVIAR (CAusal Variants Identification in Associated Regions) is a Bayesian
                                statistical method for fine-mapping potential causal variants within a
                                given signal-associated region, based on prior information and GWAS data.</p>
                            <p>
                                The basic idea of CAVIAR is to compute the posterior probability that each
                                variant is the causal variant, given a GWAS region, by decomposing the
                                likelihood function with Bayesian methods. This method considers linkage
                                disequilibrium between different variants, can handle joint analysis of
                                multiple variants, and can incorporate both genotype and phenotype
                                information in a region. CAVIAR is a powerful tool for identifying
                                potential causal variants in GWAS data, which can provide important
                                information for further functional studies and clinical applications. </p>
                            <p>
                                CAVIAR requires input of GWAS data and LD matrix. Its output has ①log_set:
                                causal SNP set.②log_post: causal posterior probability for each
                                SNP.③log_set_sorted: the causal SNPs are sorted according to the posterior
                                probability and the posterior probability are then added to the
                                file.④log_post_sorted: all SNPs were ranked according to posterior
                                probability.</p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/finemapping/caviar' })"
                                round>CAVIAR</el-button></div>
                    </div>
                </div>
            </li>
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>FINEMAP</h3>
                        <div class="card_text">
                            <p>FINEMAP is a novel software package to efficiently explore a set of the
                                most important causal configurations of the region via a shotgun stochastic
                                search algorithm. FINEMAP uses a Shotgun Stochastic Search (SSS) algorithm
                                (Hans et al., 2007) that explores the vast space of causal configurations
                                by concentrating efforts on the configurations with non-negligible
                                probability.
                            </p>
                            <p>FINEMAP can be used to: (i) identify causal SNPs; (ii)
                                estimate the effect size of causal SNPs; and (iii) estimate the genetic
                                contribution of causal SNPs. In addition, one convenient aspect of FINEMAP
                                is that after setting the maximum number of causal SNPs k, the obtained
                                results contain the posterior probabilities of 1 to k different causal SNPs
                                and the probabilities of the number of individual causal SNPs, which is
                                very convenient for the subsequent analysis.
                            </p>
                            <p>FINEMAP requires input of Z
                                files and LD matrix. Its output has (i)SNP file: each row is a SNP, and
                                different results are obtained when different causal SNPs are assumed,
                                including a summary of all results, and sorted according to the
                                PIP.(ii)cred file: the file will be followed by a number that represents
                                the number of causal SNPs. For example, a 2 in .cred2 means the number of
                                causal SNPs is 2.(iii) CONFIG file: contains the relevant parameters for
                                each causal configuration.
                            </p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/finemapping/finemap' })"
                                round>FINEMAP</el-button></div>
                    </div>
                </div>
            </li>
        </ul>
        <ul class="cards">
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>Paintor</h3>
                        <div class="card_text">
                            <p>Paintor is a probabilistic framework that integrates association strength
                                with functional genomic annotation data to improve accuracy in selecting
                                plausible causal variants for functional validation.</p>
                            <p>
                                A key feature of
                                Paintor is that it empirically estimates the contribution of each
                                functional annotation to the trait of interest directly from summary
                                association statistics while allowing for multiple causal variants at any
                                risk locus. Paintor outputs a probability for a SNP to be causal which can
                                subsequently be used to prioritize variants. Paintor requires input of
                                summary association statistics, LD matrix and functional annotation matrix.</p>
                            <p>
                                Its output has (i)locus.results: the posterior probabilities that snp is
                                causal will be output to .results file and it contains the input data.(ii)
                                Enrichment.Values: the effect size is estimated for each used annotation.
                                These effect sizes can be converted into a priori probabilities.(iii)
                                Log.BayesFactor: this file contains the sum of the log Bayesian
                                coefficients.(iiii) locus.enrich: gamma estimation.</p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/finemapping/paintor' })"
                                round>Paintor</el-button></div>
                    </div>
                </div>
            </li>
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>CAVIARBF</h3>
                        <div class="card_text">
                            <p>CAVIARBF is a ﬁnemapping tool for identifying potential causal variants within regions where
                                causal variants are assumed to be present in the data.</p>
                            <p>
                                CAVIARBF can be used to prioritise potential causal variants for subsequent functional
                                analysis after genome-wide association studies (GWAS) have been performed. It uses an
                                approximate Bayesian approach and can handle multiple causal variants. </p>
                            <p>
                                The advantage of the CAVIARBF method is that multiple associated SNPs can be analysed
                                jointly, thus improving the precision of estimating the causal eﬀect size of SNPs. In
                                addition, the CAVIARBF method can handle complex linkage disequilibrium structures in the
                                genome, reducing the incidence of false positives.</p>
                            <p>One of the outputs is the marginal posterior probability that each variant is causal.</p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/finemapping/caviarbf' })"
                                round>CAVIARBF</el-button></div>
                    </div>
                </div>
            </li>
        </ul>
        <el-divider content-position="left">
            <div class="divierName">TWAS</div>
        </el-divider>
        <ul class="cards">
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>FUSION</h3>
                        <div class="card_text">
                            <p>Fusion is a method to identify genes whose expression is significantly
                                associated to complex traits in individuals without directly measured
                                expression levels. FUSION leveraged a relatively small set of reference
                                individuals for whom both gene expression and genetic variation have been
                                measured to impute the cis-genetic component of expression into a much
                                larger set of phenotyped individuals from their SNP genotype data.
                            </p>
                            <p>To run
                                the FUSION, you need to prepare the GWAS data and specify the chromosome
                                and tissue. Its output has: ①result.dat: it includes the best predictive
                                model for genes and contains gene-disease associations.②result.top:
                                transcriptome-wide significant associations in
                                result.dat.③result.top.analysis.loc_1.pdf: The top panel shows all of the
                                genes in the locus.
                            </p>
                            <p>The marginally TWAS associated genes are highlighted in
                                blue, and those that are jointly significant (in this case, FAM109B)
                                highlighted in green. The bottom panel shows a Manhattan plot of the GWAS
                                data before (gray) and after (blue) conditioning on the green
                                genes.④result.top.analysis.joint_dropped.dat: the statistics for those
                                genes that were dropped due to being conditionally
                                non-significant.⑤result.top.analysis.joint_included.dat：The statistics for
                                the jointly significant genes.
                            </p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/twas/fusion' })"
                                round>FUSION</el-button></div>
                    </div>
                </div>
            </li>
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>S-PrediXcan</h3>
                        <div class="card_text">
                            <p>S-PrediXcan is a method for predicting the effects of genetic variants on
                                gene expression using summary statistics from genome-wide association
                                studies (GWAS). S-PrediXcan is an extension of PrediXcan, that infers
                                PrediXcan's results using only summary statistics.
                            </p>
                            <p>S-PrediXcan will
                                calculate the gene-level association results from GWAS summary statistics.
                                Only GWAS results are needed for users to run the S-PrediXcan. Its output
                                is a CSV file which includes variance of the gene expression(var_g), gene
                                name(gene_name), significance of the predicted association between
                                expression level and phenotype(pvalue) and so on.
                            </p>
                        </div>
                        <div class="clickBtn"><el-button @click="$router.push({ path: '/twas/spredixcan' })"
                                round>S-PrediXcan</el-button></div>
                    </div>
                </div>
            </li>
        </ul>

    <!-- <ul>
            <li class="cards_item">
                <div class="card" tabindex="0">
                    <div class="card_content">
                        <h3>intro</h3>
                        <div class="card_text">
                            <p>All great meals take time, but this one takes it to the next level! More than 650 hours of
                                fermenting, brining, aging, and curing goes into each and every one of our legendary Reuben
                                sandwiches.
                            </p>
                            <p>Every element of this extraordinary sandwich is handcrafted in our kitchens, from the rye
                                bread baked from our secret recipe to the cave-aged Swiss cheese, right down to the pickle.
                                The only thing we didn't make on the premises is the toothpick ( but we're looking into how
                                to do that).
                            </p>
                            <p>This unforgettable sandwich has all of the classic Reuben elements: <strong>corned beef, rye
                                    bread, creamy Russian dressing, sauerkraut, plus a sweet gherkin pickle.</strong> <em>No
                                    substitions please!</em>
                            </p>
                        </div>
                    </div>
                </div>
            </li>
                                                                                            </ul> -->

    </div>
</template>

<script setup>


</script>

<style scoped>
.divierName {
    font-family: "Trebuchet MS", sans-serif;
    font-weight: bold;
    font-size: 14px;
}

h2 {
    font-family: "Trebuchet MS", sans-serif;
    font-size: 30px;
    letter-spacing: -2px;
    text-transform: uppercase;
}

.clickBtn {
    margin-top: 10px;
}

.el-button {
    background-color: transparent;
}

:root {
    --purple: #603f8b;
    --aqua: #b4fee7;
    --violet: #a16ae8;
    --fuchsia: #fd49a0;
    --white: #efefef;
    --black: #222;
    --trueBlack: #000;
}

*,
*::before,
*::after {
    box-sizing: border-box;
}

body {
    background-color: var(--black);
}

.main {
    margin-top: 2%;
    max-width: 1200px;
}

.cards {
    display: grid;
    flex-wrap: wrap;
    list-style: none;
    margin: 0;
    padding: 0;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
}

.cards_item {
    display: flex;
    margin-top: 3%;
}

.card_image {
    display: flex;
    height: 100px;
    box-shadow: 0 50px 100px 0 var(--violet);
}

.card_image img {
    display: block;
    width: 100%;
    height: auto;
    object-fit: cover;
}

.card {
    display: flex;
    flex-direction: column;
    position: relative;
    overflow: hidden;
    border-radius: 5px 25px 5px 50px;
    transition: transform 0.1s linear, box-shadow 0.2s;
    background-image: linear-gradient(to bottom, #e1f0ff, #edf8fd);
}

.card_text:focus,
.card:focus {
    outline: 2px dashed var(--aqua);
}

.card:focus,
.card:hover {
    transform: scale(1.01);
    box-shadow: 0 10px 5px -5px rgba(0, 0, 0, 0.2);
}

.card_content {
    padding: 0.5rem 1rem 1rem;
    color: var(--white);
}

.card_title {
    position: absolute;
    top: 0;
    right: 0;
    width: 90%;
    height: auto;
    color: var(--black);
    padding: 0.5rem;
    border-radius: 5px 0 0 5px;
    transform: rotate(-3.3deg);
    transform-origin: left top;
    font-family: Georgia, Times, serif;
    font-weight: 600;
    font-size: 1.325rem;
    overflow: hidden;
    z-index: 1;
    background-color: rgba(253, 73, 160, 0.75);
    animation: 0s 0s fly-in 0 reverse both;
}

@media (min-width: 535px) {
    .card_title {
        animation: 0.5s 0.25s fly-out 1 both;
    }
}

.card:focus .card_title,
.card:hover .card_title {
    animation: 0.5s ease-in 0s fly-in 1 both;
}

.card_text {
    font-family: Segoe UI, Frutiger, Frutiger Linotype, Dejavu Sans, Helvetica,
        Helvetica Neue, Arial, sans-serif;
    line-height: 1.5;
    text-size-adjust: 0.2px;
    padding: 0 1rem;
}

.card_text p:first-of-type:first-letter {
    font-size: 1.8em;
    font-family: Georgia, Times, serif;
    margin-right: 0.05em;
}

@media (min-width: 480px) {
    .card_text {
        overflow: auto;
        max-height: 20rem;
        scrollbar-width: thin;
        scrollbar-color: var(--aqua) var(--violet);
    }

    .card_text::-webkit-scrollbar {
        width: 12px;
    }

    .card_text::-webkit-scrollbar-track {
        background: var(--violet);
    }

    .card_text::-webkit-scrollbar-thumb {
        background-color: var(--aqua);
    }
}

.card_text strong {
    color: var(--aqua);
}

.upcharge {
    position: relative;
    font-weight: 600;
    background-color: var(--violet);
    padding: 0.5rem 0.75rem;
    color: var(--trueBlack);
    border-radius: 0 10px;
    z-index: 0;
    overflow: hidden;
}

.upcharge::after,
.upcharge::before {
    content: "+";
    display: block;
    line-height: 0;
    font-size: 3rem;
    position: absolute;
    color: var(--purple);
    z-index: -1;
    opacity: 0.3;
}

.upcharge::before {
    left: 0;
    top: 0.5rem;
}

.upcharge::after {
    right: 0;
    bottom: 1.25rem;
}

.note {
    display: block;
    text-align: center;
    padding: 0.5rem;
    font-weight: 900;
    background-image: linear-gradient(-45deg,
            transparent 10%,
            var(--aqua) 10.5%,
            var(--aqua) 90%,
            transparent 90.5%);
    color: var(--black);
    font-size: 1.3em;
    font-style: italic;
    margin-top: 1rem;
}

@keyframes fly-in {
    0% {
        top: 0;
        right: 0;
        font-size: 1.325rem;
    }

    25% {
        top: 0;
        right: -200%;
        font-size: 1.325rem;
    }

    26% {
        font-size: 2rem;
    }

    100% {
        top: 2rem;
        right: 0;
        font-size: 2rem;
    }
}

@keyframes fly-out {
    0% {
        top: 2rem;
        right: 0;
        font-size: 2rem;
    }

    50% {
        top: 0;
        right: -200%;
        font-size: 1.325rem;
    }

    100% {
        top: 0;
        right: 0;
        font-size: 1.325rem;
    }
}
</style>
