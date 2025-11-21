package Model;

import java.math.BigDecimal;
import java.util.*;

public class Cart {

    // ← Key = "productId|size|color" để phân biệt từng size
    private final Map<String, CartItem> items = new LinkedHashMap<>();

    private String keyOf(int productId, String size, String color) {
        return productId + "|" + (size == null ? "" : size) + "|" + (color == null ? "" : color);
    }

    public void add(CartItem item) {
        String key = keyOf(item.getProductId(), item.getSize(), item.getColor());
        CartItem exist = items.get(key);
        if (exist == null) {
            items.put(key, item);
        } else {
            exist.setQty(exist.getQty() + item.getQty());
        }
    }

    public void updateQty(int productId, String size, String color, int qty) {
        String k = keyOf(productId, size, color);
        if (qty <= 0) {
            items.remove(k);
            return;
        }
        CartItem it = items.get(k);
        if (it != null) {
            it.setQty(qty);
        }
    }

    public void remove(int productId, String size, String color) {
        items.remove(keyOf(productId, size, color));
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public int getTotalQty() {
        return items.values().stream().mapToInt(CartItem::getQty).sum();
    }

    public BigDecimal getTotalAmount() {
        return items.values().stream()
                .map(CartItem::getLineTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void clear() {
        items.clear();
    }
}