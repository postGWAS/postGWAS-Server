<template>
    <div id="main" style="margin-left: 10%; width: 80%;height:900px;"></div>
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

// data
var resultArray = null;
var threshold = null;

onMounted(() => {
    initChart();
});

onUnmounted(() => {
    echart.dispose;
});

// 设置图像
const setChart = () => {
    var myChart = echarts.init(document.getElementById('main'));

    const jsonData = resultArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `SNP: ${item.snp}, SNP.PP.H4: ${item["SNP.PP.H4"]}`,
        value: [item.snp, item["SNP.PP.H4"]],
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));


    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of result.txt file by COLOC',
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
            name: 'Posterior Probability of One Common Causal Variant',
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
                        return Number(params.value[1]) < threshold ? '#A9E2F3' : 'red'; // 根据阈值设置颜色
                    },
                },
                label: {
                    show: false,
                    formatter: function (params) {
                        return params.name;
                    }
                }
            },
            {
                type: 'line',
                markLine: {
                    symbol: "none",
                    label: {
                        show: true,
                        formatter: 'Threshold: ' + threshold
                    },
                    lineStyle: {
                        color: "red",
                        type: "dashed"
                    },
                    data: [
                        {
                            yAxis: threshold
                        }
                    ]
                }
            }
        ]
    };

    myChart.setOption(option);
}

// 初始化
const initChart = () => {
    const jobId = jobStore.jobId;

    chartAPI.reqColoc(jobId).then((res) => {
        resultArray = res.data.data.resultArray;
        threshold = res.data.data.threshold;
        setChart();
    }).catch(() => { 
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped></style>
