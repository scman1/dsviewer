module FixtureDataHelper
	def load_data_json(path)
		File.open("test/fixtures/files/#{path}", "rb") do |file|
			JSON.load file
		end
	end
end