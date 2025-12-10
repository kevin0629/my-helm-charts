-- Order Management System Database Schema
-- Based on ER-Model.png requirements

CREATE DATABASE IF NOT EXISTS order_management_system;
USE order_management_system;

-- Suppliers table
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    category VARCHAR(100),
    sku VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE CASCADE
);

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(50),
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    shipping_address TEXT,
    billing_address TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Line Products table (Order Items)
CREATE TABLE line_products (
    line_product_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    line_total DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Indexes for better performance
CREATE INDEX idx_products_supplier ON products(supplier_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_line_products_order ON line_products(order_id);
CREATE INDEX idx_line_products_product ON line_products(product_id);

-- Insert sample data
INSERT INTO suppliers (name, contact_email, contact_phone, address) VALUES
('Tech Solutions Ltd', 'contact@techsolutions.com', '+1-555-0101', '123 Tech Street, Silicon Valley'),
('Home Goods Co', 'sales@homegoods.com', '+1-555-0102', '456 Home Avenue, Retail City'),
('Electronics World', 'info@electronicsworld.com', '+1-555-0103', '789 Circuit Road, Digital Town');

INSERT INTO products (supplier_id, name, description, price, stock_quantity, category, sku) VALUES
(1, 'Laptop Pro 15"', 'High-performance laptop with 16GB RAM', 1299.99, 50, 'Electronics', 'LAP-PRO-15-001'),
(1, 'Wireless Mouse', 'Ergonomic wireless mouse with USB receiver', 29.99, 200, 'Electronics', 'MOUSE-WRL-001'),
(2, 'Coffee Maker', 'Automatic drip coffee maker with timer', 89.99, 75, 'Home & Kitchen', 'COFFEE-AUTO-001'),
(2, 'Dining Table', 'Solid wood dining table for 6 people', 399.99, 15, 'Furniture', 'TABLE-DINING-001'),
(3, 'Smartphone X1', 'Latest smartphone with 128GB storage', 799.99, 100, 'Electronics', 'PHONE-X1-128GB');

INSERT INTO users (username, email, password_hash, first_name, last_name, phone, address) VALUES
('john_doe', 'john.doe@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj.8v5.9.9.9', 'John', 'Doe', '+1-555-1001', '123 Main St, Anytown, USA'),
('jane_smith', 'jane.smith@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj.8v5.9.9.9', 'Jane', 'Smith', '+1-555-1002', '456 Oak Ave, Somewhere, USA');
