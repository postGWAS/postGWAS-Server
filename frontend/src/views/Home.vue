<template>
    <div class="container">
        <!-- 左部分 -->
        <div class="container__half">
            <img src="../assets/images/image2.webp" style="margin-top: 3%; margin-right: 5%;" />
        </div>

        <!-- 右部分 -->
        <div class="container__half">
            <h2>Welcome to postGWAS Server !</h2>
            <el-divider style="margin-left: 10%; width: 80%;">
                <el-icon><star-filled /></el-icon>
            </el-divider>
            <div>
                <p class="intro">This webpage makes it very easy for the user to carry out the postGWAS analysis without
                    the need to download the appropriate software and configuring the relevant environment. In summary,
                    nine methods can be used to calculate causal genes or causal SNPs, including FUSION, CAVIAR, CAVIARBF,
                    PAINTOR,
                    FINEMAP, eCAVIAR, coloc, fastENLOC, and S-PrediXcan, which are divided into three main categories:
                    fine-mapping, co-localization, and TWAS. By uploading the necessary GWAS summary statistics and some
                    other necessary data, and selecting the method to perform the appropriate analysis, the preferred causal
                    genes are obtained to facilitate further research by the researcher.</p>
            </div>
        </div>
    </div>

    <br><br>

    <div class="links">

        <div class="link" @click="$router.push({ path: '/finemapping/caviar' })">
            <el-image :src="image2" class="icon"></el-image>
            <div>
                <h3>Finemapping</h3>
                <div class="desc">
                    <ul>
                        <li>A common option for post-GWAS analyses.</li>
                        <!-- <li>Focus on statistical approaches and models.</li> -->
                        <li>Identify causal variants for complex diseases or traits.</li>
                        <li>Posterior probabilities being the causal variant are calculated for each SNP.</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="link" @click="$router.push({ path: '/colocalization/coloc' })">
            <el-image :src="image1" class="icon"></el-image>
            <div>
                <h3>Colocalization</h3>
                <div class="desc">
                    <ul>
                        <li>Focus on quantifying the probability of colocalization signals of two distinct traits
                            surrounding a suspected causal variant.</li>
                        <li>An important tool in identifying causal genes or variants in complex traits.</li>
                        <li>Help researchers narrow down the list of potential candidate genes or variants for further study.
                        </li>
                    </ul>
                </div>
                
            </div>
        </div>
        <div class="link" @click="$router.push({ path: '/twas/fusionlasso' })">
            <el-image :src="image3" class="icon"></el-image>
            <div>
                <h3>TWAS</h3>
                <div class="desc">
                    <ul>
                        <li>Has attracted much interest in the field of complex disease.</li>
                        <li>A gene-based association approach.</li>
                        <li>Identify transcriptionally regulated genes underlying complex traits and diseases.</li>
                    </ul>
                </div>
            </div>
        </div>

    </div>
</template>

<style scoped>
.desc {
    width: 90%;
    margin-left: 5%;
    text-align: left;
    line-height: 3ex;
    font-size: 18px;
    font-family: Georgia;
}

.intro {
    display: inline-block;
    vertical-align: middle;
    text-align: left;
    width: 80%;
    text-indent: 3ex;
    line-height: 3ex;
    font-size: 18px;
    font-family: Georgia;
}

div {
    text-align: center;
}

.icon {
    margin-top: 8px;
    margin-left: 8px;
    margin-right: 8px;
    height: 150px;
    width: 150px;
}

.links {
    display: flex;
    justify-content: space-between;
    width: 90%;
    margin-left: 5%;
}

.link {
    width: 30%;
    margin-left: 25px;
    border: 1px solid #000;
    border-radius: 25px;
    cursor: pointer;
    box-shadow: 5px 5px 10px gray;
}

.link:hover {
    border: 1px solid #000;
    border-radius: 25px;
    cursor: pointer;
    box-shadow: 5px 5px 10px rgb(53, 50, 50);
}

.container {
    display: flex;
}

.container__half {
    flex: 1;
}

h2 {
    font-family: "Trebuchet MS", sans-serif;
    font-size: 30px;
    letter-spacing: -2px;
    text-transform: uppercase;
}
</style>

<script setup>

const image1 = new URL('../assets/images/image7.webp', import.meta.url).href;
const image2 = new URL('../assets/images/image8.webp', import.meta.url).href;
const image3 = new URL('../assets/images/image9.webp', import.meta.url).href;

const emit = defineEmits(["mailInputMethod"]);
// eslint-disable-next-line no-unused-vars
const doEmit = () => {
    emit('mailInputMethod');
}

</script>