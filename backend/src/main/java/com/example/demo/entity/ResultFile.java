package com.example.demo.entity;

public class ResultFile {

    private String fileid;
    private String jobid;
    private String filename;
    private String path;

    public String getFileid(){
        return this.fileid;
    }

    public void setFileid(String fileid){
        this.fileid = fileid;
    }

    public String getJobid(){
        return this.jobid;
    }

    public void setJobid(String jobid){
        this.jobid = jobid;
    }
    public String getFilename(){
        return this.filename;
    }

    public void setFilename(String filename){
        this.filename = filename;
    }

    public String getPath(){
        return this.path;
    }

    public void setPath(String path){
        this.path = path;
    }
}
