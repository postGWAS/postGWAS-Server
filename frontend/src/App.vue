<template>
    <div class="common-layout">
        <el-container>
            <el-header>
                <!-- 导航栏组件 -->
                <NavbarVue @mailInputMethod="mailInput" />
            </el-header>

            <el-main
                :class="{ 'greyPage': $route.path !== '/chart' && $route.path !== '/' && $route.path !== '/result' && $route.path !== '/tutorial' }">
                <!-- 路由显示内容 -->
                <!-- <router-view @mailInputMethod="mailInput"></router-view> -->
                <!--保活用户输入的数据-->
                <router-view v-slot="{ Component }" @mailInputMethod="mailInput">
                    <keep-alive>
                        <component :is="Component" />
                    </keep-alive>
                </router-view>
            </el-main>

            <el-footer>
                <el-divider />
                <div class="foot">
                    <h4>postGWAS Server NPU Data Mining and Bioinformatics Lab</h4>
                </div>

            </el-footer>
            <br>
        </el-container>
    </div>
</template>

<script setup>
import NavbarVue from './components/Navbar.vue';

// 邮箱地址填写
import { ElMessage, ElMessageBox } from 'element-plus';
import { useEmailStore } from './stores/index.js'

const emailStore = useEmailStore;

const mailInput = () => {
    // console.log("enter");
    ElMessageBox.prompt('Please input your e-mail', 'Email address for receiving results', {
        confirmButtonText: 'OK',
        cancelButtonText: 'Cancel',
        inputPattern:
            /[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?/,
        inputErrorMessage: 'Invalid Email',
        inputValue: emailStore.email,
    })
        .then(({ value }) => {
            emailStore.email = value;
            ElMessage({
                type: 'success',
                message: `Your email address is:${emailStore.email}`,
            });
        })
        .catch(() => {
            ElMessage({
                type: 'info',
                message: 'Input E-mail canceled',
            });
        })
}
</script>

<style scoped>
.el-header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 999;
    height: 80px;
    padding: 0;/* 解决两边有空的问题 */
}

.el-main {
    margin-top: 50px;
}

.greyPage {
    background-color: rgb(245, 245, 245);
    width: 70%;
    margin-left: 15%;
    margin-top: 6%;
    border-radius: 10px;
}
</style>
