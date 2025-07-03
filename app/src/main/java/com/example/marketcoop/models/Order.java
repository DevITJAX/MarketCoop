package com.example.marketcoop.models;

import androidx.annotation.NonNull;
import java.util.ArrayList;
import java.util.List;

public class Order {
    public String orderId;
    public String userId;
    public String coopId;
    public List<CartItem> items;
    public double total;
    public OrderStatus status;
    public long timestamp;

    public enum OrderStatus {
        PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED
    }

    public Order() {
        this.items = new ArrayList<>();
        this.status = OrderStatus.PENDING;
        this.timestamp = System.currentTimeMillis();
    }

    public Order(String orderId, String userId, String coopId, List<CartItem> items) {
        this();
        this.orderId = orderId;
        this.userId = userId;
        this.coopId = coopId;
        this.items = new ArrayList<>(items);
        calculateTotal();
    }

    public void calculateTotal() {
        total = 0;
        for (CartItem item : items) {
            total += item.getTotalPrice();
        }
    }

    @NonNull
    @Override
    public String toString() {
        return "Order{" +
                "orderId='" + orderId + '\'' +
                ", status=" + status +
                ", total=" + total +
                '}';
    }
}