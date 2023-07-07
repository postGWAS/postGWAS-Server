<template>
    <h3>这是TWAS页面</h3>
    <SPrediXcanView v-show="showSPrediXcan" />
    <FUSIONView v-show="showFUSION" />

</template>

<script setup>
import SPrediXcanView from '../components/twas/SPrediXcan.vue';
import FUSIONView from '../components/twas/FUSION.vue';

var showSPrediXcan = true;
var showFUSION = true;

</script>

<style scoped>

</style>

