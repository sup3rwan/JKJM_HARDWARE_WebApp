-- =====================================================================
-- JKJM Hardware - database schema (MySQL 8.0+)
-- Run:  mysql -u root -p < database/schema.sql
-- =====================================================================
DROP DATABASE IF EXISTS jkjm_hardware;
CREATE DATABASE jkjm_hardware CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jkjm_hardware;

-- ---------- Lookup tables ----------
CREATE TABLE order_status (
  order_status_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  status_name     VARCHAR(20) NOT NULL,
  PRIMARY KEY (order_status_id),
  UNIQUE KEY uq_order_status_name (status_name)
) ENGINE=InnoDB;

CREATE TABLE payment_status (
  payment_status_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  status_name       VARCHAR(20) NOT NULL,
  PRIMARY KEY (payment_status_id),
  UNIQUE KEY uq_payment_status_name (status_name)
) ENGINE=InnoDB;

CREATE TABLE delivery_status (
  delivery_status_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  status_name        VARCHAR(20) NOT NULL,
  PRIMARY KEY (delivery_status_id),
  UNIQUE KEY uq_delivery_status_name (status_name)
) ENGINE=InnoDB;

CREATE TABLE payment_method (
  payment_method_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  method_name       VARCHAR(30) NOT NULL,
  is_active         TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (payment_method_id),
  UNIQUE KEY uq_payment_method_name (method_name)
) ENGINE=InnoDB;

CREATE TABLE product_category (
  category_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(60) NOT NULL,
  PRIMARY KEY (category_id),
  UNIQUE KEY uq_category_name (category_name)
) ENGINE=InnoDB;

-- ---------- People ----------
CREATE TABLE customer (
  customer_id     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name      VARCHAR(60)  NOT NULL,
  last_name       VARCHAR(60)  NOT NULL,
  email           VARCHAR(120) NOT NULL,
  phone           VARCHAR(20)  NOT NULL,
  default_address VARCHAR(255) NOT NULL DEFAULT '',
  password_hash   VARCHAR(100) NOT NULL,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  UNIQUE KEY uq_customer_email (email)
) ENGINE=InnoDB;

CREATE TABLE employee (
  employee_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name    VARCHAR(60)  NOT NULL,
  last_name     VARCHAR(60)  NOT NULL,
  email         VARCHAR(120) NOT NULL,
  phone         VARCHAR(20)  NOT NULL,
  job_position  VARCHAR(20)  NOT NULL,
  password_hash VARCHAR(100) NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (employee_id),
  UNIQUE KEY uq_employee_email (email),
  CONSTRAINT ck_employee_position CHECK (job_position IN ('Administrator','Delivery Staff'))
) ENGINE=InnoDB;

-- ---------- Products ----------
CREATE TABLE product (
  product_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_id  INT UNSIGNED NOT NULL,
  product_name VARCHAR(120) NOT NULL,
  description  VARCHAR(255) NOT NULL,
  unit_price   DECIMAL(10,2) NOT NULL,
  stock_qty    INT UNSIGNED NOT NULL DEFAULT 0,
  image_key    VARCHAR(30) NOT NULL DEFAULT 'hammer',   -- key of the SVG picture used by the UI
  status       ENUM('Available','Out of Stock') NOT NULL DEFAULT 'Available',
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id),
  KEY idx_product_category (category_id),
  KEY idx_product_name (product_name),
  CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES product_category (category_id),
  CONSTRAINT ck_product_price CHECK (unit_price >= 0)
) ENGINE=InnoDB;

-- ---------- Orders ----------
CREATE TABLE customer_order (
  order_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id      INT UNSIGNED NOT NULL,
  order_status_id  TINYINT UNSIGNED NOT NULL,
  delivery_address VARCHAR(255) NOT NULL,
  notes            VARCHAR(250) NULL,
  delivery_fee     DECIMAL(10,2) NOT NULL DEFAULT 50.00,
  requested_date   DATE NOT NULL,
  approved_date    DATE NULL,
  -- latest admin review (no separate review table)
  reviewed_by      INT UNSIGNED NULL,
  reviewed_at      DATETIME NULL,
  review_decision  ENUM('Approved','Rejected') NULL,
  review_remarks   VARCHAR(255) NULL,
  review_reason    ENUM('payment','date') NULL,
  stock_deducted   TINYINT(1) NOT NULL DEFAULT 0,
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  KEY idx_order_customer (customer_id),
  KEY idx_order_status (order_status_id),
  CONSTRAINT fk_order_customer FOREIGN KEY (customer_id)     REFERENCES customer (customer_id),
  CONSTRAINT fk_order_status   FOREIGN KEY (order_status_id) REFERENCES order_status (order_status_id),
  CONSTRAINT fk_order_reviewer FOREIGN KEY (reviewed_by)     REFERENCES employee (employee_id)
) ENGINE=InnoDB;

