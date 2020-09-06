package com.myblog.domain;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.NaturalId;
import org.hibernate.annotations.UpdateTimestamp;

import lombok.Builder;
import lombok.Data;

@Data
@Entity
@Table(name = "tbl_user", uniqueConstraints = {
		@UniqueConstraint(columnNames = {"userid"}),
		@UniqueConstraint(columnNames = {"userpn"})
})
public class UserEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long uno;
	
	@NotBlank
	@Size(min = 2, max = 20)
	private String username;
	
	@NaturalId
	@NotBlank
	@Size(max = 60)
	@Email
	private String userid;
	
	@NotBlank
	@Size(min = 6, max = 100)
	private String userpwd;
	
	@NotBlank
	private String userpn;
	
	@NotBlank
	private String role;
	
	@CreationTimestamp
	private LocalDateTime regdate;
	
	@UpdateTimestamp
	private LocalDateTime update_date;

	
	@Transient // 간단히 vo에 저장만 하고 데이터베이스 컬럼에 추가하지 않을 경우 이 어노테이션 사용
	private int ran; 
	
	public UserEntity() {}

	@Builder
	public UserEntity(Long uno, String username, String userid,	String userpwd, String userpn, String role) {
		this.username = username;
		this.userid = userid;
		this.userpwd = userpwd;
		this.userpn = userpn;
		this.role = role;
	}


}















