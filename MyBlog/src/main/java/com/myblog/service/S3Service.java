package com.myblog.service;

import java.io.File;
import java.io.IOException;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;

import lombok.NoArgsConstructor;

@Service
@NoArgsConstructor
public class S3Service {
	
	private final Logger logger = LoggerFactory.getLogger(S3Service.class);
	
	private AmazonS3 s3Client;
	
	@Value("${cloud.aws.credentials.accesskey}")
	private String accesskey;
	
	@Value("${cloud.aws.credentials.secretkey}")
	private String secretkey;

	@Value("${cloud.aws.s3.bucket}")
	private String bucket;
	
	@Value("${cloud.aws.region.static}")
	private String region;
	
	/*
	 * 의존성 주입이 이루어진 후 초기화를 수행하는 메서드이며, bean이 한 번만 초기화 될 수 있도록 해준다.
	 * 이것의 목적은 AmazonS3ClientBuilder를 통해 S3 Client를 가져와야 하는데,
	 * 자격증명을 해야 S3 Client를 가져올 수 있기 때문이다.
	 * 자격증명은 accesskey, secretkey로 이용되고, 의존성 주입 시점에는 @Value 어노테이션의 값이 설정되지 않아서
	 * @PostConstruct를 사용한다.
	 * */
	@PostConstruct
	public void setS3Client() {
		
		// accesskey와 secretkey를 이용하여 자격증명 객체를 얻는다.
		AWSCredentials credentials = new BasicAWSCredentials(this.accesskey, this.secretkey);
		
		s3Client = AmazonS3ClientBuilder.standard()
					// 자격증명을 통해 S3 Client를 가져온다.
					.withCredentials(new AWSStaticCredentialsProvider(credentials))
					.withRegion(this.region)
					.build();
	}
	
	public String upload(MultipartFile files) throws IOException {
		
		logger.info("S3Service - upload(): " + files.getOriginalFilename());
		
		String fileName = files.getOriginalFilename();
		
		s3Client.putObject(new PutObjectRequest(bucket, fileName, files.getInputStream(), null)
				.withCannedAcl(CannedAccessControlList.PublicRead));
		
		// 업로드를 한 후, 컨트롤러에 해당 URL을 DB에 저장할 수 있도록 반환한다.
		String fileUrl = s3Client.getUrl(bucket, fileName).toString();
		System.out.println("S3Service - upload(): " + fileUrl);
		
		return fileUrl;
	}
	
	public void deleteFile(String fileName) throws IOException {
		
		logger.info("deleteFile() 호출");
		s3Client.deleteObject(new DeleteObjectRequest(bucket, fileName)
				.withKey(accesskey));
		
	}
	
	
}


















