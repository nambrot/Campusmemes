class CollegesController < ApplicationController
  respond_to :json, :html
  def index
    @colleges = College.all
  end
  
  def show
    @college = College.where("this.short.toLowerCase() == '#{params[:id]}'").first
    respond_with @college
  end
  
  def about
    
  end
end
