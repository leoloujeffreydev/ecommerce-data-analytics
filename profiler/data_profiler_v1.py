import re
import pandas as pd
import numpy as np


# =========================================================
# CONFIGURATION
# =========================================================

DEFAULT_CONFIG = {
    "date_detection_threshold": 0.80,
    "numeric_detection_threshold": 0.80,
    "email_detection_threshold": 0.80,
    "phone_detection_threshold": 0.80,
    "categorical_unique_ratio": 0.20,
    "outlier_iqr_multiplier": 1.5,

    # Optional business rules.
    # Example:
    # "required_columns": ["CustomerID", "OrderDate"]
    # "unique_columns": ["CustomerID"]
    # "non_negative_columns": ["Quantity", "Revenue"]
    "required_columns": [],
    "unique_columns": [],
    "non_negative_columns": []
}


# =========================================================
# HELPER: MERGE CONFIGURATION
# =========================================================

def _merge_config(config=None):

    final_config = DEFAULT_CONFIG.copy()

    if config:
        final_config.update(config)

    return final_config


# =========================================================
# HELPER: SAFE STRING VALUES
# =========================================================

def _string_values(series):

    return (
        series
        .dropna()
        .astype(str)
        .str.strip()
    )


# =========================================================
# DATE PARSING HELPERS
# =========================================================

def _date_formats():
    """
    Conservative, explicit date representations used for
    semantic detection and date profiling.

    Ambiguous numeric dates such as 02/07/2026 are deliberately
    allowed to match both DMY and MDY so they can be flagged as
    ambiguous instead of being silently interpreted.
    """
    return {
        "ISO": "%Y-%m-%d",
        "ISO_DATETIME": "%Y-%m-%d %H:%M:%S",
        "ISO_DATETIME_T": "%Y-%m-%dT%H:%M:%S",
        "ISO_DATETIME_MS": "%Y-%m-%d %H:%M:%S.%f",
        "ISO_DATETIME_T_MS": "%Y-%m-%dT%H:%M:%S.%f",

        "DMY": "%d/%m/%Y",
        "MDY": "%m/%d/%Y",

        "DMY_DASH": "%d-%m-%Y",
        "MDY_DASH": "%m-%d-%Y",

        "DMY_DOT": "%d.%m.%Y",
        "MDY_DOT": "%m.%d.%Y",

        "DMY_TEXT": "%d %b %Y",
        "MDY_TEXT": "%b %d %Y",

        "DMY_TEXT_LONG": "%d %B %Y",
        "MDY_TEXT_LONG": "%B %d %Y"
    }


def _analyze_date_values(values):
    """
    Evaluate each value against explicit date representations.

    Returns:
        list of dictionaries containing:
        - Value
        - Status: Invalid / Valid / Ambiguous
        - Formats
        - ParsedDates
    """
    formats = _date_formats()
    analysis = []

    for value in values:

        candidates = []

        for format_name, date_format in formats.items():

            parsed_value = pd.to_datetime(
                value,
                format=date_format,
                errors="coerce"
            )

            if pd.notna(parsed_value):
                candidates.append(
                    (format_name, parsed_value)
                )

        distinct_dates = {
            parsed_date
            for _, parsed_date in candidates
        }

        if len(candidates) == 0:
            status = "Invalid"

        elif len(distinct_dates) > 1:
            status = "Ambiguous"

        else:
            status = "Valid"

        analysis.append({
            "Value": value,
            "Status": status,
            "Formats": [
                format_name
                for format_name, _ in candidates
            ],
            "ParsedDates": [
                parsed_date
                for _, parsed_date in candidates
            ]
        })

    return analysis


def _date_detection_metrics(values):
    """
    Return value-based date detection metrics without relying
    on the column name.
    """
    analysis = _analyze_date_values(values)

    valid_count = sum(
        item["Status"] in {"Valid", "Ambiguous"}
        for item in analysis
    )

    invalid_count = sum(
        item["Status"] == "Invalid"
        for item in analysis
    )

    ambiguous_count = sum(
        item["Status"] == "Ambiguous"
        for item in analysis
    )

    recognized_formats = sorted({
        format_name
        for item in analysis
        for format_name in item["Formats"]
    })

    return {
        "analysis": analysis,
        "valid_count": int(valid_count),
        "invalid_count": int(invalid_count),
        "ambiguous_count": int(ambiguous_count),
        "recognized_formats": recognized_formats
    }


# =========================================================
# SEMANTIC FIELD TYPE DETECTION
# =========================================================

