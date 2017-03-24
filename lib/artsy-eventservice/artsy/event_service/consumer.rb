# frozen_string_literal: true
module Artsy
  module EventService
    module Consumer
      include RabbitMQConnection

      def consume(queue_name:, topic:, routing_key:, consumer_tag:, handler_class:)
        conn = create_conn
        conn.start
        ch = conn.create_channel
        q = ch.queue(queue_name)
        q.bind(topic)
        q.subscribe(consumer_tag: consumer_tag) do |delivery_info, properties, payload|
          handler = handler_class.new
          handler.before_action(delivery_info, properties) if handler.method_defined? :before_action
          handler.handle(payload)
        end
      end

    end
  end
end
