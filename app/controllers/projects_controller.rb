class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :except => :inline

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
    @suggestion = Suggestion.new
  end

  def inline
    @project = Project.find(params[:id])
    @suggestion = Suggestion.new
    params[:inline] = 'true'
  end

  def install
    @project = Project.find(params[:id])    
  end

  def invite
    @project = Project.find(params[:id])
    email = (params[:user] || {})[:email]

    if @user = @project.invite_user(email)
      redirect_to project_url(@project), :notice => 'User has been invited!'
    end
    @user = User.new.tap do |u| 
      u.errors[:email] = 'enter an email of a user that is already registered here'
    end unless @user
  end
end
