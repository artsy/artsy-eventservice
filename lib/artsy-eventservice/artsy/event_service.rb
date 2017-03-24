
# frozen_string_literal: true
module Artsy
  module EventService
    CONFIG = OpenStruct.new(initial_config)

    ## Configure the Artsy-EventService in an initializer. Ex:
    # initializers/artsy_eventservice.rb
    # 
    # Artsy::EventService.configure do |event_service|
    #   event_service.config.cool = true
    #   event_service.consume topic: 'auctions',
    #              routing_key: '*',
    #              consumer_tag: 'pulse_auctions',
    #              handler: RabbitAuctions
    #   event_service.post_event 'configured', {}
    # end
    def self.configure
      puts "calling configure: #{CONFIG.frozen?}"
      yield(self) if block_given?
      CONFIG.freeze
    end

    def self.config
      CONFIG
    end

    def self.post_event(topic:, event:)
      return unless event_stream_enabled?
      Publisher.publish(topic: topic, event: event)
    end

    # TODO: up next
    def self.consume(opts)
      return unless event_stream_enabled?
      Consumer.consume(opts)
    end


    def self.event_stream_enabled?
      config.event_stream_enabled
    end
  end
end
