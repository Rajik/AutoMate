class ProvidersController < ApplicationController

  require 'json'
  def index
    render 'providers/home'
  end


  #{"utf8"=>"✓", "authenticity_token"=>"Oki5+HUp4ZJ0NbbxNOfV4TlMCm+MGrGDHSr4lp4tcmw=", "partner_name"=>"cxzcz",
  # "url"=>"http://www.travelbook.com.mx/api/v2", "verb"=>"POST", "body"=>"", "auth"=>"", "commit"=>"Curl"}
  def curl
    puts "Here"
    puts "Params are **********"
    puts params[:url]

    if params[:verb].eql? 'GET'
      response = Typhoeus.get("www.google.com")
    else
      if params[:verb].eql? 'POST'
        response = Typhoeus.post(params[:url], body: params[:post_body].to_json)
      end
    end

    #request.run
        #request.on_complete do |response|
        #  puts "Code is {response.code}"
        #end
        puts response.response_body.as_json
    @curl_response = response
    respond_to do |format|
      format.html
      format.js   {render :curl_result}
    end
        #render 'providers/home'

  end
end

