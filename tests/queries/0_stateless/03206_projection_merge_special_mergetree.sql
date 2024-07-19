DROP TABLE IF EXISTS tp;

CREATE TABLE tp (
    type Int32,
    eventcnt UInt64,
    PROJECTION p (select sum(eventcnt), type group by type)
) engine = ReplacingMergeTree order by type;  -- { serverError SUPPORT_IS_DISABLED }

CREATE TABLE tp (
    type Int32,
    eventcnt UInt64,
    PROJECTION p (select sum(eventcnt), type group by type)
) engine = ReplacingMergeTree order by type
SETTINGS deduplicate_merge_projection_mode = 'throw';  -- { serverError SUPPORT_IS_DISABLED }

CREATE TABLE tp (
    type Int32,
    eventcnt UInt64,
    PROJECTION p (select sum(eventcnt), type group by type)
) engine = ReplacingMergeTree order by type
SETTINGS deduplicate_merge_projection_mode = 'drop';

DROP TABLE tp;

CREATE TABLE tp (
    type Int32,
    eventcnt UInt64,
    PROJECTION p (select sum(eventcnt), type group by type)
) engine = ReplacingMergeTree order by type
SETTINGS deduplicate_merge_projection_mode = 'rebuild';

DROP TABLE tp;


-- don't allow OPTIMIZE DEDUPLICATE for all engines with projections
CREATE TABLE test (
    a INT PRIMARY KEY,
    PROJECTION p (SELECT * ORDER BY a)
) engine = MergeTree;

OPTIMIZE TABLE test DEDUPLICATE;  -- { serverError NOT_IMPLEMENTED }
