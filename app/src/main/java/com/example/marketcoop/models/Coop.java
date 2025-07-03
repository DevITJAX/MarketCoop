package com.example.marketcoop.models;

import androidx.annotation.NonNull;

public class Coop {
    public String id;
    public String name;
    public String description;
    public String location;
    public String phone;
    public String email;
    public String logoUrl;

    public Coop() {}

    public Coop(String id, String name, String description, String location,
                String phone, String email, String logoUrl) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.location = location;
        this.phone = phone;
        this.email = email;
        this.logoUrl = logoUrl;
    }

    @NonNull
    @Override
    public String toString() {
        return "Coop{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                '}';
    }
}