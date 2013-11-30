class ProvidersController < ApplicationController
  include JsonValidator
  require 'json'

  def index
    render 'providers/home'
  end

  def curl
    @@api_version = params[:api_version]
    if params[:verb].eql? 'GET'
      @@response = Typhoeus.get(params[:url])
    else
      if params[:verb].eql? 'POST'
        @@response = Typhoeus.post(params[:url], headers:{ "Content-Type" => "application/x-www-form-urlencoded"} , body: params[:post_body])
      end
    end
    puts @@response.response_body.as_json
    @curl_response = @@response
    respond_to do |format|
      format.js { render :curl_result }
    end
  end

  def validate
    puts
    @errors = validate_response @@response.response_body, @@api_version.to_i

    puts @errors

    if @errors.empty?
      respond_to do |format|
        format.js { render :json_schema_pass }
      end
    else
      respond_to do |format|
        format.js { render :json_schema_fail }
      end
    end
  end
end

