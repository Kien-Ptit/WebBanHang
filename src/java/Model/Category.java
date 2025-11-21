package Model;

import java.sql.Timestamp;

public class Category {
    // Database fields
    private int id;
    private String name;
    private String description;
    private Timestamp createdAt;
    
    // Additional fields
    private int productCount;
    private boolean isActive = true;

    // Constructors
    public Category() {}

    public Category(int id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getProductCount() { return productCount; }
    public void setProductCount(int productCount) { this.productCount = productCount; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}