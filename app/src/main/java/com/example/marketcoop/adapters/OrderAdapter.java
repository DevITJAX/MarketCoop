package com.example.marketcoop.adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.marketcoop.models.Order;
import com.example.marketcoop.models.CartItem;  // Added import
import com.example.marketcoop.R;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class OrderAdapter extends RecyclerView.Adapter<OrderAdapter.OrderViewHolder> {
    private List<Order> orderList;

    public OrderAdapter(List<Order> orderList) {
        this.orderList = orderList;
    }

    @NonNull
    @Override
    public OrderViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order, parent, false);
        return new OrderViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull OrderViewHolder holder, int position) {
        Order order = orderList.get(position);

        // Set total price
        holder.total.setText(holder.itemView.getContext().getString(R.string.total, order.total));

        // Convert OrderStatus enum to string
        holder.status.setText(order.status.toString());

        // Format date
        holder.date.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
                .format(new Date(order.timestamp)));

        // Build items summary
        StringBuilder itemsSummary = new StringBuilder();
        if (order.items != null) {
            for (CartItem item : order.items) {
                itemsSummary.append(item.title)
                        .append(" x")
                        .append(item.quantity)
                        .append(", ");
            }
            if (itemsSummary.length() > 2) {
                itemsSummary.setLength(itemsSummary.length() - 2);
            }
        }
        holder.items.setText(itemsSummary.toString());
    }

    @Override
    public int getItemCount() {
        return orderList != null ? orderList.size() : 0;
    }

    public static class OrderViewHolder extends RecyclerView.ViewHolder {
        TextView total, status, date, items;

        OrderViewHolder(View itemView) {
            super(itemView);
            total = itemView.findViewById(R.id.order_total);
            status = itemView.findViewById(R.id.order_status);
            date = itemView.findViewById(R.id.order_date);
            items = itemView.findViewById(R.id.order_items);
        }
    }

    public void updateOrders(List<Order> newOrders) {
        this.orderList = newOrders;
        notifyDataSetChanged();
    }
}