# frozen_string_literal: true
module Artsy
  module EventService
    class Publisher
      def self.publish_event(topic:, event:, routing_key: nil, headers: {})
        new.post_event(topic: topic, event: event, routing_key: routing_key, headers: headers)
      end

      def self.publish_data(topic:, data:, routing_key: nil, headers: {})
        new.post_data(topic: topic, data: data, routing_key: routing_key, headers: headers)
      end

      def post_data(topic:, data:, routing_key: nil, headers: {})
        RabbitMQConnection.get_channel do |channel|
          channel.confirm_select if config.confirms_enabled
          exchange = channel.topic(topic, durable: true)
          exchange.publish(
            data,
            routing_key: routing_key,
            persistent: true,
            content_type: 'application/json',
            headers: headers,
            app_id: config.app_name
          )
          raise 'Publishing data failed' if config.confirms_enabled && !channel.wait_for_confirms
        end
      end

      def post_event(topic:, event:, routing_key: nil, headers: {})
        raise 'Event missing topic or verb.' if event.verb.to_s.empty? || topic.to_s.empty?
        post_data(
          topic: topic,
          data: event.json,
          routing_key: routing_key || event.verb,
          headers: headers
        )
      end

      def config
        Artsy::EventService.config
      end
    end
  end
end
