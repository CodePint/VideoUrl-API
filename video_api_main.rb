## Video Metadata API ##

require 'streamio-ffmpeg'
require "json"
require 'net/http'
require 'uri'
require 'pry'


puts "Examining video and fetching results"


# setting the sample URLS to the amazon S3 bucket locations
sample_url_1 = "https://s3.eu-west-2.amazonaws.com/video-api-test/sample_1.mp4"

# Creating new FFMPEG instances with the sample urls
sample_1 = FFMPEG::Movie.new(sample_url_1)


def extract_stream_data(sample)
  # setting up empty arrays for streams
  video_streams = []
  audio_streams = []
  caption_streams = []

  # iterating over the metadata for each of the streams and running a case statemnt on the codec type
  sample.metadata[:streams].each do |stream| 
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
  return {
    video_streams: video_streams,
    audio_streams: audio_streams,
    caption_streams: caption_streams
  }
end



# using URI to parse URL first, this should allow filename discovery in atypical URLs
# buidling the datastucture to be converted into JSON

def construct_data(stream, url)
  stream_data = extract_stream_data(stream)
  data = {
    name: File.basename(URI.parse(url).path),  
    duration: stream.duration,
    video_streams: stream_data[:video_streams],
    audio_streams: stream_data[:audio_streams],
    caption_streams: stream_data[:caption_streams]
  }
  return data
end

extracted_data = construct_data(sample_1, sample_url_1)
File.write("sample_1.json", extracted_data.to_json)
binding.pry
puts "break"

