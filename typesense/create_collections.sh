export TYPESENSE_API_KEY=xyz

curl -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -X DELETE \
    "http://localhost:8108/collections/events"

curl "http://localhost:8108/collections" \
      -X POST \
      -H "Content-Type: application/json" \
      -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" -d '{
        "name": "events",
        "fields": [
          {"name": "title", "type": "string" },
          {"name": "location", "type": "geopoint" },
          {"name": "tags", "type": "string[]" },
          {"name": "date", "type": "int64" }
        ]
      }'