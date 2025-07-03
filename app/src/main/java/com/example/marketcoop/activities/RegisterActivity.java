package com.example.marketcoop.activities;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.example.marketcoop.R;
import com.example.marketcoop.models.User;
import com.example.marketcoop.services.AuthService;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;

public class RegisterActivity extends AppCompatActivity {
    private EditText etName, etEmail, etPassword, etConfirmPassword, etAddress;
    private Button btnRegister;
    private TextView tvLogin;
    private AuthService authService;
    private FirebaseFirestore db;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        // Initialize views
        etName = findViewById(R.id.et_register_name);
        etEmail = findViewById(R.id.et_register_email);
        etPassword = findViewById(R.id.et_register_password);
        etConfirmPassword = findViewById(R.id.et_register_confirm_password);
        etAddress = findViewById(R.id.et_register_address);
        btnRegister = findViewById(R.id.btn_register);
        tvLogin = findViewById(R.id.tv_login_link);

        authService = new AuthService();
        db = FirebaseFirestore.getInstance();

        btnRegister.setOnClickListener(v -> registerUser());
        tvLogin.setOnClickListener(v -> {
            startActivity(new Intent(RegisterActivity.this, LoginActivity.class));
            finish();
        });
    }

    private void registerUser() {
        String name = etName.getText().toString().trim();
        String email = etEmail.getText().toString().trim();
        String password = etPassword.getText().toString().trim();
        String confirmPassword = etConfirmPassword.getText().toString().trim();
        String address = etAddress.getText().toString().trim();

        if (name.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            Toast.makeText(this, R.string.all_fields_required, Toast.LENGTH_SHORT).show();
            return;
        }

        if (!password.equals(confirmPassword)) {
            Toast.makeText(this, R.string.passwords_do_not_match, Toast.LENGTH_SHORT).show();
            return;
        }

        authService.signUp(email, password, new AuthService.AuthCallback() {
            @Override
            public void onSuccess(FirebaseUser firebaseUser) {
                // Create user document in Firestore
                User user = new User(firebaseUser.getUid(), name, email, "client", address);
                db.collection("users").document(firebaseUser.getUid())
                        .set(user)
                        .addOnSuccessListener(aVoid -> {
                            Toast.makeText(RegisterActivity.this, R.string.registration_successful, Toast.LENGTH_SHORT).show();
                            startActivity(new Intent(RegisterActivity.this, MainActivity.class));
                            finish();
                        })
                        .addOnFailureListener(e ->
                                Toast.makeText(RegisterActivity.this, R.string.registration_failed, Toast.LENGTH_SHORT).show());
            }

            @Override
            public void onFailure(Exception exception) {
                Toast.makeText(RegisterActivity.this,
                        getString(R.string.authentication_failed) + ": " + exception.getMessage(),
                        Toast.LENGTH_SHORT).show();
            }
        });
    }
}