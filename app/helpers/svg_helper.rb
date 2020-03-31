module SvgHelper
	def show_svg(path)
		File.open(Rails.root.to_s + "/app/assets/images/#{path}", "rb") do |file|
			raw file.read
		end
	end
end
