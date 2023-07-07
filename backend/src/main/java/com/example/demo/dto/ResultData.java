package com.example.demo.dto;

public class ResultData {

    /**
     * 任务创建时间
     */
    private String jobCreateTime;
    /**
     * 任务展示
     */
    private String jobDisplay;
    /**
     * 任务下载
     */
    private String jobDownload;
    /**
     * 任务ID
     */
    private String jobId;
    /**
     * 任务状态
     */
    private String jobStatus;
    /**
     * 任务类型
     */
    private String jobType;

    private String jobFinishTime;

    public String getJobCreateTime() { return jobCreateTime; }
    public void setJobCreateTime(String value) { this.jobCreateTime = value; }

    public String getJobDisplay() { return jobDisplay; }
    public void setJobDisplay(String value) { this.jobDisplay = value; }

    public String getJobDownload() { return jobDownload; }
    public void setJobDownload(String value) { this.jobDownload = value; }

    public String getJobId() { return jobId; }
    public void setJobId(String value) { this.jobId = value; }

    public String getJobStatus() { return jobStatus; }
    public void setJobStatus(String value) { this.jobStatus = value; }

    public String getJobType() { return jobType; }
    public void setJobType(String value) { this.jobType = value; }

    public String getJobFinishTime() { return jobFinishTime; }
    public void setJobFinishTime(String value) { this.jobFinishTime = value; }
}
