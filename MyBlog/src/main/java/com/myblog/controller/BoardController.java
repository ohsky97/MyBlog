package com.myblog.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import com.myblog.common.Search;
import com.myblog.domain.Board;
import com.myblog.domain.FileVO;
import com.myblog.domain.Reply;
import com.myblog.service.BoardService;
import com.myblog.service.FileService;

@Controller
@RequestMapping(value = "/myblog/board")
public class BoardController {
	
	private final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private FileService fileService;
	
	// 게시판 페이지 이동 시 리스트 출력
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String getBoardList(Model model, HttpSession session,
					@RequestParam(required = false, defaultValue = "1") int page,
					@RequestParam(required = false, defaultValue = "1") int range,
					@RequestParam(required = false, defaultValue = "boardtitle") String searchType,
					@RequestParam(required = false) String keyword)	throws Exception {
		
		logger.info("getBoardList() 호출");
		
		Search search = new Search();
		search.setSearchType(searchType);
		search.setKeyword(keyword);
		
		// 전체 개시글 개수
		int listCnt = boardService.getBoardListCnt(search);
		
		search.pageInfo(page, range, listCnt);
		
		// Pagination 객체 생성
//		Pagination pagination = new Pagination();
//		pagination.pageInfo(page, range, listCnt);
		
		model.addAttribute("pagination", search);
		
		session.setAttribute("current", search);
		
		model.addAttribute("boardList", boardService.getBoardList(search));
		
		return "/myblog/board/list";
	}
	
	// 게시글 작성 이동
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public String moveWrite(HttpSession session) {
		
		logger.info("moveWrite() 호출");
		session.getAttribute("userInfo");
		session.getAttribute("current");
		
		return "/myblog/board/write";
	}
	
	// 게시글 작성
	@RequestMapping(value = "/write", method = RequestMethod.POST)
	public ResponseEntity<Integer> registBoard(Board board, @RequestPart MultipartFile files, HttpServletRequest req) throws Exception {
		
		if (files.isEmpty()) {
			int result  = boardService.registBoard(board);
			System.out.println("첨부파일 없음, " + board);
			
			ResponseEntity<Integer> entity = null;
			
			if (result == 1) {
				entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
			} else {
				entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
			}
			
			return entity;
			
		} else {
			String fileName = files.getOriginalFilename();
			String fileNameExtension = FilenameUtils.getExtension(fileName).toLowerCase();
			File destinationFile; // DB에 저장할 파일 고유명
			String destinationFileName;
			
			HttpSession session = req.getSession();
			String rootPath = session.getServletContext().getRealPath("/");
			String fileUrl = rootPath + "resources\\static\\uploads\\" // 절대경로 설정 - 프로젝트 내의 경로에 저장
			
			do {
				destinationFileName = RandomStringUtils.randomAlphanumeric(32) + "." + fileNameExtension;
				destinationFile = new File(fileUrl + destinationFileName);
			} while (destinationFile.exists());
			
			destinationFile.getParentFile().mkdirs();
			files.transferTo(destinationFile);
			
			int result = boardService.registBoard(board);
			
			FileVO file = new FileVO();
			file.setFilename(destinationFileName);
			file.setFileoriname(fileName);
			file.setFileurl(fileUrl);
			
			System.out.println("첨부파일 있음, " + file);
			
			fileService.fileRegist(file);
			
			ResponseEntity<Integer> entity = null;
			
			if (result == 1) {
				entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
			} else {
				entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
			}
			
			return entity;
			
		}
		
	}
	
	// 게시판 상세 화면 호출 & 중복 조회수 처리(쿠키이용)
	@RequestMapping(value = "/detail", method = RequestMethod.GET)
	public String detailBoard(Model model, @RequestParam("bno") int bno,
					HttpServletRequest req, HttpServletResponse res, HttpSession session) {
		
		session.getAttribute("userInfo");
		session.getAttribute("current");
		
		Board board = boardService.getBoardContent(bno);
		model.addAttribute("detail", board);
		model.addAttribute("reply", new Reply());
		model.addAttribute("files", fileService.fileDetail(bno));
		
		Cookie[] cookies = req.getCookies();
		
		// 비교를 위한 새로운 쿠키 생성
		Cookie viewCookie = null;
		
		// 쿠키가 있을 경우
		if (cookies != null && cookies.length > 0) {
			for (int i = 0; i < cookies.length; i++) {
				// 쿠키의 name이 cookie + bno와 일치하는 쿠키를 viewCookie에 넣음
				if (cookies[i].getName().equals("cookie"+bno)) {
					
					logger.info("처음 쿠키가 생성한 뒤 들어옴");
					viewCookie = cookies[i];
				}
			}
		}
		
		if (board != null) {
			logger.info("상세페이지로 이동");
			
			
			// 만약 viewCookie가 null일 경우 쿠키를 생성해서 조회수 증가 로직을 처리함
			if (viewCookie == null) {
				logger.info("쿠키없음");
				
				// 쿠키 생성(이름, 값)
				Cookie newCookie = new Cookie("cookie"+bno, "|" + bno + "|");
				
				// 쿠키 추가
				res.addCookie(newCookie);
				
				// 쿠키를 추가 시키고 조회수 증가
				int result = boardService.updateViewCnt(bno);
				
				if (result > 0) {
					logger.info("조회수 증가");
				} else {
					logger.warn("조회수 증가 에러 발생");
				}
				
			} else {
				// viewCookie가 null이 아닐경우 쿠키가 있으므로 조회수 증가 로직을 처리하지 않음
				logger.info("쿠키 있음");
				
				// 쿠키 값
				String value = viewCookie.getValue();
				System.out.println("cookie 값: " + value);
			}
			
			return "/myblog/board/detail";
			
		} else {
			return "/myblog/board/list";
			
		}
		
	}
	
