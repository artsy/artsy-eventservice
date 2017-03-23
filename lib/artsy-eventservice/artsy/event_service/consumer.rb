# frozen_string_literal: true
module Artsy
  module EventService
    module Consumer
      include RabbitMQConnection
    end
  end
end
