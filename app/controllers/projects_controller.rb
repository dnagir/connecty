class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :except => :inline
  load_and_authorize_resource :except => :inline

  before_filter :only => [:show, :inline] do
    @project = @project || Project.find(params[:id])
    @suggestion = Suggestion.new
    @suggestions = @project.suggestions.most_voted
  end

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
    @show_done = params[:show_done] == 'true'
    @suggestions = @suggestions.active unless @show_done
  end

  def inline
    @suggestions = @suggestions.published
    params[:inline] = 'true'
  end

  def install
  end

  def invite
    email = (params[:user] || {})[:email]

    if @user = @project.invite_user(email)
      redirect_to project_url(@project), :notice => 'User has been invited!'
    end
    @user = User.new.tap do |u| 
      u.errors[:email] = 'enter an email of a user that is already registered here'
    end unless @user
  end
end
