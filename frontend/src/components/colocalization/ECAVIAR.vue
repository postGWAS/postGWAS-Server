<!-- eCAVIAR 组件 -->
<template>
    <div>
        <h2>eCAVIAR</h2>

        <div class="intro">
            <article align="left">
                <h4 style="
                        font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>eCAVIAR is a probabilistic method that has several key advantages over existing methods. </p>
                <p>First, it can account for more than one causal variant in any given locus. Second, it can leverage
                    summary statistics without accessing the individual genotype data. eCAVIAR Computes the colocalization
                    posterior probability for a GWAS and eQTL Study. The goal of eCAVIAR is to identify target genes and the
                    most relevant tissues for a given GWAS risk locus while accounting for the uncertainty of LD. eCAVIAR is
                    a valuable tool for finemapping complex trait loci, and can provide insights into the genetic basis of
                    complex diseases and traits.</p>
                <p>eCAVIAR requires the input of<em><strong> GWAS data, eQTL data, GWAS LD matrix and eQTL LD matrix
                        </strong></em> .</p>
                <p>Its output has <br>①<em><strong>log_col:</strong></em> it contains the co-localization posterior
                    probability
                    (CLPP) for each SNP. CLPP
                    is equal to the product of the posterior probability that the variant is causal in the GWAS and the
                    posterior probability that the variant is causal in the eQTL
                    study.<br>②<em><strong>log_col_sorted:</strong></em> sorted according to
                    the CLPP.<br>③<em><strong>log_1_post:</strong></em> the causal posterior probability of each SNP in GWAS
                    data.<br>④<em><strong>log_1_post_sorted:</strong></em> each
                    SNP is ranked according to its causal posterior probability in GWAS
                    data.<br>⑤<em><strong>log_2_post:</strong></em> the causal
                    posterior probability of each SNP in the eQTL data.<br>⑥<em><strong>log_2_post_sorted:</strong></em>
                    each
                    SNP is ranked according to
                    its causal posterior probability in eQTL data.<br>⑦<em><strong>log_1_set:</strong></em> causal SNP in
                    GWAS
                    data.<br>⑧<em><strong>log_1_set_sorted:</strong></em>
                    causal SNP in GWAS data and each SNP is ranked according to its causal posterior probability in GWAS
                    data.<br>⑨<em><strong>log_2_set:</strong></em> causal SNP in eQTL
                    data.<br>⑩<em><strong>log_2_set_sorted:</strong></em> causal SNP in eQTL data and each SNP is
                    ranked according to its causal posterior probability.</p>
                <p>Original software package is available at
                    <el-link type="primary" href="https://github.com/fhormoz/caviar" target="_blank">
                        GitHub <el-icon class="el-icon--right">
                            <View />
                        </el-icon>
                    </el-link>.
                </p>
            </article>
        </div>

        <div class="inputCard">
            <h4>1.Upload a GWAS file
                <el-tooltip class="item" effect="dark" content="At least includes z-score and rsID." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('ecaviarGwas.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.Upload a GWAS LD file
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('ecaviarGwasLd.ld')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasLdChild" />
        </div>

        <div class="inputCard">
            <h4>3.Upload a eQTL file
                <el-tooltip class="item" effect="dark" content="At least includes rs_id and zscore." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip color="#1296DB" :size="20" class="item" effect="dark" content="Click to download sample file."
                    placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('ecaviarEqtl.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="eqtlChild" />
        </div>

        <div class="inputCard">
            <h4>4.Upload a eQTL LD file
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('ecaviarEqtlLd.ld')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="eqtlLdChild" />
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
            <h4>7.The zscore column name in the input eQTL file</h4>
            <el-input class="input" v-model="ezscore" placeholder="Please input" />
        </div>


        <div class="inputCard">
            <h4>8.The rs_id column name in the input eQTL file</h4>
            <el-input class="input" v-model="ersid" placeholder="Please input" />

        </div>

    <!-- <div class="inputCard">
            <h3>Additional parameters (not mandatory)</h3>
            <h4>9.1.Set the maximum number of causal SNP</h4>
            <el-input class="input" v-model="c" placeholder="Please input" />
            <h4>9.2.List the probability of different number of causal SNPs</h4>
            <el-input class="input" v-model="f" placeholder="Please input" />
                            </div> -->

        <div class="inputCard">
            <h4>9.Set the maximum number of causal SNP</h4>
            <el-input class="input" type="number" v-model="c" placeholder="Please input" />
        </div>

        <br>

        <el-button class="button" type="primary" round @click="runECAVIAR(); func.clickHandler($event)">RUN
            eCAVIAR</el-button>

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
import check from '../../utils/check.js';
import { ElMessage } from 'element-plus';
import colocAPI from '../../api/colocalization';
import indexAPI from '@api';
import { useEmailStore } from '@stores';
import { func } from '@utils/button.js';
import copyToClipboard from '@utils/copy';
import navigateToResult from '@utils/navigator.js';


// 邮箱存储
const emailStore = useEmailStore;
// const emit = defineEmits(["mailInputMethod"]);

const downloadFile = (fileName) => {
    indexAPI.downloadFile(fileName);
}

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



// 定义一个组件对象
const gwasChild = ref();
const eqtlChild = ref();
const gwasLdChild = ref();
const eqtlLdChild = ref();

// 父组件中存储已上传文件列表
var gwasFile = ref();
var eqtlFile = ref();
var gwasLdFile = ref();
var eqtlLdFile = ref();

// 组件加载完成以后才能去获取组件里的值
onMounted(() => {
    gwasFile.value = gwasChild.value.file_list;
    gwasLdFile.value = gwasLdChild.value.file_list;
    eqtlFile.value = eqtlChild.value.file_list;
    eqtlLdFile.value = eqtlLdChild.value.file_list;
});

const zscore = ref();
const rsid = ref();
const ezscore = ref();
const ersid = ref();
const c = ref();
// const f = ref();

// 用户数据输入发送及验证
const runECAVIAR = () => {
    if (dataCheck()) {
        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
                gwasld: gwasLdFile.value[0].name.response.data.id,
                eqtl: eqtlFile.value[0].name.response.data.id,
                eqtlld: eqtlLdFile.value[0].name.response.data.id
            },
            zscore: zscore.value,
            rsid: rsid.value,
            ezscore: ezscore.value,
            ersid: ersid.value,
            c: c.value,
            // args: {               
            //     // f: check.isInputIllegal(f) ? f.value : null,
            // },
            email: emailStore.email,
        }
        colocAPI.reqECAVIAR(data).then((res) => {
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

// eCAVIAR 数据校验
const dataCheck = () => {

    gwasFile.value = gwasChild.value.file_list;
    gwasLdFile.value = gwasLdChild.value.file_list;
    eqtlFile.value = eqtlChild.value.file_list;
    eqtlLdFile.value = eqtlLdChild.value.file_list;

    // if (emailStore.email === undefined) {
    //     emit('mailInputMethod');
    //     return false;
    // }

    if (check.isFilesNull(gwasFile)) {
        ElMessage.error('Please upload gwas file');
        return false;
    }

    if (check.isFilesNull(gwasLdFile)) {
        ElMessage.error('Please upload gwas Ld file');
        return false;
    }

    if (check.isFilesNull(eqtlFile)) {
        ElMessage.error('Please upload eQTL file');
        return false;
    }

    if (check.isFilesNull(eqtlLdFile)) {
        ElMessage.error('Please upload eQTL LD file');
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

    if (check.isInputIllegal(ezscore)) {
        ElMessage.error('Please input ezscore');
        return false;
    }

    if (check.isInputIllegal(ersid)) {
        ElMessage.error('Please input rs_id in eQTL file');
        return false;
    }

    if (check.isInputIllegal(c)) {
        ElMessage.error('Please input the maximum number of causal SNP');
        return false;
    }

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
}</style>
