export TYPESENSE_API_KEY=xyz

docker run -p 8108:8108 -v $(pwd)/typesense-local:/data typesense/typesense:0.22.2 --data-dir /data --api-key=$TYPESENSE_API_KEY --enable-cors
