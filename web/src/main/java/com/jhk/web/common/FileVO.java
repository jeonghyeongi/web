package com.jhk.web.common;

import org.springframework.web.multipart.MultipartFile;

public class FileVO {

	MultipartFile[] file;

	public MultipartFile[] getFile() {
		return file;
	}

	public void setFile(MultipartFile[] file) {
		this.file = file;
	}
	
	
}
