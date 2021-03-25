class ChatsController < ApplicationController
  before_action :non_presence_chat, except: [:create]

  def show
    @user = User.find_by(id: params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    if user_rooms.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    else
      @room = user_rooms.room
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    redirect_to request.referer
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def non_presence_chat
    @user = User.find_by(id: params[:id])
    if @user.blank?
      redirect_to user_path(current_user), alert: "不正なアクセスです。"
    end
  end
end
