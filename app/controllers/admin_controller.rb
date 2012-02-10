class AdminController < ApplicationController
  before_filter :authenticate, :only => [:fetch, :update, :addCollege, :getToken]

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "foo" && password == "bar"
    end
  end
  
  def getToken    
@oauth = Koala::Facebook::OAuth.new(ENV['fbid'], ENV['fbsecret'], facebook_callback_url)
redirect_to @oauth.url_for_oauth_code 
  end
  
  def callback
    @oauth = Koala::Facebook::OAuth.new(ENV['fbid', ENV['fbsecret'], facebook_callback_url)
    token =  @oauth.get_access_token params[:code]
    Token.all.each {|d| d.destroy}
    Token.create ({:token => token})
    render :json => token

  end
  
  def update
    Delayed::Job.enqueue CollegeJob.new
    render :json => College.all
  end
  
  def index
    @colleges = College.all
    @college = College.new 
  end
  
  def addCollege
    College.create (params[:college])
  end
  
  
end

class CollegeJob < Object
    def perform
      College.all.each {|d| College.getPhotos(d)}
    end
end