class SkinSurveysController < ApplicationController
  # GET /skin_surveys
  # GET /skin_surveys.json
  def index
    @skin_surveys = SkinSurvey.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @skin_surveys }
    end
  end

  # GET /skin_surveys/1
  # GET /skin_surveys/1.json
  def show
    @skin_survey = SkinSurvey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @skin_survey }
    end
  end

  # GET /skin_surveys/new
  # GET /skin_surveys/new.json
  def new
    @skin_survey = SkinSurvey.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @skin_survey }
    end
  end

  # GET /skin_surveys/1/edit
  def edit
    @skin_survey = SkinSurvey.find(params[:id])
  end

  # POST /skin_surveys
  # POST /skin_surveys.json
  def create
    @skin_survey = SkinSurvey.new(params[:skin_survey])

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
    @skin_survey.destroy

    respond_to do |format|
      format.html { redirect_to skin_surveys_url }
      format.json { head :no_content }
    end
  end
end
