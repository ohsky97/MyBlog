package com.myblog.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myblog.domain.FileVO;
import com.myblog.mapper.BoardMapper;

@Service
public class FileServiceImple implements FileService {
	
	private final Logger logger = LoggerFactory.getLogger(FileServiceImple.class);
	
	@Autowired
	private BoardMapper boardMapper;

	@Override
	public int fileRegist(FileVO file) {
		
		logger.info("getRegist() 호출");
		
		return boardMapper.fileRegist(file);
	}

	@Override
	public FileVO fileDetail(int filebno) {

		logger.info("fileDetail() 호출");
		
		return boardMapper.fileDetail(filebno);
	}

	@Override
	public int fileDelete(int fno) {

		logger.info("fileDelete() 호출");
		
		return boardMapper.fileDelete(fno);
	}

}
