<!-- coloc组件 -->
<template>
    <div>
        <h2>COLOC</h2>

        <div class="intro">
            <article align="left">
                <h4 style="font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>A key feature of COLOC is the ability to derive the output statistics from single SNP summary
                    statistics,
                    hence making it possible to perform systematic meta-analysis type comparisons across multiple
                    GWAS
                    datasets.</p>
                <p>It provides information about candidate causal genes in associated intervals and has direct
                    implications
                    for the understanding of complex diseases as well as the design of drugs to target disease
                    pathways.
                </p>
                <p>It requires input of <em><strong>GWAS data and eQTL data</strong></em> (including at least rs_id,
                    pval,
                    variant_id and maf).
                </p>
                <p> Its
                    output is <em><strong>need_result.txt</strong></em> (a file contains the causal SNP).</p>
                <p>Original software package is available at
                    <el-link type=" primary" href="https://chr1swallace.github.io/coloc/" target="_blank">
                        GitHub <el-icon class="el-icon--right">
                            <View />
                        </el-icon>
                    </el-link>.
                </p>
            </article>
        </div>

        <div class="inputCard">
            <h4>1.Upload a GWAS file
                <el-tooltip class="item" effect="dark" content="At least includes rs_id、pval、beta、variant_id."
                    placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('colocGwas.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.Choose data type.</h4>
            <el-radio-group v-model.number="flag" class="ml-4">
                <el-radio :label="0">Using your own eQTL data.

                </el-radio>
                <el-radio :label="1">Using GTEx v8 eQTL data.
                    <el-tooltip class="item" effect="dark"
                        content="eGene and signiﬁcant variant-gene associations based on permutations."
                        placement="right-start">
                        <el-icon color="#1296DB" :size="20">
                            <Compass />
                        </el-icon>
                    </el-tooltip>
                </el-radio>
            </el-radio-group>
        </div>

        <div class="inputCard">
            <h4>3.Upload an eQTL file
                <el-tooltip class="item" effect="dark" content="At least rs_id、pvalue、maf、gene_id." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('colocEqtl.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <div v-show="flag === 0">
                <FileUpload ref="eqtlChild" />
            </div>
            <div v-show="flag === 1">
                <h5 style="color: #1296DB;">No need to upload eQTL file.</h5>
            </div>

        </div>


        <div class="inputCard">
            <h4>4.Size of GWAS samples</h4>
            <el-input type="number" class="input" v-model="ngwas" placeholder="Please input"
                oninput="value=value.replace(/[^\d]/g,'')" />
        </div>

        <div class="inputCard">
            <h4>5.Size of eQTL samples</h4>
            <el-input type="number" class="input" v-model="neqtl" placeholder="Please input"
                oninput="value=value.replace(/[^\d]/g,'')" :disabled="flag === 1" />
        </div>

        <div class="inputCard">
            <h4>6.The gene id column of eQTL input ﬁle
                <el-tooltip class="item" effect="dark"
                    content="Both gene id and gene name are allowed. The default value is gene_id." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="geneId" placeholder="Please input" :disabled="flag === 1" />
        </div>

        <div class="inputCard">
            <h4>7.The rs_id column name in the input GWAS file
                <el-tooltip class="item" effect="dark" content="The default value is rs_id." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="rsid" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>8.The beta column name in the input GWAS file
                <el-tooltip class="item" effect="dark" content="The default value is beta." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="beta" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>9.The pvalue column name in the input GWAS file
                <el-tooltip class="item" effect="dark" content="The default value is pval." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="pval" placeholder="Please input" />
        </div>

    <!-- <div class="inputCard">
            <h4>8.The variant_id column name in the input GWAS file
                <el-tooltip class="item" effect="dark" content="The default value is variant_id." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="variantid" placeholder="Please input" />
                                                                                                                                                                    </div> -->

        <div class="inputCard">
            <h4>10.The verbeta column name in the input GWAS file
                <el-tooltip class="item" effect="dark"
                    content="The varbeta equals the square of SE. The default value is verbeta." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="varbeta" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>11.The rs_id column of eQTL input ﬁle
                <el-tooltip class="item" effect="dark" content="The default value is rs_id." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="ersid" placeholder="Please input" :disabled="flag === 1" />
        </div>

        <div class="inputCard">
            <h4>12.The pvalue column of eQTL input ﬁle
                <el-tooltip class="item" effect="dark" content="The default value is pval." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="epval" placeholder="Please input" :disabled="flag === 1" />
        </div>

        <div class="inputCard">
            <h4>13.The minor allele frequency column of eQTL input ﬁle
                <el-tooltip class="item" effect="dark" content="The default value is MAF." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="emaf" placeholder="Please input" :disabled="flag === 1" />
        </div>

        <div class="inputCard">
            <h4>14.Choose tissue.</h4>
            <el-select v-model="tissue" class="m-2" placeholder="tissue choices" size="large" :disabled="flag === 0"
                filterable clearable>
                <el-option v-for="item in tissueOptions" :key="item.label" :label="item.label" :value="item.value" />
            </el-select>
        </div>

        <div class="inputCard">
            <h4>15.Set the threshold
                <el-tooltip class="item" effect="dark"
                    content="Posterior probabilities of H4 above this threshold were considered colocalization signals. Most studies will use 0.95."
                    placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" type="number" v-model="threshold" placeholder="Please input" />
        </div>
        <br>
        <div><el-button type="primary" @click="runColoc(); func.clickHandler($event)" round>RUN coloc</el-button></div>

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
import { ElMessage } from 'element-plus';
import colocAPI from '../../api/colocalization.js';
import check from '@utils/check.js';
import indexAPI from '@api';
import { useEmailStore } from '@stores';
import { func } from '@utils/button.js';
import copyToClipboard from '@utils/copy';
import navigateToResult from '@utils/navigator.js';

// 邮箱存储
const emailStore = useEmailStore;
// const emit = defineEmits(["mailInputMethod"]);

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
    // await navigator.clipboard.writeText(jobID.value);
    copyToClipboard(jobID.value);
    ElMessage.success('Successfully copied!');
}


// 文件下载
const downloadFile = (fileName) => {
    indexAPI.downloadFile(fileName);
}



// 定义一个组件对象
const gwasChild = ref();
const eqtlChild = ref();

// 父组件中存储已上传文件列表
var gwasFile = ref();
var eqtlFile = ref();

// 组件加载完成以后才能去获取组件里的值
onMounted(() => {
    gwasFile.value = gwasChild.value.file_list;
    eqtlFile.value = eqtlChild.value.file_list;
});

// 发送数据请求
const runColoc = () => {
    if (dataCheck()) {
        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
                eqtl: flag.value === 1 ? null : eqtlFile.value[0].name.response.data.id,
            },
            ngwas: ngwas.value,
            neqtl: flag.value === 1 ? null : neqtl.value,
            geneId: flag.value === 1 ? null : geneId.value,
            rsid: rsid.value,
            beta: beta.value,
            pval: pval.value,
            varbeta: varbeta.value,
            ersid: flag.value === 1 ? null : ersid.value,
            epval: flag.value === 1 ? null : epval.value,
            emaf: flag.value === 1 ? null : emaf.value,
            threshold: threshold.value,
            flag: flag.value,
            tissue: flag.value === 0 ? null : tissue.value,
            email: emailStore.email,
        }
        colocAPI.reqColoc(data).then((res) => {
            if (res.data.code === 200) {
                // 展示任务id
                showJobId.value = true;
                jobID.value = res.data.data.jobId;
            } else {
                ElMessage.error(res.data.message);
            }
        }).catch((err) => {
            ElMessage.error(err);
        })
    }
}

