package com.example.marketcoop.activities;

import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.*;
import java.util.*;
import com.example.marketcoop.R;
import com.example.marketcoop.adapters.CartAdapter;
import com.example.marketcoop.models.CartItem;

public class CartActivity extends AppCompatActivity {
    RecyclerView recyclerView;
    CartAdapter adapter;
    List<CartItem> cartItems = new ArrayList<>();
    TextView totalTxt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cart);

        recyclerView = findViewById(R.id.cartRecycler);
        totalTxt = findViewById(R.id.totalTxt);

        loadCartItems();

        adapter = new CartAdapter(cartItems);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);

        double total = 0;
        for (CartItem item : cartItems) {
            total += item.price * item.quantity;
        }
        totalTxt.setText("Total: " + total + " DH");
    }

    void loadCartItems() {
        cartItems.add(new CartItem("1", "Miel Bio", 85.0, "https://img.com/1.jpg", 2));
        cartItems.add(new CartItem("2", "Huile d’Argan", 120.0, "https://img.com/2.jpg", 1));
    }
}
