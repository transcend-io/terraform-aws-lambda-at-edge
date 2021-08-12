# Lambda@Edge Module

A terraform module for creating Lambda@Edge functions.

This module supports any type of Lambda Function supported by Edge, including NodeJs and Python functions.

You just point it at a set of local file globs and it handles bundling your code and deploying it.

## Requirements

You must use a versioned S3 bucket for your deployment artifacts
