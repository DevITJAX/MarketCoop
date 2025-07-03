package com.example.marketcoop.utils;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;

public class FirebaseUtils {
    // Firebase instances
    private static FirebaseAuth auth;
    private static FirebaseFirestore db;
    private static FirebaseStorage storage;

    // Get FirebaseAuth instance
    public static FirebaseAuth getAuth() {
        if (auth == null) {
            auth = FirebaseAuth.getInstance();
        }
        return auth;
    }

    // Get Firestore instance
    public static FirebaseFirestore getFirestore() {
        if (db == null) {
            db = FirebaseFirestore.getInstance();
        }
        return db;
    }

    // Get FirebaseStorage instance
    public static FirebaseStorage getStorage() {
        if (storage == null) {
            storage = FirebaseStorage.getInstance();
        }
        return storage;
    }

    // Get current user ID
    public static String getCurrentUserId() {
        if (getAuth().getCurrentUser() != null) {
            return getAuth().getCurrentUser().getUid();
        }
        return null;
    }

    // Check if user is logged in
    public static boolean isLoggedIn() {
        return getAuth().getCurrentUser() != null;
    }
}