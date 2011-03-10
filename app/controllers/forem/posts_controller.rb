class Forem::PostsController < Forem::ApplicationController
  before_filter :authenticate_forem_user
  before_filter :find_topic

  def new
    @post = @topic.posts.build
  end
  
  def create
    @post = @topic.posts.build(params[:forem_post])
    if @post.save
      flash[:notice] = t("forem.post.created")
      redirect_to [@topic.forum, @topic]
    else
      params[:reply_to_id] = params[:forem_post][:reply_to_id]
      flash[:error] = t("forem.post.not_created")
      render :action => "new"
    end
  end

  private

  def find_topic
    @topic = Forem::Topic.find(params[:topic_id])
  end
end