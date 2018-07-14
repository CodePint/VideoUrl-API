require_relative 'video_api_main'
include Metadata

file = Metadata::Streams.new("https://s3.eu-west-2.amazonaws.com/video-api-test/sample_1.mp4")
file.build_metadata
file.save_json("stream_001.json")

file = Metadata::Streams.new("https://s3.eu-west-2.amazonaws.com/video-api-test/sample_2.mp4")
file.build_metadata
file.save_json("stream_002.json")
