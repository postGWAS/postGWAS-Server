<!-- paintor 组件 -->
<template>
    <div>
        <h2>Paintor</h2>

        <div class="intro">
            <article align="left">
                <h4 style="
                                    font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>Paintor is a probabilistic framework that integrates association strength with functional genomic
                    annotation data to improve accuracy in selecting plausible causal variants for functional validation.
                </p>
                <p>A key feature of Paintor is that it empirically estimates the contribution of each functional annotation
                    to the trait of interest directly from summary association statistics while allowing for multiple causal
                    variants at any risk locus. Paintor outputs a probability for a SNP to be causal which can subsequently
                    be used to prioritize variants.</p>
                <p>Paintor requires input of <em><strong>summary association statistics</strong></em>, <em><strong>LD
                            matrix</strong></em> and <em><strong>functional annotation matrix</strong></em>.</p>
                <p>Its output has <br>(i)<em><strong>locus.results:</strong></em> the posterior probabilities that snp is
                    causal
                    will be output to
                    .results file and it contains the input data.<br>(ii) <em><strong>Enrichment.Values:</strong></em> the
                    effect size is estimated for
                    each used annotation. These effect sizes can be converted into a priori probabilities.<br>(iii)
                    <em><strong>Log.BayesFactor:</strong></em> this file contains the sum of the log Bayesian
                    coefficients.<br>(iiii) <em><strong>locus.enrich:</strong></em> gamma
                    estimation.
                </p>

                <p>Original software package is available at
                    <el-link type="primary" href="https://github.com/gkichaev/PAINTOR_V3.0" target="_blank">
                        GitHub <el-icon class="el-icon--right">
                            <View />
                        </el-icon>
                    </el-link>.
                </p>
            </article>
        </div>

        <div class="inputCard">
            <h4>1.Upload a GWAS file
                <el-tooltip class="item" effect="dark" content="At least includes zscore, rs_id." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('paintorGwas')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.Upload a GWAS LD file
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('paintorGwasLd.ld')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasLdChild" />
        </div>

        <div class="inputCard">
            <h4>3.Upload a functional annotation matrix file (not mandatory)
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('paintorMatrix.annotations')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="annotsChild" />
        </div>

        <div class="inputCard">
            <h4>4.Input the name of the annotation to include in the model (not mandatory)
                <el-tooltip class="item" effect="dark" content="Input the names of the annotations to include in model."
                    placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="annotations" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>5.The zscore column name in the input GWAS file</h4>
            <el-input class="input" v-model="zscore" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>6.The rs_id column name in the input GWAS file</h4>
            <el-input class="input" v-model="rsid" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>7.Specify this flag to enumerate all possible configurations followed by the max
                number of causal SNPs</h4>
            <el-input class="input" v-model="enumerate" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h3>Additional parameters (not mandatory)</h3>
        <!-- <h4>7.1.Specify this flag if you want to enumerate all possible configurations followed by the max
                number of causal SNPs</h4>
                <el-input class="input" v-model="enumerate" placeholder="Please input" /> -->
            <h4>8.specify the size of causals to pre-compute enrichments with</h4>
            <el-input class="input" type="number" v-model.number="max_casual" placeholder="Please input" />
        </div>

        <br>

        <el-button class="button" type="primary" round @click="runPaintor(); func.clickHandler($event)">RUN
            Paintor</el-button>

        <!-- 展示结果 -->
        <el-dialog v-model="showJobId" title="Job ID" width="30%" center>
            <span>
                The job ID is: <el-input v-model="jobID" readonly id="jobIdInput" @focus="getInputFocus($event)" />
            </span>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="showJobId = false; func.clickHandler($event)">Cancel</el-button>
                    <el-button type="primary" @click="clickToCopy(); func.clickHandler($event)">
                        Copy Job ID
                    </el-button>
                    <el-button type="success" @click="navigateToResult(jobID);
                    func.clickHandler($event);
                    showJobId = false">
                        Check result
                    </el-button>
                </span>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import check from '../../utils/check';
