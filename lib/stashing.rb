require 'request_store'
require 'forwardable'

class Stashing
  STORE_KEY = :stashing_data

  class << self
    attr_accessor :enable_cache_instrumentation

    # Send all the dirty work to LogStasher
    extend Forwardable
    def_delegators :LogStasher, :enabled, :add_custom_fields, :custom_fields=, :custom_fields
  end

  def self.stash
    if RequestStore.store[STORE_KEY].nil?
      # Get each event_store it's own private Hash instance.
      RequestStore.store[STORE_KEY] = Hash.new { |hash, key| hash[key] = {} }
    end
    RequestStore.store[STORE_KEY]
  end

  def self.watch(event, opts = {}, &block)
    event_group = opts[:event_group] || event
    ActiveSupport::Notifications.subscribe(event) do |*args|
      # It's necessary to add the custom_fields at runtime, otherwise LogStasher overrides them.
      Stashing.custom_fields << event_group unless Stashing.custom_fields.include? event_group

      # Calling the processing block with the Notification args, plus the event_stash
      block.call(*args, stash[event_group])
    end
  end
end

# LogStasher must be loaded AFTER Stashing's Railtie
if defined?(Rails)
  require 'stashing/railtie'
else
  require 'logstasher'
end
