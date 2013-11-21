require 'active_support/concern'

class Logtastic
  module ControllerExt
    extend ActiveSupport::Concern

    included do
      before_filter :enable_cache_instrumentation
    end

    protected
    def enable_cache_instrumentation
      # Cache instrumentation is disabled by default in Rails
      Rails.cache.class.instrument = true if Logtastic.enable_cache_instrumentation
    end

    def append_info_to_payload(payload)
      super
      # At the end of the request (process_action.action_controller), add the store to the payload
      Logtastic.store.each do |key, value|
        payload[key] = value
      end
    end

  end
end
