<template>
    <h3>这是finemapping页面</h3>
    <CAVIARView v-show="showCAVIAR" />
    <PaintorView v-show="showPaitor" />
    <FINEMAPView v-show="showFINEMAP" />
</template>

<script setup>
import CAVIARView from '../components/finemapping/CAVIAR.vue';
import PaintorView from '../components/finemapping/Paintor.vue';
import FINEMAPView from '../components/finemapping/FINEMAP.vue';

var showCAVIAR = true;
var showPaitor = true;
var showFINEMAP = true;

</script>

<style scoped></style>