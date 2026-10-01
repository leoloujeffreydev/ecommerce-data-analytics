# Phase 6 --- Analytics Requirements & Reporting Design

**Project:** LJ Dev Commerce --- E-commerce Data Analytics\
**Phase:** 6\
**Status:** **Completed --- documentation and requirements design**\
**Next phase:** Phase 7 --- SQL Analytics\
**Last updated:** 29 September 2026

------------------------------------------------------------------------

## 1. Purpose

Phase 6 defines the business questions, KPI and metric requirements,
analytical dimensions, PostgreSQL source mappings, and Power BI
reporting requirements before implementation.

The phase provides a documented bridge between the validated PostgreSQL
data platform (Phase 5) and the analytical SQL and Power BI work planned
in Phases 7--9.

## 2. Phase 6 Deliverables

The phase's primary deliverables are:

  --------------------------------------------------------------------------------
  File                                         Purpose
  -------------------------------------------- -----------------------------------
  `01_Phase_6_Analytics_Requirements.docx`     Business questions, analytical
                                               requirements, KPI definitions,
                                               assumptions, and limitations

  `02_Phase_6_KPI_and_Data_Mapping.xlsx`       KPI definitions, source/data
                                               mapping, and decision register

  `03_Phase_6_Power_BI_Requirements.docx`      Power BI report-page, visual,
                                               slicer, interaction, and model
                                               requirements

  `sql validation - analytics requirements/`   Phase 6 SQL validation scripts
                                               (`sql 6.1`--`sql 6.31`) supporting
                                               requirements and source review

  `notes and prompts/`                         Phase 6 roadmap and supporting
                                               working references
  --------------------------------------------------------------------------------

Keep these deliverables together in the Phase 6 folder. The SQL
validation scripts are evidence and supporting work for requirements
design; they are not the Phase 7 analytical query implementation.

## 3. Scope Completed

Phase 6 covers the following requirement areas:

1.  **Sales performance** --- sales and order activity, time trends, and
    related business questions.
2.  **Profitability** --- profit and margin measures, with explicit
    treatment of cost-data limitations.
3.  **Product performance** --- product and category sales and quantity
    analysis.
4.  **Customer and sales channel** --- customer analysis and channel
    reporting only where a channel field is verified.
5.  **Inventory performance** --- current stock, reserved and available
    stock, reorder requirements, and movement-data limitations.
6.  **KPI and metric definitions** --- consolidated business meaning,
    calculation considerations, eligibility, grain, and limitations.
7.  **Data source and table mapping** --- documented PostgreSQL source
    mapping and dependencies.
8.  **Power BI reporting requirements** --- planned report pages,
    measures, dimensions, visuals, slicers, and model needs.

## 4. Key Decisions and Implementation Gates

The following decisions and qualifications must remain visible in
subsequent phases.

  -----------------------------------------------------------------------------------------
  Area                                Documented decision or status
  ----------------------------------- -----------------------------------------------------
  Sales eligibility                   Completed orders are the selected scope for Total
                                      Sales, Total Orders, and AOV.

  Sales date basis                    `order_date` is the selected date basis for sales
                                      analysis.

  Total Sales                         The completed-order scope is selected. The actual
                                      monetary source field and calculation grain (order
                                      total versus sum of line totals) must still be
                                      verified against PostgreSQL before implementation.

  AOV                                 Use the approved sales amount divided by the matching
                                      distinct eligible orders; validate the source amount
                                      and grain before implementation.

  Returns                             Only completed returns qualify for realized Return
                                      Amount, Return Quantity, and Return Rate. Approved
                                      and pending returns remain separate. Refunds are not
                                      netted from sales until a rule is defined and
                                      supported.

  Completion Rate                     The eligible-order denominator remains undefined. Do
                                      not implement this KPI until the denominator and
                                      status rules are agreed.

  Estimated Gross Profit              Uses current product cost and must be labelled as
                                      estimated; it is not historical or audited
                                      profitability.

  Sales channel                       Not verified. Do not infer a channel from IDs,
                                      source-system names, or other indirect values.

  Inventory reorder rule              `available_stock = current_stock - reserved_stock`;
                                      compare available stock with the reorder level.

  Inventory movement                  26 records were prepared, but 0 were loaded to
                                      PostgreSQL because INM026 references missing
                                      inventory record IN020. Do not interpret the empty
                                      target as zero movement, invent a mapping, delete the
                                      source record, or bypass the foreign key.
  -----------------------------------------------------------------------------------------

### Remaining KPI implementation validations

Two KPI-related gates remain for Phase 7:

1.  **Total Sales:** verify the actual monetary field and calculation
    grain in PostgreSQL to avoid double counting.
2.  **Completion Rate:** define the eligible-order denominator and
    applicable status rules before implementation.

These are implementation gates, not reasons to reopen the completed
Phase 6 documentation unless new evidence requires a documented
correction.

## 5. Power BI Requirements

The documented reporting plan provides for 2--3 dashboard pages:

-   **Executive Overview**
-   **Sales & Profitability**
-   **Product / Inventory Analysis**

The Power BI requirements document records the intended reporting
structure and model needs. Power BI connection, model construction, DAX
implementation, dashboard development, and acceptance testing belong to
later phases; completion of Phase 6 does not mean those items have been
implemented or tested.

## 6. Known Data Limitations

-   Sales monetary field and calculation grain require
    implementation-time verification.
-   Completion Rate denominator is not yet defined.
-   Sales channel is unverified and must not be inferred.
-   Estimated Gross Profit is based on current product cost, not
    historical cost.
-   Refunds are not netted from sales without an agreed, supported rule.
-   Inventory Movement has a documented foreign-key dependency
    exception: 26 prepared records and 0 loaded records because
    inventory record IN020 is missing.

These limitations should be carried into SQL analytics, the Power BI
model, dashboard labels/tooltips where applicable, and final portfolio
documentation.

## 7. Phase 6 Completion Status

Phase 6 requirements and reporting-design documentation are complete.
The three primary deliverables have been updated, and documentation
consistency review is closed. This is a **documentation completion
status**, not a claim that analytical SQL, Power BI, or final acceptance
testing has been completed.

## 8. Handover to Phase 7

Proceed to **Phase 7 --- SQL Analytics**. Work one query/script at a
time:

1.  Adapt each Phase 7 SQL script from the relevant approved Phase 6 SQL
    reference and follow the project's established file and naming
    conventions.
2.  Provide one query at a time.
3.  Wait for execution output from PostgreSQL.
4.  Validate the actual output before proceeding to the next query.
5.  Do not assume table structures, results, mappings, or successful
    execution.

Begin with the Total Sales source validation. Confirm the source
monetary field and calculation grain before implementing the KPI. Keep
the Completion Rate denominator unresolved until its definition is
agreed.

## 9. Subsequent Project Phases

  Phase   Focus                                          Status
  ------- ---------------------------------------------- -------------
  7       SQL Analytics                                  Next
  8       Power BI setup and data model                  Not started
  9       Dashboard development                          Not started
  10      Final validation and portfolio documentation   Not started

------------------------------------------------------------------------

**Project:** LJ Dev Commerce\
**Folder:** `sql/Phase 6_analytics requirements & reporting design/`\
**README purpose:** Phase-level scope, deliverables, decisions,
limitations, completion status, and handover.
