<template>
    <div id="main1" style="margin-left: 10%; width: 80%;height:1000px;"></div>
    <div id="main2" style="margin-left: 10%; width: 80%;height:1000px;"></div>
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
var sigName = null;
var sigExtractName = null;
var geneName = null;
var geneExtractName = null;

var sigArray = null;
var sigExtractArray = null;
var geneArray = null;
var geneExtractArray = null;


// 第一幅图，判断extract数组中是否包含这个obj
const isContainsExtract1 = (geneId) => {
    var found = false;
    for (var i = 0; i < geneExtractArray.length; i++) {
        if (geneExtractArray[i].Gene === geneId) {
            found = true;
            break;
        }
    }
    return found;
}

// 第二幅图，判断extract数组中是否包含这个obj
const isContainsExtract2 = (geneId) => {
    var found = false;
    for (var i = 0; i < sigExtractArray.length; i++) {
        if (sigExtractArray[i].Signal === geneId) {
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

// 绘制第一幅图
const setChart1 = () => {
    var myChart = echarts.init(document.getElementById('main1'));

    const jsonData = geneArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `GLCP: ${item.GLCP}, Gene: ${item.Gene}, GRCP: ${item.GRCP}`,
        value: [item.GLCP, item.GRCP],
        gene: item.Gene,
    }));

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of ' + geneName + ' and ' + geneExtractName + ' file by fastENLOC',
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
                filterMode: 'filter',
            },
            {
                id: 'dataZoomY',
                type: 'slider',
                yAxisIndex: [0],
                filterMode: 'empty'
            }
        ],
        grid: {
            bottom: '80px',
        },
        xAxis: {
            type: 'value',
            name: 'Gene locus-level colocalization probability',
            nameLocation: "middle",
            nameGap: 18,
            show: true,
            // axisTick: {
            //     show: true,  // 不显示刻度
            //     inside: true,
            // },
            // axisLabel: {
            //     show: false, // 不显示刻度上的数字
            // },
            axisLabel: {
                formatter: function (value) {
                    return value.toExponential(2); // 将 y 轴数值转换为科学计数法格式
                }
            },
        },
        yAxis: {
            type: 'value',
            name: 'Gene variant-level \n colocalization probability',
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
                        return !isContainsExtract1(params.data.gene) ? '#A9E2F3' : 'red'; // 根据阈值设置颜色
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

// 绘制第二幅图
const setChart2 = () => {
    var myChart = echarts.init(document.getElementById('main2'));

    const jsonData = sigArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `LCP: ${item.LCP}, RCP: ${item.RCP}, Signal: ${item.Signal}`,
        value: [item.LCP, item.RCP],
        signal: item.Signal,
    }));

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of ' + sigName + ' and ' + sigExtractName + ' file by fastENLOC',
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
        grid: {
            bottom: '80px',
        },
        xAxis: {
            type: 'value',
            name: '   Locus-level colocalization probability',
            nameLocation: "middle",
            nameGap: 18,
            show: true,
            // axisTick: {
            //     show: true,  // 不显示刻度
            //     inside: true,
            // },
            // axisLabel: {
            //     show: false, // 不显示刻度上的数字
            // },
            axisLabel: {
                formatter: function (value) {
                    return value.toExponential(2); // 将 y 轴数值转换为科学计数法格式
                }
            },
        },
        yAxis: {
            type: 'value',
            name: 'Regional colocalization probability',
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
                        return !isContainsExtract2(params.data.signal) ? '#A9E2F3' : 'red'; // 根据阈值设置颜色
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

// 开始绘图
const initChart = () => {
    const jobId = jobStore.jobId;

    chartAPI.reqFastenloc(jobId).then((res) => {
        sigName = res.data.data.sigName;
        sigExtractName = res.data.data.sigExtractName;
        geneName = res.data.data.geneName;
        geneExtractName = res.data.data.geneExtractName;

        sigArray = res.data.data.sigArray;
        sigExtractArray = res.data.data.sigExtractArray;
        geneArray = res.data.data.geneArray;
        geneExtractArray = res.data.data.geneExtractArray;

        setChart1();
        setChart2();
    }).catch(() => { 
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped></style>
