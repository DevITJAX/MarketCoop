package com.example.marketcoop.services;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class AuthService {
    private final FirebaseAuth mAuth;

    public AuthService() {
        mAuth = FirebaseAuth.getInstance();
    }

    public interface AuthCallback {
        void onSuccess(FirebaseUser user);
        void onFailure(Exception exception);
    }

    public void signUp(String email, String password, AuthCallback callback) {
        mAuth.createUserWithEmailAndPassword(email, password)
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        callback.onSuccess(mAuth.getCurrentUser());
                    } else {
                        callback.onFailure(task.getException());
                    }
                });
    }
}