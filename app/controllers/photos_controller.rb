class PhotosController < ApplicationController
  respond_to :json
  def index
    params[:sort] = params[:sort] ? params[:sort] : 'likes'
    params[:range] = params[:range] ? params[:range].to_i : 1000000000000
    respond_with College.where("this.short.toLowerCase() == '#{params[:college_id]}'.toLowerCase()").first.photos.where(:created_at.gt => params[:range].days.ago).desc(params[:sort]).paginate :page => params[:page], :per_page => 20
  end
end
