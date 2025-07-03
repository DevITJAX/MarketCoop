package com.example.marketcoop.adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.bumptech.glide.Glide;
import com.example.marketcoop.R;
import com.example.marketcoop.models.CartItem;
import java.util.List;

public class CartAdapter extends RecyclerView.Adapter<CartAdapter.CartViewHolder> {
    private final List<CartItem> items;

    public CartAdapter(List<CartItem> items) {
        this.items = items;
    }

    @NonNull
    @Override
    public CartViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_cart, parent, false);
        return new CartViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull CartViewHolder holder, int position) {
        CartItem item = items.get(position);

        holder.title.setText(item.title != null ? item.title : "");
        holder.price.setText(String.format("%.2f DH", item.price));
        holder.quantity.setText(String.format("Qty: %d", item.quantity));

        if (item.imageUrl != null && !item.imageUrl.isEmpty()) {
            Glide.with(holder.itemView.getContext())
                    .load(item.imageUrl)
                    .placeholder(R.drawable.placeholder_image)
                    .error(R.drawable.error_image)
                    .into(holder.imageView);
        } else {
            holder.imageView.setImageResource(R.drawable.placeholder_image);
        }
    }

    @Override
    public int getItemCount() {
        return items != null ? items.size() : 0;
    }

    public static class CartViewHolder extends RecyclerView.ViewHolder {
        final TextView title;
        final TextView price;
        final TextView quantity;
        final ImageView imageView;

        public CartViewHolder(@NonNull View itemView) {
            super(itemView);
            title = itemView.findViewById(R.id.cart_title);
            price = itemView.findViewById(R.id.cart_price);
            quantity = itemView.findViewById(R.id.cart_quantity);
            imageView = itemView.findViewById(R.id.cart_image);
        }
    }

    public void updateItems(List<CartItem> newItems) {
        items.clear();
        items.addAll(newItems);
        notifyDataSetChanged();
    }
}