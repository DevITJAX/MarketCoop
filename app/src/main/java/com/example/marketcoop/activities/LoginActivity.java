package com.example.marketcoop.activities;

import android.content.Intent;
import android.os.Bundle;
import android.widget.*;
import androidx.appcompat.app.AppCompatActivity;
import com.google.firebase.auth.FirebaseAuth;
import com.example.marketcoop.R;

public class LoginActivity extends AppCompatActivity {
    // 1. Declare all your view variables here
    EditText email, password;
    Button loginBtn, registerBtn;  // Added registerBtn declaration

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        // 2. Initialize all views
        email = findViewById(R.id.email);
        password = findViewById(R.id.password);
        loginBtn = findViewById(R.id.loginBtn);
        registerBtn = findViewById(R.id.registerBtn);  // Initialize registerBtn

        // 3. Set click listeners
        loginBtn.setOnClickListener(v -> {
            String emailTxt = email.getText().toString();
            String passwordTxt = password.getText().toString();

            // Basic validation
            if (emailTxt.isEmpty() || passwordTxt.isEmpty()) {
                Toast.makeText(this, "Please fill all fields", Toast.LENGTH_SHORT).show();
                return;
            }

            FirebaseAuth.getInstance().signInWithEmailAndPassword(emailTxt, passwordTxt)
                    .addOnCompleteListener(task -> {
                        if (task.isSuccessful()) {
                            startActivity(new Intent(this, MainActivity.class));
                            finish();
                        } else {
                            Toast.makeText(this, "Login Failed: " +
                                    task.getException().getMessage(), Toast.LENGTH_SHORT).show();
                        }
                    });
        });

        registerBtn.setOnClickListener(v -> {
            startActivity(new Intent(this, RegisterActivity.class));
        });
    }
}