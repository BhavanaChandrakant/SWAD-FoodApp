package com.tap.model;

import java.sql.Timestamp;

public class User {
	private int id;
	private String name;
	private String email;
	private String passward;
	private String phone;
	private String address;
	private String role;
	private Timestamp created_date;
	private Timestamp lastLogin_date;

	
	
	public User() {
		// TODO Auto-generated constructor stub
	}

	

	public User(String name, String email,  String passward,String phone, String address, String role, Timestamp created_date,
			Timestamp lastLogin_date) {
		super();
		this.name = name;
		this.email = email;
		this.passward = passward;
		this.phone = phone;
		this.address = address;
		this.role = role;
		this.created_date = created_date;
		this.lastLogin_date = lastLogin_date;
		
	}



	public User(String name, String email, String passward ,String phone, String address, String role) {
		super();
		this.name = name;
		this.email = email;
		this.passward = passward;
		this.phone = phone;
		this.address = address;
		this.role = role;
		
	}



	


	public User(int id, String name, String email, String passward, String phone, String address, String role,
			Timestamp created_date, Timestamp lastLogin_date) {
		super();
		this.id = id;
		this.name = name;
		this.email = email;
		this.passward = passward;
		this.phone = phone;
		this.address = address;
		this.role = role;
		this.created_date = created_date;
		this.lastLogin_date = lastLogin_date;
	}






	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public Timestamp getCreated_date() {
		return created_date;
	}

	public void setCreated_date(Timestamp created_date) {
		this.created_date = created_date;
	}

	public Timestamp getLastLogin_date() {
		return lastLogin_date;
	}

	public void setLastLogin_date(Timestamp lastLogin_date) {
		this.lastLogin_date = lastLogin_date;
	}
     
	
 
	public String getPassward() {
		
		return passward;
	}
	public void setPassward(String passward) {
		this.passward = passward;
	}



	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", email=" + email + ", passward=" + passward + ", phone=" + phone
				+ ", address=" + address + ", role=" + role + ", created_date=" + created_date + ", lastLogin_date="
				+ lastLogin_date + "]";
	}
 
	
	

	 
	

}