def detect_field_types(df, config=None):

    if config is None:
        config = _merge_config(None)

    field_types = {}
    detection_details = {}

    for column in df.columns:

        series = df[column]

        # -------------------------------------------------
        # Basic values
        # -------------------------------------------------

        values = _string_values(series)

        non_empty = [
            value
            for value in values
            if str(value).strip() != ""
        ]

        name = str(column).lower().replace("_", "").replace(" ", "")

        if len(non_empty) == 0:
            field_types[column] = "text"
            detection_details[column] = {
                "DetectedType": "text",
                "Confidence": "Low",
                "Evidence": "No non-empty values available"
            }
            continue

        # -------------------------------------------------
        # Existing source dtype signals
        # -------------------------------------------------

        if pd.api.types.is_bool_dtype(series):
            field_types[column] = "boolean"
            detection_details[column] = {
                "DetectedType": "boolean",
                "Confidence": "High",
                "Evidence": "Native boolean dtype"
            }
            continue

        if pd.api.types.is_numeric_dtype(series):
            field_types[column] = "numeric"
            detection_details[column] = {
                "DetectedType": "numeric",
                "Confidence": "High",
                "Evidence": "Native numeric dtype"
            }
            continue

        # -------------------------------------------------
        # Strong semantic pattern detection
        # -------------------------------------------------

        # Email
        email_matches = sum(
            bool(
                re.fullmatch(
                    r"[^@\s]+@[^@\s]+\.[^@\s]+",
                    value
                )
            )
            for value in non_empty
        )

        email_rate = email_matches / len(non_empty)

        if email_rate >= config["email_detection_threshold"]:
            field_types[column] = "email"
            detection_details[column] = {
                "DetectedType": "email",
                "Confidence": "High",
                "Evidence": f"{email_rate:.0%} of values match email pattern"
            }
            continue

        # -------------------------------------------------
        # Boolean strings
        # -------------------------------------------------

        normalized_boolean_values = {
            value.strip().lower()
            for value in non_empty
        }

        boolean_tokens = {
            "true", "false",
            "yes", "no",
            "y", "n",
            "1", "0",
            "active", "inactive"
        }

        if (
            normalized_boolean_values
            and normalized_boolean_values.issubset(boolean_tokens)
            and len(normalized_boolean_values) <= 2
        ):
            field_types[column] = "boolean"
            detection_details[column] = {
                "DetectedType": "boolean",
                "Confidence": "High",
                "Evidence": "Values match recognized boolean representations"
            }
            continue

        # -------------------------------------------------
        # Date
        # -------------------------------------------------

        date_metrics = _date_detection_metrics(non_empty)

        date_rate = (
            date_metrics["valid_count"] / len(non_empty)
        )

        date_name_signal = any(
            keyword in name
            for keyword in [
                "date",
                "datetime",
                "timestamp",
                "createdon",
                "modifiedon",
                "createdat",
                "updatedat",
                "dob",
                "birth"
            ]
        )

        if (
            date_rate >= config["date_detection_threshold"]
            or (
                date_name_signal
                and date_rate > 0
            )
        ):
            confidence = (
                "High"
                if date_rate >= 0.95
                else "Medium"
            )

            field_types[column] = "date"
            detection_details[column] = {
                "DetectedType": "date",
                "Confidence": confidence,
                "Evidence": f"{date_rate:.0%} of values match recognized date representations"
            }
            continue

        # -------------------------------------------------
        # Phone
        #
        # Important:
        # Do not allow ordinary decimal/currency numbers to
        # become phones simply because they contain digits.
        # -------------------------------------------------

        phone_name_signal = any(
            keyword in name
            for keyword in [
                "phone",
                "mobile",
                "telephone",
                "tel",
                "contactnumber",
                "phonenumber"
            ]
        )

        phone_matches = 0

        for value in non_empty:

            stripped = value.strip()
            digits = re.sub(r"\D", "", stripped)

            # A phone number should contain a meaningful number of digits.
            if len(digits) < 7 or len(digits) > 15:
                continue

            # Digit-only values such as 0501234567 are valid phone
            # representations when the column name indicates a phone.
            if re.fullmatch(r"\d+", stripped):
                if not phone_name_signal:
                    continue

            # Allow common phone separators and optional leading +.
            if not re.fullmatch(
                r"\+?[\d\s().-]+",
                stripped
            ):
                continue

            # Decimal numbers are not phone numbers unless the column
            # explicitly identifies itself as a phone field.
            if re.fullmatch(
                r"[-+]?\d+[.,]\d+",
                stripped
            ) and not phone_name_signal:
                continue

            phone_matches += 1

        phone_rate = phone_matches / len(non_empty)

        if (
            phone_rate >= config["phone_detection_threshold"]
            or (
                phone_name_signal
                and phone_rate > 0
            )
        ):
            field_types[column] = "phone"
            detection_details[column] = {
                "DetectedType": "phone",
                "Confidence": (
                    "High"
                    if phone_rate >= 0.95
                    else "Medium"
                ),
                "Evidence": f"{phone_rate:.0%} of values match phone-like structure"
            }
            continue

        # -------------------------------------------------
        # Numeric representation detection
        # -------------------------------------------------

        numeric_results = []

        currency_tokens = {
            "AED", "USD", "EUR", "GBP", "SAR", "QAR",
            "KWD", "BHD", "OMR", "INR", "JPY", "CNY",
            "CAD", "AUD", "CHF", "SGD", "HKD"
        }

        currency_symbols = "$€£¥₹"

        for value in non_empty:

            cleaned = value.strip()

            is_percentage = cleaned.endswith("%")

            is_accounting = (
                cleaned.startswith("(")
                and cleaned.endswith(")")
            )

            currency_match = re.search(
                r"\b[A-Z]{3}\b|[$€£¥₹]",
                cleaned,
                flags=re.IGNORECASE
            )

            # Remove recognized currency indicators.
            numeric_candidate = re.sub(
                r"\b[A-Z]{3}\b",
                "",
                cleaned,
                flags=re.IGNORECASE
            )

            numeric_candidate = re.sub(
                r"[$€£¥₹]",
                "",
                numeric_candidate
            )

            numeric_candidate = numeric_candidate.strip()

            if is_percentage:
                numeric_candidate = numeric_candidate[:-1].strip()

            if is_accounting:
                numeric_candidate = numeric_candidate[1:-1].strip()

            # Normalize common thousands/decimal representations.
            normalized = numeric_candidate.replace(" ", "")

            if (
                "," in normalized
                and "." in normalized
            ):
                # Last separator is treated as decimal separator.
                if normalized.rfind(",") > normalized.rfind("."):
                    normalized = (
                        normalized
                        .replace(".", "")
                        .replace(",", ".")
                    )
                else:
                    normalized = normalized.replace(",", "")

            elif "," in normalized:
                parts = normalized.split(",")

                if (
                    len(parts[-1]) == 2
                    and all(part.isdigit() for part in parts)
                ):
                    normalized = (
                        "".join(parts[:-1])
                        + "."
                        + parts[-1]
                    )
                else:
                    normalized = normalized.replace(",", "")

            elif "." in normalized:
                parts = normalized.split(".")

                if (
                    len(parts) > 2
                    and all(part.isdigit() for part in parts)
                ):
                    normalized = "".join(parts)

            parsed_numeric = pd.to_numeric(
                normalized,
                errors="coerce"
            )

            numeric_results.append({
                "Value": value,
                "Parsed": pd.notna(parsed_numeric),
                "Percentage": is_percentage,
                "Accounting": is_accounting,
                "Currency": (
                    currency_match.group(0)
                    if currency_match
                    else None
                )
            })

        numeric_match_count = sum(
            item["Parsed"]
            for item in numeric_results
        )

        numeric_rate = (
            numeric_match_count / len(non_empty)
        )

        # Protect obvious identifier-like columns.
        identifier_name_signal = any(
            keyword in name
            for keyword in [
                "id",
                "code",
                "sku",
                "reference",
                "ref",
                "accountnumber",
                "customernumber",
                "ordernumber"
            ]
        )

        leading_zero_identifier = all(
            re.fullmatch(r"0\d+", value.strip())
            for value in non_empty
        )

        alphanumeric_identifier = (
            all(
                re.fullmatch(
                    r"[A-Za-z]+[A-Za-z0-9_-]*\d+[A-Za-z0-9_-]*",
                    value.strip()
                )
                for value in non_empty
            )
            and any(
                re.search(r"[A-Za-z]", value)
                for value in non_empty
            )
        )

        identifier_like = (
            identifier_name_signal
            or leading_zero_identifier
            or alphanumeric_identifier
        )

        if (
            numeric_rate >= config["numeric_detection_threshold"]
            and not identifier_like
        ):
            field_types[column] = "numeric"
            detection_details[column] = {
                "DetectedType": "numeric",
                "Confidence": (
                    "High"
                    if numeric_rate >= 0.95
                    else "Medium"
                ),
                "Evidence": f"{numeric_rate:.0%} of values match numeric representations"
            }
            continue

        # -------------------------------------------------
        # Identifier
        # -------------------------------------------------

        if identifier_name_signal:
            field_types[column] = "identifier"
            detection_details[column] = {
                "DetectedType": "identifier",
                "Confidence": "Medium",
                "Evidence": "Column name suggests identifier semantics"
            }
            continue

        # -------------------------------------------------
        # Categorical / text fallback
        # -------------------------------------------------

        unique_ratio = (
            series.nunique(dropna=True) / len(series)
            if len(series) > 0
            else 1
        )

        if unique_ratio <= config["categorical_unique_ratio"]:
            field_types[column] = "categorical"
            detection_details[column] = {
                "DetectedType": "categorical",
                "Confidence": "Medium",
                "Evidence": "Low unique-value ratio"
            }
        else:
            field_types[column] = "text"
            detection_details[column] = {
                "DetectedType": "text",
                "Confidence": "Low",
                "Evidence": "No stronger semantic pattern detected"
            }

    return (
        pd.Series(field_types, name="DetectedFieldType"),
        detection_details
    )


