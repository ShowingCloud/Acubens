class SkinSurveysController < ApplicationController

	respond_to :json, :xml

	# GET /skin_surveys
	# GET /skin_surveys.json
	def index
		if refinery_user?
			@skin_surveys = SkinSurvey.all
		else
			@skin_surveys = {}
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @skin_surveys }
			format.csv { send_data SkinSurvey.to_csv }
			format.xls
		end
	end

	# GET /skin_surveys/1
	# GET /skin_surveys/1.json
	def show
		@skin_survey = SkinSurvey.find(params[:id])

		if not refinery_user?
			if not session[:login] or not session[:username] or @skin_survey[:user] != session[:username]
				@skin_survey = {}
			end
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @skin_survey }
		end
	end

	# GET /skin_surveys/new
	# GET /skin_surveys/new.json
	def new
		@skin_survey = SkinSurvey.new

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @skin_survey }
		end
	end

	# GET /skin_surveys/1/edit
	def edit
		@skin_survey = SkinSurvey.find(params[:id])

		if not refinery_user?
			if not session[:login] or not session[:username] or @skin_survey[:user] != session[:username]
				@skin_survey = {}
			end
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @skin_survey }
		end
	end

	# POST /skin_surveys
	# POST /skin_surveys.json
	def create
		@skin_survey = SkinSurvey.new(params[:skin_survey])

		if not refinery_user?
			if not session[:login] or not session[:username]
				@skin_survey = {}
			else
				@skin_survey[:user] = session[:username]
			end
		end

		respond_to do |format|
			if @skin_survey.save
				format.html { redirect_to @skin_survey, notice: 'Skin survey was successfully created.' }
				format.json { render json: @skin_survey, status: :created, location: @skin_survey }
			else
				format.html { render action: "new" }
				format.json { render json: @skin_survey.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /skin_surveys/1
	# PUT /skin_surveys/1.json
	def update
		@skin_survey = SkinSurvey.find(params[:id])

		if not refinery_user?
			if not session[:login] or not session[:username] or @skin_survey[:user] != session[:username]
				@skin_survey = {}
			end
		end

		respond_to do |format|
			if @skin_survey.update_attributes(params[:skin_survey])
				format.html { redirect_to @skin_survey, notice: 'Skin survey was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @skin_survey.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /skin_surveys/1
	# DELETE /skin_surveys/1.json
	def destroy
		@skin_survey = SkinSurvey.find(params[:id])

		if not refinery_user?
			if not session[:login] or not session[:username] or @skin_survey[:user] != session[:username]
				@skin_survey = {}
			end
		end

		@skin_survey.destroy

		respond_to do |format|
			format.html { redirect_to skin_surveys_url }
			format.json { head :no_content }
		end
	end
end
