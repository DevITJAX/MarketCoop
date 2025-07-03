package com.example.marketcoop.models;

import androidx.annotation.NonNull;

public class CartItem {
    public String productId;
    public String title;
    public String imageUrl;
    public double price;
    public int quantity;

    public CartItem() {}

    public CartItem(String productId, String title, double price, String imageUrl, int quantity) {
        this.productId = productId;
        this.title = title;
        this.price = price;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return price * quantity;
    }

    @NonNull
    @Override
    public String toString() {
        return "CartItem{" +
                "productId='" + productId + '\'' +
                ", title='" + title + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }
}