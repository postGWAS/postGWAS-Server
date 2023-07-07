import { createRouter, createWebHashHistory } from 'vue-router'
import homePage from '../views/Home.vue'

const routes = [
    {
        path: '/',
        component: homePage
    },
    {
        path: '/tutorial',
        component: () =>
            import('../views/Tutorial.vue')
    },
    {
        path: '/chart',
        component: () =>
            import('../views/Chart.vue')
    },
    {
        path: '/result',
        props: (route) => ({ jobId: route.query.jobId }),
        component: () =>
            import('../views/Result.vue'),
        meta: { keepAlive: true }
    },
    {
        path: '/colocalization',
        children: [
            {
                path: 'coloc',
                component: () =>
                    import('../components/colocalization/Coloc.vue')
            },
            {
                path: 'ecaviar',
                component: () =>
                    import('../components/colocalization/ECAVIAR.vue')
            },
            {
                path: 'fastenloc',
                component: () =>
                    import('../components/colocalization/FastENLOC.vue')
            },
        ],
        meta: { keepAlive: true }
    },
    {
        path: '/finemapping',
        children: [
            {
                path: 'caviar',
                component: () =>
                    import('../components/finemapping/CAVIAR.vue')
            },
            {
                path: 'finemap',
                component: () =>
                    import('../components/finemapping/FINEMAP.vue')
            },
            {
                path: 'paintor',
                component: () =>
                    import('../components/finemapping/Paintor.vue')
            },
            {
                path: 'caviarbf',
                component: () =>
                    import('../components/finemapping/CAVIARBF.vue')
            },
        ],
        meta: { keepAlive: true }
    },
    {
        path: '/twas',
        children: [
            {
                path: 'fusion',
                component: () =>
                    import('../components/twas/FUSION.vue')
            },
            {
                path: 'spredixcan',
                component: () =>
                    import('../components/twas/SPrediXcan.vue')
            },
            {
                path: 'fusionlasso',
                component: () =>
                    import('../components/twas/FUSIONLasso.vue')
            },
            {
                path: 'fusiontop1',
                component: () =>
                    import('../components/twas/FUSIONTop1.vue')
            },
            {
                path: 'fusionenet',
                component: () =>
                    import('../components/twas/FUSIONEnet.vue')
            },
            {
                path: 'spredixcanmashr',
                component: () =>
                    import('../components/twas/SPrediXcanMashr.vue')
            },
            {
                path: 'spredixcanenet',
                component: () =>
                    import('../components/twas/SPrediXcanEnet.vue')
            },
        ],
        meta: { keepAlive: true }
    },
]

const router = createRouter({
    history: createWebHashHistory(),
    routes,
    // 每次切换路由的时候滚动到页面顶部
    scrollBehavior() {
        return { left: 0, top: 0 }
    }
})

export default router