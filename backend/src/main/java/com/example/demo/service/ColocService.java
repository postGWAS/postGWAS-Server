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
public class ColocService {
    @Autowired
    JobMapper jobMapper;

    @Autowired
    ResultFileMapper resultFileMapper;

    @Autowired
    SendResultService sendResultService;

    @Async
    public void coloc(String gwas, String eqtl, long ngwas, long neqtl, String rsid, String beta,
                      String pval, String varbeta, String ersid, String epval, String emaf, String geneid,
                      double threshold, double flag, String tissue, String jobid, String email){
        Job job = new Job();
        Date date = new Date();
        SimpleDateFormat dateFormat= new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        job.setJobid(jobid);
        job.setType("COLOC");
        job.setStatus("Running");
        job.setCreate_time(dateFormat.format(date));
        job.setResult_path("/gwas2gene/coloc/COLOC_" + jobid + ".zip");
        job.setDir_path("/gwas2gene/coloc/dir_coloc_" + jobid + "/");
        System.out.println(job.getResult_path() + " " + job.getDir_path());
        jobMapper.insert(job);

        //运行脚本
        try {
            // 设置 Conda 环境名称和 R 脚本路径
            String condaEnvironmentName = "R4.2.0";
            String rScriptPath = "/gwas2gene/coloc/";
            String rScript = "coloc.R";

               // 设置 "source activate" 命令行参数和 Rscript 命令行参数
            List<String> commands = new ArrayList<String>();
            if(flag == 0) {
                commands.addAll(Arrays.asList("/bin/bash", "-c", "source activate " + condaEnvironmentName + " && " +
                        "cd " + rScriptPath + " && Rscript " + rScript +
                        " -g " + gwas +
                        " -e " + eqtl +
                        " --ng " + ngwas +
                        " --ne " + neqtl +
                        " --rsID " + rsid +
                        " --pval " + pval +
                        " --beta " + beta +
                        " --varbeta " + varbeta +
                        " --ersID " + ersid +
                        " --emaf " + emaf +
                        " --epval " + epval +
                        " --threshold " + threshold +
                        " --geneID " + geneid +
                        " --jobID " + jobid));
                System.out.println(commands);
            } else if (flag == 1) {
                commands.addAll(Arrays.asList("/bin/bash", "-c", "source activate " + condaEnvironmentName + " && " +
                        "cd " + rScriptPath + " && Rscript " + rScript +
                        " -g " + gwas +
                        " --ng " + ngwas +
                        " --rsID " + rsid +
                        " --pval " + pval +
                        " --beta " + beta +
                        " --varbeta " + varbeta +
                        " --threshold " + threshold +
                        " --flag " + "1" +
                        " --tissue " + tissue +
                        " --jobID " + jobid));
                System.out.println(commands);
            }

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
        String readmePath = "/gwas2gene/coloc/readme.txt";
        String command = "cp "+ readmePath + " /gwas2gene/coloc/dir_coloc_" + jobid;
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
        String folderName = "dir_coloc_" + jobid;
        String zipName = "COLOC_" + jobid + ".zip";
        String resultPath = "/gwas2gene/coloc/";
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
