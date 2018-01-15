
# frozen_string_literal: true
module Artsy
  module EventService

    # Post data without an event, must be serialized.
    def self.post_data(topic:, data:, routing_key:)
      RabbitMQConnection.get_channel do |channel|
        channel.confirm_select if Artsy::EventService.config.confirms_enabled
        exchange = channel.topic(topic, durable: true)
        exchange.publish(
          data,
          routing_key: routing_key,
          persistent: true,
          content_type: 'application/json',
          app_id: Artsy::EventService.config.app_name
        )
        raise 'Publishing data failed' if Artsy::EventService.config.confirms_enabled && !channel.wait_for_confirms
      end
    end

    def self.post_event(topic:, event:, routing_key: nil)
      return unless event_stream_enabled?
      Publisher.publish(topic: topic, event: event, routing_key: routing_key || event.routing_key)
    end

    def self.consume(**args)
      raise 'Not implemented- try Sneakers'
    end

    def self.event_stream_enabled?
      Artsy::EventService.config.event_stream_enabled
    end
  end
end
