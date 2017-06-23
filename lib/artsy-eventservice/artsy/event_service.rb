
# frozen_string_literal: true
module Artsy
  module EventService
    def self.post_event(topic:, event:)
      return unless event_stream_enabled?
      Publisher.publish(topic: topic, event: event)
    end

    def self.consume(**args)
      raise 'Not implemented- try Sneakers'
    end

    def self.event_stream_enabled?
      Artsy::EventService.config.event_stream_enabled
    end
  end
end
