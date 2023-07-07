package com.example.demo.mapper;

import com.example.demo.entity.Job;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface JobMapper {

    int insert(Job job);

    Job selectByJobid(String jobid);

    int updateByPrimaryKey(Job job);
}