# =========================================================
# TEXT PROFILING
# =========================================================

def profile_text(df, field_types):

    results = {}

    columns = field_types[
        field_types == "text"
    ].index

    for column in columns:

        values = _string_values(df[column])

        # -------------------------------------------------
        # POTENTIAL MISSING-VALUE MARKERS
        #
        # These are flagged for review rather than converted
        # into actual missing values automatically.
        # -------------------------------------------------
        potential_missing_markers = {
            "n/a",
            "na",
            "null",
            "none",
            "unknown"
        }

        marker_mask = (
            values.str.lower().isin(
                potential_missing_markers
            )
        )

        results[column] = {
            "WhitespaceCount": int(
                (
                    df[column]
                    .dropna()
                    .astype(str)
                    !=
                    df[column]
                    .dropna()
                    .astype(str)
                    .str.strip()
                ).sum()
            ),

            "BlankCount": int(
                (
                    values == ""
                ).sum()
            ),

            "PotentialMissingMarkerCount": int(
                marker_mask.sum()
            ),

            "PotentialMissingMarkers": sorted(
                values[marker_mask]
                .str.lower()
                .unique()
                .tolist()
            ),

            "MinimumLength": (
                int(values.str.len().min())
                if len(values)
                else 0
            ),

            "MaximumLength": (
                int(values.str.len().max())
                if len(values)
                else 0
            ),

            "AverageLength": (
                round(values.str.len().mean(), 2)
                if len(values)
                else 0
            )
        }

    return results


