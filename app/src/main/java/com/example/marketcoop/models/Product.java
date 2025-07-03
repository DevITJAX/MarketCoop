package com.example.marketcoop.models;

import androidx.annotation.NonNull;

public class Product {
    public String id;
    public String title;
    public String description;
    public String imageUrl;
    public String category;
    public String coopId;
    public double price;
    public int stock;
    public boolean available;

    public Product() {}

    public Product(String id, String title, String description, double price,
                   String imageUrl, String category, String coopId, int stock) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.category = category;
        this.coopId = coopId;
        this.stock = stock;
        this.available = stock > 0;
    }

    @NonNull
    @Override
    public String toString() {
        return "Product{" +
                "id='" + id + '\'' +
                ", title='" + title + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                '}';
    }
}