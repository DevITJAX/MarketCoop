package com.example.marketcoop.activities;

import android.os.Bundle;
import android.widget.*;
import androidx.appcompat.app.AppCompatActivity;
import com.bumptech.glide.Glide;
import com.example.marketcoop.models.Product;
import com.example.marketcoop.R;

public class ProductDetailActivity extends AppCompatActivity {
    TextView title, description, price;
    ImageView imageView;
    Button addToCartBtn;
    Product product;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_product_detail);

        title = findViewById(R.id.productTitle);
        description = findViewById(R.id.productDescription);
        price = findViewById(R.id.productPrice);
        imageView = findViewById(R.id.productImage);
        addToCartBtn = findViewById(R.id.addToCartBtn);

        product = (Product) getIntent().getSerializableExtra("product");

        if (product != null) {
            title.setText(product.title);
            description.setText(product.description);
            price.setText(product.price + " DH");
            Glide.with(this).load(product.imageUrl).into(imageView);
        }

        addToCartBtn.setOnClickListener(v -> {
            Toast.makeText(this, "Added to cart", Toast.LENGTH_SHORT).show();
        });
    }
}
