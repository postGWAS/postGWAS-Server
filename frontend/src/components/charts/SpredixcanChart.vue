<template>
    <div id="main1" style="margin-left: 10%; width: 80%;height:900px;"></div>
    <br><br>
    <div id="main2" style="margin-left: 10%; width: 80%;height:900px;"></div>
</template>

<script setup>
import * as echarts from "echarts";
import { onMounted, onUnmounted } from "vue";
import { useJobStore } from '@stores/index.js';
import chartAPI from '@api/charts.js';
import { ElMessage } from "element-plus";

// 定义存储
const jobStore = useJobStore;

// 绘图数据
var resultArray = null;

/// 声明定义一下echart
let echart = echarts;

onMounted(() => {
    initChart();


});

onUnmounted(() => {
    echart.dispose;
});

const setChart1 = () => {
    var myChart = echarts.init(document.getElementById('main1'));

    const jsonData = resultArray;

    // const threshold = 0.95;

    // 渐变颜色的变化
    var minVal = 10;
    var maxVal = -10;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData
        .filter(item => item.pvalue !== 'NA' && item.zscore !== 'NA')
        .map(item => ({
            pvalue: -Math.log(item.pvalue) / Math.log(10),
            gene_name: item.gene_name,
            gene: item.gene,
            zscore: item.zscore,
        }))
        .map(item => ({
            name: `gene_name: ${item.gene_name}, -log10(pvalue): ${item.pvalue}, gene: ${item.gene}, zscore: ${item.zscore}`,
            value: [item.gene_name, item.pvalue],
        }))
        .sort((a, b) => a.value[0].localeCompare(b.value[0]));

    for (var i = 0; i < data.length; i++) {
        minVal = Math.min(minVal, data[i].value[1]);
        maxVal = Math.max(maxVal, data[i].value[1]);
    }

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of result.out by S-PrediXcan',
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
            name: 'gene',
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
            type: 'value',
            name: '-log10(pvalue)',
            show: true,
            // axisLabel: {
            //     formatter: function (value, index) {
            //         return value.toExponential(2); // 将 y 轴数值转换为科学计数法格式
            //     }
            // },
        },
        visualMap: {
            type: 'continuous',
            min: minVal,
            max: maxVal,
            calculable: true,
            inRange: {
                color: ['#A9E2F3', 'red']
            },
            dimension: 1
        },
        series: [
            {
                name: 'post',
                type: 'scatter',
                data: data,
                itemStyle: {
                    color: 'visualMap-continuous'
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

const setChart2 = () => {
    var myChart = echarts.init(document.getElementById('main2'));

    const jsonData = resultArray;

    // const threshold = 0.95;

    // 渐变颜色的变化
    var minVal = 1;
    var maxVal = -1;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData
        .filter(item => item.pvalue !== 'NA' && item.zscore !== 'NA')
        .map(item => ({
            pvalue: -Math.log(item.pvalue) / Math.log(10),
            gene_name: item.gene_name,
            gene: item.gene,
            zscore: item.zscore,
        }))
        .map(item => ({
            name: `gene_name: ${item.gene_name}, -log10(pvalue): ${item.pvalue}, gene: ${item.gene}, zscore: ${item.zscore}`,
            value: [item.gene_name, item.zscore],
        }))
        .sort((a, b) => a.value[0].localeCompare(b.value[0]));

    for (var i = 0; i < data.length; i++) {
        minVal = Math.min(minVal, data[i].value[1]);
        maxVal = Math.max(maxVal, data[i].value[1]);
    }

    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of result.csv by S-PrediXcan',
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
            name: 'gene',
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
            type: 'value',
            name: 'zscore',
            show: true,
            // axisLabel: {
            //     formatter: function (value, index) {
            //         return value.toExponential(2); // 将 y 轴数值转换为科学计数法格式
            //     }
            // },
        },
        visualMap: {
            type: 'continuous',
            min: minVal,
            max: maxVal,
            calculable: true,
            inRange: {
                color: ['#A9E2F3', '#9d34f1']
            },
            dimension: 1
        },
        series: [
            {
                name: 'post',
                type: 'scatter',
                data: data,
                itemStyle: {
                    color: 'visualMap-continuous'
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

    chartAPI.reqSpredixcan(jobId).then((res) => {
        resultArray = res.data.data.resultArray;

        setChart1();
        setChart2();
    }).catch(() => {
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped></style>
