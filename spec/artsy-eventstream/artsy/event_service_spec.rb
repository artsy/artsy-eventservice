# frozen_string_literal: true
require 'spec_helper'

describe Artsy::EventService do
  let(:event) { double('event', topic: 'foo', verb: 'bar', routing_key: 'test.passed') }

  context 'event stream disabled' do
    before do
      allow(Artsy::EventService).to receive(:config).and_return(double(event_stream_enabled: false))
    end
    describe '.post_event' do
      it 'does not connect to rabbit' do
        expect(Artsy::EventService::Publisher).not_to receive(:publish)
        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end
  end

  context 'event stream enabled' do
    before do
      allow(Artsy::EventService).to receive(:config).and_return(double(event_stream_enabled: true))
    end
    describe '.post_event' do
      it 'calls publish with proper params' do
        expect(Artsy::EventService::Publisher).to receive(:publish_event).with(topic: 'test', event: event, routing_key: 'test.passed')

        Artsy::EventService.post_event(topic: 'test', event: event)
      end
      it 'calls publish with proper params with routing key' do
        expect(Artsy::EventService::Publisher).to receive(:publish_event).with(topic: 'test', event: event, routing_key: 'good.route')

        Artsy::EventService.post_event(topic: 'test', event: event, routing_key: 'good.route')
      end
    end
  end
end
