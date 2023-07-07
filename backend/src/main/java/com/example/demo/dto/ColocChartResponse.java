package com.example.demo.dto;

public class ColocChartResponse {
    /**
     * 服务响应
     */
    private long code;
    /**
     * 返回的数据对象
     */
    private ColocChartData data;
    /**
     * 服务说明
     */
    private String message;

    public long getCode() { return code; }
    public void setCode(long value) { this.code = value; }

    public ColocChartData getData() { return data; }
    public void setData(ColocChartData value) { this.data = value; }

    public String getMessage() { return message; }
    public void setMessage(String value) { this.message = value; }
}
