<!-- Result视图界面 -->
<template>
    <div class="jobMain">
        <h2>Job Result</h2>
        <el-form ref="formRef" :inline="true" label-width="80px" class="demo-form-inline">
            <el-form-item label="Job ID :" style="width: 350px;">
                <el-input v-model.trim="jobId" />
            </el-form-item>
            <el-form-item>
                <el-button @click="searchJobId(); func.clickHandler($event)">Search</el-button>
            </el-form-item>
        </el-form>

        <br><br>

        <el-table :data="jobList" border style="border-radius: 5px;"
            :header-cell-style="{ background: '#eef1f6', color: '#606266' }">
            <el-table-column align="center" prop="jobId" label="Job ID" />
            <el-table-column align="center" prop="jobType" label="Job Type" width="100" />
            <el-table-column align="center" prop="jobStatus" label="Status" width="100">
                <template #default="scope">
                    <span v-if="scope.row.jobStatus === 'Running'" style="color: yellowgreen">Running</span>
                    <span v-if="scope.row.jobStatus === 'Success'" style="color: green">Success</span>
                    <span v-if="scope.row.jobStatus === 'Failed'" style="color: red">Failed</span>
                </template>
            </el-table-column>
            <el-table-column align="center" prop="jobCreateTime" label="Create Time" width="180" />
            <el-table-column align="center" prop="jobFinishTime" label="Finish Time" width="180" />
            <el-table-column align="center" prop="jobDowmload" label="Download" width="180">
                <template #default="scope">
                    <el-button :disabled="scope.row.jobStatus !== 'Success'" type="success" size="small"
                        @click="handleDownload(scope.row); func.clickHandler($event)">Download</el-button>
                </template>
            </el-table-column>
            <el-table-column align="center" prop="jobDisplay" label="Display" width="180">
                <template #default="scope">
                    <el-button :disabled="scope.row.jobStatus !== 'Success'" type="primary" size="small"
                        @click="handleDisplay(scope.row); func.clickHandler($event)">Display</el-button>
                </template>
            </el-table-column>
        </el-table>


        <!-- 显示display的内容 -->
        <el-dialog v-model="showDisplay" title="Result Files" style="border-radius: 5px;">
            <el-table :data="jobResultFileList">
                <el-table-column property="fileName" label="File name" />
                <el-table-column property="filePreview" label="Preview">
                    <template #default="scope">
                        <el-button type="primary" size="small"
                            @click="handlePreviewFile(scope.row); func.clickHandler($event)">Preview</el-button>
                    </template>
                </el-table-column>
                <el-table-column property="fileDownload" label="Download">
                    <template #default="scope">
                        <el-button type="primary" size="small"
                            @click="handleDownloadFile(scope.row); func.clickHandler($event)">Download</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-dialog>

        <!-- 展示文件的具体内容 -->
        <el-dialog :width="dialogWidth" v-model="showSingleFile" :title="fileName" style="border-radius: 5px;">

            <iframe :src="filePreviewURL" frameborder="0" width="100%" height="500px"></iframe>

        </el-dialog>
        <!-- 测试图片 -->
    <!-- <iframe id="ctl00_mainContent_uxEditClient_ifrmThumb" width="100px" height="100px"
                                                    src="http://upload.wikimedia.org/wikipedia/commons/7/7a/Basketball.png"></iframe> -->
    </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { ref, onActivated } from 'vue';
import { ElMessage, ElLoading } from 'element-plus';
import resultAPI from '@api/result.js';
import { func } from '@utils/button.js';

// 通过获取url中的地址来决定是否搜索
let geturl = window.location.href;
let getqyinfo = geturl.split('?')[1];   // 截取到参数部分
let getqys = new URLSearchParams('?' + getqyinfo);  // 将参数放在URLSearchParams函数中
let getUrlJobId = getqys.get('jobId');

