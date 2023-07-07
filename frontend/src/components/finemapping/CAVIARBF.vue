<!-- CAVIARBF 组件 -->
<template>
    <div>
        <h2>CAVIARBF</h2>

        <div class="intro">
            <article align="left">
                <h4 style="
                                font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>CAVIARBF is a ﬁnemapping tool for identifying potential causal variants within regions where causal
                    variants are assumed to be present in the data.</p>
                <p>CAVIARBF can be used to prioritise potential causal variants for subsequent functional analysis after
                    genome-wide association studies (GWAS) have been performed. It uses an approximate Bayesian approach and
                    can handle multiple causal variants.</p>
                <p>The advantage of the CAVIARBF method is that multiple associated SNPs can be analysed jointly, thus
                    improving the precision of estimating the causal eﬀect size of SNPs. In addition, the CAVIARBF method
                    can handle complex linkage disequilibrium structures in the genome, reducing the incidence of false
                    positives.</p>
                <p>One of the outputs is<em><strong> the marginal posterior probability</strong></em> that each variant is
                    causal.</p>
                <p>Original software package is available at
                    <el-link type="primary" href="https://bitbucket.org/Wenan/caviarbf/src/master/" target="_blank">
                        Bitbucket <el-icon class="el-icon--right">
                            <View />
                        </el-icon>
                    </el-link>.
                </p>
            </article>
        </div>

        <div class="inputCard">
            <h4>1.Upload a GWAS file
                <el-tooltip class="item" effect="dark" content="At least includes zscore and rs_id." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('caviarbfGwas.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.Upload a GWAS LD file
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('caviarbfGwasLd.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasLdChild" />
        </div>

        <div class="inputCard">
            <h4>3.The zscore column name in the input GWAS file
                <el-tooltip class="item" effect="dark" content="The default value is zscore." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="zscore" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>4.The rs_id column name in the input GWAS file
                <el-tooltip class="item" effect="dark" content="The default value is rs_id." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="rsid" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>5.The maximum size of causal variants
                <el-tooltip class="item" effect="dark" content="The default value is 1." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="maxCasual" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>6.Size of GWAS samples</h4>
            <el-input type="number" class="input" v-model="ng" placeholder="Please input" />
        </div>

        <br>

        <el-button class="button" type="primary" round @click="runCAVIARBF(); func.clickHandler($event)">RUN
            CAVIARBF</el-button>

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
import copyToClipboard from '@utils/copy';
import navigateToResult from '@utils/navigator.js';


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

// 邮箱存储
const emailStore = useEmailStore;
// const emit = defineEmits(["mailInputMethod"]);

// 下载示例文件
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

const zscore = ref("zscore");
const rsid = ref("rs_id");
const maxCasual = ref(1);
const ng = ref();

const runCAVIARBF = () => {
    if (dataCheck()) {
        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
                ld: gwasLdFile.value[0].name.response.data.id
            },
            zscore: zscore.value,
            rsid: rsid.value,
            maxCasual: maxCasual.value,
            ng: ng.value,
            email: emailStore.email,
        }

        finemappingAPI.reqCAVIARBF(data).then((res) => {
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

    if (check.isInputIllegal(zscore)) {
        ElMessage.error('Please input zscore');
        return false;
    }

    if (check.isInputIllegal(rsid)) {
        ElMessage.error('Please input rs_id');
        return false;
    }

    if (check.isInputIllegal(maxCasual)) {
        ElMessage.error('Please input maxCausal');
        return false;
    }

    if (check.isInputIllegal(ng)) {
        ElMessage.error('Please input size of GWAS samples');
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
