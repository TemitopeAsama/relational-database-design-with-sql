# SQL Joins — Notes

## Notation Legend

| Symbol | Meaning |
|---|---|
| $R, S, P, V$ | Sets of rows (tables). $P$ = Product, $V$ = Review in the examples below. |
| $\times$ | **Cartesian product** — all possible row-pairings between two sets. |
| $\bowtie$ | **Join** — combining two tables. |
| $\bowtie_{\theta}$ | Join with condition $\theta$ (e.g. `product.product_id = reviews.product_id`). |
| $\theta$ | A **condition/predicate** — a boolean expression like the `ON` clause. |
| $\sigma_{\theta}(X)$ | **Selection** — keep only rows/pairs in $X$ that satisfy $\theta$. |
| $\cup$ | **Union** — combine two sets, removing exact duplicates. |
| $\mid$ | "such that" — used inside set-builder notation, e.g. $\{x \mid x > 0\}$ reads "the set of $x$ such that $x > 0$." |
| $\in$ | "is an element of" — e.g. $p \in P$ means "$p$ is a row in $P$." |
| $\nexists$ | "there does not exist" — e.g. $\nexists\, v \in V$ means "no row $v$ in $V$ exists (satisfying what follows)." |
| $(a, b)$ | An ordered pair — one combined row from two tables. |
| $\text{NULL}$ | Placeholder for missing values, used when a row has no match on the other side. |
| $|X|$ | Cardinality — the number of elements (rows) in set $X$. |

---

## Why Joins?

Relational databases split data across multiple related tables to avoid redundancy. **Joins** let us combine rows from two or more tables based on a related column between them.

Example: query products alongside their reviews.

    SELECT name, review_text
    FROM product
    JOIN reviews
      ON product.product_id = reviews.product_id;

- The `JOIN` clause combines rows from `product` and `reviews`.
- The `ON` clause specifies the **condition** used to match rows between the two tables.

## The Cartesian Product

Given two tables (as sets of rows) $R$ and $S$, the **Cartesian product** is:

$$R \times S = \{(r, s) \mid r \in R,\ s \in S\}$$

Every row $r$ in $R$ paired with every row $s$ in $S$. If $R$ has $m$ rows and $S$ has $n$ rows:

$$|R \times S| = m \times n$$

A `JOIN ... ON` can be understood as a **filtered Cartesian product**. In relational algebra, an inner join with condition $\theta$ is:

$$R \bowtie_{\theta} S = \sigma_{\theta}(R \times S)$$

where $\sigma_\theta$ is the *selection* operator — it keeps only the pairs $(r,s)$ satisfying condition $\theta$ (here, $\theta$ is `product.product_id = reviews.product_id`).

**Note:** This is a conceptual model, not literal execution. Real engines use indexes, hash joins, and merge joins to avoid ever materializing the full $m \times n$ product for large tables.

---

## Types of Joins

Let $P$ = Product rows, $V$ = Review rows, and let $\theta$ be the condition `product.product_id = reviews.product_id`.

### 1. INNER JOIN (same as `JOIN`)

$$\text{INNER}(P, V) = \sigma_{\theta}(P \times V)$$

Returns only rows where a match exists in **both** tables.

    SELECT name, review_text
    FROM product
    INNER JOIN reviews
      ON product.product_id = reviews.product_id;

`JOIN` and `INNER JOIN` are equivalent; `INNER` is the explicit form.

### 2. LEFT JOIN (LEFT OUTER JOIN)

$$\text{LEFT}(P, V) = \text{INNER}(P,V) \;\cup\; \{(p, \text{NULL}) \mid p \in P,\ \nexists\, v \in V : \theta(p, v)\}$$

Returns **all rows from $P$**, matched with rows from $V$ where possible — unmatched product rows get `NULL` in place of review columns.

    SELECT name, review_text
    FROM product
    LEFT JOIN reviews
      ON product.product_id = reviews.product_id;

### 3. RIGHT JOIN (RIGHT OUTER JOIN)

