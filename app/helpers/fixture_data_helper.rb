module FixtureDataHelper
	def load_data_json(path)
		File.open(Rails.root.to_s + "/test/fixtures/files/#{path}", "rb") do |file|
			JSON.load file
		end
	end
end