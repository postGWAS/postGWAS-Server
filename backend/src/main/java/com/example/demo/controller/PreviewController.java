package com.example.demo.controller;

import com.example.demo.entity.ResultFile;
import com.example.demo.mapper.ResultFileMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.*;

@RestController
public class PreviewController {

    @Autowired
    ResultFileMapper resultFileMapper;
    @GetMapping("/api/v1/result/previewFile")
    public void previewFile(@RequestParam("fileId") String fileId,
                                   HttpServletResponse response) throws IOException {
        try {
            ResultFile resultFile = resultFileMapper.selectByID(fileId);
            String filePath = resultFile.getPath();
            File file = new File(filePath);
            FileInputStream inputStream = new FileInputStream(file);
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
            BufferedReader reader = new BufferedReader(inputStreamReader);
            String line;
            StringBuilder fileContent = new StringBuilder();
            while ((line = reader.readLine()) != null) {
                fileContent.append(line).append("\n");
            }
            reader.close();
            if(file.getName().substring(file.getName().length() - 3).equals("png")){
                response.setContentType("image/png");
                InputStream imageStream = new FileInputStream(file.getPath());
                OutputStream outputStream = response.getOutputStream();
                byte[] buffer = new byte[1024];
                int len = 0;
                while ((len = imageStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, len);
                }
                outputStream.flush();
            } else if(file.getName().substring(file.getName().length() - 3).equals("pdf")){
                response.setContentType("application/pdf");
                InputStream imageStream = new FileInputStream(file.getPath());
                OutputStream outputStream = response.getOutputStream();
                byte[] buffer = new byte[1024];
                int len = 0;
                while ((len = imageStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, len);
                }
                outputStream.flush();
            }
            else {
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(fileContent.toString());
            }
        } catch (Exception e){
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("Preview failed");
        }

    }
}
