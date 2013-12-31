class ProvidersController < ApplicationController
  include JsonValidator
  require 'json'

  def index
    render 'providers/home'
  end

  def curl
    @@api_version = params[:api_version]
    auth = params[:auth]

    url = params[:url]
    if params[:verb].eql? 'GET'
      if auth.empty?
        @@response = Typhoeus.get(url)
      else
        @@response = Typhoeus.get(url, userpwd: auth)
      end
    else
      if params[:verb].eql? 'POST'
        content_type = params[:content_type]
        post_body = params[:post_body]
        if auth.empty?
          @@response = Typhoeus.post(url, headers: {"Content-Type" => content_type}, body: post_body)
        else
          @@response = Typhoeus.post(url, headers: {"Content-Type" => content_type}, body: post_body, userpwd: auth)
        end
      end
    end
    puts @@response.headers_hash.as_json['Content-Type']
    puts @@response.response_body.as_json
    @curl_response = @@response
    respond_to do |format|
      format.js { render :curl_result }
    end
  end

  def validate
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

