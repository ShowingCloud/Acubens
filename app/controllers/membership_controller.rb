#encoding: utf-8

class MembershipController < ApplicationController

	respond_to :json, :xml, :html

	before_filter :checklogin, :except => [:verifymobile, :register, :login, :logout, :getusers, :getdict, :changepsw]
	before_filter :checksurveyitems, :only => [:surveydone]
	before_filter :checkcaptcha, :only => [:login]

	SurveyKeys = [ :style, :care, :problems, :time, :procedures, :effects, :shortcomings,
				:cost, :markets, :factors, :brands, :importance, :source, :ways,
				:infos, :offline, :age ]


	def index
		redirect_to "/"
	end


	def show
		redirect_to "/"
	end


	def verifymobile
		resp = Membership.verifymobile params[:mobile]

		if not refinery_user?
			resp.delete :return_value
		end

		respond_with resp, :location => nil
	end


	def register
		session[:username] = nil
		session[:login] = nil

		resp = Membership.register params[:mobile], params[:password],
			params[:verification], params[:email]

		if resp[:status] == "1"
			session[:username] = params[:mobile]

			Membership.settodict session[:username], :login, 1
			session[:login] = 1

			resp[:fillinfo] = Membership.updateinfo session[:username],
				:email => params[:email], :password => resp[:password]
			resp[:username] = session[:username].to_s
		end

		resp.delete :password
		respond_with resp, :location => nil
	end


	def login
		session[:username] = nil
		session[:login] = nil

		resp = Membership.login params[:username], params[:password], params[:captcha]

		if resp[:status] == 1
			session[:username] = params[:username]
			session[:nickname] = resp[:resp][:return_value][:nick_name]
			session[:gender] = resp[:resp][:return_value][:gender_id].to_i

			login = Membership.getfromdict params[:username], :login
			if login == nil
				Membership.settodict params[:username], :login, 1
				login = 1
			end
			session[:login] = login

			respond_with resp, :location => nil
		else
			respond_with resp, :location => nil
		end
	end


	def logout
		session[:username] = nil
		session[:login] = nil

		redirect_to '/'
	end


	def changepsw
		resp = Membership.changepswd params[:mobile], params[:password], params[:verification]

		if resp[:status] != "1"
			respond_with resp.merge({ :progress => :password }), :location => nil and return
		end

		resp = Membership.updateinfo params[:mobile], :password => resp[:password]
		resp.delete :password
		respond_with resp, :location => nil
	end


	def fillinfo
		resp = Membership.updateinfo session[:username], :fullname => params[:fullname],
			:gender => params[:gender], :birthdate => params[:birthdate],
			:subscription => params[:subscription], :phone => params[:phone],
			:weibo => params[:weibo], :wechat => params[:wechat]

		session[:nickname] = params[:fullname].to_s
		session[:gender] = params[:gender].to_i

		if session[:login] == 1
			Membership.settodict session[:username], :login, 2
			session[:login] = 2
		end

		respond_with resp, :location => nil
	end


	def getinfo
		resp = Membership.getinfo session[:username]

		if not refinery_user?
			resp[:return_value].delete :password
			resp[:return_value].delete :password_md5
			resp[:return_value].delete Membership::Columns[:password].to_sym
		end

		resp[:addr] = Membership.getanaddr session[:username]

		respond_with resp, :location => nil
	end


	def getaddr
		resp = Membership.getaddr session[:username], params[:id]
		respond_with resp, :location => nil
	end


	def addaddr
		resp = Membership.addaddr session[:username], params[:id], params[:name],
			params[:mobile], params[:phone], params[:address], params[:zipcode],
			params[:province], params[:city], params[:district]
		respond_with resp, :location => nil
	end


	def updateaddr
		resp = Membership.updateaddr session[:username], params[:id], params[:name],
			params[:mobile], params[:phone], params[:address], params[:zipcode],
			params[:province], params[:city], params[:district]
		respond_with resp, :location => nil
	end


	def deladdr
		resp = Membership.deladdr session[:username], params[:id]
		respond_with resp, :location => nil
	end


	def getdefaddr
		respond_with Membership.getdefaddr(session[:username]), :location => nil
	end


	def setdefaddr
		respond_with Membership.setdefaddr(session[:username], params[:id]), :location => nil
	end


	def surveydone
		if session[:login] == 2
			@skin_survey = SkinSurvey.find_or_initialize_by_user session[:username].to_s
			@skin_survey.update_attributes params[:skin_survey]
			@skin_survey[:user] = session[:username].to_s
			@skin_survey.save

			resp = Membership.questionnaire session[:username]

			if resp[:status] == "1"
				Membership.settodict session[:username], :login, 3
				session[:login] = 3
			end

			respond_with resp, :location => nil and return
		else
			respond_with ret = { :status => -1 }, :location => nil and return
		end
	end


	def getpoint
		resp = Membership.getpoint session[:username], params[:type]
		respond_with resp, :location => nil
	end


	def getpendingpoint
		points = PendingOrder.where(username: session[:username]).sum('points')
		respond_with ret = { :status => 1, :points => points }, :location => nil and return
	end


	def getavailpoint
		begin
			points = Membership.getpoint(session[:username], 1)[:value].to_i
			points -= PendingOrder.where(username: session[:username]).sum('points').to_i
			status = 1
		rescue
			points = 0
			status = -1
		end

		if points < 0
			points = 0
			status = 0
		end

		respond_with ret = { :status => status, :points => points }, :location => nil and return
	end

	def getpointproducts
		resp = Membership.getpointproducts
		respond_with resp, :location => nil
	end


	def getpointredeemproducts
		resp = Membership.getpointredeemproducts
		respond_with resp, :location => nil
	end


	def getpointredeemhistory
		resp = Membership.getpointredeemhistory session[:username], params[:type]
		respond_with resp, :location => nil
	end


	def getpointlist
		resp = Membership.getpointlist session[:username], params[:type]
		respond_with resp, :location => nil
	end


	def getusers
		if not refinery_user?
			respond_with ret = { :status => 0 }, :location => nil and return
		end

		respond_with Membership.getusers, :location => nil
	end


	def getdict
		resp = Membership.getdict params[:type]
		respond_with resp, :location => nil
	end


	private

	def checklogin
		if not session[:login] or not session[:username]
			respond_with ret = { :status => 0 }, :location => nil and return
		end
	end


	def checksurveyitems
		params[:skin_survey].blank? and respond_with ret = { :status => 0 }, :location => nil and return
		SurveyKeys.each do |v|
			params[:skin_survey][v].blank? and respond_with ret = { :status => 0 }, :location => nil and return
		end
	end


	def checkcaptcha
		if not simple_captcha_valid?
			respond_with ret = { :status => 2 }, :location => nil and return
		end
	end

end
