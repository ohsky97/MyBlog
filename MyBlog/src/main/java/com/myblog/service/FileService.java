package com.myblog.service;

import com.myblog.domain.FileVO;

public interface FileService {
	
	public int fileRegist(FileVO file);
	
	public FileVO fileDetail(int filebno);
	
	public int fileDelete(int fno);

}
