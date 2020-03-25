class RoomsController < ApplicationController
  before_action :require_authentication, only: [:new, :create, :edit, :update, :destroy]

  def index
    Room.most_recent.map do |room|
      RoomPresenter.new(room, self, false)
    end
  end

  def show
    room_model = Room.find(params[:id])
    @room = RoomPresenter.new(room_model, self)
  end

  def new
    @room = current_user.rooms.build
  end

  def edit
    @room = current_user.rooms.find(params[:id])
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: t('flash.notice.room_created')
    else
      render action: "new"    
    end
  end

  def update
    @room = current_user.rooms.find(params[:id])
    if @room.update(room_params)
      redirect_to @room, notice: t('flash.notice.room_updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @room = current_user.rooms.find(params[:id])
    @room.destroy
    redirect_to rooms_url
  end

  private
  
  def room_params
    params.require(:room).permit(:title, :location, :description)
  end
end