import { ElMessage } from 'element-plus';
import finemappingAPI from '../../api/finemapping.js';
import indexAPI from '@api';
import { useEmailStore } from '@stores';
import { func } from '@utils/button.js';
import navigateToResult from '@utils/navigator.js';


// 邮箱存储
const emailStore = useEmailStore;
// const emit = defineEmits(["mailInputMethod"]);

const downloadFile = (fileName) => {
    indexAPI.downloadFile(fileName);
}

// 定义一个组件对象
const gwasChild = ref();
const gwasLdChild = ref();
const annotsChild = ref();

// 父组件中存储已上传文件列表
var gwasFile = ref();
var gwasLdFile = ref();
var annotsFile = ref();

onMounted(() => {
    gwasFile.value = gwasChild.value.file_list;
    gwasLdFile.value = gwasLdChild.value.file_list;
    annotsFile.value = annotsChild.value.file_list;
});

const annotations = ref();
const zscore = ref();
const rsid = ref();
const enumerate = ref();
// const mi = ref();
const max_casual = ref();
// const gaminital = ref();

// 展示JobID
const showJobId = ref(false);
const jobID = ref('');
// 选中jobID
const getInputFocus = (event) => {
    event.currentTarget.select();
}
// 一键复制
const clickToCopy = async () => {
    //执行复制
    await navigator.clipboard.writeText(jobID.value);
    ElMessage.success('Successfully copied!');
}

const runPaintor = () => {
    if (dataCheck()) {
        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
                ld: gwasLdFile.value[0].name.response.data.id,
                annots: check.isFilesNull(annotsFile) ? null : annotsFile.value[0].name.response.data.id
            },
            annotations: check.isInputIllegal(annotations) ? null : annotations.value,
            zscore: zscore.value,
            rsid: rsid.value,
            args: {
                enumerate: enumerate.value,
                // mi: mi.value,
                maxCasual: max_casual.value,
                // gaminital: gaminital.value
            },
            email: emailStore.email,
        }
        finemappingAPI.reqPaintor(data).then((res) => {
            if (res.data.code === 200) {
                // 展示任务id
                showJobId.value = true;
                jobID.value = res.data.data.jobId;
            } else {
                ElMessage.error(res.data.message);
            }
        }).catch((err) => {
            ElMessage.error(err);
        });
    }
}

const dataCheck = () => {

    gwasFile.value = gwasChild.value.file_list;
    gwasLdFile.value = gwasLdChild.value.file_list;
    annotsFile.value = annotsChild.value.file_list;

    // if (emailStore.email === undefined) {
    //     emit('mailInputMethod');
    //     return false;
    // }

    if (check.isFilesNull(gwasFile)) {
        ElMessage.error('Please upload gwas file');
        return false;
    }

    if (check.isFilesNull(gwasLdFile)) {
        ElMessage.error('Please upload gwas LD file');
        return false;
    }

    // if (check.isFilesNull(annotsFile)) {
    //     ElMessage.error('Please upload annots file');
    //     return false;
    // }

    // if (check.isInputIllegal(annotations)) {
    //     ElMessage.error('Please input annotations');
    //     return false;
    // }

    if (check.isInputIllegal(zscore)) {
        ElMessage.error('Please input zscore');
        return false;
    }

    if (check.isInputIllegal(rsid)) {
        ElMessage.error('Please input rs_id');
        return false;
    }

    if (check.isInputIllegal(enumerate)) {
        ElMessage.error('Please input enumerate');
        return false;
    }

    // 验证通过
    return true;
}
</script>

<style scoped>
.intro {
    border: 1px solid #1296DB;
    border-radius: 5px;
    padding: 10px;
    background-color: #d6eaff;
    box-shadow: 0px 0px 3px #1296DB;
}

article {
    font-size: 17px;
    line-height: 1.5;
}

.inputCard {
    text-align: left;
}

.input {
    width: 50%;
    margin-left: 2%;
}

.button {
    margin-top: 15px;
}

.fileIcon {
    margin-left: 4px;
    cursor: pointer;
}
</style>
