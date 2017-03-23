
# frozen_string_literal: true
module Artsy
  module EventService
    def self.post_event(topic:, event:)
      return unless event_stream_enabled?
      Publisher.publish(topic: topic, event: event)
    end

    # TODO: up next
    def self.consume(_name, **_opts)
      return unless event_stream_enabled?
      raise 'not implemented'
    end

    def self.config
      CONFIG
    end

    def self.event_stream_enabled?
      config.event_stream_enabled
    end
  end
end
