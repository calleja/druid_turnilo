REPLACE INTO "membership_viz" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"local","baseDir":"/opt/shared","filter":"membership_viz.csv"}',
      '{"type":"csv","findColumnsFromHeader":true}'
    )
  ) EXTEND (
    "calendar_date"      VARCHAR,
    "active_cnts"        BIGINT,
    "temporary_inactivte" BIGINT,
    "revoked"            BIGINT,
    "general_leave"      BIGINT,
    "winbacks"           BIGINT
  )
)
SELECT
  TIME_PARSE("calendar_date", 'yyyy-MM-dd')  AS __time,
  "active_cnts",
  "temporary_inactivte",
  "revoked",
  "general_leave",
  "winbacks"
FROM "ext"
PARTITIONED BY MONTH

/*
If you skip the wizard and want to POST a spec directly to http://localhost:8888/druid/indexer/v1/task, here is the full spec

{
  "type": "index_parallel",
  "spec": {
    "ioConfig": {
      "type": "index_parallel",
      "inputSource": {
        "type": "local",
        "baseDir": "/opt/shared",
        "filter": "membership_viz.csv"
      },
      "inputFormat": {
        "type": "csv",
        "findColumnsFromHeader": true
      }
    },
    "dataSchema": {
      "dataSource": "membership_viz",
      "timestampSpec": {
        "column": "calendar_date",
        "format": "yyyy-MM-dd"
      },
      "dimensionsSpec": {
        "dimensions": []
      },
      "metricsSpec": [
        { "type": "longSum", "name": "active_cnts",        "fieldName": "active_cnts" },
        { "type": "longSum", "name": "temporary_inactivte", "fieldName": "temporary_inactivte" },
        { "type": "longSum", "name": "revoked",             "fieldName": "revoked" },
        { "type": "longSum", "name": "general_leave",       "fieldName": "general_leave" },
        { "type": "longSum", "name": "winbacks",            "fieldName": "winbacks" }
      ],
      "granularitySpec": {
        "type": "uniform",
        "segmentGranularity": "MONTH",
        "queryGranularity": "DAY",
        "rollup": true
      }
    },
    "tuningConfig": {
      "type": "index_parallel",
      "maxRowsPerSegment": 5000000,
      "maxRowsInMemory": 100000
    }
  }
}

**run the above with** 
curl -X POST -H 'Content-Type: application/json' \
  -d @membership_viz_ingestion_spec.json \
  http://localhost:8888/druid/indexer/v1/task
*/