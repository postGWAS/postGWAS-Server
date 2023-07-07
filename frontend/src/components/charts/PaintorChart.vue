<template>
    <div id="main" style="width: 80%;height:900px;"></div>
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

// 绘图数据源
var locusArray = null;

// 制作图像
const setLocus = () => {
    var myChart = echarts.init(document.getElementById('main'));

    const jsonData = locusArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.map(item => ({
        name: `SNP: ${item.rs_id}, Posterior_Prob: ${item.Posterior_Prob}, zscore: ${item.zscore}`,
        value: [item.rs_id, item.Posterior_Prob],
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));


    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of locus.results file by PAINTOR'
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

onMounted(() => {
    initChart();
});

onUnmounted(() => {
    echart.dispose;
});

const initChart = () => {
    const jobId = jobStore.jobId;

    chartAPI.reqPaintor(jobId).then((res) => {
        console.log(res);
        locusArray = res.data.data.locusResults;
        setLocus();
    }).catch(() => { 
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped>

</style>
