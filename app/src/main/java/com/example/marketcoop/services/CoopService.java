package com.example.marketcoop.services;

import com.example.marketcoop.models.Coop;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;
import java.util.List;  // Added import for List

public class CoopService {
    private final FirebaseFirestore db;

    public CoopService() {
        db = FirebaseFirestore.getInstance();
    }

    public void getAllCoops(CoopCallback callback) {
        db.collection("coops")
                .orderBy("name", Query.Direction.ASCENDING)
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess(task.getResult().toObjects(Coop.class));
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }

    public void getCoopById(String coopId, SingleCoopCallback callback) {
        db.collection("coops").document(coopId)
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess(task.getResult().toObject(Coop.class));
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }

    public interface CoopCallback {
        void onSuccess(List<Coop> coops);
        void onFailure(Exception exception);
    }

    public interface SingleCoopCallback {
        void onSuccess(Coop coop);
        void onFailure(Exception exception);
    }
}