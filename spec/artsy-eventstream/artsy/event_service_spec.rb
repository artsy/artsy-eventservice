# frozen_string_literal: true
require 'spec_helper'

describe Artsy::EventService do
  let(:event) { double('event', topic: 'foo', verb: 'bar') }

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
      it 'does connect to rabbit' do
        expect(Artsy::EventService::Publisher).to receive(:publish)

        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end
  end
end
