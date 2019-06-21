class Api::V1::UsersController < Api::V1::BaseController

	# before_action :authenticate_member!

  def index
		# users = Api::V1::UsersFilter.new(User.all, params).collection
    users = User.all
    render :json => array_serializer(users)
  end

  def show
    user = User.find_by_id(params[:id])
    render :json => user.render_api
  end

	def me
		request.headers["uid"]
		user = User.find_by(uid: request.headers["uid"])
		# puts user.tokens
		# puts user.confirmation_token
		render :json => user.render_api
	end

	def updateMe
		@user = User.find_by(uid: request.headers["uid"])
		if @user.update_attributes(permitted_params)
			 render :json => @user.render_api
		end
	end

  def update
   @user = User.find(params[:id])
   if @user.update_attributes(permitted_params)
		 render :json => @user.render_api
   end
  end

	def destroy
   User.find(params[:id]).destroy
   redirect_to :action => 'index'
  end

  private

  def permitted_params
    params.require(:user).permit(
      :email,
			:name
    )
  end

	def array_serializer users
      users_serialized = Array.new
      users.each do |user|
      	users_serialized.push(user.render_api)
      end
      users_serialized
  end

end
