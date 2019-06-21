class Api::V1::WeightsController < Api::V1::BaseController

	# before_action :authenticate_member!

	before_action :valid_user

	def valid_user
		@user = User.find_by(uid: request.headers["uid"])
		if !@user
			render json: [], status: 422
			return;
		end
		if params[:id]
			@weight = Weight.find(params[:id])
			if @user.id != @weight.user_id
				render json: [], status: 422
				return;
			end
		end
	end

	def all_user_weight
		@weights = Weight.where("weights.user_id = ?", @user.id)
		@weights = @weights.sort_by{ |e| e.date.split("-")[2] + "-" + e.date.split("-")[1] + "-" + e.date.split("-")[0]}
		@weights.each_with_index do |e, index|
			if index != 0
				e.write_attribute(:diff, e.value - @last)
				e.save
			end
			@last = e.value;
		end
	end

  def index
		@weights = Api::V1::WeightsFilter.new(Weight.all, params).collection
    render :json => array_serializer(@weights)
  end

  def show
    weight = Weight.find_by_id(params[:id])
    render :json => weight.render_api
  end

	def create
		@weight = Weight.new(permitted_params)
		@weight.user_id = @user.id

		if @weight.save
			all_user_weight
			render :json => @weight.render_api
		else
			render json: [], status: 422
		end
	end

  def update
		if @weight.update_attributes(permitted_params)
			all_user_weight
			render :json => @weight.render_api
		end
	end

	def destroy
		Weight.find(params[:id]).destroy
		all_user_weight
		render :json => []
	end

  private

  def permitted_params
    params.require(:weight).permit(
      :value,
			:diff,
			:date,
			:user_id
    )
  end

	def array_serializer weights
      weights_serialized = Array.new
      weights.each do |weight|
      	weights_serialized.push(weight.render_api)
      end
      weights_serialized
  end

end
