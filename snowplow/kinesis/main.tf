resource "aws_kinesis_stream" "good" {
  name                      = "snowplow-good-stream"
  shard_count               = var.number_of_shards_good_stream
  retention_period          = 24
  enforce_consumer_deletion = true


  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}


resource "aws_kinesis_stream" "bad" {
  name                      = "snowplow-bad-stream"
  shard_count               = var.number_of_shards_bad_stream
  retention_period          = 24
  enforce_consumer_deletion = true

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kinesis_stream" "good-enriched" {
  name                      = "snowplow-good-stream-enriched"
  shard_count               = var.number_of_shards_good_stream_enriched
  retention_period          = 24
  enforce_consumer_deletion = true

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kinesis_stream" "bad-enriched" {
  name                      = "snowplow-bad-stream-enriched"
  shard_count               = var.number_of_shards_good_bad_stream_enriched
  retention_period          = 24
  enforce_consumer_deletion = true

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kinesis_stream" "good-enriched-pii" {
  name                      = "snowplow-good-stream-enriched-pii"
  shard_count               = var.number_of_shards_good_stream_enriched_pii
  retention_period          = 24
  enforce_consumer_deletion = true

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

//resource "aws_kinesis_stream" "s3-loader-bad-enriched" {
//  name             = "snowplow-bad-stream-s3-loader-enriched"
//  shard_count      = var.number_of_shards_good_bad_stream_s3_loader_enriched
//  retention_period = 24
//
//  shard_level_metrics = [
//    "IncomingBytes",
//    "OutgoingBytes",
//  ]
//}
