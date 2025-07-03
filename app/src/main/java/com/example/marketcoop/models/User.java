package com.example.marketcoop.models;

import com.google.firebase.auth.FirebaseUser;

public class User {
    public String uid;
    public String name;
    public String email;
    public String role;
    public String address;
    public String profileImageUrl;

    public User() {}  // Required for Firestore

    public User(String uid, String name, String email, String role, String address) {
        this.uid = uid;
        this.name = name;
        this.email = email;
        this.role = role;
        this.address = address;
    }
}