$$\text{RIGHT}(P, V) = \text{INNER}(P,V) \;\cup\; \{(\text{NULL}, v) \mid v \in V,\ \nexists\, p \in P : \theta(p, v)\}$$

Returns **all rows from $V$ (Review)**, matched with rows from $P$ (Product) where possible.

    SELECT name, review_text
    FROM product
    RIGHT JOIN reviews
      ON product.product_id = reviews.product_id;


### 4. FULL OUTER JOIN

$$\text{FULL}(P, V) = \text{LEFT}(P,V) \;\cup\; \text{RIGHT}(P,V)$$

Equivalently:

$$\text{FULL}(P, V) = \text{INNER}(P,V) \cup \{(p,\text{NULL}) \mid \nexists\, v: \theta\} \cup \{(\text{NULL}, v) \mid \nexists\, p: \theta\}$$

    SELECT name, review_text
    FROM product
    FULL OUTER JOIN reviews
      ON product.product_id = reviews.product_id;

**Note:** MySQL has no native `FULL OUTER JOIN` — it's emulated as `LEFT JOIN UNION RIGHT JOIN`. PostgreSQL and SQL Server support it directly.

### Comparison

| Join Type | Set Definition | Rows Returned |
|---|---|---|
| INNER JOIN | $\sigma_\theta(P \times V)$ | Only matches |
| LEFT JOIN | INNER $\cup$ unmatched $P$ rows | All of $P$ + matches from $V$ |
| RIGHT JOIN | INNER $\cup$ unmatched $V$ rows | All of $V$ + matches from $P$ |
| FULL OUTER | LEFT $\cup$ RIGHT | Everything, matched where possible |

---

## WHERE vs. JOIN

Before `JOIN` syntax became standard, tables were joined via a comma-separated `FROM` and a `WHERE` condition — an **implicit join**:

    SELECT name, review_text
    FROM product, reviews
    WHERE product.product_id = reviews.product_id;

This is logically equivalent to $\sigma_\theta(P \times V)$ — the same as an `INNER JOIN`. It's called *implicit* because the relationship is expressed via a filter condition rather than a dedicated clause; the explicit form (`JOIN ... ON`) separates the two.

`WHERE` isn't exclusive to joins — it also filters a single table:

    SELECT name, product_id
    FROM product
    WHERE product_id = 2;

### Why prefer explicit `JOIN` over `WHERE`-style joins?

- **Readability** — `JOIN ... ON` separates *how tables relate* ($\theta$, the `ON` condition) from *how rows are filtered* (a separate `WHERE` clause). The comma-style mixes both, which gets harder to parse as joins/filters multiply.
- **Maintainability** — explicit join logic makes it easier to spot mistakes (e.g. a missing condition silently producing the full $m \times n$ Cartesian product) and easier to extend.
- **Expressiveness** — outer joins (LEFT, RIGHT, FULL) are only cleanly expressible with explicit `JOIN` syntax; the comma-style realistically only expresses inner joins well.

<!-- >"JOINs are more optimized than WHERE clauses" isn't generally true on modern engines (PostgreSQL, MySQL, SQL Server) — the query optimizer typically produces the **same execution plan** for `JOIN...ON` vs. comma/`WHERE` syntax for inner joins. The durable advantage of explicit `JOIN` is readability and maintainability, not guaranteed performance. -->

---

## Summary

- $R \times S$: Cartesian product — all row pairs, size $|R|\times|S|$.
- $\text{INNER}(R,S) = \sigma_\theta(R\times S)$: inner join — filtered Cartesian product.
- $\text{LEFT}(P,V) = \text{INNER}(P,V) \cup$ unmatched left rows (padded with `NULL`).
- $\text{RIGHT}(P,V) = \text{INNER}(P,V) \cup$ unmatched right rows (padded with `NULL`).
- $\text{FULL}(P,V) = \text{LEFT}(P,V) \cup \text{RIGHT}(P,V)$.
- Prefer explicit `JOIN ... ON` over old-style `WHERE` joins for readability and maintainability, not because it's inherently faster.