## Video Metadata API ##

require 'streamio-ffmpeg'
require "json"
require 'net/http'
require 'uri'
require 'pry'

module Metadata
  class Streams

    attr_accessor :resource_location, :ffmpeg_object, :extracted_metadata, :video_streams, :audio_streams, :caption_streams

    def initialize(resource)
      # creating a new directory for the JSON to be saved (if it doesnt already exist)
      FileUtils.mkdir_p "JSON_META_STORE"
      # setting the resource location
      @resource_location = resource
      # Creating new FFMPEG instance
      @ffmpeg_object = FFMPEG::Movie.new(resource)

      # setting up empty arrays for streams
      @video_streams = []
      @audio_streams = []
      @caption_streams = []
    end


    def extract_metadata
      # iterating over the metadata for each of the streams and running a case statemnt on the codec type
      ffmpeg_object.metadata[:streams].each do |stream| 
      # running a case statement so different data can be pulled out depending on the codec type  
        case stream[:codec_type]
        when "video" 
          video = {
            stream_id: stream[:index],
            bitrate: stream[:bit_rate],
            fps: stream[:r_frame_rate],
            resolution: ("#{stream[:width]}x#{stream[:height]}")
          }
          @video_streams << video
        when "audio"
          audio = {
            stream_id: stream[:index],
            language: stream[:tags][:language],
            sample_rate: stream[:sample_rate],
            format: stream[:codec_name]
          }
          @audio_streams << audio
        when "data"
          caption = {
            stream_id: stream[:index],
            language: stream[:tags][:language]
          }
          @caption_streams << caption
        end
      end
    end


    # buidling the datastucture to be converted into JSON

    def build_metadata
    # running the extract data method
      extract_metadata
      binding.pry

    # using URI to parse URL first, this should allow filename discovery in atypical URLs
      @extracted_metadata = {
        name: File.basename(URI.parse(@resource_location).path),  
        duration: ffmpeg_object.duration,
        video_streams: @video_streams,
        audio_streams: @audio_streams,
        caption_streams: @caption_streams
      }
    end

    # convert to JSON, prettify it, save to JSON META directory
    def save_json(filename)
      File.write("JSON_META_STORE/"+filename, JSON.pretty_generate(@extracted_metadata))
    end

  end
end