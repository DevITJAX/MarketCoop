package com.example.marketcoop.activities;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.*;
import com.google.firebase.firestore.*;
import java.util.*;
import com.example.marketcoop.models.Order;
import com.example.marketcoop.adapters.OrderAdapter;
import com.example.marketcoop.R;

public class OrderHistoryActivity extends AppCompatActivity {
    RecyclerView orderRecycler;
    List<Order> orderList = new ArrayList<>();
    OrderAdapter orderAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_history);

        orderRecycler = findViewById(R.id.orderRecycler);
        orderAdapter = new OrderAdapter(orderList);
        orderRecycler.setLayoutManager(new LinearLayoutManager(this));
        orderRecycler.setAdapter(orderAdapter);

        FirebaseFirestore.getInstance().collection("orders")
                .whereEqualTo("userId", "CURRENT_USER_ID") // replace dynamically
                .get().addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        for (QueryDocumentSnapshot doc : task.getResult()) {
                            Order o = doc.toObject(Order.class);
                            orderList.add(o);
                        }
                        orderAdapter.notifyDataSetChanged();
                    }
                });
    }
}
