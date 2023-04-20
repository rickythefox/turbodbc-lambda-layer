# Turbodbc AWS lambda layer for Python 3.10 runtime
This is a builder for an AWS lambda layer with [Turbodbc](https://turbodbc.readthedocs.io/en/latest/) and [unixODBC](https://www.unixodbc.org/).

## Installation
You can use the ready-built layer from the releases section of this repository or build your own using the provided builder.

### Use the pre-built layer
1. Download the zip file from Releases.
2. Run the following command to install the layer: 
```bash
  aws lambda publish-layer-version \
      --layer-name "turbodbc310" \
      --compatible-runtimes python3.10 \
      --zip-file fileb://out/turbodbc-layer.zip
```

### Build the layer yourself
1. Ensure you have Docker installed and running
2. Run the `build.sh` script from the repo root.
