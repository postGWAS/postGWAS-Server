<!-- 教程界面 -->
<template>
    <el-row class="tac">
        <el-col :span="5">
            <el-menu default-active="1-1" class="el-menu-vertical-demo">
                <el-sub-menu index="1">
                    <template #title>
                        <el-icon>
                            <location />
                        </el-icon>
                        <span style="color:darkgray;">About postGWAS Server</span>
                    </template>

                    <el-menu-item index="1-1" @click="handleClick">Introduction</el-menu-item>
                    <!-- <el-menu-item index="1-2" @click="handleClick">Updates</el-menu-item> -->

                </el-sub-menu>
                <el-sub-menu index="2">
                    <template #title>
                        <el-icon>
                            <location />
                        </el-icon>
                        <span style="color:darkgray;">Finemapping</span>
                    </template>

                    <el-menu-item index="2-1" @click="handleClick">FINEMAP</el-menu-item>
                    <el-menu-item index="2-2" @click="handleClick">CAVIAR</el-menu-item>
                    <el-menu-item index="2-3" @click="handleClick">CAVIARBF</el-menu-item>
                    <el-menu-item index="2-4" @click="handleClick">Paintor</el-menu-item>
                </el-sub-menu>

                <el-sub-menu index="3">
                    <template #title>
                        <el-icon>
                            <location />
                        </el-icon>
                        <span style="color:darkgray;">Colocalization</span>
                    </template>

                    <el-menu-item index="3-1" @click="handleClick">Coloc</el-menu-item>
                    <el-menu-item index="3-2" @click="handleClick">eCAVIAR</el-menu-item>
                    <el-menu-item index="3-3" @click="handleClick">fastENLOC</el-menu-item>

                </el-sub-menu>

                <el-sub-menu index="4">
                    <template #title>
                        <el-icon>
                            <location />
                        </el-icon>
                        <span style="color:darkgray;">TWAS</span>
                    </template>

                    <el-menu-item index="4-1" @click="handleClick">FUSION</el-menu-item>
                    <el-menu-item index="4-2" @click="handleClick">S-Predixcan(Mashr)</el-menu-item>
                    <el-menu-item index="4-3" @click="handleClick">S-Predixcan(Elastic net)</el-menu-item>
                </el-sub-menu>
            </el-menu>
        </el-col>
        <el-col :span="19">
            <div style="width: 90%; margin-left: 5%;">
                <!-- index1 -->
                <div v-if="currentMenuItem === '1-1'">
                    <h2>Introduction</h2>
                    <p>Although genome-wide association studies(GWAS) have identified many risk loci associated with complex
                        trait or disease, most GWAS risk loci are located in non-coding regions. This issue is attributed to
                        linkage disequilibrium (LD) existing between causal and non-causal variants. This phenomenon can
                        obscure the effects of causal variants on the relevant phenotype, making them difficult to discern.
                        This is when post-GWAS analyses can help. However, conducting post-GWAS analyses requires
                        researchers to be proficient in computer-related applications, which poses a barrier to researchers
                        with non-computational backgrounds.
                    </p>
                    <p>This web server makes it very easy and efficient for the researchers and bioinformatics enthusiasts
                        to carry out the postGWAS analysis without the need to download the appropriate software and
                        configuring the relevant environment.
                    </p>
                    <p>A tutorial on using the nine methods of analysis is detailed on the following pages. The entirety of
                        the web server's workflow is displayed below.
                    </p>
                    <img src="../assets/tutorial-intro.webp" alt="introduction" style="width: 100%;">
                </div>
            <!-- <div v-if="currentMenuItem === '1-2'">
                    <h2>updates</h2>
                                                            </div> -->

                <!-- index2 -->
                <div v-if="currentMenuItem === '2-1'">
                    <FinemapAnalysis />
                </div>
                <div v-if="currentMenuItem === '2-2'">
                    <CaviarAnalysis />
                </div>
                <div v-if="currentMenuItem === '2-3'">
                    <CaviarbfAnalysis />
                </div>
                <div v-if="currentMenuItem === '2-4'">
                    <PaintorAnalysis />
                </div>

                <!-- index3 -->
                <div v-if="currentMenuItem === '3-1'">
                    <ColocAnalysis />
                </div>
                <div v-if="currentMenuItem === '3-2'">
                    <eCaviarAnalysis />
                </div>
                <div v-if="currentMenuItem === '3-3'">
                    <FastenlocAnalysis />
                </div>

                <!-- index4 -->
                <div v-if="currentMenuItem === '4-1'">
                    <FusionAnalysis />
                </div>
                <div v-if="currentMenuItem === '4-2'">
                    <SpredixcanMashrAnalysis />
                </div>
                <div v-if="currentMenuItem === '4-3'">
                    <SpredixcanEnetAnalysis />
                </div>
            </div>
        </el-col>
    </el-row>
</template>

<script setup>

import { ref } from 'vue';

import CaviarAnalysis from '@tutorials/CaviarTutorial.vue';
import CaviarbfAnalysis from '@tutorials/CaviarbfTutorial.vue';
import FinemapAnalysis from '@tutorials/FinemapTutorial.vue';
import PaintorAnalysis from '@tutorials/PaintorTutorial.vue';
import eCaviarAnalysis from '@tutorials/EcaviarTutorial.vue';
import FastenlocAnalysis from '@tutorials/FastenlocTutorial.vue';
import ColocAnalysis from '@tutorials/ColocTutorial.vue';
import SpredixcanMashrAnalysis from '@tutorials/SpredixcanMashrTutorial.vue';
import SpredixcanEnetAnalysis from '@tutorials/SpredixcanEnetTutorial.vue';
import FusionAnalysis from '@tutorials/FusionTutorial.vue';



const currentMenuItem = ref('1-1');

const handleClick = (item) => {
    currentMenuItem.value = item.index;
    // console.log(currentMenuItem.value);
}

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
    font-size: small;
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