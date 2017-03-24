# frozen_string_literal: true
require 'spec_helper'
require 'json'

describe Artsy::EventService::Publisher do
  let(:event) { double('event', topic: 'foo') }

  before do
    Artsy::EventService.instance_variable_set('@configuration', nil)
    ENV['EVENT_STREAM_ENABLED'] = 'true'
    allow(event).to receive_messages(
      verb: 'testing',
      json: JSON.generate(hello: true)
    )
  end

  describe '.publish' do
    it 'fails when topic is empty' do
      expect { Artsy::EventService::Publisher.publish(topic: nil, event: event) }.to raise_error 'Event missing topic or verb.'
    end
    it 'fails when event.verb is empty' do
      allow(event).to receive(:verb).and_return('')
      expect { Artsy::EventService::Publisher.publish(topic: 'test', event: event) }.to raise_error 'Event missing topic or verb.'
    end
    it 'fails when event.verb is nil' do
      allow(event).to receive(:verb).and_return(nil)
      expect { Artsy::EventService::Publisher.publish(topic: 'test', event: event) }.to raise_error 'Event missing topic or verb.'
    end
    it 'calls publish on the exchange with proper data' do
      conn = double
      channel = double
      exchange = double
      allow(Bunny).to receive(:new).and_return(conn)
      expect(conn).to receive(:start).once
      expect(conn).to receive(:stop).once
      allow(conn).to receive(:create_channel).and_return(channel)
      allow(channel).to receive(:topic).with('test', durable: true).and_return(exchange)

      expect(exchange).to receive(:publish).with(
        JSON.generate(hello: true),
        routing_key: 'testing',
        persistent: true,
        content_type: 'application/json',
        app_id: 'artsy'
      )
      Artsy::EventService::Publisher.publish(topic: 'test', event: event)
    end
  end
end
