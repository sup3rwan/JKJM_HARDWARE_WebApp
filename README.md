# JKJM_HARDWARE_WebApp
An online ordering and delivery platform for construction supplies and hardware materials. Customers browse products and place orders, admins review orders and manage stock, and delivery staff handle confirmed deliveries.


## Team
Izza Brita
Jasmine Bobis

## Repository Contents

```
.
├── README.md
├── Task1_ProjectBrief.docx   # Project brief: problem, users, goals
├── crud-map.docx             # Which pages create, read, update, delete which tables
├── sitemap.docx              # Sitemap and user flow
├── style_guide.docx          # Colors, typography, spacing, components
├── schema.sql                # Database structure (MySQL)
├── seed.sql                  # Starting data (statuses, categories, products)
├── Wireframes/               # Desktop and phone wireframes (Figma exports)
└── prototype/                # Task 6: static HTML/CSS pages
    ├── list.html             # Products & Stock list page
    ├── form.html             # Add a Product form
    └── css/
        └── style.css         # Shared stylesheet (style-guide variables)
```

---

## USER 

| Role | What they do |
|------|--------------|
| **Customer** | Browses products, places orders, chooses a payment method, tracks delivery |
| **Admin** | Reviews and confirms or rejects orders, manages products and stock, assigns delivery staff |
| **Delivery Staff** | Works on confirmed orders and updates delivery status |

---

## Database

The database is `jkjm_hardware` (MySQL). It covers customers, orders and order details, products and categories, payments and payment methods, employees, and deliveries with their status history and staff assignments.

**Set it up:**

```bash
mysql -u root -p < schema.sql    # create the database and tables
mysql -u root -p < seed.sql      # load statuses, payment methods, categories, products
```

Run `schema.sql` first. `seed.sql` depends on it.

---

## Viewing the Prototype

No server or build step is needed.

1. Clone or download this repository.
2. Open `prototype/list.html` in a browser.
3. Use **Add a product** or **Edit** to open `prototype/form.html`.

To check the phone layout, open the browser's developer tools and set the viewport to **390px** wide.

### Prototype notes
- The list page shows 6 products copied from `seed.sql`.
- Search, Edit and Delete are visual only. They start working in later weeks.
- Each form input's `name` matches a column in the `product` table (`product_name`, `category_id`, `description`, `unit_price`, `stock_qty`, `status`, `image_key`) so PHP can read it with `$_POST[...]`.

---

## Design System

All pages share `prototype/css/style.css`, which begins with the style-guide variables.

CSS 
:root { --color-primary: #ffc72c;   /* buttons, active tabs, highlights */ --color-bg: #ffffff;        --color-text: #1c1c1e;      
/* page background */ 
/* body text. Contrast on bg: 17.01:1 ✓ */ --color-success: #15803d;   /* approve and verify buttons. White text: 
5.02:1 ✓ */ --color-error: #c62828;     
✓ */ 
/* cancel and reject buttons. White text: 5.62:1 --font-heading: "Outfit", "Manrope", sans-serif;   /* titles, weight 600 */ --font-body: "Manrope", system-ui, sans-serif;     
/* all other text */ --font-size-base: 15px;     --radius: 12px;             
} 
/* body text size */ 
/* buttons and inputs */

---

## Tech Stack

- **Now:** HTML and CSS
- **Planned:** PHP, JavaScript, MySQL

---

## Roadmap

- [x] Task 1: Project brief
- [x] Task 2: CRUD map
- [x] Task 3: Sitemap and user flow
- [x] Task 4: Wireframes
- [x] Task 5: Style guide
- [x] Task 6: Static pages (`list.html`, `form.html`)
- [ ] Later weeks: PHP, JavaScript and database connection
