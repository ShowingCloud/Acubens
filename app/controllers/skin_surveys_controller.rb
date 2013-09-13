class SkinSurveysController < ApplicationController

	respond_to :json, :xml, :html
	respond_to :csv, :xls, :only => [:index]

	before_filter :check_right_username, :only => [:show, :edit, :update, :destroy]

	# GET /skin_surveys
	def index
		if not refinery_user?
			respond_with ret = nil, :location => nil do |format|
				format.html { redirect_to "/" }
			end and return
		end

		@skin_surveys = SkinSurvey.all

		respond_with @skin_surveys do |format|
			format.csv { send_data SkinSurvey.to_csv }
		end
	end

	# GET /skin_surveys/1
	def show
		@skin_survey = SkinSurvey.find params[:id]
	end

	# GET /skin_surveys/new
	def new
		@skin_survey = SkinSurvey.new
	end

	# GET /skin_surveys/1/edit
	def edit
		@skin_survey = SkinSurvey.find params[:id]
	end

	# POST /skin_surveys
	def create
		@skin_survey = SkinSurvey.new params[:skin_survey]

		if not refinery_user?
			if not session[:login] or not session[:username]
				respond_with ret = nil, :location => nil do |format|
					format.html { redirect_to "/" }
				end and return
			else
				@skin_survey[:user] = session[:username]
			end
		end

		@skin_survey.save
		respond_with @skin_survey
	end

	# PUT /skin_surveys/1
	# PUT /skin_surveys/1.json
	def update
		@skin_survey = SkinSurvey.find params[:id]
		@skin_survey.update_attributes params[:skin_survey]
		respond_with @skin_survey
	end

	# DELETE /skin_surveys/1
	# DELETE /skin_surveys/1.json
	def destroy
		@skin_survey = SkinSurvey.find params[:id]
		@skin_survey.destroy
		respond_with @locality
	end


	private

	def check_right_username
		@survey = SkinSurvey.find params[:id]

		if not refinery_user?
			if not session[:login] or not session[:username] or @survey[:user] != session[:username]
				respond_with ret = nil, :location => "/" do |format|
					format.html { redirect_to "/" }
				end and return
			end
		end
	end
end
