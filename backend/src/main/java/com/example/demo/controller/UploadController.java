package com.example.demo.controller;


import com.example.demo.dto.UploadData;
import com.example.demo.dto.UploadResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.example.demo.mapper.UserFileMapper;
import com.example.demo.entity.UserFile;

import java.io.IOException;
import java.io.File;
import java.util.UUID;

@RestController
public class UploadController {

    @Value("${upload_file_path}")
    private String fileSavePath;

    @Autowired
    private UserFileMapper userfileMapper;

    @PostMapping("/api/v1/file/upload")
    public UploadResponse upload(@RequestParam("file") MultipartFile uploadFile) {
        UploadResponse response = new UploadResponse();
        UploadData data = new UploadData();
        UserFile userFile = new UserFile();
        userFile.setID(UUID.randomUUID().toString());
        userFile.setFile_name(uploadFile.getOriginalFilename());
        String filePath = fileSavePath + userFile.getID() + '/';
        File directory = new File(filePath);
        directory.mkdirs();
        try{
            uploadFile.transferTo(new File(directory, userFile.getFile_name()));
        } catch (IOException e){
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("Upload Failed");
            return response;
        }
        userFile.setFile_path(filePath + userFile.getFile_name());
        userfileMapper.insert(userFile);
        data.setid(userFile.getID());
        response.setCode(200);
        response.setData(data);
        response.setMessage("Upload Success");
        return response;
    }
}

