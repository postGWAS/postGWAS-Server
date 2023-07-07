<!-- FINEMAP 组件 -->
<template>
    <div>
        <h2>FINEMAP</h2>

        <div class="intro">
            <article align="left">
                <h4 style="
                        font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>FINEMAP is a novel software package to efficiently explore a set of the most important causal
                    configurations of the region via a shotgun stochastic search algorithm. </p>
                <p>FINEMAP uses a Shotgun Stochastic Search (SSS) algorithm (Hans et al., 2007) that explores the vast space
                    of causal configurations by concentrating efforts on the configurations with non-negligible probability.
                    FINEMAP can be used to: (i) identify causal SNPs; (ii) estimate the effect size of causal SNPs; and
                    (iii) estimate the genetic contribution of causal SNPs. In addition, one convenient aspect of FINEMAP is
                    that after setting the maximum number of causal SNPs k, the obtained results contain the posterior
                    probabilities of 1 to k different causal SNPs and the probabilities of the number of individual causal
                    SNPs, which is very convenient for the subsequent analysis.</p>
                <p>FINEMAP requires input of <em><strong>Z files</strong></em> and <em><strong>LD matrix.</strong></em></p>
                <p>Its output has <br>(i)<em><strong>SNP file:</strong></em> each row is a SNP, and different results are
                    obtained when different causal
                    SNPs are assumed, including a summary of all results, and sorted according to the
                    PIP.<br>(ii)<em><strong>cred file:</strong></em> the
                    file will be followed by a number that represents the number of causal SNPs. For example, a 2 in .cred2
                    means the number of causal SNPs is 2.<br>(iii) <em><strong>CONFIG file:</strong></em> contains the
                    relevant
                    parameters for each causal
                    configuration.</p>

                <p>Original software package is available at
                    <el-link type="primary" href="http://www.christianbenner.com/" target="_blank">
                        christianbenner <el-icon class="el-icon--right">
                            <View />
                        </el-icon>
                    </el-link>.
                </p>
            </article>
        </div>

        <div class="inputCard">
            <h4>1.Upload a GWAS file
                <el-tooltip class="item" effect="dark"
                    content="At least includes beta, rs_id, chromosome, position, effect allele, non-effect allele, maf, se."
                    placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('finemapGwas.z')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.Upload a GWAS LD file
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('finemapGwasLd.ld')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasLdChild" />
        </div>

        <div class="inputCard">
            <h4>3.The beta column name in the input GWAS file.</h4>
            <el-input class="input" v-model="beta" placeholder="Please input" />

        </div>

        <div class="inputCard">
            <h4>4.The rs_id column name in the input GWAS file.</h4>
            <el-input class="input" v-model="rsid" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>5.The chromosome column name in the input GWAS file.</h4>
            <el-input class="input" v-model="chr" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>6.The position column name in the input GWAS file.</h4>
            <el-input class="input" v-model="pos" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>7.The effect allele column name in the input GWAS file.</h4>
            <el-input class="input" v-model="a1" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>8.The non-effect allele column name in the input GWAS file.</h4>
            <el-input class="input" v-model="a2" placeholder="Please input" />

        </div>

        <div class="inputCard">
            <h4>9.The maf column name in the input GWAS file.</h4>
            <el-input class="input" v-model="maf" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>10.The se column name in the input GWAS file.</h4>
            <el-input class="input" v-model="se" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>11.The size of GWAS samples.</h4>
            <el-input class="input" type="number" v-model.number="ngwas" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>12.Specify the maximum number of allowed causal SNPs.
                <el-tooltip class="item" effect="dark" content="The default value is 5." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" type="number" v-model.number="c" placeholder="Please input" />
        </div>

        <br>

        <el-button class="button" type="primary" round @click="runFINEMAP(); func.clickHandler($event)">RUN
            FINEMAP</el-button>

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
import finemapAPI from '../../api/finemapping.js';
import indexAPI from '@api';
import { useEmailStore } from '@stores';
import { func } from '@utils/button.js';
import copyToClipboard from '@utils/copy.js';
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

const downloadFile = (fileName) => {
    indexAPI.downloadFile(fileName);
}


// 定义一个组件对象
const gwasChild = ref();
const gwasLdChild = ref();

// 父组件中存储已上传文件列表
var gwasFile = ref();
var gwasLdFile = ref();

onMounted(() => {
    gwasFile.value = gwasChild.value.file_list;
    gwasLdFile.value = gwasLdChild.value.file_list;
});


const beta = ref();
const rsid = ref();
const chr = ref();
const pos = ref();
const a1 = ref();
const a2 = ref();
const maf = ref();
const se = ref();
const ngwas = ref();
const c = ref(5);


const runFINEMAP = () => {
    if (dataCheck()) {
        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
                ld: gwasLdFile.value[0].name.response.data.id
            },
            beta: beta.value,
            rsid: rsid.value,
            chr: chr.value,
            pos: pos.value,
            a1: a1.value,
            a2: a2.value,
            maf: maf.value,
            se: se.value,
            ngwas: ngwas.value,
            c: c.value,
            email: emailStore.email,
        }

        finemapAPI.reqFINEMAP(data).then((res) => {
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

const dataCheck = () => {

    gwasFile.value = gwasChild.value.file_list;
    gwasLdFile.value = gwasLdChild.value.file_list;

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

    if (check.isInputIllegal(beta)) {
        ElMessage.error('Please input beta');
        return false;
    }

    if (check.isInputIllegal(rsid)) {
        ElMessage.error('Please input rs_id');
        return false;
    }

    if (check.isInputIllegal(chr)) {
        ElMessage.error('Please input chromosome');
        return false;
    }

    if (check.isInputIllegal(pos)) {
        ElMessage.error('Please input position');
        return false;
    }

    if (check.isInputIllegal(a1)) {
        ElMessage.error('Please input a1');
        return false;
    }

    if (check.isInputIllegal(a2)) {
        ElMessage.error('Please input a2');
        return false;
    }

    if (check.isInputIllegal(maf)) {
        ElMessage.error('Please input maf');
        return false;
    }

    if (check.isInputIllegal(se)) {
        ElMessage.error('Please input se');
        return false;
    }

    if (check.isInputIllegal(ngwas)) {
        ElMessage.error('Please input the number of GWAS samples.');
        return false;
    }

    if (check.isInputIllegal(c)) {
        ElMessage.error('Please input the maximum number of allowed causal SNPs. ');
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

.button {
    margin-top: 15px;
}

.inputCard {
    text-align: left;
}

.input {
    width: 50%;
    margin-left: 2%;
}

.fileIcon {
    margin-left: 4px;
    cursor: pointer;
}
</style>
