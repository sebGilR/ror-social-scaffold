class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @requests = Friendship.where(friend_id: current_user.id, confirmed: nil)
  end

  def create
    @friend = User.find(params[:user])

    current_user.friendships.create(friend: @friend)
    redirect_to request.referrer
  end

  def update
    @friendship = Friendship.find_by(id: params[:id])

    if params[:confirmed] == '1'
      @friendship.accept
      current_user.friendships.create(friend: @friendship.user, confirmed: true)
    else
      @friendship.destroy
    end
    redirect_to request.referrer
  end
end
