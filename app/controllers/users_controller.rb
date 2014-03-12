class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = []
    if params[:topic_id].present? then
      topic = Topic.find(params[:topic_id].to_i)
      if topic != nil then
        @users = topic.experts
      end
    else
      @users = User.all
    end
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { render json: @users }
    end
  end

  def sort_by_degree(a, b)
    if a != nil then
      if b != nil then
        return a.degree <=> b.degree
      else
        return 1
      end
    elsif b != nil then
      return -1
    else
      return 0
    end
  end

  #max_topics is in params
  #currently returns most connected USERS & TOPICS
  def most_connected
    @topics = []
    if params[:user_id].present? then
      user = User.find(params[:user_id].to_i)
      if user != nil then
        user.expertises.each do |expertise|
          @topics << expertise
        end
        user.peers.each do |peer|
          @topics << peer 
        end
      end
    end

    @topics = @topics.sort{|a, b| sort_by_degree(a, b)}
    respond_to do |format|
      format.html { redirect_to @topics }
      format.json { render json: @topics }
    end
  end

  #Adds topic to given user
  #topic_id as payload
  def add_topic
    if params[:topic_id].present? then
      topic = Topic.find(params[:topic_id].to_i)
      user = User.find(params[:id])
      if topic != nil && user != nil then
        user.expertises << topic
      end
    end
    render :nothing => true
  end

  #Adds topic to given user
  #topic_id as payload
  def remove_topic
    if params[:topic_id].present? && params[:id].present? then
      user = User.find(params[:id])
      topic = Topic.find(params[:topic_id].to_i)
      if topic != nil && user!= nil then
        if user.expertises.include? topic then
          user.expertises.delete(topic)
        end
      end
    end
    render :nothing => true
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { redirect_to user_url }
      format.json { render json: @user }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { redirect_to edit_user_url }
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
