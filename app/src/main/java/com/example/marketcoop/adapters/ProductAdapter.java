package com.example.marketcoop.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.marketcoop.R;
import com.example.marketcoop.models.CartItem;
import com.example.marketcoop.models.Product;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;
import com.squareup.picasso.Picasso;

import java.util.List;

public class ProductAdapter extends RecyclerView.Adapter<ProductAdapter.ProductViewHolder> {
    private List<Product> productList;
    private Context context;
    private String userId;

    public ProductAdapter(Context context, List<Product> productList, String userId) {
        this.context = context;
        this.productList = productList;
        this.userId = userId;
    }

    @NonNull
    @Override
    public ProductViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_product, parent, false);
        return new ProductViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ProductViewHolder holder, int position) {
        Product product = productList.get(position);
        holder.title.setText(product.title);
        holder.description.setText(product.description);
        holder.price.setText(String.format("Price: $%.2f", product.price));
        holder.category.setText(product.category);

        if (product.imageUrl != null && !product.imageUrl.isEmpty()) {
            Picasso.get()
                    .load(product.imageUrl)
                    .placeholder(R.drawable.placeholder_image)
                    .error(R.drawable.error_image)
                    .into(holder.image);
        } else {
            holder.image.setImageResource(R.drawable.placeholder_image);
        }

        holder.btnAddToCart.setOnClickListener(v -> addToCart(product));
    }

    private void addToCart(Product product) {
        if (userId == null || userId.isEmpty()) {
            Toast.makeText(context, "Please sign in to add items to cart", Toast.LENGTH_SHORT).show();
            return;
        }

        FirebaseFirestore db = FirebaseFirestore.getInstance();
        CartItem cartItem = new CartItem(product.id, product.title, product.price, product.imageUrl, 1);

        db.collection("carts").document(userId)
                .collection("items").document(product.id)
                .get()
                .addOnSuccessListener(documentSnapshot -> {
                    if (documentSnapshot.exists()) {
                        long currentQty = documentSnapshot.getLong("quantity") != null ?
                                documentSnapshot.getLong("quantity") : 1;
                        db.collection("carts").document(userId)
                                .collection("items").document(product.id)
                                .update("quantity", currentQty + 1);
                    } else {
                        db.collection("carts").document(userId)
                                .collection("items").document(product.id)
                                .set(cartItem);
                    }
                    Toast.makeText(context, "Added to cart", Toast.LENGTH_SHORT).show();
                })
                .addOnFailureListener(e -> {
                    Toast.makeText(context, "Failed to add to cart", Toast.LENGTH_SHORT).show();
                });
    }

    @Override
    public int getItemCount() {
        return productList != null ? productList.size() : 0;
    }

    public static class ProductViewHolder extends RecyclerView.ViewHolder {
        ImageView image;
        TextView title, description, price, category;
        Button btnAddToCart;

        public ProductViewHolder(@NonNull View itemView) {
            super(itemView);
            image = itemView.findViewById(R.id.product_image);
            title = itemView.findViewById(R.id.product_title);
            description = itemView.findViewById(R.id.product_description);
            price = itemView.findViewById(R.id.product_price);
            category = itemView.findViewById(R.id.product_category);
            btnAddToCart = itemView.findViewById(R.id.btn_add_to_cart);
        }
    }
}