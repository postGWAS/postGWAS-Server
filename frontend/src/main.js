import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
// 引入路由
import router from './router'
// 导入icon
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
// 导入pinia
import { createPinia } from 'pinia'

const app = createApp(App);
const pinia = createPinia()

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
}

app.use(router).use(pinia).mount('#app')
