require 'rails/railtie'
require 'logtastic/controller_ext'

class Logtastic
  class Railtie < Rails::Railtie
    config.logtastic = ActiveSupport::OrderedOptions.new
    config.logtastic.enabled = false
    config.logtastic.enable_cache_instrumentation = false

    initializer :logtastic do |app|
      # Extending ActionController with the controller extension
      ActiveSupport.on_load(:action_controller) { include Logtastic::ControllerExt }

      # Pass the configuration over to logstasher
      app.config.logstasher = app.config.logtastic

      # Should we enable cache instrumentation?
      Logtastic.enable_cache_instrumentation = app.config.logtastic.enable_cache_instrumentation
    end
  end
end

require 'logstasher'
