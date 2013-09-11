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
