
# frozen_string_literal: true
module Artsy
  module EventService

    # Post data without an event, data must be a string.
    def self.post_data(topic:, data:, routing_key: nil)
      return unless event_stream_enabled?
      Publisher.publish_data(topic: topic, data: data, routing_key: routing_key)
    end

    def self.post_event(topic:, event:, routing_key: nil)
      return unless event_stream_enabled?
      Publisher.publish_event(topic: topic, event: event, routing_key: routing_key || event.routing_key)
    end

    def self.consume(**args)
      raise 'Not implemented- try Sneakers'
    end

    def self.event_stream_enabled?
      Artsy::EventService.config.event_stream_enabled
    end
  end
end
