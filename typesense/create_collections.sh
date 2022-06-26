export TYPESENSE_API_KEY=xyz

curl -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -X DELETE \
    "https://fjv6dx17iac5tz2lp-1.a1.typesense.net:443/collections/events"

curl "https://fjv6dx17iac5tz2lp-1.a1.typesense.net:443/collections" \
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