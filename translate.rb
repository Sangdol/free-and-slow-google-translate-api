require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'google_drive'
require 'rack/contrib/jsonp'

# Need "callback" query string parameter
use Rack::JSONP

session = GoogleDrive.login(ENV['GOOGLE_ID'], ENV['GOOGLE_PASSWD'])
ws = session.spreadsheet_by_key(ENV['SPREADSHEET_KEY']).worksheets[0]

MAX_ROW_NUMBER = 1000
row = 0;

get '/translate' do
	content_type :json

	if (params.empty?)
		redirect 'https://github.com/Sangdol/free-and-slow-google-translate-api'
	end

	start_time = Time.now
	from = params[:from] # Optional
	to = params[:to]
	texts = params[:text]
	result = {}

	if texts.is_a? String
		texts = [texts]
	end

	row = (row + 1) % MAX_ROW_NUMBER

	# Call script from spreadsheet
	texts.each_with_index do |text, index|
		if from.nil?
			ws[row, 1] = "=DetectLanguage(\"#{text}\")"
			ws[row, index + 2] = "=GoogleTranslate(\"#{text}\", A#{row}, \"#{to}\")"
		else
			ws[row, index + 2] = "=GoogleTranslate(\"#{text}\", \"#{from}\", \"#{to}\")"
		end
	end

	# Save and reload the worksheet to get my changes effect
	ws.save
	ws.reload

	texts.each_with_index do |text, index|
		result[text] = ws[row, index + 2]
	end

	result[:elapased_time] = Time.now - start_time
	result.to_json
end
