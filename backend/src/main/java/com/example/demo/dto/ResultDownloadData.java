package com.example.demo.dto;

public class ResultDownloadData {
    /**
     * 结果文件列表
     */
    private ResultDownloadFile[] files;

    public ResultDownloadFile[] getFiles() { return files; }
    public void setFiles(ResultDownloadFile[] value) { this.files = value; }
}