# =========================================================
# CATEGORICAL / BOOLEAN PROFILING
# =========================================================

def profile_categorical(df, field_types):

    results = {}

    columns = field_types[
        field_types.isin([
            "categorical",
            "boolean"
        ])
    ].index

    for column in columns:

        counts = df[column].value_counts(
            dropna=False
        )

        results[column] = {
            "UniqueCount": int(
                df[column].nunique(
                    dropna=True
                )
            ),

            "MostCommonValue": (
                counts.index[0]
                if len(counts)
                else None
            ),

            "MostCommonCount": (
                int(counts.iloc[0])
                if len(counts)
                else 0
            ),

            "CategoryDistribution":
                counts.to_dict()
        }

    return results


# =========================================================
# NUMERIC VALUE PARSING
# =========================================================

def _parse_numeric_value(value):
    """
    Parse common numeric representations for profiling only.
    The source dataframe is never modified.
    """

    if pd.isna(value):
        return {
            "Valid": False,
            "Value": None,
            "Representation": "Missing",
            "Currency": None,
            "IsPercentage": False,
            "IsAccounting": False
        }

    raw = str(value).strip()

    if raw == "":
        return {
            "Valid": False,
            "Value": None,
            "Representation": "Blank",
            "Currency": None,
            "IsPercentage": False,
            "IsAccounting": False
        }

    is_percentage = raw.endswith("%")
    is_accounting = raw.startswith("(") and raw.endswith(")")

    working = raw[1:-1].strip() if is_accounting else raw

    currency = None
    currency_match = re.search(
        r"\b[A-Z]{3}\b|[$€£¥₹]",
        working,
        flags=re.IGNORECASE
    )

    if currency_match:
        currency = currency_match.group(0)

        working = re.sub(
            r"\b[A-Z]{3}\b",
            "",
            working,
            flags=re.IGNORECASE
        )

        working = re.sub(
            r"[$€£¥₹]",
            "",
            working
        )

    working = working.strip()

    if is_percentage:
        working = working[:-1].strip()

    # Accounting notation uses parentheses to represent a negative value.
    sign = -1 if is_accounting else 1

    if working.startswith("-"):
        sign = -1
        working = working[1:].strip()
    elif working.startswith("+"):
        if not is_accounting:
            sign = 1
        working = working[1:].strip()

    working = working.replace(" ", "")

    if re.search(r"[A-Za-z]", working):
        return {
            "Valid": False,
            "Value": None,
            "Representation": "Invalid",
            "Currency": currency,
            "IsPercentage": is_percentage,
            "IsAccounting": is_accounting
        }

    if "," in working and "." in working:

        if working.rfind(",") > working.rfind("."):
            normalized = (
                working
                .replace(".", "")
                .replace(",", ".")
            )
            representation = "EuropeanFormatted"
        else:
            normalized = working.replace(",", "")
            representation = "ThousandsComma"

    elif "," in working:

        parts = working.split(",")

        if (
            len(parts) == 2
            and len(parts[1]) == 2
            and all(part.isdigit() for part in parts)
        ):
            normalized = parts[0] + "." + parts[1]
            representation = "EuropeanDecimal"

        elif all(part.isdigit() for part in parts):
            normalized = "".join(parts)
            representation = "ThousandsComma"

        else:
            return {
                "Valid": False,
                "Value": None,
                "Representation": "Invalid",
                "Currency": currency,
                "IsPercentage": is_percentage,
                "IsAccounting": is_accounting
            }

    elif "." in working:

        parts = working.split(".")

        if len(parts) > 2 and all(
            part.isdigit()
            for part in parts
        ):
            normalized = "".join(parts)
            representation = "ThousandsDot"
        else:
            normalized = working
            representation = "Decimal"

    else:
        normalized = working
        representation = "Integer"

    parsed = pd.to_numeric(
        normalized,
        errors="coerce"
    )

    if pd.isna(parsed):
        return {
            "Valid": False,
            "Value": None,
            "Representation": "Invalid",
            "Currency": currency,
            "IsPercentage": is_percentage,
            "IsAccounting": is_accounting
        }

    parsed = float(parsed) * sign

    if is_percentage:
        representation = "Percentage"
    elif currency is not None:
        representation = "Currency"
    elif is_accounting:
        representation = "Accounting"

    return {
        "Valid": True,
        "Value": parsed,
        "Representation": representation,
        "Currency": currency,
        "IsPercentage": is_percentage,
        "IsAccounting": is_accounting
    }


