package com.example.demo.entity;

public class Job {

    private String jobid;
    private String status;
    private String result_path;
    private String type;
    private String create_time;
    private String finish_time;
    private String dir_path;

    public String getJobid(){
        return this.jobid;
    }

    public void setJobid(String jobid){
        this.jobid = jobid;
    }

    public String getStatus(){
        return this.status;
    }

    public void setStatus(String status){
        this.status = status;
    }

    public String getResult_path(){
        return this.result_path;
    }

    public void setResult_path(String result_path){
        this.result_path = result_path;
    }

    public String gettype(){
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCreate_time(){
        return this.create_time;
    }

    public void setCreate_time(String create_time){
        this.create_time = create_time;
    }

    public String getFinish_time(){
        return this.finish_time;
    }

    public void setFinish_time(String finish_time){
        this.finish_time = finish_time;
    }

    public String getDir_path(){
        return this.dir_path;
    }

    public void setDir_path(String dir_path){
        this.dir_path = dir_path;
    }
}
