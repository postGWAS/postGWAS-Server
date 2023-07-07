<template>
    <div>
        Threshold: 
        <el-input v-model.number="threshold" type="number" placeholder="Please input threshold." size="small" style="width: 10%;"></el-input>
        <el-button @click="changeThreshold(); func.clickHandler($event)" size="small" style="margin-left: 2%;">Change</el-button>
    </div>
    <br>
    <div>
        <div id="main" style="margin-left: 10%; width: 80%;height:900px;"></div>
    </div>
</template>

<script setup>
import * as echarts from "echarts";
import { onMounted, onUnmounted, ref } from "vue";
import { useJobStore } from '@stores/index.js';
import chartAPI from '@api/charts.js';
import { func } from '@utils/button.js';
import { ElMessage } from "element-plus";


// 定义存储
const jobStore = useJobStore;

/// 声明定义一下echart
let echart = echarts;
var myChart;
var option;
var data;

// 门限值
const threshold = ref(0.03);

// 绘图数据集
var caviarbfArray = null;

// 确认更改
const changeThreshold = () => {
    updateOption();
    myChart.setOption(option, true);
}

// 更新option配置
const updateOption = () => {
    // console.log("门限值", threshold.value, "  ", typeof (threshold.value));
    option = {
        title: {
            text: 'Visualization results of myﬁle.bf.prior0.rsid.marginal file by CAVIARBF',
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
            name: 'Posterior Inclusion Probability (PIP)',
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
                        return params.value[1] < threshold.value ? '#A9E2F3' : 'red'; // 根据阈值设置颜色
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
                        formatter: 'Threshold: ' + threshold.value
                    },
                    lineStyle: {
                        color: "red",
                        type: "dashed"
                    },
                    data: [
                        {
                            yAxis: threshold.value
                        }
                    ],
                    precision: 20,
                }
            }
        ]
    };
}

onMounted(() => {
    initChart();
});

onUnmounted(() => {
    echart.dispose;
});


const setChart = () => {
    myChart = echarts.init(document.getElementById('main'));

    const jsonData = caviarbfArray;

    // 从 JSON 数据中提取散点图所需的坐标和标签信息
    data = jsonData.map(item => ({
        name: `SNP: ${item.rs_id}, PIP: ${item.PIP}`,
        value: [item.rs_id, item.PIP],
    })).sort((a, b) => a.value[0].localeCompare(b.value[0]));

    // 配置散点图
    updateOption()
    myChart.setOption(option);
}

const initChart = () => {
    const jobId = jobStore.jobId;

    chartAPI.reqCaviarbf(jobId).then((res) => {
        
        caviarbfArray = res.data.data.caviarbfArray;
        setChart();
    }).catch(() => { 
        ElMessage.error('Get data failed');
    });
}

</script>

<style scoped></style>