const ngwas = ref();
const neqtl = ref();
const rsid = ref("rs_id");
const beta = ref("beta");
const pval = ref("pval");
const varbeta = ref("varbeta");
const ersid = ref("rs_id");
const epval = ref("pval");
const emaf = ref("maf");
const threshold = ref(0.95);
const geneId = ref("gene_name");
const flag = ref(0);

const dataCheck = () => {

    gwasFile.value = gwasChild.value.file_list;
    eqtlFile.value = eqtlChild.value.file_list;

    // if (emailStore.email === undefined) {
    //     emit('mailInputMethod');
    //     return false;
    // }

    if (check.isFilesNull(gwasFile)) {
        ElMessage.error('Please upload gwas file');
        return false;
    }

    if (flag.value === 0 && check.isFilesNull(eqtlFile)) {
        ElMessage.error('Please upload eQTL file');
        return false;
    }

    if (!check.isNumber(ngwas.value)) {
        ElMessage.error('Please input ngwas');
        return false;
    }

    if (flag.value === 0 && !check.isNumber(neqtl.value)) {
        ElMessage.error('Please input neqtl');
        return false;
    }

    if (flag.value === 0 && !check.isInputIllegal(geneId.value)) {
        ElMessage.error('Please input gene id');
        return false;
    }

    if (check.isInputIllegal(rsid)) {
        ElMessage.error('Please input rs_id');
        return false;
    }

    if (check.isInputIllegal(beta)) {
        ElMessage.error('Please input beta');
        return false;
    }

    if (check.isInputIllegal(pval)) {
        ElMessage.error('Please input pval');
        return false;
    }

    if (check.isInputIllegal(varbeta)) {
        ElMessage.error('Please input varbeta');
        return false;
    }

    if (flag.value === 0 && check.isInputIllegal(ersid)) {
        ElMessage.error('Please input ersid');
        return false;
    }

    if (flag.value === 0 && check.isInputIllegal(epval)) {
        ElMessage.error('Please input epval');
        return false;
    }

    if (flag.value === 0 && check.isInputIllegal(emaf)) {
        ElMessage.error('Please input emaf');
        return false;
    }

    if (flag.value === 1 && check.isInputIllegal(tissue)) {
        ElMessage.error('Please choose tissue');
        return false;
    }

    if (check.isInputIllegal(threshold)) {
        ElMessage.error('Please input threshold');
        return false;
    }

    return true;
}

