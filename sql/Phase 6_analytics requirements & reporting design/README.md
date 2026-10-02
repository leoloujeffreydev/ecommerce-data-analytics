# Phase 6 --- Analytics Requirements & Reporting Design

**Project:** LJ Dev Commerce --- E-commerce Data Analytics\
**Phase:** 6\
**Status:** **Completed --- documentation and requirements design**\
**Next phase:** Phase 8 --- Power BI Setup and Data Model\
**Last updated:** 2 October 2026

------------------------------------------------------------------------

## 1. Purpose

Phase 6 defines the business questions, KPI and metric requirements,
analytical dimensions, PostgreSQL source mappings, and Power BI
reporting requirements before implementation.

The phase provided a documented bridge between the validated PostgreSQL
data platform (Phase 5), the completed SQL analytics work (Phase 7), and
the Power BI implementation planned in Phases 8--10.

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

The following decisions and qualifications remain relevant to subsequent
phases. Phase 7 SQL Analytics has verified the sales source and calculations
where noted below; unresolved business definitions and data limitations
remain implementation constraints.

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

### Phase 7 SQL validation outcomes

Phase 7 validated the following KPI values against PostgreSQL:

| Measure | Validated result |
|---|---:|
| Completed orders | 15 |
| Total completed sales | AED 26,870.00 |
| Average Order Value | AED 1,791.33 |
| Sales lines | 19 |
| Units sold | 21 |
| Products represented in sales | 14 |
| Customers with completed purchases | 11 |
| Inventory records reconciled | 19 |
| Inventory records at or below reorder level | 3 |
| Estimated product cost | AED 21,510.00 |
| Estimated gross profit | AED 5,360.00 |
| Estimated profit margin | 19.95% |

The previous estimated gross profit benchmark of AED 7,603 differs from
the validated AED 5,360 result by AED 2,243. The original benchmark
calculation was not available for reconciliation. The variance remains
unresolved; no adjustment was made to force a match.

The Completion Rate denominator remains undefined and must not be
implemented until its eligible-order denominator and status rules are
approved.

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

-   Sales monetary field and calculation grain were validated in Phase 7;
    preserve the distinction between order-header and line-level amounts.
-   Completion Rate denominator is not yet defined.
-   Sales channel is unverified and must not be inferred.
-   Estimated Gross Profit is based on current product cost, not
    historical cost. Phase 7 validated AED 5,360 estimated gross profit
    and a 19.95% estimated margin; the AED 2,243 variance from the
    earlier AED 7,603 benchmark remains unexplained.
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
consistency review is closed. Phase 7 SQL Analytics is also complete,
with its validated results and unresolved limitations recorded above.
This does not mean that Power BI implementation or final acceptance
testing has been completed.

## 8. Handover to Phase 8

Proceed to **Phase 8 --- Power BI Setup and Data Model**.

Use the validated Phase 7 SQL results as the reconciliation baseline.
Connect the required PostgreSQL sources, establish and verify the data
model, and implement the calendar structure and measures in accordance
with the approved Phase 6 requirements.

Carry forward the documented limitations:
- Completion Rate denominator remains undefined.
- Sales channel remains unverified.
- Profitability is estimated using current product costs; the AED 2,243
  variance from the earlier benchmark remains unresolved.
- Inventory movement records remain unloaded because of the documented
  foreign-key dependency exception.
- Refunds are not netted from sales without an agreed, supported rule.

Validate relationships, filter behavior, measure grain, and KPI
reconciliation before proceeding to dashboard development.

## 9. Subsequent Project Phases

  Phase   Focus                                          Status
  ------- ---------------------------------------------- -------------
  7       SQL Analytics                                  Completed
  8       Power BI setup and data model                  Next
  9       Dashboard development                          Not started
  10      Final validation and portfolio documentation   Not started

------------------------------------------------------------------------

**Project:** LJ Dev Commerce\
**Folder:** `sql/Phase 6_analytics requirements & reporting design/`\
**README purpose:** Phase-level scope, deliverables, decisions,
limitations, completion status, and handover.
