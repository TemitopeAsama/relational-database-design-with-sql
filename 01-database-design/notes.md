DATABASE DESIGN LIFECYCLE

Why is database design important?
- Maintainability
- Readability
- Scalability
- Flexibility

Overview of the design process
- Requirement Gathering
This involves gatherinhg info about the database. This process involves calls and conversations with stakeholders (e.g software engineers, IT staff, analysts etc). You need to curate specific and valid questions to aid your requirement gathering (any AI tool might help you with good questions you can ask). Recording or taking notes of your conversation is a very helpful tool to truly understanding the requirements, giving you the opportunity to return to the conversations over and over again. If the transcript of the conversation is very long, you may also seek help from generative AI
- Analysis and Design
Key steps include:
- Identify the goals of the database
From your requirements, you should be able to identify what your database should achieve, the kind of users, roles, products or whatever you will be collecting.
- Identify subjects, characteristics, and relationships
From the gathered requirements, you want to pick out the nouns as it relates to your product/business, this are your potential subjects/entities. What these nouns possess or should posses are your characteristics and nouns can be related to one another, for example, a user and an order can be related in say a food ordering business. a user can make multiple orders but an order can only be made by a user.

- Data Modelling
Using Entity-Relationship Diagrams

- Normalization
Breaking down a table containing more than one entities into separate tables
Has a clear defined theorem

- Implementation/integration and Testing
Building and validating data models from your blueprint
Convert your E-R model to SQL code
Validate your database with test data, testing functionality e.g creating, updating, deleting, etc.
Check how database handle heavy use
Check database security
Fix bugs




# Database Design Lifecycle

## Why Database Design Matters

Good database design pays off through:

- **Maintainability** — a well-structured schema is easier to update, debug, and extend without breaking existing functionality.
- **Readability** — clear table/column names and relationships make the schema self-explanatory to any developer who joins later.
- **Scalability** — a properly normalized, indexed design holds up as data volume and query load grow.
- **Flexibility** — good design anticipates future changes (new features, new entities) without requiring a full rebuild.

---

## Overview of the Design Process

### 1. Requirements Gathering

The process of collecting information about what the database needs to store and support. This typically involves:

- Calls and conversations with stakeholders (software engineers, IT staff, business analysts, product owners, etc.)
- Preparing specific, targeted questions ahead of time (an AI tool can help brainstorm good questions to ask)
- Recording or transcribing conversations — this lets you revisit the discussion rather than relying on memory
- For long transcripts, generative AI can help summarize and extract the key requirements

### 2. Analysis and Design

**a. Identify the goals of the database**
From the gathered requirements, determine what the database needs to achieve — what kinds of users, roles, products, or records it will manage.

**b. Identify subjects, characteristics, and relationships**
- **Subjects/Entities** — the "nouns" of the business (e.g. `User`, `Order`, `Product`)
- **Characteristics/Attributes** — the properties those nouns have or should have (e.g. a `User` has a name, email, phone number)
- **Relationships** — how entities relate to one another, including *cardinality* (one-to-one, one-to-many, many-to-many)

### 3. Data Modeling

Represent the entities, attributes, and relationships visually using an **Entity-Relationship Diagram (ERD)**. This is the blueprint before any SQL is written.

### 4. Normalization

The process of breaking down a table that mixes more than one entity's data into separate, well-defined tables to reduce redundancy and preventing update/insert/delete anomalies. Normalization follows a defined set of rules (**normal forms**: 1NF, 2NF, 3NF, etc.), each with formal criteria a table must satisfy (to be treated later).

### 5. Implementation, Integration & Testing

- Convert the E-R model into actual SQL (`CREATE TABLE` statements, constraints, indexes)
- Validate with test data — confirm create, read, update, delete (CRUD) operations behave correctly
- Load-test — check how the database performs under heavy read/write volume
- Security-test — check access controls, permissions, and exposure to injection or leaks
- Fix bugs surfaced during testing before going live

---

## Naming Conventions

Consistency here directly supports maintainability and readability:

- Use `snake_case` for table and column names (e.g. `order_items`, `created_at`)
- Prefer singular or plural table names *consistently* across the whole schema (e.g. always `order` or always `orders`, not a mix)
- Primary key columns are often named `id` or `<table_name>_id` (e.g. `user_id`)
- Foreign key columns should match the name of the primary key they reference (e.g. `user_id` in `orders` referencing `user_id` in `users`)
- Avoid reserved SQL keywords as identifiers (`order`, `group`, `select`, etc.)

---

## Case Study: Designing "Foodly" (a food delivery app)

Now, we can design the lifecycle end-to-end for **Foodly**, a hypothetical food delivery platform.

**1. Requirements Gathering**
Interviews with the product manager and lead engineer reveal: customers browse restaurants, place orders containing multiple menu items, restaurants prepare orders, and drivers deliver them. Stakeholders want to track order status, payment, and delivery time.

**2. Analysis and Design**
- *Goal:* support customer ordering, restaurant menu management, and delivery tracking.
- *Subjects identified:* `Customer`, `Restaurant`, `MenuItem`, `Order`, `OrderItem`, `Driver`, `Delivery`.
- *Characteristics:* a `Customer` has a name, email, phone, address; a `MenuItem` has a name, price, restaurant it belongs to.
- *Relationships:*
  - A `Customer` can place many `Order`s (one-to-many).
  - An `Order` can contain many `MenuItem`s, and a `MenuItem` can appear in many `Order`s (many-to-many).
  - A `Driver` handles many `Delivery` records, but each `Delivery` has one `Driver` (one-to-many).

**3. Data Modeling**
An ERD is drawn showing `Customer`, `Restaurant`, `MenuItem`, `Order`, `OrderItem`, `Driver`, and `Delivery` as boxes, connected by lines representing the relationships above, annotated with cardinality (1, many).

**4. Normalization**
Initially, a single `orders` table might have stored customer name, restaurant name, and a comma-separated list of menu items directly — this mixes multiple entities together and repeats data. Normalization splits this into `customers`, `restaurants`, `menu_items`, `orders`, and `order_items` tables, each representing exactly one entity.

**5. Implementation & Testing**
```sql
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  order_status VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```
The team then tests: creating a customer, placing an order, updating order status, and confirms the database performs correctly under simulated peak-hour order volume before launch.