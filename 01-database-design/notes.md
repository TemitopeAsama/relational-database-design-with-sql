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


- Entity Relationship Diagrams
- Concept to Implementation - Entity to Table; Atrributes to Columns
- Naming Conventions


Primary Key, Candidate Keys and Superkeys (Concentric circles analogy)
Every table needs a primary key. It refres to one or more attributes that can be used to identify an individual row
The values of the primary key must be unique to each individual
A table can only have one primary key
Pick the best candidate key as the primary key, if no good candiddate key is available, create a new attribute to serve as the primary key
A candidate key is the smallest possible combination of attributes that can unqiely identify in a table
A superkey is a set of one or more columns of a table that can uniquely identify a row in that table

How to pick the right primary key
Pick the best candidate key as the primary key, if no good candiddate key is available, create a new attribute to serve as the primary key

- Must be unique
- Must be non-null
- Must be stable
- Must be simple
- Must be short
- Must be familiar
- Must be preventing redundancy


Composite Keys
Surrogate Key - non-meaningful column 
