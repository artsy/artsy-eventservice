module Artsy
  module EventService
    def self.conn
      @conn ||= Bunny.new(
        ENV['RABBITMQ_URL'],
        tls: true,
        tls_cert: Base64.decode64(ENV['RABBITMQ_CLIENT_CERT'] || ''),
        tls_key: Base64.decode64(ENV['RABBTIMQ_CLIENT_KEY'] || ''),
        tls_ca_certificates: [Base64.decode64(ENV['RABBITMQ_CA_CERT'] || '')],
        verify_peer: true
      )
    end

    def self.post_event(topic:, event:)
      return unless ENV['EVENT_STREAM_ENABLED']
      raise 'Event missing topic or verb.' if event.verb.to_s.empty? || topic.to_s.empty?
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
      defined?(Rails) ? Rails.application.class.to_s.split("::").first : 'artsy'
    end
  end
end