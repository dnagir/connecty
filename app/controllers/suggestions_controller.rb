class SuggestionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :vote]
  load_and_authorize_resource :except => [:create, :vote, :pivotal_story]

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
    @field_values = @suggestion.field_values.order(:name)
  end

  def update
    if @suggestion.update_attributes(params[:suggestion])
      redirect_to project_url(@suggestion.project), :notice => 'Successfully updated.'
    else
      render :edit
    end
  end


  def vote
    @suggestion = Suggestion.find(params[:suggestion_id])
    can_vote = cookies[:voted].to_s.split(';').find {|s| s.to_i == @suggestion.id }.blank?
    notice = if can_vote
      cookies.permanent[:voted] = (cookies[:voted] || '') << ";#{@suggestion.id}"
      @suggestion.vote(params[:value].to_i)
      'Thanks for your vote!'
    else
      'You have already voted for this suggestion before'
    end

    if inline?
      redirect_to inline_project_url(@suggestion.project), :notice => notice
    else
      redirect_to project_url(@suggestion.project), :notice => notice
    end
  end

  def pivotal_story
    @suggestion = Suggestion.find(params[:suggestion_id])
    authorize! :manage, @suggestion
    args = params[:integrations_pivotal_tracker_story] || {}
    args = {
      'name' => args[:name] || @suggestion.content_brief,
      'description' => args[:description] || @suggestion.content,
      'email' => args[:email] || current_user.email
    }.merge(args)

    @story = Integrations::PivotalTracker::Story.new(args)
    if request.post? and @story.create(current_user)
      redirect_to edit_project_suggestion_url(@suggestion.project, @suggestion), :notice => 'The suggestion was created as a Story.'
    end    
  end

  def destroy
    @project = @suggestion.project
    @suggestion.destroy
    redirect_to project_url(@project), :notice => 'Suggestion has been deleted.'
  end
end
