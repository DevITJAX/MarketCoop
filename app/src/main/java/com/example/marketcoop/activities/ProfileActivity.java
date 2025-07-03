package com.example.marketcoop.activities;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.example.marketcoop.R;
import com.example.marketcoop.models.User;
import com.example.marketcoop.utils.FirebaseUtils;
import com.google.firebase.firestore.FirebaseFirestore;
import com.squareup.picasso.Picasso;

public class ProfileActivity extends AppCompatActivity {
    private EditText etName, etEmail, etAddress;
    private ImageView ivProfile;
    private Button btnSave;
    private FirebaseFirestore db;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        // Initialize views
        etName = findViewById(R.id.et_profile_name);
        etEmail = findViewById(R.id.et_profile_email);
        etAddress = findViewById(R.id.et_profile_address);
        ivProfile = findViewById(R.id.iv_profile_image);
        btnSave = findViewById(R.id.btn_save_profile);

        db = FirebaseFirestore.getInstance();
        loadUserProfile();

        btnSave.setOnClickListener(v -> saveProfile());
    }

    private void loadUserProfile() {
        String userId = FirebaseUtils.getCurrentUserId();
        if (userId != null) {
            db.collection("users").document(userId)
                    .get()
                    .addOnSuccessListener(documentSnapshot -> {
                        if (documentSnapshot.exists()) {
                            User user = documentSnapshot.toObject(User.class);
                            if (user != null) {
                                etName.setText(user.name);
                                etEmail.setText(user.email);
                                etAddress.setText(user.address);

                                if (user.profileImageUrl != null && !user.profileImageUrl.isEmpty()) {
                                    Picasso.get().load(user.profileImageUrl).into(ivProfile);
                                } else {
                                    ivProfile.setImageResource(R.drawable.ic_profile_placeholder);
                                }
                            }
                        }
                    });
        }
    }

    private void saveProfile() {
        String name = etName.getText().toString().trim();
        String email = etEmail.getText().toString().trim();
        String address = etAddress.getText().toString().trim();

        if (name.isEmpty() || email.isEmpty()) {
            Toast.makeText(this, R.string.all_fields_required, Toast.LENGTH_SHORT).show();
            return;
        }

        String userId = FirebaseUtils.getCurrentUserId();
        if (userId != null) {
            User updatedUser = new User(userId, name, email, "client", address);
            db.collection("users").document(userId)
                    .set(updatedUser)
                    .addOnSuccessListener(aVoid ->
                            Toast.makeText(this, R.string.profile_saved, Toast.LENGTH_SHORT).show())
                    .addOnFailureListener(e ->
                            Toast.makeText(this, R.string.profile_save_failed, Toast.LENGTH_SHORT).show());
        }
    }
}