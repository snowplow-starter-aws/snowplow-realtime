variable "snowplow_bucket_arn" {}


variable "number_of_shards_good_stream" {
  default = 1
}
variable "number_of_shards_bad_stream" {
  default = 1
}

variable "number_of_shards_good_stream_enriched" {
  default = 1
}
variable "number_of_shards_good_bad_stream_enriched" {
  default = 1
}

variable "number_of_shards_good_stream_enriched_pii" {
  default = 1
}

variable "number_of_shards_good_bad_stream_s3_loader_enriched" {
  default = 1
}