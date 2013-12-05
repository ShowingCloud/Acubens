class LocalitiesController < ApplicationController

	respond_to :json, :xml, :html

	before_filter :check_admin, :except => [:index, :show]

	# GET /localities
	def index
		@localities = Locality.all
		respond_with @localities
	end

	# GET /localities/1
	def show
		@locality = Locality.find params[:id]

		@children = Locality.find :all, :conditions => { :parent => params[:id] }
		@locality[:children] = @children

		respond_with @locality
	end

	# GET /localities/new
	def new
		@locality = Locality.new
		respond_with @locality
	end

	# GET /localities/1/edit
	def edit
		@locality = Locality.find params[:id]
		respond_with @locality
	end

	# POST /localities
	def create
		@locality = Locality.new params[:locality]
		@locality.save
		respond_with @locality
	end

	# PUT /localities/1
	def update
		@locality = Locality.find params[:id]
		@locality.update_attributes params[:locality]
		respond_with @locality
	end

	# DELETE /localities/1
	def destroy
		@locality = Locality.find params[:id]
		@locality.destroy
		respond_with @locality
	end


	private

	def check_admin
		if not refinery_user?
			respond_with ret = nil, :location => nil do |format|
				format.html { redirect_to "/" }
			end and return
		end
	end
end
