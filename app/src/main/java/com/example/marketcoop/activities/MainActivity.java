package com.example.marketcoop.activities;

import android.os.Bundle;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.marketcoop.R;
import com.example.marketcoop.adapters.ProductAdapter;
import com.example.marketcoop.models.Product;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    private RecyclerView productRecycler;
    private List<Product> productList = new ArrayList<>();
    private ProductAdapter productAdapter;
    private FirebaseAuth mAuth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mAuth = FirebaseAuth.getInstance();
        String userId = mAuth.getCurrentUser() != null ? mAuth.getCurrentUser().getUid() : "";

        initializeViews();
        setupRecyclerView(userId);
        loadProducts();
    }

    private void initializeViews() {
        productRecycler = findViewById(R.id.productRecycler);
    }

    private void setupRecyclerView(String userId) {
        productAdapter = new ProductAdapter(this, productList, userId);
        productRecycler.setLayoutManager(new LinearLayoutManager(this));
        productRecycler.setAdapter(productAdapter);
    }

    private void loadProducts() {
        FirebaseFirestore.getInstance().collection("products")
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        productList.clear();
                        for (QueryDocumentSnapshot doc : task.getResult()) {
                            Product product = doc.toObject(Product.class);
                            product.id = doc.getId(); // Ensure product ID is set
                            productList.add(product);
                        }
                        productAdapter.notifyDataSetChanged();
                    } else {
                        Toast.makeText(this, "Failed to load products", Toast.LENGTH_SHORT).show();
                    }
                });
    }
}