class Api::V1::LettersController < Api::V1::BaseController

  def index
		@letters = Letter.all.order(id: :asc)
    render :json => array_serializer(@letters)
  end

  def show
    @letter = Letter.find_by_id(params[:id])
    render :json => @letter.render_api
  end

	def create
		@letter = Letter.new(permitted_params)

		if @letter.save
			render :json => @letter.render_api
		else
			render json: [], status: 422
		end
	end

  def update
		@letter = Letter.find_by_id(params[:id]);
		if @letter.update_attributes(permitted_params)
			render :json => @letter.render_api
		else
			render json: [], status: 422
		end
	end

	def destroy
		Letter.find(params[:id]).destroy
		render :json => []
	end

  private

  def permitted_params
    params.require(:letter).permit(
			:name,
			:date,
			:count
    )
  end

	def array_serializer letters
      letters_serialized = Array.new
      letters.each do |letter|
      	letters_serialized.push(letter.render_api)
      end
      letters_serialized
  end

end
