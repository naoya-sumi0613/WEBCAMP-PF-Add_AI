class Users::PhotosController < ApplicationController
  impressionist :actions => [:show], :unique => [:impressionable_id, :ip_address]

  def index
    @photos = Photo.order(created_at: "DESC")
    @user = User.find(current_user.id)
    if params[:tag_name]
      @photos = Photo.tagged_with("#{params[:tag_name]}").order(created_at: "DESC")
    end
  end

  def new
  	@photo = Photo.new
  end

  def create
  	@photo = Photo.new(photo_params)
  	@photo.user_id = current_user.id
  	@photo.save
  	redirect_to photo_path(@photo.id)
  end

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(@photo.user_id)
    @comment = Comment.new
  end

  def update
    @photo = Photo.find(params[:id])
    @photo.update(photo_params)
    redirect_to photo_path(params[:id])
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to user_path(current_user)
  end

  def likes
    @photo = Photo.find(params[:id])
    @likes = Like.where(photo_id: @photo.id)
  end

  def comments
    @photo = Photo.find(params[:id])
    @comments = Comment.where(photo_id: @photo.id)
  end

  def photo_params
  	params.require(:photo).permit(:user_id, :image, :word, :range, :tag_list)
  end
end