	// fileDownload
	@RequestMapping(value = "/fileDown/{filebno}")
	private void fileDown(@PathVariable int filebno, HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		req.setCharacterEncoding("UTF-8");
		FileVO fileVO = fileService.fileDetail(filebno);
		
		// 파일 업로드된 경로
		try {
			String fileUrl = fileVO.getFileurl();
			fileUrl += "/";
			String savePath = fileUrl;
			String fileName = fileVO.getFilename();
			
			// 실제로 보내질 파일명
			String oriFileName = fileVO.getFileoriname();
			InputStream in = null;
			OutputStream out = null;
			File file = null;
			boolean skip = false;
			String client = "";
			
			// 파일을 읽어 스트림에 담기
			try {
				file = new File(savePath, fileName);
				in = new FileInputStream(file);
				
			} catch (FileNotFoundException e) {
				skip = true;
			}
			
			client = req.getHeader("User-Agent");
			
			// 파일 다운로드 헤더 저장
			res.reset();
			res.setContentType("application/octet-stream");
			res.setHeader("Content-Description", "JSP Generated Data");
			
			if (!skip) {
				// IE
				if (client.indexOf("MISE") != -1) {
					res.setHeader("Content-Disposition", "attachment; filename=\""
							+ java.net.URLEncoder.encode(oriFileName, "UTF-8").replaceAll("\\+", "\\ ") + "\"");
				
				// IE 11이상
				} else if (client.indexOf("Trident") != -1) {
					res.setHeader("Content-Disposition", "attachment; filename=\""
							+ java.net.URLEncoder.encode(oriFileName, "UTF-8").replaceAll("\\+", "\\ ") + "\"");
					
				} else {
					// 한글 파일명 처리
					res.setHeader("Content-Disposition", "attachment; filename=\"" 
							+ new String(oriFileName.getBytes("UTF-8"), "ISO8859_1") + "\"");
					res.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
					
				}
				
				res.setHeader("Content-Length", "" + file.length());
				out = res.getOutputStream();
				byte b[] = new byte[(int) file.length()];
				int leng = 0;
				
				while ((leng = in.read(b)) > 0) {
					out.write(b, 0, leng);
				}
				
			} else {
				res.setContentType("text/html; charset=UTF-8");
				System.out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다.'); history.back();</script>");
			}
			
			in.close();
			out.close();
			
		} catch (Exception e) {
			System.out.println("fileDownload Error: " + e.getMessage());
		}
	}
	
	// 게시판 수정
	@RequestMapping(value = "/update", method = RequestMethod.PUT)
	public ResponseEntity<Integer> updateBoard(Board board, @RequestPart MultipartFile files) throws Exception {
		
		if (files.isEmpty()) {
			int result = boardService.updateBoard(board);
			System.out.println("첨부파일 없음, " + board);
			
			ResponseEntity<Integer> entity = null;
			
			if (result == 1) {
				entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
			} else {
				entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
			}
			
			return entity;
			
		} else {
			String fileName = files.getOriginalFilename();
			String fileNameExtension = FilenameUtils.getExtension(fileName).toLowerCase();
			File destinationFile; // DB에 저장할 파일 고유명
			String destinationFileName;
			
			String fileUrl = "C:\\portfolio\\MyBlog\\MyBlog\\src\\main\\resources\\static\\uploads\\"; // 절대경로 설정 - 프로젝트 내의 경로에 저장
			
			do {
				destinationFileName = RandomStringUtils.randomAlphanumeric(32) + "." + fileNameExtension;
				destinationFile = new File(fileUrl + destinationFileName);
			} while (destinationFile.exists());
			
			destinationFile.getParentFile().mkdirs();
			files.transferTo(destinationFile);
			
			int result = boardService.updateBoard(board);
			
			FileVO file = new FileVO();
			file.setFilename(destinationFileName);
			file.setFileoriname(fileName);
			file.setFileurl(fileUrl);
			
			System.out.println("첨부파일 있음, " + file);
			
			fileService.fileRegist(file);
			
			ResponseEntity<Integer> entity = null;
			
			if (result == 1) {
				entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
			} else {
				entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
			}
			
			return entity;
		}
		
	}
	
	// 업로드 파일 삭제
	@RequestMapping(value = "/fileDelete", method = RequestMethod.DELETE)
	public ResponseEntity<Integer> fileDelete(@RequestBody FileVO fileVO) {
		
		System.out.println(fileVO);
		
		// 원본 파일 삭제 - 프로젝트 경로에 있는 파일
		new File("C:\\portfolio\\MyBlog\\MyBlog\\src\\main\\resources\\static\\uploads\\" + fileVO.getFilename().replace('/', File.separatorChar)).delete();
		
		// DB저장 내용 삭제
		int result = fileService.fileDelete(fileVO.getFno());
		
		ResponseEntity<Integer> entity = null;
		
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
			
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
		
		
		return entity;
	}
	
	// 게시판 삭제
	@RequestMapping(value = "/delete", method = RequestMethod.DELETE)
	public ResponseEntity<Integer> deleteBoard(@RequestBody Board board) {
		
		int result = boardService.deleteBoard(board.getBno());
		
		// 원본 파일 삭제 - 프로젝트 경로에 있는 파일
		new File("C:\\portfolio\\MyBlog\\MyBlog\\src\\main\\resources\\static\\uploads\\" + board.getFilename().replace('/', File.separatorChar)).delete();
		
		ResponseEntity<Integer> entity = null;
		
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	
	@RequestMapping(value = "/myPage")
	public String myPage(HttpSession session) {
		
		logger.info("moveWrite() 호출");
		session.getAttribute("userInfo");
		
		return "/myblog/myPage";
	}
}



























