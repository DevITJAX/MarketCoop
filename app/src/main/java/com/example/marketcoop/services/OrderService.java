package com.example.marketcoop.services;

import com.example.marketcoop.models.Order;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query; // Added Query import
import com.google.firebase.firestore.FieldValue;
import java.util.List; // Added List import

public class OrderService {
    private final FirebaseFirestore db;

    public OrderService() {
        db = FirebaseFirestore.getInstance();
    }

    public void placeOrder(Order order, OrderCallback callback) {
        db.collection("orders").document(order.orderId)
                .set(order)
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess();
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }

    public void getUserOrders(String userId, OrderListCallback callback) {
        db.collection("orders")
                .whereEqualTo("userId", userId)
                .orderBy("timestamp", Query.Direction.DESCENDING)
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess(task.getResult().toObjects(Order.class));
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }

    public void updateOrderStatus(String orderId, String newStatus, OrderCallback callback) {
        db.collection("orders").document(orderId)
                .update("status", newStatus)
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess();
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }

    public interface OrderCallback {
        void onSuccess();
        void onFailure(Exception exception);
    }

    public interface OrderListCallback {
        void onSuccess(List<Order> orders);
        void onFailure(Exception exception);
    }
}