# Entities, Attributes, and Keys

## Entities and Attributes

- **Entity** — a distinguishable object or concept relevant to the business (typically a "noun"). It becomes a **table** in the database. Example: `Customer`, `Order`, `MenuItem`.
- **Attribute** — a characteristic or property that an entity has. It becomes a **column** in that entity's table. Example: `Customer` has attributes `name`, `email`, `phone_number`.

| Concept (Design) | Implementation (SQL) |
|---|---|
| Entity | Table |
| Attribute | Column |
| Relationship | Foreign key / junction table |
| Instance of an entity | Row |

---

## Keys

A **key** is one or more attributes used to identify or relate rows in a table. There are several types, each serving a different purpose.

### Superkey

A **superkey** is any set of one or more columns that can uniquely identify a row in a table. It does not care about redundancy or extra "baggage" i.e., it can either be as small as single column or as big as the combination of all the columns in the table.
- A single unique column can be a superkey (e.g., `{user_id}`).
- You can tack on extra non-unique columns, and the combination remains a superkey (e.g., `{user_id, age}`).
- Even the set of *all* columns in a table combined is technically a superkey.

### Candidate Key

A **candidate key** is a *minimal* superkey—a superkey stripped down to its absolute minimum with zero redundant attributes. 
- If you remove any single attribute from a candidate key, it loses its uniqueness.
- A table can have multiple candidate keys (e.g., both `user_id` and `email` independently and uniquely identify a row).

### Primary Key

The **primary key** is the specific candidate key chosen to be the main identifier for a table (the "elected leader").
- Every table should have exactly one primary key.
- Its values must be unique and non-null for every row.
- **Good PK traits:** Unique, non-null, stable (doesn't change (often) over time), simple, short, and non-redundant. If no natural candidate key fits, a surrogate key is used.

### Alternate Key

Any candidate key **not** chosen as the primary key becomes an **alternate key**. If `user_id` is chosen as the primary key, `email` remains unique and becomes an alternate key.

### Composite Key

A **composite key** is a key made up of two or more columns that, only *together*, uniquely identify a row. 
- **The Minimality Rule:** If any single column can be removed from the composite key and uniqueness is still maintained, it is **not** a valid composite key. Removing any attribute from a valid composite key must immediately break uniqueness. Common in junction/associative tables.

### Surrogate Key

A **surrogate key** is an artificially generated, non-meaningful column (e.g., a serial, auto-incrementing integer or UUID) created specifically to serve as the primary key. It has zero business meaning and is purely a technical mechanism to guarantee row uniqueness.

### Foreign Key

A **foreign key** is a column (or set of columns) in one table that points directly to the primary key of another table, establishing a relationship between them.

---

## Decoding the Set Notation

Relational databases are built on mathematical set theory. Here is how to interpret the symbols used in formal definitions:

- **$T$ (Table / Relation):** Represents the entire table as a set of rows (tuples).
- **$K$ (Attribute Set):** Represents a subset of columns chosen from table $T$ (e.g., $K = \{\text{id, email}\}$).
- **Uniqueness condition ($r_1[K] \neq r_2[K]$):** For any two distinct rows $r_1$ and $r_2$ in table $T$, their combined values across the attribute set $K$ cannot be identical.
- **Minimality condition ($K \setminus \{A\}$):** For candidate keys, taking any attribute $A$ out of set $K$ (subtraction notation $\setminus$) leaves a subset that is *no longer* a superkey. This proves there is no dead weight.

---

## The Concentric Circles Analogy

Picture three nested circles:

```text
┌─────────────────────────────┐
│ SUPERKEYS                   │ ← Any set of columns that's unique (single, bloated, or all columns)
│ ┌─────────────────────────┐ │
│ │ CANDIDATE KEYS          │ │ ← Minimal superkeys (no dead weight)
│ │ ┌─────────────────────┐ │ │
│ │ │ PRIMARY KEY         │ │ │ ← One chosen candidate key (leader)
│ │ └─────────────────────┘ │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘

```

Every candidate key is a superkey, but not every superkey is a candidate key (it might not be minimal). Every primary key is a candidate key, but not every candidate key is the primary key (the others become alternate keys).

---

## Comparison Table

| Key Type | Definition | Unique? | Nullable? | One per table? | Example |
|---|---|---|---|---|---|
| **Superkey** | Any column set that uniquely identifies a row | Yes | Can include nullable columns | No — many possible | `{email, phone}` in `customers` |
| **Candidate Key** | A minimal superkey | Yes | Typically no | No — a table can have several | `user_id`, `email` |
| **Primary Key** | The chosen candidate key | Yes | Never | Yes — exactly one | `customer_id` |
| **Alternate Key** | Candidate key(s) not chosen as PK | Yes | Typically no | No — zero or more | `email` (if `customer_id` is PK) |
| **Composite Key** | Two+ columns, unique only together | Yes (as a combination) | Usually no | Can be the PK or a candidate key | `(order_id, product_id)` |
| **Surrogate Key** | Artificially generated identifier, no business meaning | Yes | Never | Often used as the PK | `order_id SERIAL` |
| **Foreign Key** | References another table's primary key | No (can repeat) | Can be nullable | A table can have several | `customer_id` in `orders` |

---

## Case Study: Keys in "Foodly"

Continuing the Foodly schema from the Database Design Lifecycle note:

```sql
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,      -- surrogate key, chosen as primary key
  email VARCHAR(100) UNIQUE NOT NULL,  -- alternate key (candidate, not chosen as PK)
  name VARCHAR(100) NOT NULL
);

CREATE TABLE menu_items (
  menu_item_id SERIAL PRIMARY KEY,
  restaurant_id INT NOT NULL REFERENCES restaurants(restaurant_id), -- foreign key
  name VARCHAR(100) NOT NULL,
  price DECIMAL(6,2) NOT NULL
);

CREATE TABLE order_items (
  order_id INT NOT NULL REFERENCES orders(order_id),         -- foreign key
  menu_item_id INT NOT NULL REFERENCES menu_items(menu_item_id), -- foreign key
  quantity INT NOT NULL,
  PRIMARY KEY (order_id, menu_item_id)  -- composite primary key
);
```

- `customers.customer_id` — a **surrogate key**, used as the **primary key** (auto-generated, no business meaning).
- `customers.email` — a **candidate key** (naturally unique) that became an **alternate key** since `customer_id` was chosen instead.
- `order_items (order_id, menu_item_id)` — a **composite key**: neither `order_id` nor `menu_item_id` alone is unique in this table (an order has many items, and a menu item appears in many orders), but the *pair* together is.
- `menu_items.restaurant_id` and both columns in `order_items` — **foreign keys**, linking each table back to the entity it relates to.