# Artsy EventService [![Build Status](https://travis-ci.org/artsy/artsy-eventservice.svg?branch=master)](https://travis-ci.org/artsy/artsy-eventservice)
Ruby Gem for producing events in Artsy's event stream.

## Installation
Add following line to your Gemfile

```ruby
gem 'artsy-eventservice'
```

## Configuration

Add `artsy_eventservice.rb under config/initializers. `Artsy::EventService` uses [Bunny](http://rubybunny.info/) to connect to RabbitMQ. Here is a sample of configuration:

```ruby
# config/initializers/artsy_eventservice.rb
Artsy::EventService.configure do |config|
  config.app_name = 'my-app'  # Used for RabbitMQ queue name
  config.event_stream_enabled = true  # Boolean used to enable/disable posting events
  config.rabbitmq_url = 'amqp(s)://<user>:<pass>@<host>:<port>/<vhost>'  # required
  config.tls = true  # following configs are only used if tls is true
  config.tls_ca_certificate = <string content>
  config.tls_cert = <string content>
  config.tls_key = <string content>
  config.verify_peer = true  # Boolean used to decide in case we are using tls, we should verify peer or not
end
```

## Usage
Create events by inheriting from `Events::BaseEvent`. Override the properties that are different than `BaseEvent` and set extra `properties`.

```ruby
module Events
  class ConversationEvent < Events::BaseEvent
    def subject
      {
        id: @object.to_id,
        display: @object.to_name
      }
    end

    def properties
      {
        test_prop: 'testing'
      }
    end
  end
end
```


### Enabling Posting Events
We have a feature flag setup for enabling/disabling EventService. Setting `EVENT_STREAM_ENABLED` env variable will enable posting events. Not having this env means event service is disabled and no events will actually be sent.


### Posting events
Call `post_event` with proper `topic` and `event`:
```ruby
Artsy::EventService.post_event(topic: 'testing', event: event_model)
```


### Update to Version 1.0
In previous versions this gem was using Environment variables for configuration. On version 1.0, configuration step is now mandatory and it will no longer read environment variables directly. Make sure to go to configuration step.

# Contributing

* Fork the project.
* Make your feature addition or bug fix with tests.
* Update CHANGELOG.
* Send a pull request. Bonus points for topic branches.
