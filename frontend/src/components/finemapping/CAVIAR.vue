<!-- CAVIAR 组件 -->
<template>
    <div>
        <h2>CAVIAR</h2>

        <div class="intro">
            <article align="left">
                <h4 style="
                        font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>CAVIAR (CAusal Variants Identification in Associated Regions) is a Bayesian statistical method for
                    fine-mapping potential causal variants within a given signal-associated region, based on prior
                    information and GWAS data.</p>
                <p>The basic idea of CAVIAR is to compute the posterior probability that each variant is the causal variant,
                    given a GWAS region, by decomposing the likelihood function with Bayesian methods. This method considers
                    linkage disequilibrium between different variants, can handle joint analysis of multiple variants, and
                    can incorporate both genotype and phenotype information in a region. CAVIAR is a powerful tool for
                    identifying potential causal variants in GWAS data, which can provide important information for further
                    functional studies and clinical applications.</p>
                <p>CAVIAR requires input of <em><strong>GWAS data </strong></em>and<em><strong> LD matrix</strong></em>.</p>
                <p>Its output has <br>①<em><strong>log_set:</strong></em> causal SNP set.
                    <br>②<em><strong>log_post:</strong></em>
                    causal posterior probability for each
                    SNP. <br>③<em><strong>log_set_sorted:</strong></em> the causal SNPs are sorted according to the
                    posterior
                    probability and the
                    posterior
                    probability are then added to the file. <br>④<em><strong>log_post_sorted:</strong></em> all SNPs were
                    ranked
                    according to posterior
                    probability.</p>
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
                <el-tooltip class="item" effect="dark" content="At least includes zscore and rs_id." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('caviarGwas.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.Upload a GWAS LD file
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('caviarGwasLd.txt')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasLdChild" />
        </div>

        <div class="inputCard">
            <h4>3.The zscore column name in the input GWAS file</h4>
            <el-input class="input" v-model="zscore" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>4.The rs_id column name in the input GWAS file</h4>
            <el-input class="input" v-model="rsid" placeholder="Please input" />
        </div>

    <!-- <div class="inputCard">
            <h3>Additional parameters (not mandatory)</h3>
            <h4>5.1.Set the maximum size of causal SNP</h4>
            <el-input class="input" v-model="c" placeholder="Please input" />
            <h4>5.2.List the probability of different size of causal SNPs</h4>
            <el-input class="input" v-model="f" placeholder="Please input" />
                        </div> -->

        <div class="inputCard">
            <h4>5.Set the maximum size of causal SNP</h4>
            <el-input class="input" v-model="c" placeholder="Please input" />
        </div>

        <br>

        <el-button class="button" type="primary" round @click="runCAVIAR(); func.clickHandler($event)">RUN
            CAVIAR</el-button>

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

const zscore = ref();
const rsid = ref();
const c = ref();
// const f = ref();

const runCAVIAR = () => {
    if (dataCheck()) {
        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
                ld: gwasLdFile.value[0].name.response.data.id
            },
            zscore: zscore.value,
            rsid: rsid.value,
            args: {
                c: c.value,
                // f: f.value
            },
            email: emailStore.email,
        }

        finemappingAPI.reqCAVIAR(data).then((res) => {
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

    if (check.isInputIllegal(c)) {
        ElMessage.error('Please input the maximum size of causal SNP');
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
}</style>
