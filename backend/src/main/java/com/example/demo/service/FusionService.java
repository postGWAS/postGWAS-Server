package com.example.demo.service;

import com.example.demo.entity.Job;
import com.example.demo.entity.ResultFile;
import com.example.demo.mapper.JobMapper;
import com.example.demo.mapper.ResultFileMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class FusionService {
    @Autowired
    JobMapper jobMapper;

    @Autowired
    ResultFileMapper resultFileMapper;

    @Autowired
    SendResultService sendResultService;

    @Async
    public void fusion(String gwas, String tissue, String zscore, String rsid, String a1, String a2,
                       long chr, String model, String threshold, String jobid, String email){
        Job job = new Job();
        Date date = new Date();
        SimpleDateFormat dateFormat= new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        job.setJobid(jobid);
        job.setType("FUSION");
        job.setStatus("Running");
        job.setCreate_time(dateFormat.format(date));
        job.setResult_path("/gwas2gene/fusion/FUSION_" + jobid + ".zip");
        job.setDir_path("/gwas2gene/fusion/dir_fusion_" + jobid + "/");
        System.out.println(job.getResult_path() + " " + job.getDir_path());
        jobMapper.insert(job);

        //运行脚本
        try {
            // 设置 Conda 环境名称和 R 脚本路径
            String condaEnvironmentName = "R3.6.1";
            String rScriptPath = "/gwas2gene/fusion/";
            String rScript = "fusion.R";

            // 设置 "source activate" 命令行参数和 Rscript 命令行参数
            List<String> commands = new ArrayList<String>();
            commands.addAll(Arrays.asList("/bin/bash", "-c", "source activate " + condaEnvironmentName + " && " +
                    "cd " + rScriptPath + " && Rscript " + rScript +
                    " -g " + gwas +
                    " --zscore " + zscore +
                    " --rsID " + rsid +
                    " --A1 " + a1 +
                    " --A2 " + a2 +
                    " --chr " + chr +
                    " --model " + model +
                    " --tissue " + tissue +
                    " --threshold " + threshold +
                    " --jobID " + jobid));
            System.out.println(commands);

            // 执行命令
            ProcessBuilder pb = new ProcessBuilder(commands);
            pb.redirectErrorStream(true);
            Process process = pb.start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

            // 打印输出
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            // 等待脚本执行完毕
            int exitCode = process.waitFor();
            System.out.println("R script executed with exit code " + exitCode);
            if(exitCode == 0) {
                job.setStatus("Success");
                jobMapper.updateByPrimaryKey(job);
            } else {
                job.setStatus("Failed");
                jobMapper.updateByPrimaryKey(job);
                sendResultService.SendErrorByEmail(email, jobid);
                return;
            }
        } catch(Exception e) {
            e.printStackTrace();
            job.setStatus("Failed");
            jobMapper.updateByPrimaryKey(job);
            sendResultService.SendErrorByEmail(email, jobid);
            return;
        }
        Date date1 = new Date();
        job.setFinish_time(dateFormat.format(date1));
        jobMapper.updateByPrimaryKey(job);
        String readmePath = "/gwas2gene/fusion/readme.txt";
        String command = "cp "+ readmePath + " /gwas2gene/fusion/dir_fusion_" + jobid;
        try {
            ProcessBuilder pb = new ProcessBuilder("/bin/bash", "-c", command);
            Process process = pb.start();
            int exitCode = process.waitFor();

        } catch (Exception e) {
            e.printStackTrace();
        }
        //将结果文件信息存入数据库
        try{
            Job job1 = jobMapper.selectByJobid(jobid);
            String dir_path = job1.getDir_path();
            File folder = new File(dir_path);
            File[] listOfFiles = folder.listFiles();
            for (File file : listOfFiles) {
                if (file.isFile()) {
                    ResultFile resultFile = new ResultFile();
                    String fileid = UUID.randomUUID().toString().replace("-" ,"");
                    resultFile.setFileid(fileid);
                    resultFile.setJobid(jobid);
                    resultFile.setFilename(file.getName());
                    resultFile.setPath(dir_path + "/" + file.getName());
                    resultFileMapper.insert(resultFile);
                    System.out.println(file.getName());
                }
            }

        } catch (Exception e){
            e.printStackTrace();
        }

        //压缩结果文件夹
        String folderName = "dir_fusion_" + jobid;
        String zipName = "FUSION_" + jobid + ".zip";
        String resultPath = "/gwas2gene/fusion/";
        String zipCommand = "cd "+ resultPath + " && zip -r " + zipName + " " + folderName;
        try {
            ProcessBuilder pb = new ProcessBuilder("/bin/bash", "-c", zipCommand);
            Process process = pb.start();

            // 等待执行完成
            int exitCode = process.waitFor();
            System.out.println("Zip executed with exit code " + exitCode);

        } catch (Exception e) {
            e.printStackTrace();
        }

        //发送邮件
        sendResultService.SendResultByEmail(email, jobid);
    }
}
