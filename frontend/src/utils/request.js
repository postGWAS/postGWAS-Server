import axios from "axios";
import { ElMessage } from "element-plus"; 

export function request(config) {

    // axios实例
    const instance = axios.create({
        baseURL: import.meta.env.VITE_APP_BASEURL,
        timeout: 10000,
    })

    // 添加请求拦截器
    instance.interceptors.request.use(function reqInterception(config) {
        // 在发送请求之前做些什么
        return config;
    }, function reqErrorInterception(error) {
        // 对请求错误做些什么
        return Promise.reject(error);
    });

    // 添加响应拦截器
    instance.interceptors.response.use(function respInterception(response) {
        // 2xx 范围内的状态码都会触发该函数。
        // 对响应数据做点什么
        return response;
    }, function respErrorInterception(error) {
        // 超出 2xx 范围的状态码都会触发该函数。
        // 对响应错误做点什么
        if (error.response) {
            if (error.status === 500) {
                ElMessage.error('服务器内部发生错误!');
            }
        }

        return Promise.reject(error);
    });

    // 发送一个真正的请求
    return instance(config)
}