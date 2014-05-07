require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module VampsApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.assets.enable = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
 
    config.active_record.schema_format setting = :sql # http://guides.rubyonrails.org/migrations.html#types-of-schema-dumps
    #config.action_view.JavaScript_expansions[:defaults] = %w(jquery rails application) 
    
    # from http://everydayrails.com/2012/03/12/testing-series-rspec-setup.html#sthash.OsHkyDKY.dpuf
    config.generators do |g|
      g.test_framework :rspec,
        :fixture => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true 
       g.fixture_replacement :factory_girl, :dir => "spec/factories"      
    end
  end
end
