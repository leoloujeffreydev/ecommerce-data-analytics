"""
Regression tests for profiler.data_profiler_v1

Run from the LJ_Dev_Commerce project root with:

    python -m pytest profiler/tests/test_profiler_v1.py -v

These tests intentionally focus on behavior already validated manually.
They are regression tests: if a future profiler change breaks one of
these behaviors, pytest should identify it immediately.
"""

import pandas as pd
import pytest

from profiler import data_profiler_v1 as profiler


# =========================================================
# HELPERS
# =========================================================

def profile(df):
    return profiler.profile_dataset(df)


# =========================================================
# 1. FIELD-TYPE / SEMANTIC DETECTION
# =========================================================

@pytest.mark.parametrize(
    "column_name, values, expected_type",
    [
        (
            "UnknownColumn",
            ["2026-07-01", "2026-07-02", "2026-07-03", "2026-07-04"],
            "date",
        ),
        (
            "CustomerID",
            ["10001", "10002", "10003", "10004", "10005"],
            "identifier",
        ),
        (
            "OrderID",
            ["500001", "500002", "500003", "500004", "500005"],
            "identifier",
        ),
        (
            "Quantity",
            ["10", "25", "5", "12", "8"],
            "numeric",
        ),
        (
            "Amount",
            ["ABC", "DEF", "GHI", "JKL"],
            "text",
        ),
        (
            "Code",
            ["1001", "1002", "1003", "1004"],
            "identifier",
        ),
    ],
)
def test_semantic_detection(column_name, values, expected_type):
    df = pd.DataFrame({column_name: values})

    result = profile(df)

    assert result["field_types"][column_name] == expected_type


def test_supplier_semantic_types():
    # Use a realistic 9-row supplier dataset so that the categorical
    # unique-ratio rule is exercised correctly.
    df = pd.DataFrame({
        "SupplierCode": [
            "SUP001", "SUP002", "SUP003",
            "SUP004", "SUP005", "SUP006",
            "SUP007", "SUP008", "SUP009"
        ],
        "SupplierName": [
            "Alpha", "Beta", "Gamma",
            "Delta", "Epsilon", "Zeta",
            "Eta", "Theta", "Iota"
        ],
        "ContactPerson": [
            "John", "Mary", "Peter",
            "Sarah", "David", "Anna",
            "Mark", "Lisa", "James"
        ],
        "EmailAddress": [
            "john@example.com",
            "mary@example.com",
            "peter@example.com",
            "sarah@example.com",
            "david@example.com",
            "anna@example.com",
            "mark@example.com",
            "lisa@example.com",
            "james@example.com"
        ],
        "PhoneNumber": [
            "0501234567",
            "0502345678",
            "0503456789",
            "0504567890",
            "0505678901",
            "0506789012",
            "0507890123",
            "0508901234",
            "0509012345"
        ],
        "StreetAddress": [
            "Street 1", "Street 2", "Street 3",
            "Street 4", "Street 5", "Street 6",
            "Street 7", "Street 8", "Street 9"
        ],
        "City": [
            "Dubai", "Dubai", "Dubai",
            "Dubai", "Dubai", "Dubai",
            "Dubai", "Dubai", "Dubai"
        ],
        "Country": [
            "UAE", "UAE", "UAE",
            "UAE", "UAE", "UAE",
            "UAE", "UAE", "UAE"
        ],
        "ActiveFlag": [
            True, False, True,
            True, True, True,
            True, True, True
        ],
        "CreatedOn": [
            "2026-07-01", "2026-07-02", "2026-07-03",
            "2026-07-04", "2026-07-05", "2026-07-06",
            "2026-07-07", "2026-07-08", "2026-07-09"
        ],
        "CreatedByUser": [
            "admin", "admin", "admin",
            "admin", "admin", "admin",
            "admin", "admin", "admin"
        ],
        "ModifiedOn": [
            "2026-07-10", "2026-07-11", "2026-07-12",
            "2026-07-13", "2026-07-14", "2026-07-15",
            "2026-07-16", "2026-07-17", "2026-07-18"
        ],
        "ModifiedByUser": [
            "admin", "admin", "admin",
            "admin", "admin", "admin",
            "admin", "admin", "admin"
        ],
    })

    result = profile(df)
    types = result["field_types"]

    assert types["SupplierCode"] == "identifier"
    assert types["SupplierName"] == "text"
    assert types["EmailAddress"] == "email"
    assert types["PhoneNumber"] == "phone"
    assert types["Country"] == "categorical"
    assert types["ActiveFlag"] == "boolean"
    assert types["CreatedOn"] == "date"
    assert types["ModifiedOn"] == "date"