def _numeric_series_for_profile(series):

    parsed = [
        _parse_numeric_value(value)
        for value in series
    ]

    numeric_series = pd.Series(
        [
            item["Value"]
            if item["Valid"]
            else np.nan
            for item in parsed
        ],
        index=series.index,
        dtype="float64"
    )

    return numeric_series, parsed


# =========================================================
# NUMERIC PROFILING
# =========================================================

def profile_numeric(
    df,
    field_types,
    config
):

    results = {}

    columns = field_types[
        field_types == "numeric"
    ].index

    for column in columns:

        numeric_values, parsed_results = (
            _numeric_series_for_profile(df[column])
        )

        values = numeric_values.dropna()

        invalid_count = sum(
            not item["Valid"]
            for item in parsed_results
        )

        representations = sorted({
            item["Representation"]
            for item in parsed_results
            if item["Valid"]
        })

        currencies = sorted({
            item["Currency"]
            for item in parsed_results
            if item["Valid"]
            and item["Currency"] is not None
        })

        percentage_count = sum(
            item["IsPercentage"]
            for item in parsed_results
            if item["Valid"]
        )

        accounting_count = sum(
            item["IsAccounting"]
            for item in parsed_results
            if item["Valid"]
        )

        result = {
            "ValidNumericCount": int(len(values)),
            "InvalidNumericCount": int(invalid_count),

            "Minimum": (
                values.min()
                if len(values)
                else None
            ),

            "Maximum": (
                values.max()
                if len(values)
                else None
            ),

            "Mean": (
                values.mean()
                if len(values)
                else None
            ),

            "Median": (
                values.median()
                if len(values)
                else None
            ),

            "ZeroCount": int(
                (values == 0).sum()
            ),

            "NegativeCount": int(
                (values < 0).sum()
            ),

            "PositiveCount": int(
                (values > 0).sum()
            ),

            "RecognizedRepresentations":
                representations,

            "CurrencyIndicators":
                currencies,

            "PercentageCount":
                int(percentage_count),

            "AccountingCount":
                int(accounting_count)
        }

        if len(values) >= 4:

            q1 = values.quantile(0.25)
            q3 = values.quantile(0.75)

            iqr = q3 - q1

            lower = (
                q1
                - config["outlier_iqr_multiplier"]
                * iqr
            )

            upper = (
                q3
                + config["outlier_iqr_multiplier"]
                * iqr
            )

            outlier_mask = (
                (values < lower)
                | (values > upper)
            )

            result["OutlierCandidateCount"] = int(
                outlier_mask.sum()
            )

            result["LowerOutlierBoundary"] = lower
            result["UpperOutlierBoundary"] = upper

        else:

            result["OutlierCandidateCount"] = 0
            result["LowerOutlierBoundary"] = None
            result["UpperOutlierBoundary"] = None

        results[column] = result

    return results


