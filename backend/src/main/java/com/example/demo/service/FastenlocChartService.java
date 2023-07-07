package com.example.demo.service;

import com.example.demo.dto.EcaviarChartData;
import com.example.demo.dto.FastenlocChartData;
import com.example.demo.entity.Fastenloc;
import com.example.demo.mapper.FastenlocMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;


@Service
public class FastenlocChartService {
    @Autowired
    SplitDataService service;
    @Autowired
    FastenlocMapper fastenlocMapper;
    FastenlocChartData data = new FastenlocChartData();

    public FastenlocChartData getFastenlocChartData(String jobid, String dir) throws FileNotFoundException {

        String prefix = fastenlocMapper.selectByJobid(jobid).getPrefix();
        String sigName = prefix + ".enloc.sig.out";
        String sigExtractName = prefix + ".enloc.sig.extract.out";
        String geneName = prefix + ".enloc.gene.out";
        String geneExtractName = prefix + ".enloc.gene.extract.out";

        String sig_path = dir + sigName;
        String sig_extract_path = dir + sigExtractName;
        String gene_path = dir + geneName;
        String gene_extract_path = dir + geneExtractName;

        data.setSigName(sigName);
        data.setSigExtractName(sigExtractName);
        data.setGeneName(geneName);
        data.setGeneExtractName(geneExtractName);
        data.setSigArray(service.splitData(sig_path));
        data.setSigExtractArray(service.splitData(sig_extract_path));
        data.setGeneArray(service.splitData(gene_path));
        data.setGeneExtractArray(service.splitData(gene_extract_path));

        return data;
    }
}
