<!-- 导航栏 -->
<template>
    <el-menu class="el-menu-demo" mode="horizontal" active-text-color="#1296DB" text-color="#001"
        :default-active="$route.path" router>

    <!-- <div class="header" @click="$router.push({ path: '/' })">
            <img id="logo" src="../assets/logo1.png" />
                                            </div> -->
        <div @click="$router.push({ path: '/' })">
            <div style="cursor: pointer;">
                <p id="WebName">postGWAS<font color="#1296DB">Server</font>
                </p>
            </div>
        </div>

        <el-menu-item index="/" class="subTitle">
            <el-icon>
                <House />
            </el-icon>Home
        </el-menu-item>

        <el-menu-item index="/tutorial" class="subTitle">
            <el-icon>
                <QuestionFilled />
            </el-icon>Tutorial
        </el-menu-item>
        <el-sub-menu index="/finemapping" class="subTitle">
            <template #title>
                <div class="title">Finemapping</div>
            </template>
            <el-menu-item index="/finemapping/finemap" class="smallTitle">FINEMAP</el-menu-item>
            <el-menu-item index="/finemapping/caviar" class="smallTitle">CAVIAR</el-menu-item>
            <el-menu-item index="/finemapping/caviarbf" class="smallTitle">CAVIARBF</el-menu-item>
            <el-menu-item index="/finemapping/paintor" class="smallTitle">Paintor</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="/colocalization" class="subTitle">
            <template #title>
                <div class="title">Colocalization</div>
            </template>
            <el-menu-item index="/colocalization/coloc" class="smallTitle">COLOC</el-menu-item>
            <el-menu-item index="/colocalization/ecaviar" class="smallTitle">eCAVIAR</el-menu-item>
            <el-menu-item index="/colocalization/fastenloc" class="smallTitle">fastENLOC</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="/twas" class="subTitle">
            <template #title>
                <div class="title">TWAS</div>
            </template>
            <!-- <el-menu-item index="/twas/fusion" class="smallTitle">FUSION</el-menu-item> -->
            <!-- <el-menu-item index="/twas/spredixcan" class="smallTitle">S-PrediXcan</el-menu-item> -->
            <el-sub-menu index="/twas/fusion" class="smallTitle">
                <template #title>FUSION</template>
                <el-menu-item index="/twas/fusionlasso" class="smallTitle">FUSION (lasso)</el-menu-item>
                <el-menu-item index="/twas/fusiontop1" class="smallTitle">FUSION (top1)</el-menu-item>
                <el-menu-item index="/twas/fusionenet" class="smallTitle">FUSION (elastic net)</el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="/twas/spredixcan" class="smallTitle">
                <template #title>S-PrediXcan</template>
                <el-menu-item index="/twas/spredixcanmashr" class="smallTitle">S-PrediXcan (mashr)</el-menu-item>
                <el-menu-item index="/twas/spredixcanenet" class="smallTitle">S-PrediXcan (elastic net)</el-menu-item>
            </el-sub-menu>
        </el-sub-menu>

        <el-menu-item index="/result" class="subTitle">
            <el-icon>
                <Reading />
            </el-icon>Result
        </el-menu-item>

        <el-menu-item index="/chart" class="subTitle">
            <el-icon>
                <More />
            </el-icon>Charts
        </el-menu-item>


        <div class="mail" :key="emailStore.email">
        <!-- <el-tooltip class="item" effect="dark" v-if="emailStore.email !== undefined"
                :content="'Email: ' + emailStore.email" placement="top-start">
                <img id="logo" src="../assets/mail.png" @click="$emit('mailInputMethod')" />
            </el-tooltip>
            <el-tooltip class="item" effect="dark" v-else content="Please enter your email address" placement="top-start">
                <img id="logo" src="../assets/mail.png" @click="$emit('mailInputMethod')" />
                                                        </el-tooltip> -->
            <el-tooltip class="item" effect="dark" placement="top-start">
                <template #content>
                    <div v-if="emailStore.email !== undefined">
                        Email: {{ emailStore.email }}
                    </div>
                    <div v-else>
                        Please enter your email address
                    </div>
                </template>
                <img id="logo" src="../assets/mail.png" @click="$emit('mailInputMethod')" />
            </el-tooltip>
        </div>

    </el-menu>
</template>

<script setup>

// 使用pinia中的邮件信息
import { useEmailStore } from '../stores/index.js';

const emailStore = useEmailStore;

</script>

<style scoped>
#WebName {
    font-size: x-large;
    padding: 0 60px;
    font-weight: 600;
}

/* 导航栏上下宽度调整 */
.el-menu {
    --el-menu-item-height: 70px;
}

.el-sub-menu .el-menu-item {
    height: 70px;
}

.header {
    height: 70px;
    width: 20%;
    text-align: center;
    line-height: 70px;
    color: rgb(49, 45, 45);
    font-size: x-large;
    font-weight: bold;
    cursor: pointer;
}

.subTitle {
    /* margin-left: 40px; */
    font-size: 20px;
    font-weight: bold;
    height: 80px;
}

.mail {
    margin-left: 5%;
    font-size: 20px;
    font-weight: bold;
    height: 50px;
    margin-top: 12px;
    cursor: pointer;
}


#logo {
    margin-top: 2%;
    height: 80%;
}

.title {
    font-size: 20px;
}

.smallTitle {
    font-size: 16px;
    font-weight: bold;
}
</style>
