# Artsy EventService [![Build Status](https://travis-ci.org/artsy/artsy-eventservice.svg?branch=master)](https://travis-ci.org/artsy/artsy-eventservice)
Ruby Gem for producing events in Artsy's event stream.

## Installation
Add following line to your Gemfile

```
gem 'artsy-eventservice'
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

`Artsy::EventService` uses [Bunny](http://rubybunny.info/) to securly connect to RabbitMQ over ssl, make sure following environment variables are set in your project:
```
RABBITMQ_URL="something like amqps://<user>:<pass>@rabbitmq.artsy.net:<port>/<vhost>"
RABBITMQ_CLIENT_CERT=base64 strict decoded
RABBTIMQ_CLIENT_KEY=base64 strict decoded
RABBITMQ_CA_CERT=base64 strict decoded
```

### Enabaling Posting Events
We have a feature flag setup for enabling/disabling EventService. Setting `EVENT_STREAM_ENABLED` env variable will enable posting events. Not having this env means event service is disabled and no events will actually be sent.


### Posting events
Call `post_event` with proper `topic` and `event`:
```ruby
Artsy::EventService.post_event(topic: 'testing', event: event_model)
```


# Contributing

* Fork the project.
* Make your feature addition or bug fix with tests.
* Update CHANGELOG.
* Send a pull request. Bonus points for topic branches.
