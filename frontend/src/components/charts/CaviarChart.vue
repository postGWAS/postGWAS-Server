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

var setArray = null;
var postArray = null;

onMounted(() => {
    initChart();

});

onUnmounted(() => {
    echart.dispose;
});

// 设置图像
const setChart = () => {
    var myChart = echarts.init(document.getElementById('main'));

    const jsonData = postArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    const data = jsonData.concat(setArray).map(item => ({
        name: `${item.snpID} (Rank ${item.rank}, causal_Post_Prob: ${item.casual_Post_Prob}, prob_in_pCausalSet: ${item.prob_in_pCasualSet})`,
        value: [item.snpID, item.prob_in_pCasualSet],
        type: setArray.includes(item) ? 'set' : 'post'
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));


    // 配置散点图
    const option = {
        title: {
            text: 'Visualization results of log_set_sorted and log_post_sorted file by CAVIAR',
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
            name: 'SNP ID',
            show: true,
            axisTick: {
                show: false  // 不显示刻度
            },
            axisLabel: {
                show: false // 不显示刻度上的数字
            }
        },
        yAxis: {
            type: 'log',
            name: 'prob_in_pCausalSet',
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
                data: data.filter(item => item.type === 'post'),
                itemStyle: {
                    color: '#A9E2F3'
                },
                label: {
                    show: false,
                    formatter: function (params) {
                        return params.name;
                    }
                }
            },
            {
                name: 'set',
                type: 'scatter',
                data: data.filter(item => item.type === 'set'),
                itemStyle: {
                    color: 'red'
                },
                label: {
                    show: false,
                    formatter: function (params) {
                        return params.name;
                    }
                }
            }
        ]
    };

    myChart.setOption(option);
}

const initChart = () => {
    const jobId = jobStore.jobId;

    chartAPI.reqCaviar(jobId).then((res) => {
        console.log(res);
        postArray = res.data.data.postArray;
        setArray = res.data.data.setArray;
        setChart();
    }).catch(() => { 
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped></style>
