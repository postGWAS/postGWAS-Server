<template>
    <div id="main1" style="margin-left: 10%; width: 80%;height:900px;"></div>
    <br><br>
    <div id="main2" style="margin-left: 10%; width: 80%;height:900px;"></div>
    <br><br>
    <div id="main3" style="margin-left: 10%; width: 80%;height:900px;"></div>
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

// 绘图数据
var set1Array = null;
var post1Array = null;
var set2Array = null;
var post2Array = null;
var colArray = null;

// 第一个图使用，判断set数组中是否包含这个obj
const isContainsSNP1 = (snp) => {
    var found = false;
    for (var i = 0; i < set1Array.length; i++) {
        if (set1Array[i].snpID === snp) {
            found = true;
            break;
        }
    }
    return found;
}

// 第二个图使用，判断set数组中是否包含这个obj
const isContainsSNP2 = (snp) => {
    var found = false;
    for (var i = 0; i < set2Array.length; i++) {
        if (set2Array[i].snpID === snp) {
            found = true;
            break;
        }
    }
    return found;
}

onMounted(() => {
    initChart();


});

onUnmounted(() => {
    echart.dispose;
});

// 绘制第一个图
const setChart1 = () => {
    var myChart = echarts.init(document.getElementById('main1'));

    const jsonData = post1Array;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `snpID: ${item.snpID}, Causal_Post_Prob: ${item.Casual_Post_Prob}, grank: ${item.grank}, prob_in_pCausalSet: ${item.prob_in_pCasualSet}`,
        value: [item.snpID, item.Casual_Post_Prob],
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of log_1_set_sorted and log_1_post_sorted by eCAVIAR'
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
            name: 'Causal Posterior Probability',
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
                    color: function (params) {
                        return !isContainsSNP1(params.value[0]) ? '#A9E2F3' : 'red'; // 根据阈值设置颜色
                    },
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

// 绘制第二个图
const setChart2 = () => {
    var myChart = echarts.init(document.getElementById('main2'));

    const jsonData = post2Array;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `snpID: ${item.snpID}, Causal_Post_Prob: ${item.Casual_Post_Prob}, grank: ${item.grank}, prob_in_pCausalSet: ${item.prob_in_pCasualSet}`,
        value: [item.snpID, item.Casual_Post_Prob],
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of log_2_set_sorted and log_2_post_sorted by eCAVIAR'
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
            name: 'Causal Posterior Probability',
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
                    color: function (params) {
                        return !isContainsSNP2(params.value[0]) ? '#A9E2F3' : 'red'; // 根据阈值设置颜色
                    },
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

// 绘制第三个图
const setChart3 = () => {
    var myChart = echarts.init(document.getElementById('main3'));

    const jsonData = colArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `snpID: ${item.snpID}, CLPP: ${item.CLPP}, rank: ${item.rank}, prob_in_pCausalSet: ${item.prob_in_pCasualSet}`,
        value: [item.snpID, item.CLPP],
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of log_col_sorted by eCAVIAR'
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
            name: 'Coloclization Posterior Probability',
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

    chartAPI.reqEcaviar(jobId).then((res) => {
        post1Array = res.data.data.post1Array;
        set1Array = res.data.data.set1Array;
        post2Array = res.data.data.post2Array;
        set2Array = res.data.data.set2Array;
        colArray = res.data.data.colArray;

        setChart1();
        setChart2();
        setChart3();
    }).catch(() => { 
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped></style>
