# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
VampsApp7::Application.initialize!

VampsApp7::Application.configure do
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }  
end

# ActionMailer::Base.smtp_settings = {  
#   :address              => "smtp.gmail.com",  
#   :port                 => 587,  
#   :domain               => "gmail.com",  
#   :user_name            => "myinfo@gmail.com",  
#   :password             => "secret",  
#   :authentication       => "plain"
#   # :enable_starttls_auto => true # I don't have this, but it should work anyway 
# } 
# Add new inflection rules using the following format
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  inflect.uncountable 'metadata'
  inflect.irregular 'taxon', 'taxa'
# inflect.plural /^(ox)$/i, '\1en'
# inflect.singular /^(ox)en/i, '\1'
# inflect.irregular 'person', 'people'
# inflect.uncountable %w( fish sheep )
end

