#encoding: utf-8
require 'digest/sha2'
require 'json'

class MembershipController < ApplicationController

	respond_to :json, :xml

	Client = Savon.client do
		wsdl "http://www.mokard.com/WSV26Test/PointRequest.asmx?WSDL"
		namespace "http://tempuri.org/"
		convert_request_keys_to :camelcase
		soap_version 2
	end

	Channel = "Gelnic"
	Merchant = "1591"

	def index
		redirect_to "/"
	end

	def show
		redirect_to "/"
	end

	def verifymobile
		resp = query_mokard(:verfied_mobile_by_sms, {
			:mobile => params[:mobile].to_s
		})

		if not refinery_user?
			resp.delete :return_value
		end

		respond_with resp, :location => nil
	end

	def register
		session[:username] = nil
		session[:login] = nil

		digest = Digest::SHA256.new
		digest.update params[:password].to_s
		digest.update Acubens::Application.config.membership_secret_token

		resp = query_mokard(:regist, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => params[:username].to_s,
			:pass_word => digest.hexdigest.slice(0, 32),
			:mobile => params[:mobile].to_s,
			:verification_code => params[:verification].to_s,
			:user_info => {
				:email => params[:email].to_s
			}
		})

		if resp[:status] == "1"
			session[:username] = params[:username]
			session[:login] = true
		end

		respond_with resp, :location => nil
	end

	private

	def query_mokard(method, data)
		response = Client.call(method, message: data)
		method_response = (method.to_s + "_response").to_sym
		method_result = (method.to_s + "_result").to_sym
		return response.body[method_response][method_result]
	end

end
