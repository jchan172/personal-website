class BlogentriesController < ApplicationController
  before_action :signed_in_user

  def new
    @blogentry = Blogentry.new
    @blogid = params[:blogid]
  end

  def edit
    @blogentry = Blogentry.friendly.find(params[:id])
  end

  def destroy
    blogentry = Blogentry.friendly.find(params[:id])
    blog_id = blogentry.blog.id
    blogentry.blog.touch
    if blogentry.destroy
      flash[:success] = "Blog entry deleted."

    else
      flash[:fail] = "Blog entry not deleted: Unknown reason."
    end
    redirect_to blogs_manage_path(blog_id)
  end

  def update
    @blogentry = Blogentry.friendly.find(params[:id])
    blog_id = @blogentry.blog.friendly_id
    if @blogentry.update_attributes(blogentry_params)
      @blogentry.blog.touch
      flash[:success] = "Blog entry updated!"
      redirect_to blogs_manage_path(blog_id, :page => params[:blogentry][:from_page])
    else
      render 'edit'
    end
  end

  def create
    @blogentry = current_user.blogs.friendly.find(params[:blog][:id]).blogentries.build(blogentry_params)
    if @blogentry.save
      @blogentry.blog.touch
      flash[:success] = "Blog entry created successfully!"
      redirect_to blogs_manage_path(params[:blog][:id])
    else
      @blogid = params[:blog][:id]
      render 'new'
    end
  end

  private

    def blogentry_params # strong params
      params.require(:blogentry).permit(:content, :title, :blog_id, :created_at, :draft)
    end

    def signed_in_user
      redirect_to login_url, notice: "Please sign in." unless signed_in?
    end
    
end
