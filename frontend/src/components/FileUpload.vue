<!-- 文件上传组件 vue测试文件上传地址https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15 -->
<template>
    <div>
        <el-upload class="upload-demo" drag :action="UploadURL + '/api/v1/file/upload'" :on-success="onSuccessHandle"
            :on-error="onErrorHandle" :on-remove="onRemoveHandle" :before-upload="beforeUploadHandle" :limit="1" :on-exceed="uploadExceedHandle" multiple>
            <!-- 文件上传默认name为file -->
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">
                Drop file here or <em>click to upload</em>
            </div>
            <template #tip>
                <div class="el-upload__tip">
                    Allow only one file (less than 500MB) to be uploaded.
                </div>
            </template>
        </el-upload>
        <!-- <p>已上传文件列表：{{ file_list }}</p> -->
    </div>
</template>

<script setup>
import { ref } from "vue";
import { ElMessage } from 'element-plus';

var file_list = ref([]);// 已上传文件列表
const UploadURL = import.meta.env.VITE_APP_UPLOADURL;

defineExpose({ file_list });// 向外暴露文件列表

// 文件数量超出限制
const uploadExceedHandle = () => {
    ElMessage.error("Allow only one file (less than 500MB) to be uploaded. Please remove the previous file.");
}

// 文件上传的回调函数
const onSuccessHandle = (resp, file) => {
    // var newResp = JSON.stringify(resp);
    // var newfile = JSON.stringify(file);
    // var newfileList = JSON.stringify(fileList);
    // console.log("响应: " + newResp);
    // console.log("文件对象: " + newfile);
    // console.log("文件列表对象: " + newfileList);

    file_list.value.push({
        name: file
    });
    ElMessage.success('file upload success');
}

// 文件上传失败的回调函数
const onErrorHandle = () => {
    // var newError = JSON.stringify(error);
    // console.log("文件上传失败" + newError);
    ElMessage.error('File upload failed');
}

// 文件被移除文件列表
const onRemoveHandle = () => {
    // var deletedFile = JSON.stringify(uploadFile);
    // var remainFiles = JSON.stringify(uploadFiles);

    file_list.value = [];
    // console.log("删除文件：", deletedFile);
    // console.log("现存文件：", remainFiles);
    ElMessage.info('File removed');
}

const beforeUploadHandle = (file) => {
    const isLt500M = file.size / 1024 / 1024 < 500
    if (!isLt500M) {
        ElMessage.error('File size must be less than 500MB!')
    }
    return isLt500M
}
</script>

<style scoped></style>
