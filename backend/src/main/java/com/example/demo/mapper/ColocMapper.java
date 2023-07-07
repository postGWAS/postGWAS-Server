package com.example.demo.mapper;

import com.example.demo.entity.Coloc;
import com.example.demo.entity.Job;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ColocMapper {
    int insert(Coloc coloc);

    Coloc selectByJobid(String jobid);

    int updateByPrimaryKey(Coloc coloc);
}
