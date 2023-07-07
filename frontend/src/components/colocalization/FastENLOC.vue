<!-- fastENLOC组件 -->
<template>
    <!-- fastENLOC 界面 -->
    <div>
        <h2>fastENLOC</h2>

        <div class="intro">
            <article align="left">
                <h4
                    style="
                                                    font-family: 'Trocchi' , sans-serif; font-size: 20px; letter-spacing: 1px; ">
                    Introduction
                </h4>
                <p>fastENLOC is a genomic method for identifying regulatory factors of gene expression, based on gene
                    expression and genotype data.</p>
                <p>fastENLOC is a powerful genomic tool that can aid researchers in better understanding gene expression
                    regulation and disease mechanisms, providing new insights and strategies for disease prediction,
                    diagnosis, and treatment.</p>
                <p>It requires the input of <em><strong>GWAS data</strong></em>(variant_id\rs_id, loc_id, zscore) and
                    <em><strong>eQTL annotation file</strong></em>. The eQTL
                    annotation file can be specified by the user, or you can use Multi-tissue eQTL annotation with hg38
                    position ID and also Multi-tissue eQTL annotation with rs ID.
                </p>
                <p>Its output has<br>①<em><strong>Height_Blood.enloc.enrich.out:</strong></em> enrichment analysis
                    result.<br>②<em><strong>Height_Blood.enloc.sig.out:</strong></em>
                    signal-level colocalization result.<br>③<em><strong>Height_Blood.enloc.snp.out:</strong></em> SNP-level
                    colocalization
                    result.<br>④<em><strong>Height_Blood.enloc.gene.out:</strong></em> gene-level colocalization
                    result.<br>⑤<em><strong>Height_Blood.enloc.sig.extract.out:</strong></em> screening based on regional
                    colocalization probability (RCP)
                    thresholds.<br>⑥<em><strong>Height_Blood.enloc.gene.extract.out:</strong></em> screening based on gene
                    variant-level colocalization
                    probability(GRCP) thresholds.</p>
                <p>Original software package is available at
                    <el-link type="primary" href="https://github.com/xqwen/fastenloc/tree/master/tutorial" target="_blank">
                        GitHub <el-icon class="el-icon--right">
                            <View />
                        </el-icon>
                    </el-link>.
                </p>
            </article>
        </div>

        <div class="inputCard">
            <h4>1.Upload a GWAS file
                <el-tooltip class="item" effect="dark" content="At least includes variant_id (or rs_id)、loc_id、zscore."
                    placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
                <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('fastenlocGwas.gz')">
                        <Paperclip />
                    </el-icon>
                </el-tooltip>
            </h4>
            <FileUpload ref="gwasChild" />
        </div>

        <div class="inputCard">
            <h4>2.The eQTL file options:
                <el-tooltip class="item" effect="dark" placement="right-start">
                    <template #content>
                        <div>You can use Multi-tissue eQTL annotation with hg38 position ID and also Multi-tissue eQTL
                            annotationwith rs ID. <br>Note that the variant IDs have to match in the GWAS and eQTL
                            annotations.
                        </div>
                    </template>
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-select v-model="flag" class="m-2" placeholder="Select eQTL file choice" size="large">
                <el-option v-for="item in eQTLFileOptions" :key="item.value" :label="item.label" :value="item.value" />
            </el-select>
        </div>

        <div class="inputCard" v-show="flag === 0">
            <h4>2.1.Upload an eQTL file
            <!-- <el-tooltip class="item" effect="dark" content="Click to download sample file." placement="right-start">
                    <el-icon color="#1296DB" :size="20" class="fileIcon" @click="downloadFile('fastEnlocEqtl')">
                        <Paperclip />
                    </el-icon>
                                                                </el-tooltip> -->
            </h4>
            <FileUpload ref="eqtlChild" />
        </div>

        <div class="inputCard">
            <h4>3.Choose tissue
            <!-- <el-tooltip class="item" effect="dark"
                    content="if you use your own eQTL or file based on hg38 position ID." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                            </el-tooltip> -->
            </h4>
            <div>
                <!-- 使用disabled动态设置 -->
                <el-select v-model="tissue" class="m-2" placeholder="tissue choice" size="large" :disabled="false">
                    <el-option v-for="item in tissueOptions" :key="item.label" :label="item.label" :value="item.label" />
                </el-select>
            </div>
        </div>

        <div class="inputCard">
            <h4>4.The zscore column name in input GWAS file</h4>
            <el-input class="input" v-model="zscore" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>5.The prefix name of output file
                <el-tooltip class="item" effect="dark" content="The default value is prefix." placement="top-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <el-input class="input" v-model="prefix" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>6.The rs_id (or variant_id) column name in the input GWAS file</h4>
            <el-radio-group v-model="id_type">
                <el-radio label="rs_id"></el-radio>
                <el-radio label="variant_id"></el-radio>
            </el-radio-group>
            <br>
            <br>
            <el-input class="input" v-model="id_value" placeholder="Please input" />
        </div>

        <div class="inputCard">
            <h4>7.The loc_id column name in the input GWAS file.</h4>
            <el-input class="input" v-model="locid" placeholder="Please input" />
        </div>

    <!-- <p class="title">8.variant_id column name in the GWAS input file</p>
                                                                                                                                                                            <el-input class="input" v-model="variantid" placeholder="Please input" /> -->


        <div class="inputCard">
            <h4>8.Total size of SNP in GWAS. (not mandatory)</h4>
            <el-input class="input" v-model.number="ngwas" type="number" placeholder="Please input" />
        </div>


        <div class="inputCard">
            <h4>9.Regional co-location probability (RCP) threshold.
                <el-tooltip class="item" effect="dark" content="The default value is 0.5." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <div class="slider-demo-block">
                <el-slider v-model="rcp" :min="0.00" :max="1.00" :step="0.00001" show-input />
            </div>
        </div>

        <div class="inputCard">
            <h4>10.Gene variant-level colocalization probability(GRCP) thresholds.
                <el-tooltip class="item" effect="dark" content="The default value is 0.5." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <div class="slider-demo-block">
                <el-slider v-model="grcp" :min="0.00" :max="1.00" :step="0.00001" show-input />
            </div>
        </div>


        <div class="inputCard">
            <h4>11.Gene locus-level colocalization probability(GLCP) thresholds.
                <el-tooltip class="item" effect="dark" content="The default value is 0.5." placement="right-start">
                    <el-icon color="#1296DB" :size="20">
                        <Compass />
                    </el-icon>
                </el-tooltip>
            </h4>
            <div class="slider-demo-block">
                <el-slider v-model="glcp" :min="0.00" :max="1.00" :step="0.00001" show-input />
            </div>
        </div>

        <br>

        <el-button class="button" type="primary" round @click="runFastENLOC(); func.clickHandler($event)">RUN
            fastENLOC</el-button>

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
import FileUpload from '../../components/FileUpload.vue';
import { ref, onMounted } from 'vue';
import { ElInput, ElMessage } from 'element-plus';
import check from '../../utils/check.js'
import colocAPI from '../../api/colocalization.js';
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
const eqtlChild = ref();

