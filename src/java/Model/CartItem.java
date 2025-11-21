// model/CartItem.java
package Model;

import java.math.BigDecimal;

public class CartItem {

    private int productId;
    private String name;
    private String imageUrl;
    private BigDecimal price; // price_at_add hoặc price hiện tại
    private int qty;
    private String size;
    private String color;
    private Integer variantId;

    public CartItem(int productId, String name, String imageUrl, BigDecimal price, int qty) {
        this.productId = productId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.price = price;
        this.qty = qty;
    }

    public int getProductId() {
        return productId;
    }

    public String getName() {
        return name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public BigDecimal getLineTotal() {
        return price.multiply(new BigDecimal(qty));
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Integer getVariantId() {
        return variantId;
    }

    public void setVariantId(Integer id) {
        this.variantId = id;
    }
}
