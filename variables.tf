variable "name" {
  description = "Name of the Lambda@Edge Function"
}

variable "description" {
  description = "Description of what the Lambda@Edge Function does"
}

variable "s3_artifact_bucket" {
  description = "Name of the S3 bucket to upload versioned artifacts to"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources that support them"
  default     = {}
}

variable "lambda_code_source_dir" {
  description = "An absolute path to the directory containing the code to upload to lambda"
}

variable "file_globs" {
  type        = list(string)
  default     = ["index.js", "node_modules/**", "yarn.lock", "package.json"]
  description = "list of files or globs that you want included from the lambda_code_source_dir"
}

variable "local_file_dir" {
  description = "A path to the directory to store plan time generated local files"
  default     = "."
}

variable "runtime" {
  description = "The runtime of the lambda function"
  default     = "nodejs14.x"
}

variable "handler" {
  description = "The path to the main method that should handle the incoming requests"
  default     = "index.handler"
}

variable "config_file_name" {
  description = "The name of the file var.plaintext_params will be written to as json"
  default     = "config.json"
}

variable "plaintext_params" {
  type        = map(string)
  default     = {}
  description = <<EOF
  Lambda@Edge does not support env vars, so it is a common pattern to exchange Env vars for values read from a config file.

  So instead of using env vars like:
  `const someEnvValue = process.env.SOME_ENV`

  you would have lookups from a config file:
  ```
  const config = JSON.parse(readFileSync('./config.json'))
  const someConfigValue = config.SomeKey
  ```

  Compared to var.ssm_params, you should use this variable when you have non-secret things that you want very quick access
  to during the execution of your lambda function.
  EOF
}

variable "ssm_params" {
  type        = map(string)
  default     = {}
  description = <<EOF
  Lambda@Edge does not support env vars, so it is a common pattern to exchange Env vars for SSM params.

  So instead of using env vars like:
  `const someEnvValue = process.env.SOME_ENV`

  you would have lookups in SSM, like:
  `const someEnvValue = await ssmClient.getParameter({ Name: 'SOME_SSM_PARAM_NAME', WithDecryption: true })`

  These params should have names that are unique within an AWS account, so it is a good idea to use a common
  prefix in front of the param names, such as:

  ```
  params = {
    COMMON_PREFIX_REGION = "eu-west-1"
    COMMON_PREFIX_NAME   = "Joeseph Schreibvogel"
  }
  ```

  Compared to var.plaintext_params, you should use this variable when you have secret data that you don't want written in plaintext in a file
  in your lambda .zip file. These params will need to be fetched via a Promise at runtime, so there may be small performance delays.
  EOF
}

variable "cloudwatch_log_groups_kms_arn" {
  type        = string
  description = "KMS ARN to encrypt the log group in cloudwatch"
  default     = null
}

