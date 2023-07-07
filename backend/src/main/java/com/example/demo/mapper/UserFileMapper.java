package com.example.demo.mapper;


import com.example.demo.entity.UserFile;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserFileMapper {

    int insert(UserFile userFile);

    UserFile selectByID(String id);
}