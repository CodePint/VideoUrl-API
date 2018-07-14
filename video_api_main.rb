## Video Metadata API ##

require 'streamio-ffmpeg'
require "json"
require 'net/http'
require 'uri'
require 'pry'


puts "Examining video and fetching results"

# creating new files for json to be written too
#File.new("sample_1.json", "w")

# setting the sample URLS to the amazon S3 bucket locations
sample_url_1 = "https://s3.eu-west-2.amazonaws.com/video-api-test/sample_1.mp4"

# Creating new FFMPEG instances with the sample urls
sample_1 = FFMPEG::Movie.new(sample_url_1)

# setting up empty arrays for streams
video_streams = []
audio_streams = []
caption_streams = []


# iterating over the metadata for each of the streams and running a case statemnt on the codec type
sample_1.metadata[:streams].each do |stream| 
# running a case statement so different data can be pulled out depending on the codec type  
  case stream[:codec_type]
  when "video" 
    video = {
      stream_id: stream[:index],
      bitrate: stream[:bit_rate],
      fps: stream[:r_frame_rate],
      resolution: ("#{stream[:width]}x#{stream[:height]}")
    }
    video_streams << video
  when "audio"
    audio = {
      stream_id: stream[:index],
      language: stream[:tags][:language],
      sample_rate: stream[:sample_rate],
      format: stream[:codec_name]
    }
    audio_streams << audio
  when "data"
    caption = {
      stream_id: stream[:index],
      language: stream[:tags][:language]
    }
    caption_streams << caption
  end
end



# using URI to parse URL first, this should allow filename discovery in atypical URLs
# buidling the datastucture to be converted into JSON
sample_1_result = {
  name: File.basename(URI.parse(sample_url_1).path),  
  duration: sample_1.duration,
  video_streams: video_streams,
  audio_streams: audio_streams,
  caption_streams: caption_streams
}


sample_1_result_json = sample_1_result.to_json
File.write
binding.pry
puts "break"

