<!-- 将图像可视化的界面 -->
<template>
  <div style="margin-top: 10px;">
    <div class="jobArea">
      <h2>Job Charts</h2>
      <el-form ref="formRef" :inline="true" label-width="80px" class="demo-form-inline">
        <el-form-item label="Job Type:" style="width: 350px;">
          <el-select v-model="jobType" class="m-2" placeholder="choose type" filterable clearable>
            <el-option v-for="item in typeOptions" :key="item.label" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="Job ID:" style="width: 350px;">
          <el-input v-model.trim="jobId" />
        </el-form-item>
        <el-form-item>
          <el-button @click="searchJobId(); func.clickHandler($event)">Search</el-button>
        </el-form-item>
      </el-form>

      <br><br>

      <component :is="currentComponent"></component>
    </div>

    <!-- <div id="main" :style="{ width: '900px', height: '600px' }"></div> -->

  </div>
</template>

<script setup>
import { ref } from 'vue';
import check from '@utils/check.js';
import { ElMessage } from 'element-plus';
import { func } from '@utils/button.js';
import { useJobStore } from '@stores/index.js';
import { defineAsyncComponent } from 'vue';

// 定义存储
const jobStore = useJobStore;

// 选择Job Type
const jobType = ref();
const typeOptions = [
  { value: "coloc", label: "Coloc" },
  { value: "fastenloc", label: "fastENLOC" },
  { value: "ecaviar", label: "eCAVIAR" },
  { value: "paintor", label: "Paintor" },
  { value: "caviar", label: "CAVIAR" },
  { value: "finemap", label: "FINEMAP" },
  { value: "caviarbf", label: "CAVIARBF" },
  { value: "fusion", label: "Fusion" },
  { value: "spredixcan", label: "S-PrediXcan" }
]


// 搜索job
const jobId = ref();
const searchJobId = () => {

  if (check.isInputIllegal(jobType)) {
    ElMessage.error('Please choose Job Type');
    return;
  }

  if (check.isInputIllegal(jobId)) {
    ElMessage.error('Please input Job ID');
    return;
  }

  // pinia全局存储存储jobId
  jobStore.jobId = jobId.value;

  // 根据不同的名称动态加载不同的组件
  if (jobType.value === 'finemap') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/FinemapChart.vue'));
  } else if (jobType.value == 'paintor') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/PaintorChart.vue'));
  } else if (jobType.value == 'caviarbf') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/CaviarbfChart.vue'));
  } else if (jobType.value == 'fusion') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/FusionChart.vue'));
  } else if (jobType.value == 'caviar') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/CaviarChart.vue'));
  } else if (jobType.value == 'coloc') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/ColocChart.vue'));
  } else if (jobType.value == 'ecaviar') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/EcaviarChart.vue'));
  } else if (jobType.value == 'fastenloc') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/FastenlocChart.vue'));
  } else if (jobType.value == 'spredixcan') {
    currentComponent.value = defineAsyncComponent(() => import('@charts/SpredixcanChart.vue'));
  }

}

// 动态显示画图界面
const currentComponent = ref(null);

</script>

<style scoped>
.chartArea {
  width: 100%;
  height: 800px;
  border-radius: 10px;
  box-shadow: 10px 10px 5px #888888;
}

h2 {
  font-family: "Trebuchet MS", sans-serif;
  font-size: 30px;
  letter-spacing: -2px;
  text-transform: uppercase;
}
</style>
