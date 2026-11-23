-- =====================================================================
-- JKJM Hardware - starting data (run AFTER schema.sql)
-- Run:  mysql -u root -p < database/seed.sql
-- Demo user accounts are created by:  npm run db:users  (passwords must be hashed by Node)
-- =====================================================================
USE jkjm_hardware;

INSERT INTO order_status (status_name) VALUES ('Pending'),('Confirmed'),('Rejected'),('Cancelled');
INSERT INTO payment_status (status_name) VALUES ('Pending'),('Paid'),('Failed'),('Refunded');
INSERT INTO delivery_status (status_name) VALUES ('Preparing'),('To Receive'),('Delivered');
INSERT INTO payment_method (method_name, is_active) VALUES ('Cash on Delivery',1),('GCash',1),('Bank Transfer',1);

INSERT INTO product_category (category_name) VALUES
  ('Tools'),
  ('Building Materials'),
  ('Paint & Finishing'),
  ('Plumbing & Electrical'),
  ('Safety Gear'),
  ('Hardware & Security');

INSERT INTO product (category_id, product_name, description, unit_price, stock_qty, image_key, status) VALUES
  (1, 'Claw Hammer 16oz', 'Forged steel head, fiberglass handle', 280, 40, 'hammer', 'Available'),
  (1, 'Cordless Drill 12V', '2 batteries, 10mm chuck', 2450, 12, 'drill', 'Available'),
  (2, 'Portland Cement 40kg', 'Type 1 general purpose cement', 265, 100, 'cement', 'Available'),
  (2, 'Hollow Block 4"', 'Standard CHB, sold per piece', 16, 500, 'brick', 'Available'),
  (2, 'Coco Lumber 2x3x10', 'Kiln-dried framing lumber', 185, 60, 'lumber', 'Available'),
  (2, 'Concrete Nails 3" (1kg)', 'Hardened steel masonry nails', 95, 80, 'nails', 'Available'),
  (3, 'Latex Paint White 4L', 'Washable interior and exterior', 890, 24, 'paint', 'Available'),
  (4, 'PVC Pipe 1/2" (3m)', 'Class 600, for water lines', 120, 70, 'pipe', 'Available'),
  (4, 'THHN Wire #12 (75m)', 'Copper, 600V rated', 2650, 0, 'wire', 'Out of Stock'),
  (5, 'Safety Helmet', 'Impact-resistant, adjustable strap', 180, 35, 'helmet', 'Available'),
  (1, 'Adjustable Wrench 10"', 'Chrome vanadium steel', 320, 28, 'wrench', 'Available'),
  (1, 'Screwdriver Set (6 pcs)', 'Magnetic tips, cushion grip', 395, 30, 'screwdriver', 'Available'),
  (1, 'Hand Saw 20"', 'Hardened teeth, wood grip', 340, 18, 'saw', 'Available'),
  (1, 'Tape Measure 5m', 'Auto-lock, steel blade', 140, 60, 'tape', 'Available'),
  (1, 'Steel Ladder 6-step', 'Foldable, 150kg capacity', 2850, 8, 'ladder', 'Available'),
  (3, 'Paint Brush 3"', 'Soft bristle, wooden handle', 85, 75, 'brush', 'Available'),
  (3, 'Paint Roller Set 9"', 'Roller, tray and handle', 260, 22, 'roller', 'Available'),
  (4, 'LED Bulb 9W', 'Daylight, E27 base', 75, 120, 'bulb', 'Available'),
  (4, 'Wall Faucet 1/2"', 'Brass body, chrome finish', 210, 33, 'faucet', 'Available'),
  (4, 'Duplex Outlet', 'Universal, 16A 250V', 95, 90, 'outlet', 'Available'),
  (2, 'Deformed Bar 10mm x 6m', 'Grade 40 reinforcing steel bar', 245, 150, 'rebar', 'Available'),
  (2, 'Floor Tile 60x60 (box)', 'Glazed ceramic, 4 pcs per box', 780, 40, 'tile', 'Available'),
  (5, 'Work Gloves', 'Cut-resistant palm grip', 90, 55, 'gloves', 'Available'),
  (5, 'Safety Goggles', 'Anti-scratch clear lens', 130, 45, 'goggles', 'Available'),
  (6, 'Padlock 50mm', 'Hardened shackle, 3 keys', 210, 40, 'padlock', 'Available');
