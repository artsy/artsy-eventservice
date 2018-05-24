# frozen_string_literal: true
require 'spec_helper'

describe Artsy::EventService::RabbitMQConnection do
  describe '.get_connection' do
    before :each do
      Artsy::EventService::RabbitMQConnection.instance_variable_set(:@connection, nil)
    end

    context 'with an open connection' do
      it 'returns that connection' do
        open_conn = double(:open_conn, closed?: false, start: nil)
        expect(Bunny).to receive(:new).once.and_return(open_conn)

        connection = Artsy::EventService::RabbitMQConnection.get_connection

        expect(connection).to eq open_conn
      end
    end

    context 'with a closed connection' do
      it 'rebuilds and returns that new connection' do
        closed_conn = double(:closed_conn, closed?: true, start: nil)
        open_conn = double(:open_conn, closed?: false, start: nil)
        expect(Bunny).to receive(:new).twice.and_return(closed_conn, open_conn)

        connection = Artsy::EventService::RabbitMQConnection.get_connection

        expect(connection).to eq open_conn
      end
    end
  end
end
