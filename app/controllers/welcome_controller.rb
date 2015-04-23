class WelcomeController < ApplicationController

  def index
    @profile = Profile.all.sample 
    splashbase_response = HTTParty.get("http://www.splashbase.co/api/v1/images/search?query=cherry%20blossoms")
    response_body = splashbase_response.body
    	 # @debug_example = response_body.inspect
    response_hash = JSON.parse(response_body, symbolize_names: true)
    @image_url = response_hash[:images][0][:url]

    splashbase_response = HTTParty.get("http://www.splashbase.co/api/v1/images/search?query=wallet")
    response_body = splashbase_response.body
    	 # @debug_example = response_body.inspect
    response_hash = JSON.parse(response_body, symbolize_names: true)
    @image_url2 = response_hash[:images][0][:url]

    splashbase_response = HTTParty.get("http://www.splashbase.co/api/v1/images/search?query=laptop")
    response_body = splashbase_response.body
    	 # @debug_example = response_body.inspect
    response_hash = JSON.parse(response_body, symbolize_names: true)
    @image_url3 = response_hash[:images][0][:url]
  end


end
