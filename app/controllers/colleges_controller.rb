class CollegesController < ApplicationController
  respond_to :html
  def index
    @colleges = College.all.asc(:name)
  end
  
  def show
    @college = College.where("this.short.toLowerCase() == '#{params[:id]}'").first
  end
  
  def create
    @college = ProposedCollege.create(params[:proposed_college])
    redirect_to :root, :notice => 'Thanks for submitting ' + @college.name
  end
  
  def about
    @college = ProposedCollege.new
  end
end
