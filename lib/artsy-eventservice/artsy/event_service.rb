require 'bunny'

module Artsy
  module EventService
    def self.create_conn
      tls = ENV['RABBITMQ_NO_TLS'] == 'true' ? false : true
      params = { tls: tls }
      if tls
        params.merge!({
          tls_cert: Base64.decode64(ENV['RABBITMQ_CLIENT_CERT']),
          tls_key: Base64.decode64(ENV['RABBITMQ_CLIENT_KEY']),
          tls_ca_certificates: [Base64.decode64(ENV['RABBITMQ_CA_CERT'])],
          verify_peer: ENV['RABBITMQ_NO_VERIFY_PEER'] == 'true' ? false : true
        })
      end
      Bunny.new(ENV['RABBITMQ_URL'], **params)
    end

    def self.post_event(topic:, event:)
      return unless ENV['EVENT_STREAM_ENABLED']
      raise 'Event missing topic or verb.' if event.verb.to_s.empty? || topic.to_s.empty?
      conn = create_conn
      conn.start
      channel = conn.create_channel
      exchange = channel.topic(topic, durable: true)
      exchange.publish(
        event.json,
        routing_key: event.verb,
        persistent: true,
        content_type: 'application/json',
        app_id: app_name
      )
      conn.close
    end

    def self.app_name
      defined?(Rails) ? Rails.application.class.to_s.split('::').first : 'artsy'
    end
  end
end