# =========================================================
# 2. NUMERIC PROFILING
# =========================================================

def test_negative_numbers():
    df = pd.DataFrame({
        "NegativeNumber": [
            "-1250.50",
            "-2300.00",
            "-875.75",
            "-4100.25",
        ]
    })

    result = profile(df)

    assert result["field_types"]["NegativeNumber"] == "numeric"

    numeric = result["numeric"]["NegativeNumber"]

    assert numeric["ValidNumericCount"] == 4
    assert numeric["InvalidNumericCount"] == 0
    assert numeric["NegativeCount"] == 4
    assert numeric["PositiveCount"] == 0
    assert numeric["Minimum"] == pytest.approx(-4100.25)
    assert numeric["Maximum"] == pytest.approx(-875.75)


def test_numeric_representations():
    df = pd.DataFrame({
        "PlainNumber": [
            "1250.50", "2300.00", "875.75", "4100.25"
        ],
        "ThousandsComma": [
            "1,250.50", "2,300.00", "875.75", "4,100.25"
        ],
        "CurrencyAED": [
            "AED 1,250.50",
            "AED 2,300.00",
            "AED 875.75",
            "AED 4,100.25",
        ],
        "CurrencySymbol": [
            "$1,250.50",
            "$2,300.00",
            "$875.75",
            "$4,100.25",
        ],
        "Accounting": [
            "(1,250.50)",
            "2,300.00",
            "(875.75)",
            "4,100.25",
        ],
        "Percentage": [
            "15%", "12.5%", "7%", "100%"
        ],
        "IdentifierLike": [
            "001234", "001235", "001236", "001237"
        ],
    })

    result = profile(df)
    types = result["field_types"]
    numeric = result["numeric"]

    assert types["PlainNumber"] == "numeric"
    assert types["ThousandsComma"] == "numeric"
    assert types["CurrencyAED"] == "numeric"
    assert types["CurrencySymbol"] == "numeric"
    assert types["Accounting"] == "numeric"
    assert types["Percentage"] == "numeric"
    assert types["IdentifierLike"] == "identifier"

    assert numeric["CurrencyAED"]["CurrencyIndicators"] == ["AED"]
    assert numeric["CurrencySymbol"]["CurrencyIndicators"] == ["$"]

    assert numeric["Percentage"]["PercentageCount"] == 4

    accounting = numeric["Accounting"]

    assert accounting["AccountingCount"] == 2
    assert accounting["NegativeCount"] == 2
    assert accounting["PositiveCount"] == 2
    assert accounting["Minimum"] == pytest.approx(-1250.50)


def test_mixed_numeric_values():
    df = pd.DataFrame({
        "MixedAmount": [
            "1,250.50",
            "AED 2,300.00",
            "N/A",
            "4,100.25",
            "(875.75)",
        ]
    })

    result = profile(df)

    assert result["field_types"]["MixedAmount"] == "numeric"

    numeric = result["numeric"]["MixedAmount"]

    assert numeric["ValidNumericCount"] == 4
    assert numeric["InvalidNumericCount"] == 1
    assert numeric["Minimum"] == pytest.approx(-875.75)
    assert numeric["Maximum"] == pytest.approx(4100.25)
    assert numeric["NegativeCount"] == 1
    assert numeric["PositiveCount"] == 3
    assert numeric["CurrencyIndicators"] == ["AED"]
    assert numeric["AccountingCount"] == 1


def test_numeric_column_with_invalid_text():
    df = pd.DataFrame({
        "Revenue": [
            "1250.50",
            "2300.00",
            "875.75",
            "INVALID",
            "4100.25",
            "-500.00",
            "0",
        ]
    })

    result = profile(df)

    assert result["field_types"]["Revenue"] == "numeric"

    numeric = result["numeric"]["Revenue"]

    assert numeric["ValidNumericCount"] == 6
    assert numeric["InvalidNumericCount"] == 1
    assert numeric["ZeroCount"] == 1
    assert numeric["NegativeCount"] == 1
    assert numeric["PositiveCount"] == 4


# =========================================================
# 2.5 OUTLIER DETECTION
# =========================================================

def test_numeric_outlier_detection():
    df = pd.DataFrame({
        "Revenue": [
            100,
            110,
            105,
            98,
            102,
            101,
            99,
            5000,
        ]
    })

    result = profile(df)

    numeric = result["numeric"]["Revenue"]

    assert result["field_types"]["Revenue"] == "numeric"
    assert numeric["ValidNumericCount"] == 8
    assert numeric["InvalidNumericCount"] == 0
    assert numeric["OutlierCandidateCount"] == 1
    assert numeric["Minimum"] == pytest.approx(98.0)
    assert numeric["Maximum"] == pytest.approx(5000.0)
    assert numeric["LowerOutlierBoundary"] == pytest.approx(90.0)
    assert numeric["UpperOutlierBoundary"] == pytest.approx(116.0)


