# Logtastic
### Wrapped-up [Logstasher](https://github.com/shadabahmed/logstasher)  

Logstasher is awesome. It does one thing, and does it well.
While you can add information to Logstasher relatively easily, it is harder to add information that changes over time, for example, the number of SQL queries performed during a request.

## Installation
In your Gemfile:

```ruby
gem 'logtastic'
```

### Configure your `<environment>.rb` (for example: `production.rb`)

```ruby
# The options are the same as LogStasher's
config.logtastic.enabled = true
config.logtastic.suppress_app_log = false

# Set this to true if you want to enable caching instrumentation
config.logtastic.enable_cache_instrumentation = true 
```

## Enter Logtastic
Logtastic is a wrapper around LogStasher.
Any option you can pass to LogStasher, you can pass to Logtastic.

Logtastic is simply here to help you log metrics based on ActiveSupport::Notifications, by tracking them and adding them to the final payload.

See a complete [example](https://github.com/elhu/logtastic/blob/master/example/initializer.rb).

For example, if you want to log the number of SQL queries performed during a request, could can do:

```ruby
# config/initializers/logtastic.rb

Logtastic.watch('sql.active_record') do |name, start, finish, id, payload, event_store|
  duration = (finish - start) * 1000
  event_store[:queries] = event_store[:queries].to_i.succ
end
```

`Logtastic.watch` takes the notification's name in argument, and a block, called every time the notification is triggered, with the following arguments:

* `name`: The notification's name
* `start`: Beginning date for the event
* `finish`: End date for the event
* `id`: ID of the event
* `payload`: Event's payload
* `event_store`: A thread-safe hash where you can store the data you want to log. This is reset after each request.

If you want to share an `event_store` between several events, you can assign them to an `event_group`:

``` ruby
# config/initializers/logtastic.rb
Logtastic.watch('cache_fetch_hit.active_support', event_group: 'cache') do |*args, event_store|
  event_store[:fetch_hit] = event_store[:fetch_hit].to_i.succ
end

Logtastic.watch('cache_generate.active_support', event_group: 'cache') do |*args, event_store|
  event_store[:generate] = event_store[:generate].to_i.succ
end
```

Whatever you put in your `event_store`, you'll get back in your log:
```json
# The field name is either the notification's name, or the `event_group` if one is set.
{"@source":"unknown","@tags":["request"],"@fields":{"method":"GET","path":"/login","format":"html","controller":"session","action":"credential_requestor","status":200,"duration":1265.1,"view":1087.07,"db":89.96,"sql.active_record":{"queries":35,"slowest_query":14.312999999999999},"ip":"127.0.0.1","route":"session#credential_requestor","parameters":"service=http://example.com/login\n","user_id":null,"cas_id":null,"session_id":"e309097c16d4c4bd2ca1474b316e6406","request_id":"6dffb5ea-8075-4e38-b2ba-bb5f5264421a","cache":{"fetch_hit":3}},"@timestamp":"2013-11-21T14:35:08.210091+00:00"}
```
