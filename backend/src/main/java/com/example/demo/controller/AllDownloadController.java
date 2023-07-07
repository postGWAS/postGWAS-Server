package com.example.demo.controller;

import com.example.demo.entity.Job;
import com.example.demo.mapper.JobMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.*;

@RestController
public class AllDownloadController {

    @Autowired
    JobMapper jobMapper;

    @GetMapping("/api/v1/result/downloadAllFiles")
    public void downloadAllFiles(@RequestParam("jobId") String jobId,
                               HttpServletResponse response) throws IOException {
        Job job = jobMapper.selectByJobid(jobId);
        // 根据 jobId 获取需要下载的文件或文件夹路径
        String filePath = job.getResult_path();

        // 获取文件或文件夹名称
        String filename = job.gettype() + "_" + job.getJobid() + ".zip";

        // 设置响应头
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=" + new String(filename.getBytes(), "iso-8859-1"));

        InputStream is = null;
        OutputStream os = response.getOutputStream();
        try {
            // 读取需要下载的文件或文件夹，并写入输出流
            is = new FileInputStream(filePath);
            byte[] buffer = new byte[1024];
            int len = 0;
            while ((len = is.read(buffer)) > 0) {
                os.write(buffer, 0, len);
            }
            os.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 关闭输入输出流
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (os != null) {
                try {
                    os.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
