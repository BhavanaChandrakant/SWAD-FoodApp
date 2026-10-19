package com.tap.model;

public class Oderitem {
   private int orderItemID;
   private int orderId;
   private int menuId;
   private int quantity;
   private double itemTotal;
   
   public Oderitem() {
	// TODO Auto-generated constructor stub
   }

   public Oderitem(int quantity, double itemTotal) {
	super();
	this.quantity = quantity;
	this.itemTotal = itemTotal;
   }
   public Oderitem(int orderId, int menuId, int quantity, double itemTotal) {

	    this.orderId = orderId;
	    this.menuId = menuId;
	    this.quantity = quantity;
	    this.itemTotal = itemTotal;
	}

   public Oderitem(int orderItemID, int orderId, int menuId, int quantity, double itemTotal) {
	super();
	this.orderItemID = orderItemID;
	this.orderId = orderId;
	this.menuId = menuId;
	this.quantity = quantity;
	this.itemTotal = itemTotal;
   }

   public int getOrderItemID() {
	return orderItemID;
   }

   public void setOrderItemID(int orderItemID) {
	this.orderItemID = orderItemID;
   }

   public int getOrderId() {
	return orderId;
   }

   public void setOrderId(int orderId) {
	this.orderId = orderId;
   }

   public int getMenuId() {
	return menuId;
   }

   public void setMenuId(int menuId) {
	this.menuId = menuId;
   }

   public int getQuantity() {
	return quantity;
   }

   public void setQuantity(int quantity) {
	this.quantity = quantity;
   }

   public double getItemTotal() {
	return itemTotal;
   }

   public void setItemTotal(double itemTotal) {
	this.itemTotal = itemTotal;
   }

   @Override
   public String toString() {
	return "Oderitem [orderItemID=" + orderItemID + ", orderId=" + orderId + ", menuId=" + menuId + ", quantity="
			+ quantity + ", itemTotal=" + itemTotal + "]";
   }
   
   
}
