import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// element插件按需引用
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
import ElementPlus from 'unplugin-element-plus/vite'

// eslint插件
import eslintPlugin from 'vite-plugin-eslint';

import path from 'path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue({
      template: {
        compilerOptions: {
          isCustomElement: (tag) => {
            return tag.startsWith('font') // 解决logo中的font问题
          }
        }
      }
    }),
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }), ElementPlus(),
    eslintPlugin(),
  ],

  build: {
    chunkSizeWarningLimit: 2000, // 单位：KB
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('node_modules')) {
            // 根据库名称划分代码块
            const packageName = id.match(/node_modules\/([^\/]+)/)[1];
            return `vendor-${packageName}`;
          }
        },
      },
    },
  },

  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@stores': path.resolve(__dirname, './src/stores'),
      '@api': path.resolve(__dirname, './src/api'),
      '@assets': path.resolve(__dirname, './src/assets'),
      '@utils': path.resolve(__dirname, './src/utils'),
      '@charts': path.resolve(__dirname, './src/components/charts'),
      '@compo': path.resolve(__dirname, './src/components'),
      '@tutorials': path.resolve(__dirname, './src/components/tutorials'),
      // ... 可以添加其他的别名
    },
  },

  base: './',// 打包相对路径
})
