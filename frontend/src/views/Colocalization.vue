<template>
    <h3>这是colocalization页面</h3>
    <ColocComponent v-show="showColoc" />
    <FastENLOCComponent v-show="showFastE" />
    <ECAVIARComponent v-show="showEcaviar" />

</template>

<script setup>
import ColocComponent from '../components/colocalization/Coloc.vue';
import FastENLOCComponent from '../components/colocalization/FastENLOC.vue'
import ECAVIARComponent from '../components/colocalization/ECAVIAR.vue'

var showColoc = true;
var showFastE = true;
var showEcaviar = true;

</script>

<style scoped>


</style>