# =========================================================
# DATE PROFILING
# =========================================================

def profile_dates(df, field_types):

    results = {}

    columns = field_types[
        field_types == "date"
    ].index

    for column in columns:

        values = _string_values(df[column])

        date_analysis = _analyze_date_values(values)

        valid_count = sum(
            item["Status"] in {"Valid", "Ambiguous"}
            for item in date_analysis
        )

        invalid_count = sum(
            item["Status"] == "Invalid"
            for item in date_analysis
        )

        ambiguous_count = sum(
            item["Status"] == "Ambiguous"
            for item in date_analysis
        )

        recognized_formats = sorted({
            format_name
            for item in date_analysis
            for format_name in item["Formats"]
        })

        # A value that has more than one possible interpretation
        # is ambiguous, but that alone does not prove the source
        # used mixed formats.
        unambiguous_formats = {
            item["Formats"][0]
            for item in date_analysis
            if (
                item["Status"] == "Valid"
                and len(item["Formats"]) == 1
            )
        }

        ambiguous_formats = {
            format_name
            for item in date_analysis
            if item["Status"] == "Ambiguous"
            for format_name in item["Formats"]
        }

        mixed_format = (
            len(unambiguous_formats) > 1
            or (
                len(unambiguous_formats) > 0
                and bool(
                    ambiguous_formats
                    - unambiguous_formats
                )
            )
        )

        # Only unambiguous values are safe to use for
        # minimum/maximum/future-date calculations.
        unambiguous_dates = [
            item["ParsedDates"][0]
            for item in date_analysis
            if (
                item["Status"] == "Valid"
                and len(item["ParsedDates"]) == 1
            )
        ]

        if unambiguous_dates:

            minimum_date = min(
                unambiguous_dates
            )

            maximum_date = max(
                unambiguous_dates
            )

        else:

            minimum_date = None
            maximum_date = None

        today = pd.Timestamp.today().normalize()

        future_count = sum(
            parsed_date > today
            for parsed_date in unambiguous_dates
        )

        results[column] = {

            "ValidDateCount":
                int(valid_count),

            "InvalidDateCount":
                int(invalid_count),

            "AmbiguousDateCount":
                int(ambiguous_count),

            "RecognizedFormats":
                recognized_formats,

            "MixedFormat":
                bool(mixed_format),

            "MinimumDate":
                minimum_date,

            "MaximumDate":
                maximum_date,

            "FutureDateCount":
                int(future_count)
        }

    return results


# =========================================================
# EMAIL PROFILING
# =========================================================

def profile_email(df, field_types):

    results = {}

    columns = field_types[
        field_types == "email"
    ].index

    pattern = r"^[^@\s]+@[^@\s]+\.[^@\s]+$"

    for column in columns:

        values = _string_values(df[column])

        matches = values.str.match(
            pattern,
            na=False
        )

        results[column] = {
            "EmailLikeValueCount": int(
                matches.sum()
            ),

            "InvalidEmailLikeValueCount": int(
                (~matches).sum()
            ),

            "EmailPatternMatchRate":
                round(
                    matches.mean() * 100,
                    2
                ),

            "DuplicateEmailCount": int(
                values.duplicated().sum()
            )
        }

    return results


# =========================================================
# PHONE PROFILING
# =========================================================

def profile_phone(df, field_types):

    results = {}

    columns = field_types[
        field_types == "phone"
    ].index

    pattern = (
        r"^\+?[0-9\s().\-]{7,}$"
    )

    for column in columns:

        values = _string_values(df[column])

        matches = values.str.match(
            pattern,
            na=False
        )

        results[column] = {
            "PhoneLikeValueCount": int(
                matches.sum()
            ),

            "InvalidPhoneLikeValueCount":
                int((~matches).sum()),

            "PhonePatternMatchRate":
                round(
                    matches.mean() * 100,
                    2
                ),

            "DuplicatePhoneCount": int(
                values.duplicated().sum()
            )
        }

    return results


# =========================================================
# IDENTIFIER PROFILING
# =========================================================

