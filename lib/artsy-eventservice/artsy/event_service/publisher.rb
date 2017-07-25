# frozen_string_literal: true
module Artsy
  module EventService
    class Publisher
      include RabbitMQConnection

      def self.publish(topic:, event:, routing_key: nil)
        new.post_event(topic: topic, event: event, routing_key: routing_key)
      end

      def post_event(topic:, event:, routing_key: nil)
        raise 'Event missing topic or verb.' if event.verb.to_s.empty? || topic.to_s.empty?
        connect_to_rabbit do |conn|
          channel = conn.create_channel
          exchange = channel.topic(topic, durable: true)
          exchange.publish(
            event.json,
            routing_key: routing_key || event.verb,
            persistent: true,
            content_type: 'application/json',
            app_id: config.app_name
          )
        end
      end

      def self.config
        Artsy::EventService.config
      end
    end
  end
end
