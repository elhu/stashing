require 'rails/railtie'
require 'stashing/controller_ext'

class Stashing
  class Railtie < Rails::Railtie
    config.stashing = ActiveSupport::OrderedOptions.new
    config.stashing.enabled = false
    config.stashing.enable_cache_instrumentation = false

    initializer :stashing do |app|
      # Extending ActionController with the controller extension
      ActiveSupport.on_load(:action_controller) { include Stashing::ControllerExt }

      # Pass the configuration over to logstasher
      app.config.logstasher = app.config.stashing

      # Should we enable cache instrumentation?
      Stashing.enable_cache_instrumentation = app.config.stashing.enable_cache_instrumentation
    end
  end
end

require 'logstasher'