# =========================================================
# 3. DATE PROFILING
# =========================================================

def test_unknown_column_date_detection():
    df = pd.DataFrame({
        "Field_17": [
            "2026-07-01",
            "2026-07-02",
            "2026-07-03",
            "2026-07-04",
        ]
    })

    result = profile(df)

    assert result["field_types"]["Field_17"] == "date"


def test_date_profile_for_supplier_dates():
    df = pd.DataFrame({
        "CreatedOn": [
            "2026-07-01",
            "2026-07-02",
            "2026-07-03",
        ],
        "ModifiedOn": [
            "2026-07-04",
            "2026-07-05",
            "2026-07-06",
        ],
    })

    result = profile(df)

    dates = result["date"]

    assert dates["CreatedOn"]["ValidDateCount"] == 3
    assert dates["CreatedOn"]["InvalidDateCount"] == 0

    assert dates["ModifiedOn"]["ValidDateCount"] == 3
    assert dates["ModifiedOn"]["InvalidDateCount"] == 0


# =========================================================
# 4. EMAIL / PHONE / IDENTIFIER PROFILING
# =========================================================

def test_email_and_phone_detection():
    df = pd.DataFrame({
        "EmailAddress": [
            "a@example.com",
            "b@example.com",
            "c@example.com",
            "d@example.com",
        ],
        "PhoneNumber": [
            "0501234567",
            "0502345678",
            "0503456789",
            "0504567890",
        ],
    })

    result = profile(df)

    assert result["field_types"]["EmailAddress"] == "email"
    assert result["field_types"]["PhoneNumber"] == "phone"


# =========================================================
# 5. CONFIGURATION / REGRESSION SAFETY
# =========================================================

def test_required_numeric_configuration_exists():
    assert "numeric_detection_threshold" in profiler.DEFAULT_CONFIG
    assert profiler.DEFAULT_CONFIG["numeric_detection_threshold"] == pytest.approx(0.80)


# =========================================================
# 5.5 POTENTIAL MISSING-VALUE MARKERS
# =========================================================

def test_potential_missing_value_markers():
    df = pd.DataFrame({
        "TestValues": [
            None,
            float("nan"),
            "",
            "   ",
            "N/A",
            "NA",
            "NULL",
            "null",
            "Unknown",
            "Valid Value",
        ]
    })

    result = profile(df)

    text_profile = result["text"]["TestValues"]
    issues = result["issues"]

    assert text_profile["PotentialMissingMarkerCount"] == 5

    assert text_profile["PotentialMissingMarkers"] == [
        "n/a",
        "na",
        "null",
        "unknown",
    ]

    marker_issues = issues[
        issues["IssueType"] == "PotentialMissingMarker"
    ]

    assert len(marker_issues) == 1
    assert marker_issues.iloc[0]["Column"] == "TestValues"
    assert marker_issues.iloc[0]["Severity"] == "Low"
    assert int(marker_issues.iloc[0]["Count"]) == 5


# =========================================================
# 6. DATA-QUALITY ISSUES
# =========================================================

def test_duplicate_and_whitespace_issues():
    df = pd.DataFrame({
        "SupplierCode": [
            "SUP001",
            "SUP002",
            "SUP002",
        ],
        "SupplierName": [
            "Alpha",
            "Beta",
            "Gamma ",
        ],
        "EmailAddress": [
            "a@example.com",
            "b@example.com",
            "b@example.com",
        ],
    })

    result = profile(df)

    issues = result["issues"]

    issue_types = {
        (
            row["Column"],
            row["IssueType"],
        )
        for _, row in issues.iterrows()
    }

    assert ("SupplierCode", "DuplicateIdentifier") in issue_types
    assert ("EmailAddress", "DuplicateEmail") in issue_types
    assert ("SupplierName", "Whitespace") in issue_types


def test_exact_duplicate_rows():
    df = pd.DataFrame({
        "ID": ["A", "B", "B"],
        "Value": [10, 20, 20],
    })

    result = profile(df)

    issues = result["issues"]

    exact_duplicate_rows = issues[
        issues["IssueType"] == "ExactDuplicateRows"
    ]

    assert len(exact_duplicate_rows) == 1
    assert int(exact_duplicate_rows.iloc[0]["Count"]) == 1
