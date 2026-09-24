LJ Dev Commerce — Source-System Raw Data Simulation

This is a project simulation, not a claim that every source assignment is
explicitly specified in the BRD.

Confirmed source systems from the BRD include CRM, Shopify, Amazon UAE, Noon,
Zoho Inventory, Zoho Books, Meta Ads, Google Ads, TikTok Ads, and courier systems.

Simulation decisions where the BRD is not specific:
- Supplier -> Procurement / ERP
- Category/Product -> Product Catalog
- Marketing Campaign -> Marketing system
- Return -> Returns System
- Payment -> Zoho Books
- Sales Order / Sales Order Item -> split across Shopify, Amazon UAE, and Noon

The raw extracts intentionally use source-style column names. They are NOT
target-schema copies. Python ETL will map them to the PostgreSQL target schema.

The raw data remains connected through business identifiers so the final
PostgreSQL relationships can be validated.

Customer is already completed. Do not recreate or reload it.

Recommended target load order:
Customer, Supplier, Category, Warehouse, Marketing Campaign, Product,
Sales Order, Sales Order Item, Payment, Shipment, Return, Inventory,
Inventory Movement.
