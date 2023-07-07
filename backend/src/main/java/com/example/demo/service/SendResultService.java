package com.example.demo.service;

import com.example.demo.mapper.JobMapper;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


@Service

public class SendResultService {

    public void SendResultByEmail(String email, String jobid)
    {
        String to = email;  // 收件人电子邮件地址
        String from = "gwas2gene@163.com";  // 发件人电子邮件地址
        String host = "smtp.163.com";  // SMTP服务器
        String authorizationCode = "OKFMQZRWTQRWUWNK";
        String name = "postGWAS Server";

        // 设置SMTP服务器的配置属性
        Properties properties = new Properties();
        properties.setProperty("mail.smtp.host", host);
        properties.setProperty("mail.smtp.auth", "true");
        properties.setProperty("mail.transport.protocol", "smtp");
        properties.put("mail.smtp.ssl.enable", true);
        properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
        properties.put("mail.smtp.socketFactory.port", "465");

        Session session = Session.getInstance(properties);
        session.setDebug(true);

        try {
            // 创建一个MimeMessage对象
            MimeMessage message = new MimeMessage(session);

            // 设置发件人和收件人
            message.setFrom(new InternetAddress(from, name));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            // 设置邮件主题和正文
            message.setSubject("Your postGWAS Results are Ready - Download Link Inside!");
            message.setText("Dear User,\n\n" +
                    "Thank you for choosing to use the postGWAS website for your research. We have generated the results of your analysis and would like to provide you with a download link for your convenience.\n\n" +
                    "Please click the following link to download your results:\n\n" +
                    "Job ID:" + jobid + "\n\n" +
                    "biographml.com/g2gdemo/api/v1/result/downloadAllFiles?jobId=" + jobid + "\n\n" +
                    "The results generally consist of the output obtained by the original method and a visualisation of the results. You can also see the graphical visualisation of the results on the charts page.\n\n" +
                    "This email is sent automatically by the system. Should you have any questions or require assistance, please do not hesitate to contact us. We will do our best to provide support and help ensure that you are able to successfully complete your research.\n\n" +
                    "Once again, we appreciate your trust and support in using the postGWAS website. We are looking forward to continuing to provide excellent research experiences for you in the future.\n\n" +
                    "Best wishes,\n\n" +
                    "The postGWAS Team\n");

            // 发送邮件
            Transport transport = session.getTransport();
            transport.connect(from, authorizationCode);
            //发送邮件
            transport.sendMessage(message, message.getAllRecipients());
            //关闭连接
            transport.close();

            System.out.println("Email send success");

        } catch (Exception e) {
            System.err.println("Email send error" + e.getMessage());
        }
    }

    public void SendErrorByEmail(String email, String jobid)
    {
        String to = email;  // 收件人电子邮件地址
        String from = "gwas2gene@163.com";  // 发件人电子邮件地址
        String host = "smtp.163.com";  // SMTP服务器
        String authorizationCode = "OKFMQZRWTQRWUWNK";
        String name = "postGWAS Server";

        // 设置SMTP服务器的配置属性
        Properties properties = new Properties();
        properties.setProperty("mail.smtp.host", host);
        properties.setProperty("mail.smtp.auth", "true");
        properties.setProperty("mail.transport.protocol", "smtp");
        properties.put("mail.smtp.ssl.enable", true);
        properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
        properties.put("mail.smtp.socketFactory.port", "465");

        Session session = Session.getInstance(properties);
        session.setDebug(true);

        try {
            // 创建一个MimeMessage对象
            MimeMessage message = new MimeMessage(session);

            // 设置发件人和收件人
            message.setFrom(new InternetAddress(from, name));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            // 设置邮件主题和正文
            message.setSubject("postGWAS Website - Error Running Analysis");
            message.setText("Dear User,\n\n" +
                    "I am writing to inform you that we have received a notification that your analysis on the postGWAS website has failed. We understand that this can be frustrating, and we apologize for any inconvenience this may have caused.\n\n" +
                    "We kindly request that you please review the tutorial section on our website to ensure that the input file format and parameters you have used are in line with our requirements. This may assist in resolving the issue and ensuring successful completion of your analysis.\n\n" +
                    "Job ID:" + jobid + "\n\n" +
                    "This email is sent automatically by the system. Please do not hesitate to reach out to us if you require any assistance or have any questions regarding the analysis process.\n\n" +
                    "We appreciate your patience and cooperation in this matter. Thank you for using the postGWAS website for your analysis needs.\n\n" +
                    "Best wishes,\n\n" +
                    "The postGWAS Team\n");

            // 发送邮件
            Transport transport = session.getTransport();
            transport.connect(from, authorizationCode);
            //发送邮件
            transport.sendMessage(message, message.getAllRecipients());
            //关闭连接
            transport.close();

            System.out.println("Email send success");

        } catch (Exception e) {
            System.err.println("Email send error" + e.getMessage());
        }
    }

}