def profile_identifiers(df, field_types):

    results = {}

    columns = field_types[
        field_types == "identifier"
    ].index

    for column in columns:

        values = _string_values(df[column])

        results[column] = {
            "UniqueCount": int(
                values.nunique()
            ),

            "DuplicateCount": int(
                values.duplicated().sum()
            ),

            "MissingCount": int(
                df[column].isna().sum()
            )
        }

    return results


# =========================================================
# GENERAL PROFILING
# =========================================================

def profile_general(df, field_types):

    profile = pd.DataFrame({
        "DataType":
            df.dtypes.astype(str),

        "DetectedFieldType":
            field_types,

        "MissingCount":
            df.isna().sum(),

        "MissingPercent":
            (
                df.isna().mean() * 100
            ).round(2),

        "UniqueCount":
            df.nunique(
                dropna=True
            ),

        "DuplicateValueCount":
            df.apply(
                lambda col:
                col.duplicated().sum()
            )
    })

    return {
        "rows": len(df),
        "columns": len(df.columns),

        "exact_duplicate_rows":
            int(df.duplicated().sum()),

        "column_profile":
            profile
    }


# =========================================================
# ISSUE ENGINE
# =========================================================

def generate_issues(
    df,
    field_types,
    general,
    text,
    dates,
    emails,
    phones,
    identifiers,
    config
):

    issues = []

    def add_issue(
        column,
        issue_type,
        severity,
        count,
        description
    ):

        issues.append({
            "Column": column,
            "IssueType": issue_type,
            "Severity": severity,
            "Count": int(count),
            "Description": description
        })

    # -------------------------------------------------
    # EXACT DUPLICATE ROWS
    # -------------------------------------------------

    duplicate_rows = general[
        "exact_duplicate_rows"
    ]

    if duplicate_rows > 0:

        add_issue(
            None,
            "ExactDuplicateRows",
            "High",
            duplicate_rows,
            "Exact duplicate rows detected."
        )

    # -------------------------------------------------
    # MISSING VALUES
    # -------------------------------------------------

    for column, row in (
        general["column_profile"].iterrows()
    ):

        if row["MissingCount"] > 0:

            severity = (
                "High"
                if field_types[column]
                == "identifier"
                else "Medium"
            )

            add_issue(
                column,
                "MissingValues",
                severity,
                row["MissingCount"],
                "Missing values detected."
            )

    # -------------------------------------------------
    # TEXT ISSUES
    # -------------------------------------------------

    for column, result in text.items():

        if result["WhitespaceCount"] > 0:

            add_issue(
                column,
                "Whitespace",
                "Low",
                result["WhitespaceCount"],
                "Leading or trailing whitespace detected."
            )

        if result["BlankCount"] > 0:

            add_issue(
                column,
                "BlankText",
                "Medium",
                result["BlankCount"],
                "Blank text values detected."
            )

        if result["PotentialMissingMarkerCount"] > 0:

            add_issue(
                column,
                "PotentialMissingMarker",
                "Low",
                result["PotentialMissingMarkerCount"],
                "Potential missing-value markers detected; review based on business context."
            )

    # -------------------------------------------------
    # DATE ISSUES
    # -------------------------------------------------

    for column, result in dates.items():

        if result["InvalidDateCount"] > 0:

            add_issue(
                column,
                "InvalidDate",
                "High",
                result["InvalidDateCount"],
                "Values could not be interpreted as dates."
            )

        if result["AmbiguousDateCount"] > 0:

            add_issue(
                column,
                "AmbiguousDate",
                "High",
                result["AmbiguousDateCount"],
                "Date interpretation may be ambiguous."
            )

        if result["MixedFormat"]:

            add_issue(
                column,
                "MixedDateFormat",
                "Medium",
                0,
                "Multiple date formats were detected."
            )

        if result["FutureDateCount"] > 0:

            add_issue(
                column,
                "FutureDate",
                "Medium",
                result["FutureDateCount"],
                "Dates later than today were detected."
            )

    # -------------------------------------------------
    # EMAIL ISSUES
    # -------------------------------------------------

    for column, result in emails.items():

        if result[
            "InvalidEmailLikeValueCount"
        ] > 0:

            add_issue(
                column,
                "InvalidEmail",
                "Medium",
                result[
                    "InvalidEmailLikeValueCount"
                ],
                "Values do not match the detected email pattern."
            )

        if result[
            "DuplicateEmailCount"
        ] > 0:

            add_issue(
                column,
                "DuplicateEmail",
                "Medium",
                result[
                    "DuplicateEmailCount"
                ],
                "Duplicate email values detected."
            )

    # -------------------------------------------------
    # PHONE ISSUES
    # -------------------------------------------------

    for column, result in phones.items():

        if result[
            "InvalidPhoneLikeValueCount"
        ] > 0:

            add_issue(
                column,
                "InvalidPhone",
                "Medium",
                result[
                    "InvalidPhoneLikeValueCount"
                ],
                "Values do not match the detected phone pattern."
            )

    # -------------------------------------------------
    # IDENTIFIER ISSUES
    # -------------------------------------------------

    for column, result in identifiers.items():

        if result["DuplicateCount"] > 0:

            add_issue(
                column,
                "DuplicateIdentifier",
                "High",
                result["DuplicateCount"],
                "Repeated identifier values detected."
            )

        if result["MissingCount"] > 0:

            add_issue(
                column,
                "MissingIdentifier",
                "High",
                result["MissingCount"],
                "Missing identifier values detected."
            )

    # -------------------------------------------------
    # NUMERIC BUSINESS RULES
    # -------------------------------------------------

    for column in config[
        "non_negative_columns"
    ]:

        if column in df.columns:

            numeric_values, _ = _numeric_series_for_profile(
                df[column]
            )

            negative_count = int(
                (numeric_values < 0).sum()
            )

            if negative_count > 0:

                add_issue(
                    column,
                    "NegativeValue",
                    "High",
                    negative_count,
                    "Negative values violate configured non-negative rule."
                )

    # -------------------------------------------------
    # UNIQUE BUSINESS RULES
    # -------------------------------------------------

    for column in config[
        "unique_columns"
    ]:

        if column in df.columns:

            duplicate_count = int(
                df[column]
                .duplicated()
                .sum()
            )

            if duplicate_count > 0:

                add_issue(
                    column,
                    "ConfiguredUniquenessViolation",
                    "High",
                    duplicate_count,
                    "Configured unique-field rule was violated."
                )

    # -------------------------------------------------
    # REQUIRED COLUMN RULES
    # -------------------------------------------------

    for column in config[
        "required_columns"
    ]:

        if column not in df.columns:

            add_issue(
                column,
                "MissingRequiredColumn",
                "High",
                1,
                "Required column is missing from the dataset."
            )

    # -------------------------------------------------
    # BUILD TABLE
    # -------------------------------------------------

    issue_df = pd.DataFrame(
        issues,
        columns=[
            "Column",
            "IssueType",
            "Severity",
            "Count",
            "Description"
        ]
    )

    if len(issue_df) > 0:

        severity_order = {
            "High": 1,
            "Medium": 2,
            "Low": 3
        }

        issue_df["_SeverityRank"] = (
            issue_df["Severity"]
            .map(severity_order)
        )

        issue_df = (
            issue_df
            .sort_values(
                [
                    "_SeverityRank",
                    "Column"
                ],
                na_position="first"
            )
            .drop(
                columns="_SeverityRank"
            )
            .reset_index(drop=True)
        )

    return issue_df


