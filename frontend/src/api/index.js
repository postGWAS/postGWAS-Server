import axios from 'axios';
import { ElMessage } from 'element-plus';

const downloadFile = (fileName) => {
  ElMessage.success("File starts downloading, it may takes several minutes.");

  // 更换为axios原生下载
  axios({
    url: import.meta.env.VITE_APP_BASEURL + '/api/v1/file/download',
    method: 'GET',
    responseType: 'blob',
    params: {
      fileName: fileName
    },
  }).then((response) => {
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', fileName);
    document.body.appendChild(link);
    link.click();
  });
};

export default { downloadFile };