// 父组件中存储已上传文件列表
var gwasFile = ref();
var eqtlFile = ref();

// eQTL file choices
const flag = ref()
const eQTLFileOptions = [
    // {
    //     value: 0,
    //     label: 'Use specified file',
    // },
    {
        value: 1,
        label: 'Use Multi-tissue eQTL annotation data with hg38 position ID',
    },
    {
        value: 2,
        label: 'Use Multi-tissue eQTL annotation data with rs ID',
    },
]

// tissue 选项 TODO
const tissue = ref()
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

// zscore gwas文件的列名
const zscore = ref();

// 输出文件前缀
const prefix = ref("prefix");

// gwas文件rs_id, col_ID, variant_ID, ngwas
const locid = ref();
const ngwas = ref();
const id_type = ref('rs_id');
const id_value = ref();

// 将滑动输入的范围从 1-100 变为 0-1
// const formatTooltip = (val) => {
//     return val / 100;
// }

// 区域共定位概率, 变异水平共定位概率, 位点水平共定位概率 默认50 / 100 = 0.5, 最后处理时除50
const rcp = ref(0.50);
const grcp = ref(0.50);
const glcp = ref(0.50);

// 用户输入数据验证及发送
const runFastENLOC = () => {
    if (dataCheck()) {

        const data = {
            files: {
                gwas: gwasFile.value[0].name.response.data.id,
                eqtl: null,
            },
            flag: flag.value,
            tissue: tissue.value,
            zscore: zscore.value,
            prefix: prefix.value,
            // rsid: rsid.value,
            locid: locid.value,
            // variantid: variantid.value,
            ngwas: ngwas.value,
            rcp: rcp.value,
            grcp: grcp.value,
            glcp: glcp.value,
            idType: id_type.value,
            idValue: id_value.value,
            email: emailStore.email,
        }

        colocAPI.reqFastENCOL(data).then((res) => {
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

// fastENLOC 数据校验
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

    if (flag.value == undefined) {
        ElMessage.error('Please choose eQTL file type');
        return false;
    } else if (flag.value === 0 || flag.value === 1) {
        if (flag.value === 0 && check.isFilesNull(eqtlFile)) {
            ElMessage.error('Please upload eQTL file');
            return false;
        }
        if (check.isInputIllegal(tissue)) {
            ElMessage.error('Please choose tissue');
            return false;
        }
    } else {// flag.value == 3时， tissue为空
        tissue.value = null;
    }

    if (check.isInputIllegal(zscore)) {
        ElMessage.error('Please input zscore');
        return false;
    }

    if (check.isInputIllegal(prefix)) {
        ElMessage.error('Please input prefix');
        return false;
    }

    // if (check.isInputIllegal(rsid)) {
    //     ElMessage.error('Please input rs_id');
    //     return false;
    // }

    if (check.isInputIllegal(id_value)) {
        ElMessage.error('Please input rs_id (or variant_id)');
        return false;
    }

    if (check.isInputIllegal(locid)) {
        ElMessage.error('Please input col_ID');
        return false;
    }

    // if (check.isInputIllegal(variantid)) {
    //     ElMessage.error('Please input variant_ID');
    //     return false;
    // }

    // if (check.isInputIllegal(ngwas)) {
    //     ElMessage.error('Please input Total number of SNP');
    //     return false;
    // }

    return true;
}

// 组件加载完成以后才能去获取组件里的值
onMounted(() => {
    gwasFile.value = gwasChild.value.file_list;
    eqtlFile.value = eqtlChild.value.file_list;
});
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

.slider-demo-block {
    width: 60%;
    display: flex;
    align-items: right;
    margin-left: 0%;
}

.slider-demo-block .el-slider {
    margin-top: 0;
    margin-left: 8%;
}

.fileIcon {
    margin-left: 4px;
    cursor: pointer;
}
</style>
