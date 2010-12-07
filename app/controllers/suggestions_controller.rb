class SuggestionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :vote]

  def create
    @project = Project.find(params[:project_id])    
    @suggestion = Suggestion.new(params[:suggestion]).tap do |s|
      s.project = @project
    end
    if @suggestion.save
      redirecting_to = inline? ? inline_project_url(@project) : project_path(@project)
      redirect_to redirecting_to, :notice => 'Thanks. We appreciate your feedback.'
    else
      @suggestions = @project.suggestions.most_voted
      render :new
    end
  end

  def edit    
    @suggestion = Suggestion.find(params[:id])
  end

  def update
    @suggestion = Suggestion.find(params[:id])
    if @suggestion.update_attributes(params[:suggestion])
      redirect_to project_url(@suggestion.project), :notice => 'Successfully updated.'
    else
      render :edit
    end
  end


  def vote
    @suggestion = Suggestion.find(params[:suggestion_id])
    @suggestion.vote(params[:value].to_i)
    if inline?
      redirect_to inline_project_url(@suggestion.project), :notice => 'Thanks for your vote!'
    else
      redirect_to project_url(@suggestion.project), :notice => 'Thanks for your vote!'
    end
  end
end
