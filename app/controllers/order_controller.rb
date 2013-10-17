#encoding: utf-8
require 'json'

class OrderController < ApplicationController

	respond_to :json, :xml

	before_filter :checklogin, :checkcaptcha

	Client = Savon.client do
		wsdl "http://210.13.83.245/GelnicWebServiceTest/OfficialService.asmx?WSDL"
		namespace "http://tempuri.org/"
		convert_request_keys_to :camelcase
		soap_version 2
	end


	def index
		redirect_to "/"
	end


	def show
		redirect_to "/"
	end


	def setorder
		resp = Order.setorder session[:username]

		respond_with ret = { :status => resp }, :location => nil and return
	end


	private

	def checklogin
		if not session[:login] or not session[:username]
			respond_with ret = { :status => 0 }, :location => nil and return
		end
	end


	def checkcaptcha
		if not simple_captcha_valid?
			respond_with ret = { :status => 2 }, :location => nil and return
		end
	end

end
