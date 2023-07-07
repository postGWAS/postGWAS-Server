<template>
    <div id="dot" style="margin-left: 10%; width: 80%;height:900px;"></div>
    <div id="bar" style="margin-left: 10%; width: 80%;height:900px;"></div>
</template>

<script setup>
import * as echarts from "echarts";
import { onMounted, onUnmounted } from "vue";
import { useJobStore } from '@stores/index.js';
import chartAPI from '@api/charts.js';
import { ElMessage } from "element-plus";


// 定义存储
const jobStore = useJobStore;

/// 声明定义一下echart
let echart = echarts;

var snpArray = null;
var configArray = null;

onMounted(() => {
    initChart()
});

onUnmounted(() => {
    echart.dispose;
});

const setBar = () => {
    var myChart = echarts.init(document.getElementById('bar'));
    // JSON 数据
    // [
    //     {
    //         "prob": "0.452272",
    //         "sd": "0.0142348,0.0142401",
    //         "h2_0.95CI": "0.0130734,0.0162348",
    //         "mean": "-0.497758,0.499498",
    //         "odds": "1",
    //         "rank": "1",
    //         "log10bf": "268.168",
    //         "prob_norm_k": "0.452272",
    //         "h2": "0.0146779",
    //         "k": "2",
    //         "config": "rs9401634,rs9320913"
    //     }
    // ]
    const jsonData = configArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.slice(0, 5);

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of data.config file by FINEMAP',
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            },
        },
        xAxis: {
            type: 'value',
        },
        yAxis: {
            type: 'category',
            name: 'Rank',
            data: data.map(item => item.rank),
        },
        series: [
            {
                name: 'Probability',
                type: 'bar',
                data: data.map(item => ({
                    value: item.prob,
                    config: item.config,
                })),
                itemStyle: {
                    color: '#A9E2F3',
                },
                label: {
                    show: true,
                    position: 'insideBottom', // 标签显示在柱子右侧
                    fontSize: 18,
                    formatter: function (params) {
                        return params.data.config;
                    },

                },
            },
        ]
    };

    myChart.setOption(option);
}

const setDot = () => {
    // console.log("加载完毕", snpArray, configArray);

    var myChart = echarts.init(document.getElementById('dot'));

    const jsonData = snpArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `SNP: ${item.rsid}, prob: ${item.prob}`,
        value: [item.rsid, item.prob],
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));


    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of data.snp file by FINEMAP'
        },
        tooltip: {
            trigger: 'item',
            formatter: function (params) {
                return params.name;
            }
        },
        dataZoom: [
            {
                id: 'dataZoomX',
                type: 'slider',
                xAxisIndex: [0],
                filterMode: 'filter'
            },
            {
                id: 'dataZoomY',
                type: 'slider',
                yAxisIndex: [0],
                filterMode: 'empty'
            }
        ],
        xAxis: {
            type: 'category',
            name: 'SNP',
            show: true,
            axisTick: {
                show: true,  // 不显示刻度
                inside: true,
            },
            axisLabel: {
                show: false, // 不显示刻度上的数字
            },
        },
        yAxis: {
            type: 'log',
            name: 'Posterior Inclusion Probability',
            show: true,
            axisLabel: {
                formatter: function (value) {
                    return value.toExponential(2); // 将 y 轴数值转换为科学计数法格式
                }
            },
        },
        series: [
            {
                name: 'post',
                type: 'scatter',
                data: data,
                itemStyle: {
                    color: '#A9E2F3',
                },
                label: {
                    show: false,
                    formatter: function (params) {
                        return params.name;
                    }
                }
            },
        ]
    };

    myChart.setOption(option);
}

const initChart = () => {
    const jobId = jobStore.jobId;

    chartAPI.reqFinemap(jobId).then((res) => {
        // console.log(res);
        snpArray = res.data.data.finemapSnp;
        configArray = res.data.data.finemapConfig;
        setDot();
        setBar();
    }).catch(() => { 
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped></style>