const tissue = ref();
const tissueOptions = [
    { label: "Adipose_Subcutaneous", value: "Adipose_Subcutaneous" },
    { label: "Adipose_visceral_Omentum", value: "Adipose_visceral_Omentum" },
    { label: "Adrenal_Gland", value: "Adrenal_Gland" },
    { label: "Artery_Aorta", value: "Artery_Aorta" },
    { label: "Artery_Coronary", value: "Artery_Coronary" },
    { label: "Artery_Tibial", value: "Artery_Tibial" },
    { label: "Brain_Amygdala", value: "Brain_Amygdala" },
    { label: "Brain_Anterior_cingulate_cortex_BA24", value: "Brain_Anterior_cingulate_cortex_BA24" },
    { label: "Brain_Caudate_basal_ganglia", value: "Brain_Caudate_basal_ganglia" },
    { label: "Brain_Cerebellar_Hemisphere", value: "Brain_Cerebellar_Hemisphere" },
    { label: "Brain_Cerebellum", value: "Brain_Cerebellum" },
    { label: "Brain_Cortex", value: "Brain_Cortex" },
    { label: "Brain_Frontal_Cortex_BA9", value: "Brain_Frontal_Cortex_BA9" },
    { label: "Brain_Hippocampus", value: "Brain_Hippocampus" },
    { label: "Brain_Hypothalamus", value: "Brain_Hypothalamus" },
    { label: "Brain_Nucleus_accumbens_basal_ganglia", value: "Brain_Nucleus_accumbens_basal_ganglia" },
    { label: "Brain_Putamen_basal_ganglia", value: "Brain_Putamen_basal_ganglia" },
    { label: "Brain_Spinal_cord_cervical_c-1", value: "Brain_Spinal_cord_cervical_c_1" },
    { label: "Brain_Substantia_nigra", value: "Brain_Substantia_nigra" },
    { label: "Breast_Mammary_Tissue", value: "Breast_Mammary_Tissue" },
    { label: "Cells_Cultured_ﬁbroblasts", value: "Cells_Cultured_ﬁbroblasts" },
    { label: "Cells_EBV-transformed_lymphocytes", value: "Cells_EBV_transformed_lymphocytes" },
    { label: "Colon_Sigmoid", value: "Colon_Sigmoid" },
    { label: "Colon_Transverse", value: "Colon_Transverse" },
    { label: "Esophagus_Gastroesophageal_Junction", value: "Esophagus_Gastroesophageal_Junction" },
    { label: "Esophagus_Mucosa", value: "Esophagus_Mucosa" },
    { label: "Esophagus_Muscularis", value: "Esophagus_Muscularis" },
    { label: "Heart_Atrial_Appendage", value: "Heart_Atrial_Appendage" },
    { label: "Heart_Left_Ventricle", value: "Heart_Left_Ventricle" },
    { label: "Kidney_Cortex", value: "Kidney_Cortex" },
    { label: "Liver", value: "Liver" },
    { label: "Lung", value: "Lung" },
    { label: "Minor_Salivary_Gland", value: "Minor_Salivary_Gland" },
    { label: "Muscle_Skeletal", value: "Muscle_Skeletal" },
    { label: "Nerve_Tibial", value: "Nerve_Tibial" },
    { label: "Ovary", value: "Ovary" },
    { label: "Pancreas", value: "Pancreas" },
    { label: "Pituitary", value: "Pituitary" },
    { label: "Prostate", value: "Prostate" },
    { label: "Skin_Not_Sun_Exposed_Suprapubic", value: "Skin_Not_Sun_Exposed_Suprapubic" },
    { label: "Skin_Sun_Exposed_Lower_leg", value: "Skin_Sun_Exposed_Lower_leg" },
    { label: "Small_Intestine_Terminal_Ileum", value: "Small_Intestine_Terminal_Ileum" },
    { label: "Spleen", value: "Spleen" },
    { label: "Stomach", value: "Stomach" },
    { label: "Testis", value: "Testis" },
    { label: "Vagina", value: "Vagina" },
    { label: "Whole_Blood", value: "Whole_Blood" },
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

.input {
    width: 50%;
    margin-left: 2%;
}

.button {
    margin-top: 15px;
}

.inputCard {
    text-align: left;
}

.fileIcon {
    margin-left: 4px;
    cursor: pointer;
}
</style>
