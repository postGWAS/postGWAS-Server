package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

@RestController
public class ExampleDownloadController {

    @Value("${example_file_path}")
    private String exampleFilePath;

    @GetMapping("/api/v1/file/download")
    public void downloadExample(@RequestParam("fileName") String fileName, HttpServletResponse response){
        String contentType = "";
        switch(fileName){
            case "colocGwas.txt":contentType ="text/plain";break;
            case "colocEqtl.txt":contentType ="text/plain";break;
            case "ecaviarGwas.txt":contentType ="text/plain";break;
            case "ecaviarGwasLd.ld":contentType ="text/plain";break;
            case "ecaviarEqtl.txt":contentType ="text/plain";break;
            case "ecaviarEqtlLd.ld":contentType ="text/plain";break;
            case "fastenlocGwas.gz":contentType ="application/gzip";break;
            case "caviarGwas.txt":contentType ="text/plain";break;
            case "caviarGwasLd.txt":contentType ="text/plain";break;
            case "finemapGwas.z":contentType ="text/plain";break;
            case "finemapGwasLd.ld":contentType ="text/plain";break;
            case "paintorGwas":contentType ="text/plain";break;
            case "paintorGwasLd.ld":contentType ="text/plain";break;
            case "paintorMatrix.annotations":contentType ="text/plain";break;
            case "fusionGwas.txt.gz":contentType ="application/gzip";break;
            case "sPrediXcanGwas.gz":contentType ="application/gzip";break;
            case "caviarbfGwas.txt":contentType ="text/plain";break;
            case "caviarbfGwasLd.txt":contentType ="text/plain";break;
            default:return;
        }
        String filePath = exampleFilePath + fileName;
        File file = new File(filePath);
        response.setHeader("Content-Type",contentType);
        //设置下载文件的名称，解决中文文件名乱码问题
        response.setHeader("Content-Disposition","attachment;filename="+ fileName);
        //创建流
        FileInputStream is = null;
        BufferedInputStream bs = null;
        ServletOutputStream os = null;
        //流到客户端
        try{
            is = new FileInputStream(file);
            bs =new BufferedInputStream(is);
            os = response.getOutputStream();
            byte[] buffer = new byte[1024];
            int len = 0;
            while((len = bs.read(buffer)) != -1){
                os.write(buffer,0,len);
            }
        }catch (IOException ex){
            ex.printStackTrace();
        }finally {
            try{
                if(is != null){
                    is.close();
                }
                if( bs != null ){
                    bs.close();
                }
                if( os != null){
                    os.flush();
                    os.close();
                }
            }catch (IOException e){
                e.printStackTrace();
            }
        }



    }
}
