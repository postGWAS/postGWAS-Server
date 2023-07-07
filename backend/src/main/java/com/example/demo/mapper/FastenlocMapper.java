package com.example.demo.mapper;

import com.example.demo.entity.Fastenloc;
import com.example.demo.entity.Job;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FastenlocMapper {
    int insert(Fastenloc fastenloc);

    Fastenloc selectByJobid(String jobid);

    int updateByPrimaryKey(Fastenloc fastenloc);
}
