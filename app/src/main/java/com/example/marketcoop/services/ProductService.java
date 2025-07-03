package com.example.marketcoop.services;

import com.example.marketcoop.models.Product;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;
import java.util.List; // Added this import

public class ProductService {
    private final FirebaseFirestore db;

    public ProductService() {
        db = FirebaseFirestore.getInstance();
    }

    public void getProductsByCoop(String coopId, ProductCallback callback) {
        db.collection("products")
                .whereEqualTo("coopId", coopId)
                .orderBy("title", Query.Direction.ASCENDING)
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess(task.getResult().toObjects(Product.class));
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }

    public void getProductById(String productId, SingleProductCallback callback) {
        db.collection("products").document(productId)
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess(task.getResult().toObject(Product.class));
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }

    public interface ProductCallback {
        void onSuccess(List<Product> products);
        void onFailure(Exception exception);
    }

    public interface SingleProductCallback {
        void onSuccess(Product product);
        void onFailure(Exception exception);
    }
}