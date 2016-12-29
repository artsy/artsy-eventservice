require 'spec_helper'
require 'json'

describe Artsy::EventService do
  let(:event) { double("event") }

  before do
    allow(event).to receive_messages(
      verb: 'testing',
      json: JSON.generate(hello: true)
    )
  end
  describe '#post_event' do
    context 'event stream disabled' do
      before do
        ENV['EVENT_STREAM_ENABLED'] = nil
      end
      it 'does not call conn and post event' do
        expect(Artsy::EventService).not_to receive(:conn)
        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end

    context 'event stream enabled' do
      before do
        ENV['EVENT_STREAM_ENABLED'] = 'true'
      end
      it 'fails when topic is empty' do
        expect { Artsy::EventService.post_event(topic: nil, event: event)}.to raise_error 'Event missing topic or verb.'
      end
      it 'fails when event.verb is empty' do
        allow(event).to receive(:verb).and_return('')
        expect { Artsy::EventService.post_event(topic: 'test', event: event)}.to raise_error 'Event missing topic or verb.'
      end
      it 'fails when event.verb is nil' do
        allow(event).to receive(:verb).and_return(nil)
        expect { Artsy::EventService.post_event(topic: 'test', event: event)}.to raise_error 'Event missing topic or verb.'
      end
      it 'calls publish on the exchange with proper data' do
        conn = double
        expect(Artsy::EventService).to receive(:conn).at_least(3).times.and_return(conn)
        expect(conn).to receive(:start).once
        expect(conn).to receive(:close).once
        channel = double
        expect(conn).to receive(:create_channel).and_return(channel)
        exchange = double
        expect(channel).to receive(:topic).with('test', durable: true).and_return(exchange)
        expect(exchange).to receive(:publish).with(
          JSON.generate(hello: true),
          routing_key: 'testing',
          persistent: true,
          content_type: 'application/json',
          app_id: 'artsy'
        )
        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end
  end
end
