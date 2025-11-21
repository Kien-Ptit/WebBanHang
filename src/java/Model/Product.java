package Model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {
    // Database fields
    private int id;
    private String name;
    private String description;
    private BigDecimal price;
    private BigDecimal discountPrice;  // Khớp với discount_price trong DB
    private String imageUrl;           // Khớp với image_url trong DB
    private Integer categoryId;        // Khớp với category_id trong DB
    private int stockQuantity;         // Khớp với stock_quantity trong DB
    private String size;
    private String color;
    private String material;
    private String brand;
    private String status;             // enum('active','inactive')
    private boolean featured;          // tinyint(1)
    private int views;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private Category category;
    private String categoryName;
    private int minStockLevel = 5;

    // Constructors
    public Product() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getDiscountPrice() { return discountPrice; }
    public void setDiscountPrice(BigDecimal discountPrice) { this.discountPrice = discountPrice; }
    
    // Alias cho sale price
    public BigDecimal getSalePrice() { return discountPrice; }
    public void setSalePrice(BigDecimal salePrice) { this.discountPrice = salePrice; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    // Alias cho image
    public String getImage() { return imageUrl; }
    public void setImage(String image) { this.imageUrl = image; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getMaterial() { return material; }
    public void setMaterial(String material) { this.material = material; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    
    // Alias
    public String getBrandName() { return brand; }
    public void setBrandName(String brandName) { this.brand = brandName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }
    
    // Alias
    public int getViewCount() { return views; }
    public void setViewCount(int viewCount) { this.views = viewCount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public int getMinStockLevel() { return minStockLevel; }
    public void setMinStockLevel(int minStockLevel) { this.minStockLevel = minStockLevel; }

    // Helper methods
    public boolean isOnSale() {
        return discountPrice != null && discountPrice.compareTo(price) < 0;
    }

    public BigDecimal getFinalPrice() {
        return isOnSale() ? discountPrice : price;
    }

    public boolean isLowStock() {
        return stockQuantity <= minStockLevel;
    }

    public boolean isOutOfStock() {
        return stockQuantity == 0;
    }

    public boolean isActive() {
        return "active".equalsIgnoreCase(status);
    }
}