// 加载完后判断url有没有附带id
onActivated(() => {

    // 更新这些数据
    geturl = window.location.href;
    getqyinfo = geturl.split('?')[1];   // 截取到参数部分
    getqys = new URLSearchParams('?' + getqyinfo);  // 将参数放在URLSearchParams函数中
    getUrlJobId = getqys.get('jobId');

    if (getUrlJobId !== null) {
        jobId.value = getUrlJobId;
        searchJobId();
    }
})

// import { useEmailStore } from '@stores'

// 邮箱存储
// const emailStore = useEmailStore;
// const emit = defineEmits(["mailInputMethod"]);

// 自定el-dialog宽度
const dialogWidth = "80%";


// 获取jobId
const router = useRouter();
const jobId = ref(router.currentRoute.value.query.jobId);
const jobList = ref([
    // {
    //     jobId: "34",
    //     jobType: "gwas",
    //     jobStatus: "finished",
    //     jobCreateTime: "2022-3-4 19:45:23",
    //     jobDowmload: "http://ere.er",
    //     jobDisplay: "http://dfe.re",
    // }
]);

// 查找job各项数据
const searchJobId = () => {

    // 检查是否输入
    if (jobId.value === undefined) {
        ElMessage.error('Please input Job ID');
        return;
    }
    const loadingInstance = ElLoading.service({ fullscreen: true })

    // 像后端读取任务进度并展示
    resultAPI.getJobInfo(jobId.value).then((res) => {
        if (res.data.code === 200) {
            // 去重然后加入到列表当中
            addToJobList(res.data.data);
            // jobList.value.push(res.data.data);
            loadingInstance.close();
        } else {
            ElMessage.error("Get job information failed.");
            loadingInstance.close();
        }
    }).catch(() => {
        ElMessage.error("Get job information failed.");
        loadingInstance.close();
    })
};

// 将结果项加入到列表当中，保证去重以及更新状态
const addToJobList = (res) => {
    var flag = true;
    for (let i = 0; i < jobList.value.length; ++i) {
        if (res.jobId === jobList.value[i].jobId) {
            // 更新操作
            jobList.value[i] = res;
            flag = false;
        }
    }
    if (flag) {
        // 直接加入操作
        jobList.value.push(res);
    }
}

// 处理下载按钮
const handleDownload = (row) => {
    // console.log(row);

    // 下载文件压缩包
    let a = document.createElement('a');
    a.href = 'http://' + row.jobDownload;
    a.target = '_blank';//在新窗口打开
    a.click();
};

// 处理展示详细文件按钮
const showDisplay = ref(false);
const jobResultFileList = ref([]);
const handleDisplay = (row) => {
    // console.log(row);
    getResultFile(row.jobId);
    showDisplay.value = true;
};

// 获取全部文件列表
const getResultFile = (jobId) => {
    resultAPI.getResultFiles(jobId).then((res) => {
        if (res.data.code === 200) {
            jobResultFileList.value = res.data.data.files;
        } else {
            ElMessage.error("Get job files failed.");
        }
    })
}

// 用户浏览单个文件
const showSingleFile = ref(false);
const fileName = ref();
const filePreviewURL = ref();
const handlePreviewFile = (row) => {
    if (row.fileName.endsWith('.png')) {
        let a = document.createElement('a');
        a.href = 'http://' + row.filePreview;
        a.target = '_blank';//在新窗口打开
        a.click();
        console.log('png');
    } else {
        // console.log(row);
        showSingleFile.value = true;
        fileName.value = row.fileName;
        filePreviewURL.value = 'http://' + row.filePreview;
        console.log('not png');
    }
}

// 用户下载单个文件
const handleDownloadFile = (row) => {
    // 下载文件压缩包
    let a = document.createElement('a');
    a.href = 'http://' + row.fileDownload;
    a.target = '_blank';//在新窗口打开
    a.click();
}

</script>
  
<style scoped>
h2 {
    font-family: "Trebuchet MS", sans-serif;
    font-size: 30px;
    letter-spacing: -2px;
    text-transform: uppercase;
}

.jobMain {
    height: 780px
}
</style>
  