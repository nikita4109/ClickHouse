#!/usr/bin/env bash
# Tags: long, no-replicated-database, no-parallel, no-fasttest, no-tsan, no-asan, no-msan, no-ubsan
# no sanitizers -- memory consumption is unpredicatable with sanitizers

CURDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=../shell_config.sh
. "$CURDIR"/../shell_config.sh

echo "[Aggregation] -- No Limits"
$CLICKHOUSE_CLIENT -q "
    SELECT uniqExact(number::String), uniqExact((number, number)) FROM numbers(10000000) GROUP BY (number % 1000)::String FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_group_by = 0, max_bytes_ratio_before_external_group_by = 0
    -- { serverError MEMORY_LIMIT_EXCEEDED }
"

echo "[Aggregation] -- Big Ratio"
$CLICKHOUSE_CLIENT -q "
    SELECT uniqExact(number::String), uniqExact((number, number)) FROM numbers(10000000) GROUP BY (number % 1000)::String FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_group_by = 0, max_bytes_ratio_before_external_group_by = 0.99999
    -- { serverError MEMORY_LIMIT_EXCEEDED }
"

echo "[Aggregation] -- Big Bytes"
$CLICKHOUSE_CLIENT -q "
    SELECT uniqExact(number::String), uniqExact((number, number)) FROM numbers(10000000) GROUP BY (number % 1000)::String FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_group_by = 499999994, max_bytes_ratio_before_external_group_by = 0
    -- { serverError MEMORY_LIMIT_EXCEEDED }
"

echo "[Aggregation] -- Bytes Limit Only"
$CLICKHOUSE_CLIENT -q "
    SELECT uniqExact(number::String), uniqExact((number, number)) FROM numbers(10000000) GROUP BY (number % 1000)::String FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_group_by = '250M', max_bytes_ratio_before_external_group_by = 0
"

echo "[Aggregation] -- Ratio Limit Only"
$CLICKHOUSE_CLIENT -q "
    SELECT uniqExact(number::String), uniqExact((number, number)) FROM numbers(10000000) GROUP BY (number % 1000)::String FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_group_by = 0, max_bytes_ratio_before_external_group_by = 0.5
"

echo "[Aggregation] -- Small Bytes Big Ratio"
$CLICKHOUSE_CLIENT -q "
    SELECT uniqExact(number::String), uniqExact((number, number)) FROM numbers(10000000) GROUP BY (number % 1000)::String FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_group_by = '250M', max_bytes_ratio_before_external_group_by = 0.99999999
"

echo "[Aggregation] -- Big Bytes Small Ratio"
$CLICKHOUSE_CLIENT -q "
    SELECT uniqExact(number::String), uniqExact((number, number)) FROM numbers(10000000) GROUP BY (number % 1000)::String FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_group_by = 499999994, max_bytes_ratio_before_external_group_by = 0.5
"

####################################################

echo "[Sort] -- No Limits"
$CLICKHOUSE_CLIENT -q "
    SELECT number FROM numbers(10000000) ORDER BY (number::String, (number+1)::String) FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_sort = 0, max_bytes_ratio_before_external_sort = 0
    -- { serverError MEMORY_LIMIT_EXCEEDED }
"

echo "[Sort] -- Big Ratio"
$CLICKHOUSE_CLIENT -q "
    SELECT number FROM numbers(10000000) ORDER BY (number::String, (number+1)::String) FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_sort = 0, max_bytes_ratio_before_external_sort = 0.99999999
    -- { serverError MEMORY_LIMIT_EXCEEDED }
"

echo "[Sort] -- Big Bytes"
$CLICKHOUSE_CLIENT -q "
    SELECT number FROM numbers(10000000) ORDER BY (number::String, (number+1)::String) FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_sort = 499999994, max_bytes_ratio_before_external_sort = 0
    -- { serverError MEMORY_LIMIT_EXCEEDED }
"

echo "[Sort] -- Bytes Limit Only"
$CLICKHOUSE_CLIENT -q "
    SELECT number FROM numbers(10000000) ORDER BY (number::String, (number+1)::String) FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_sort = '250M', max_bytes_ratio_before_external_sort = 0
"

echo "[Sort] -- Ratio Limit Only"
$CLICKHOUSE_CLIENT -q "
    SELECT number FROM numbers(10000000) ORDER BY (number::String, (number+1)::String) FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_sort = 0, max_bytes_ratio_before_external_sort = 0.5
"

echo "[Sort] -- Small Bytes Big Ratio"
$CLICKHOUSE_CLIENT -q "
    SELECT number FROM numbers(10000000) ORDER BY (number::String, (number+1)::String) FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_sort = '250M', max_bytes_ratio_before_external_sort = 0.99999999
"

echo "[Sort] -- Big Bytes Small Ratio"
$CLICKHOUSE_CLIENT -q "
    SELECT number FROM numbers(10000000) ORDER BY (number::String, (number+1)::String) FORMAT Null
    SETTINGS max_memory_usage_for_user = '500M', max_bytes_before_external_sort = 499999994, max_bytes_ratio_before_external_sort = 0.5
"
