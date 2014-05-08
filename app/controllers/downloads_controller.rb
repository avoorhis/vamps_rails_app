class DownloadsController < ApplicationController

    before_action :authenticate_user!
	
	def index
         
    end
  
  
	def generate_data_download()
		send_data(:controller=>"visualization", :action=>"get_taxonomy_by_site", :file_name => "my_file_name", :type => "application/text")
	end

end
