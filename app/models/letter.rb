class Letter < ApplicationRecord

	def render_api
	{
		id: self.id,
		date: self.date,
		name: self.name,
		count: self.count
	}
	end

end
