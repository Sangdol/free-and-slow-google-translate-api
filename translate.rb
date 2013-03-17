require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'google_drive'
require 'rack/contrib/jsonp'

# Need "callback" query string parameter for JSONP
use Rack::JSONP

session = GoogleDrive.login(ENV['GOOGLE_ID'], ENV['GOOGLE_PASSWD'])
ws = session.spreadsheet_by_key(ENV['SPREADSHEET_KEY']).worksheets[0]

MAX_ROW_NUMBER = 1000
row = 0;

get '/translate' do
	content_type :json

	GITHUB_PAGE = 'https://github.com/Sangdol/free-and-slow-google-translate-api'
	redirect GITHUB_PAGE if params.empty?

	start_time = Time.now
	from = params[:from] # Optional
	to = params[:to]
	texts = params[:text]
	result = {}

	texts = [texts] if texts.is_a? String
	row = (row + 1) % MAX_ROW_NUMBER

	if from.nil?
		ws[row, 1] = "=DetectLanguage(\"#{texts[0]}\")"
		from = "A#{row}"
	else
		from = "\"#{from}\""
	end

	# Call script from spreadsheet
	texts.each_with_index do |text, index|
		ws[row, index + 2] = "=GoogleTranslate(\"#{text}\", #{from}, \"#{to}\")"
	end

	# Save and reload the worksheet to get my changes effect
	ws.save
	ws.reload

	texts.each_with_index do |text, index|
		result[text] = ws[row, index + 2]
	end

	result[:elapsed_time] = Time.now - start_time
	result.to_json
end
