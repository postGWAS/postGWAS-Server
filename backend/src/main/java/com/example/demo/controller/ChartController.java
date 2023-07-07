package com.example.demo.controller;

import com.example.demo.dto.*;
import com.example.demo.entity.Coloc;
import com.example.demo.entity.Fastenloc;
import com.example.demo.entity.Job;
import com.example.demo.mapper.JobMapper;
import com.example.demo.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChartController {

    @Autowired
    JobMapper jobMapper;

    @Autowired
    FinemapChartService finemapChartService;

    @Autowired
    PaintorChartService paintorChartService;

    @Autowired
    CaviarBFChartService caviarBFChartService;

    @Autowired
    CaviarChartService caviarChartService;

    @Autowired
    SpredixcanChartService spredixcanChartService;

    @Autowired
    EcaviarChartService ecaviarChartService;

    @Autowired
    ColocChartService colocChartService;

    @Autowired
    FastenlocChartService fastenlocChartService;

    @Autowired
    FusionChartService fusionChartService;

    @GetMapping("/api/v1/chart/finemap")
    public FinemapChartResponse getFinemapChart(@RequestParam("jobId") String jobId) {

        FinemapChartResponse response = new FinemapChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            FinemapChartData data = finemapChartService.getFinemapChartData(dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get finemap chart success");
        } catch (Exception e){
            response.setCode(400);
            response.setMessage("Get finemap chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/paintor")
    public PaintorChartResponse getPaintorChart(@RequestParam("jobId") String jobId) {

        PaintorChartResponse response = new  PaintorChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            PaintorChartData data = paintorChartService.getPaintorChartData(dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get paintor chart success");
        } catch (Exception e){
            response.setCode(400);
            response.setMessage("Get paintor chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/caviarbf")
    public CaviarBFChartResponse getCaviarBFChart(@RequestParam("jobId") String jobId) {

        CaviarBFChartResponse response = new  CaviarBFChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            CaviarBFChartData data = caviarBFChartService.getCaviarBFChartData(dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get CAVIARBF chart success");
        } catch (Exception e){
            response.setCode(400);
            response.setMessage("Get CAVIARBF chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/caviar")
    public CaviarChartResponse getCaviarChart(@RequestParam("jobId") String jobId) {

        CaviarChartResponse response = new  CaviarChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            CaviarChartData data = caviarChartService.getCaviarChartData(dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get CAVIAR chart success");
        } catch (Exception e){
            response.setCode(400);
            response.setMessage("Get CAVIAR chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/s-predixcan")
    public SpredixcanChartResponse getSpredixcanChart(@RequestParam("jobId") String jobId) {

        SpredixcanChartResponse response = new  SpredixcanChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            SpredixcanChartData data = spredixcanChartService.getSpredixcanChartData(dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get S-PrediXcan chart success");
        } catch (Exception e){
            response.setCode(400);
            response.setMessage("Get S-PrediXcan chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/ecaviar")
    public EcaviarChartResponse getEcaviarChart(@RequestParam("jobId") String jobId) {

        EcaviarChartResponse response = new  EcaviarChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            EcaviarChartData data = ecaviarChartService.getEcaviarChartData(dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get eCAVIAR chart success");
        } catch (Exception e){
            response.setCode(400);
            response.setMessage("Get eCAVIAR chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/fastenloc")
    public FastenlocChartResponse getFastenlocChart(@RequestParam("jobId") String jobId) {

        FastenlocChartResponse response = new  FastenlocChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            FastenlocChartData data = fastenlocChartService.getFastenlocChartData(jobId, dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get COLOC chart success");
        } catch (Exception e){
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("Get COLOC chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/coloc")
    public ColocChartResponse getColocChart(@RequestParam("jobId") String jobId) {

        ColocChartResponse response = new  ColocChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            ColocChartData data = colocChartService.getColocChartData(jobId, dir);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get COLOC chart success");
        } catch (Exception e){
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("Get COLOC chart failed");
        }
        return response;
    }

    @GetMapping("/api/v1/chart/fusion")
    public FusionChartResponse getFusionChart(@RequestParam("jobId") String jobId) {

        FusionChartResponse response = new  FusionChartResponse();
        try{
            Job job = jobMapper.selectByJobid(jobId);
            String dir = job.getDir_path();
            FusionChartData data = fusionChartService.getFusionChartData(jobId);
            response.setData(data);
            response.setCode(200);
            response.setMessage("Get FUSION chart success");
        } catch (Exception e){
            e.printStackTrace();
            response.setCode(400);
            response.setMessage("Get FUSION chart failed");
        }
        return response;
    }
}
