#encoding: utf-8
require 'json'

class OrderController < ApplicationController

	respond_to :json, :xml

	before_filter :checklogin

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
		if not simple_captcha_valid?
			respond_with ret = { :status => 2 }, :location => nil and return
		end

		order = {
			"orderid" =>,
			"customerid" => session[:username].to_s,
			"score" =>,
			"ordertime" =>,
			"Receiver" =>,
			"ReceiverProvince" =>,
			"ReceiverCity" =>,
			"ReceiverDistrict" =>,
			"ReceiverAddress" =>,
			"ReceiverMobile" =>,
			"ReceiverTel" =>,
			"ReceiverPostCode" =>,
			"item" =>
		}

		resp = query_800ts(:set_order, {
			"orderJson" => order,
		})

		respond_with ret = { :status => resp }, :location => nil and return
	end


	private

	def query_800ts(method, data)
		response = Client.call(method, message: data)
		method_response = (method.to_s + "_response").to_sym
		method_result = (method.to_s + "_result").to_sym
		return response.body[method_response][method_result]
	end


	def checklogin
		if not session[:login] or not session[:username]
			respond_with ret = { :status => 0 }, :location => nil and return
		end
	end

end
