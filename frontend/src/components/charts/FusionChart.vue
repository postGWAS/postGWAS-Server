<!-- fusion是直接展示图片 -->
<template>
    <div text-align="center">
        <div v-for="(pdfSource, index) in source" :key="index">
            <vue-pdf-embed :source="pdfSource" />
        </div>
    </div>
</template>

<script setup>
import VuePdfEmbed from 'vue-pdf-embed';
import { ref, onMounted } from 'vue';
import { useJobStore } from '@stores/index.js';
import chartAPI from '@api/charts.js';
import { ElMessage } from "element-plus";

// 定义存储
const jobStore = useJobStore;

onMounted(() => {
    const jobId = jobStore.jobId;

    chartAPI.reqFusion(jobId).then((res) => {
        source.value = res.data.data.previewUrl;

    }).catch(() => {
        ElMessage.error('Get data failed');
    });
})

const source = ref();
</script>
<style scoped></style>