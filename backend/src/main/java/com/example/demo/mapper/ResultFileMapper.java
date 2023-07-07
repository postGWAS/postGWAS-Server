package com.example.demo.mapper;


import com.example.demo.entity.ResultFile;
import com.example.demo.entity.UserFile;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ResultFileMapper {

    int insert(ResultFile resultFile);

    ResultFile selectByID(String fileid);

    List<ResultFile> selectAll();
}