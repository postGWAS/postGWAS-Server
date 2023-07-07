package com.example.demo.dto;

public class ResultDownloadFile {
    /**
     * 文件下载
     */
    private String fileDownload;
    /**
     * 文件id
     */
    private String fileId;
    /**
     * 文件名
     */
    private String fileName;
    /**
     * 文件预览
     */
    private String filePreview;

    public String getFileDownload() { return fileDownload; }
    public void setFileDownload(String value) { this.fileDownload = value; }

    public String getFileId() { return fileId; }
    public void setFileId(String value) { this.fileId = value; }

    public String getFileName() { return fileName; }
    public void setFileName(String value) { this.fileName = value; }

    public String getFilePreview() { return filePreview; }
    public void setFilePreview(String value) { this.filePreview = value; }
}
