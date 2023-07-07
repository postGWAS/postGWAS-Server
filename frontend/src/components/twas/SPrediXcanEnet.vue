<!-- S-PrediXcan 组件 -->
<template>
    <div>
        <h2>S-PrediXcan (Elastic net)</h2>

        <div class="intro">
            <article align="left">
                <h4 style="
                        font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>S-PrediXcan is a method for predicting the effects of genetic variants on gene expression using summary
                    statistics from genome-wide association studies (GWAS). </p>
                <p>S-PrediXcan is an extension of PrediXcan, that infers PrediXcan's results using only summary statistics.
                </p>
                <p>S-PrediXcan will calculate the gene-level association results from GWAS summary statistics. Only
                    <em><strong>GWAS results</strong></em> are needed for users to run the S-PrediXcan.
                </p>
                <p>Its output is a <em><strong>CSV file</strong></em> which includes variance of the gene expression(var_g),
                    gene name(gene_name),
                    significance of the predicted association between expression level and phenotype(pvalue) and so on.</p>
                <p>Original software package is available at
                    <el-link type="primary" href="https://github.com/hakyimlab/MetaXcan" target="_blank">
                        GitHub <el-icon class="el-icon--right">
                            <View />
                        </el-icon>
                    </el-link>.
                </p>
            </article>
        </div>

        <div class="inputCard">
            <h4>1.Upload a GWAS file
                <el-tooltip class="item" effect="dark"
                    content="At least includes rs_id、effect allele、non_eﬀect_allele、zscore." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('sPrediXcanGwas.gz')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.Choose tissue</h4>
            <el-select v-model="tissue" class="m-2" placeholder="tissue choice" size="large" filterable clearable>
                <el-option v-for="item in tissueOptions" :key="item.label" :label="item.label" :value="item.label" />
            </el-select>
        </div>

        <div class="inputCard">
            <h4>3.The zscore column name in the input GWAS file</h4>
            <el-input class="input" v-model="zscore" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>4.The rs_id column name in the input GWAS file</h4>
            <el-input class="input" v-model="rsid" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>5.The effect allele name in the input GWAS file</h4>
            <el-input class="input" v-model="a1" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>6.The non-effect allele name in the input GWAS file</h4>
            <el-input class="input" v-model="a2" placeholder="Please input" />
        </div>

    <!-- <div class="inputCard">
            <h4>7.The non-effect allele
                <el-tooltip class="item" effect="dark" placement="right-start">
                    <template #content>
                        <div style="font-size: small; margin-left: 2%;">
                            <p>Mashr-based models are recommended. </p>
                            <p>Elastic Net models trained on GTEx v8 data are provided for compatibility
                                reasons but are suboptimal.</p>
                        </div>
                    </template>
                    <el-icon>
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-select v-model="model" class="m-2" placeholder="choose model" size="large" filterable clearable>
                <el-option v-for="item in modelOptions" :key="item.label" :label="item.label" :value="item.value" />
            </el-select>

            </div> -->

        <br>
        <el-button class="button" type="primary" round @click="runSPrediXcan(); func.clickHandler($event)">RUN
            S-Predixcan</el-button>

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
import FileUpload from '../FileUpload.vue';
import { ref, onMounted } from 'vue';
import { ElInput, ElMessage } from 'element-plus';
import check from '../../utils/check.js';
import twasAPI from '../../api/twas.js';
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

// 父组件中存储已上传文件列表
var gwasFile = ref();

// 组件加载完成以后才能去获取组件里的值
onMounted(() => {
    gwasFile.value = gwasChild.value.file_list;
});


const zscore = ref("zscore");
const rsid = ref("rs_id");
const a1 = ref("A1");
const a2 = ref("A2");

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

const runSPrediXcan = () => {
    if (dataCheck()) {
        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
            },
            tissue: tissue.value,
            zscore: zscore.value,
            rsid: rsid.value,
            a1: a1.value,
            a2: a2.value,
            email: emailStore.email,
        }
        twasAPI.runSPrediXcanEnet(data).then((res) => {
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

    // if (emailStore.email === undefined) {
    //     emit('mailInputMethod');
    //     return false;
    // }

    if (check.isFilesNull(gwasFile)) {
        ElMessage.error('Please upload gwas file');
        return false;
    }

    if (check.isInputIllegal(tissue)) {
        ElMessage.error('Please choose tissue');
        return false;
    }

    if (check.isInputIllegal(zscore)) {
        ElMessage.error('Please input zscore');
        return false;
    }

    if (check.isInputIllegal(rsid)) {
        ElMessage.error('Please input rs_id');
        return false;
    }

    if (check.isInputIllegal(a1)) {
        ElMessage.error('Please input effect allele');
        return false;
    }

    if (check.isInputIllegal(a2)) {
        ElMessage.error('Please input non-effect allele');
        return false;
    }

    return true;
}

// const model = ref();
// const modelOptions = [
//     { label: "Mashr-based", value: "Mashr-based" },
//     { label: "Elastic Net", value: "Elastic Net" },
// ];

const tissue = ref("Whole_Blood");
const tissueOptions = [
    { label: "Adipose_Subcutaneous" },
    { label: "Adipose_visceral_Omentum" },
    { label: "Adrenal_Gland" },
    { label: "Artery_Aorta" },
    { label: "Artery_Coronary" },
    { label: "Artery_Tibial" },
    { label: "Brain_Amygdala" },
    { label: "Brain_Anterior_cingulate_cortex_BA24" },
    { label: "Brain_Caudate_basal_ganglia" },
    { label: "Brain_Cerebellar_Hemisphere" },
    { label: "Brain_Cerebellum" },
    { label: "Brain_Cortex" },
    { label: "Brain_Frontal_Cortex_BA9" },
    { label: "Brain_Hippocampus" },
    { label: "Brain_Hypothalamus" },
    { label: "Brain_Nucleus_accumbens_basal_ganglia" },
    { label: "Brain_Putamen_basal_ganglia" },
    { label: "Brain_Spinal_cord_cervical_c_1" },
    { label: "Brain_Substantia_nigra" },
    { label: "Breast_Mammary_Tissue" },
    { label: "Cells_Cultured_ﬁbroblasts" },
    { label: "Cells_EBV_transformed_lymphocytes" },
    { label: "Colon_Sigmoid" },
    { label: "Colon_Transverse" },
    { label: "Esophagus_Gastroesophageal_Junction" },
    { label: "Esophagus_Mucosa" },
    { label: "Esophagus_Muscularis" },
    { label: "Heart_Atrial_Appendage" },
    { label: "Heart_Left_Ventricle" },
    { label: "Kidney_Cortex" },
    { label: "Liver" },
    { label: "Lung" },
    { label: "Minor_Salivary_Gland" },
    { label: "Muscle_Skeletal" },
    { label: "Nerve_Tibial" },
    { label: "Ovary" },
    { label: "Pancreas" },
    { label: "Pituitary" },
    { label: "Prostate" },
    { label: "Skin_Not_Sun_Exposed_Suprapubic" },
    { label: "Skin_Sun_Exposed_Lower_leg" },
    { label: "Small_Intestine_Terminal_Ileum" },
    { label: "Spleen" },
    { label: "Stomach" },
    { label: "Testis" },
    { label: "Vagina" },
    { label: "Whole_Blood" }
]

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

.el-select {
    margin-left: 2%;
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
