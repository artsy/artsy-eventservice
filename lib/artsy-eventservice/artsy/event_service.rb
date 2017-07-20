
# frozen_string_literal: true
module Artsy
  module EventService
    def self.post_event(topic:, event:, routing_key: nil)
      return unless event_stream_enabled?
      Publisher.publish(topic: topic, event: event, routing_key: routing_key)
    end

    def self.consume(**args)
      raise 'Not implemented- try Sneakers'
    end

    def self.event_stream_enabled?
      Artsy::EventService.config.event_stream_enabled
    end
  end
end
