import { request } from '../utils/request.js';
import axios from "axios";

// 调取任务信息
const getJobInfo = (jobId) => {
    return request({
        url: '/api/v1/result/jobInfo',
        method: 'get',
        params: {
            jobId: jobId
        }
    })
}

// 获取结果文件
const getResultFiles = (jobId) => {
    return request({
        url: '/api/v1/result/getResultFiles',
        method: 'get',
        params: {
            jobId: jobId
        }
    })
}

// 根据文件url下载具体文件
const downloadFileByURL = (fileName, fileURL) => {
    axios.get(fileURL, { responseType: 'blob' }).then((response) => {
        const url = window.URL.createObjectURL(new Blob([response.data]))
        const link = document.createElement('a')
        link.href = url
        link.setAttribute('download', fileName)
        document.body.appendChild(link)
        link.click()
    })
}

export default {
    getJobInfo,
    getResultFiles,
    downloadFileByURL
}