CREATE TABLE order_detail (
  order_id   INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  quantity   INT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,                      -- price at the time of ordering
  PRIMARY KEY (order_id, product_id),
  KEY idx_detail_product (product_id),
  CONSTRAINT fk_detail_order   FOREIGN KEY (order_id)   REFERENCES customer_order (order_id) ON DELETE CASCADE,
  CONSTRAINT fk_detail_product FOREIGN KEY (product_id) REFERENCES product (product_id),
  CONSTRAINT ck_detail_qty CHECK (quantity > 0)
) ENGINE=InnoDB;

CREATE TABLE payment (
  payment_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id          INT UNSIGNED NOT NULL,
  payment_method_id TINYINT UNSIGNED NOT NULL,
  payment_status_id TINYINT UNSIGNED NOT NULL,
  reference_no      VARCHAR(60) NULL,                     -- GCash / bank transaction reference
  amount            DECIMAL(10,2) NOT NULL,
  paid_at           DATETIME NULL,
  PRIMARY KEY (payment_id),
  UNIQUE KEY uq_payment_order (order_id),
  CONSTRAINT fk_payment_order  FOREIGN KEY (order_id)          REFERENCES customer_order (order_id) ON DELETE CASCADE,
  CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_method (payment_method_id),
  CONSTRAINT fk_payment_status FOREIGN KEY (payment_status_id) REFERENCES payment_status (payment_status_id)
) ENGINE=InnoDB;

-- ---------- Delivery ----------
-- A delivery row is created when the admin confirms the order.
-- delivery_status_id stays NULL until staff start preparing (the UI shows "Confirmed").
CREATE TABLE delivery (
  delivery_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id           INT UNSIGNED NOT NULL,
  delivery_status_id TINYINT UNSIGNED NULL,
  delivery_date      DATE NOT NULL,
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (delivery_id),
  UNIQUE KEY uq_delivery_order (order_id),
  CONSTRAINT fk_delivery_order  FOREIGN KEY (order_id)           REFERENCES customer_order (order_id) ON DELETE CASCADE,
  CONSTRAINT fk_delivery_status FOREIGN KEY (delivery_status_id) REFERENCES delivery_status (delivery_status_id)
) ENGINE=InnoDB;

-- Many-to-many: a delivery can be handled by one or more delivery staff
CREATE TABLE delivery_assignment (
  delivery_id INT UNSIGNED NOT NULL,
  employee_id INT UNSIGNED NOT NULL,
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (delivery_id, employee_id),
  KEY idx_assignment_employee (employee_id),
  CONSTRAINT fk_assign_delivery FOREIGN KEY (delivery_id) REFERENCES delivery (delivery_id) ON DELETE CASCADE,
  CONSTRAINT fk_assign_employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
) ENGINE=InnoDB;

CREATE TABLE delivery_status_history (
  history_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  delivery_id        INT UNSIGNED NOT NULL,
  delivery_status_id TINYINT UNSIGNED NOT NULL,
  updated_by         INT UNSIGNED NOT NULL,
  updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (history_id),
  KEY idx_history_delivery (delivery_id),
  CONSTRAINT fk_history_delivery FOREIGN KEY (delivery_id)        REFERENCES delivery (delivery_id) ON DELETE CASCADE,
  CONSTRAINT fk_history_status   FOREIGN KEY (delivery_status_id) REFERENCES delivery_status (delivery_status_id),
  CONSTRAINT fk_history_employee FOREIGN KEY (updated_by)         REFERENCES employee (employee_id)
) ENGINE=InnoDB;
