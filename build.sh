#!/bin/bash

mkdir -p out

docker build -t turbodbc-builder .
docker run --rm -v $(pwd)/out:/out turbodbc-builder
docker rmi turbodbc-builder

read -p "Do you want to upload the layer to AWS? [y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  export AWS_PAGER=""
  aws lambda publish-layer-version \
      --layer-name "turbodbc310" \
      --compatible-runtimes python3.10 \
      --zip-file fileb://out/turbodbc-layer.zip
fi

