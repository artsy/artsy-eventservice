
# frozen_string_literal: true
module Artsy
  module EventService
    CONFIG = OpenStruct.new(initial_config)

    ## Configure the Artsy-EventService in an initializer. Ex:
    # initializers/artsy_eventservice.rb
    #
    # Artsy::EventService.configure do |es|
    #   es.config.cool = true
    #   es.post_event topic: 'artsy-eventservice', event: {'configured' => true}
    # end
    def self.configure
      yield(self) if block_given?
    end

    # Get configuration object
    def self.config
      CONFIG
    end

    def self.post_event(topic:, event:)
      return unless event_stream_enabled?
      Publisher.publish(topic: topic, event: event)
    end

    def self.consume(**args)
      raise 'Not implemented- try Sneakers'
    end


    def self.event_stream_enabled?
      config.event_stream_enabled
    end
  end
end
