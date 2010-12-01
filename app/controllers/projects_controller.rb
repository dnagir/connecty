class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :except => :show

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.users << current_user
    if @project.save
      redirect_to install_project_url(@project), :notice => 'Project successfully created. Now you can install the code into your site'
    else
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
    @suggestions = @project.suggestions
    @suggestion = Suggestion.new
    render :layout => 'inline' if params[:inline] == 'true'
  end


  def install
    @project = Project.find(params[:id])    
  end
end