# =========================================================
# MAIN PROFILER
# =========================================================

def profile_dataset(df, config=None):

    config = _merge_config(config)

    # ---------------------------------------------
    # SEMANTIC DETECTION
    # ---------------------------------------------

    field_types, detection_details = (
        detect_field_types(
            df,
            config
        )
    )

    # ---------------------------------------------
    # PROFILE
    # ---------------------------------------------

    general = profile_general(
        df,
        field_types
    )

    text = profile_text(
        df,
        field_types
    )

    categorical = profile_categorical(
        df,
        field_types
    )

    numeric = profile_numeric(
        df,
        field_types,
        config
    )

    dates = profile_dates(
        df,
        field_types
    )

    emails = profile_email(
        df,
        field_types
    )

    phones = profile_phone(
        df,
        field_types
    )

    identifiers = profile_identifiers(
        df,
        field_types
    )

    # ---------------------------------------------
    # ISSUE REPORT
    # ---------------------------------------------

    issues = generate_issues(
        df=df,
        field_types=field_types,
        general=general,
        text=text,
        dates=dates,
        emails=emails,
        phones=phones,
        identifiers=identifiers,
        config=config
    )

    # ---------------------------------------------
    # FINAL RESULT
    # ---------------------------------------------

    results = {

        "field_types":
            field_types,

        "detection_details":
            detection_details,

        "general":
            general,

        "text":
            text,

        "categorical":
            categorical,

        "numeric":
            numeric,

        "date":
            dates,

        "patterns": {
            "email": emails,
            "phone": phones,
            "identifier": identifiers
        },

        "issues":
            issues,

        "configuration":
            config
    }

    return results