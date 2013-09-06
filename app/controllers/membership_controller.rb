#encoding: utf-8
require 'digest/sha2'
require 'openssl/cipher'
require 'base64'
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

#		if not refinery_user?
#			resp.delete :return_value
#		end

		respond_with resp, :location => nil
	end


	def register
		session[:username] = nil
		session[:login] = nil

		cipher = OpenSSL::Cipher::Cipher.new 'DES3'
		cipher.encrypt
		cipher.key = Acubens::Application.config.membership_secret_token

		iv = Digest::SHA256.new
		iv.update params[:username].to_s
		cipher.iv = iv.hexdigest

		result = cipher.update params[:password].slice(0, 23)
		result << cipher.final
		pswd = Base64.strict_encode64 result

		resp = query_mokard(:regist, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => params[:username].to_s,
			:pass_word => pswd,
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


	def login
		session[:username] = nil
		session[:login] = nil

		if not simple_captcha_valid?
			respond_with { :status => "2" }, :location => nil
		end

		resp = query_mokard(:get_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => params[:username].to_s
		})

		pswd = resp[:return_value][:password_md5]
		pswd = Base64.strict_decode64 pswd

		cipher = OpenSSL::Cipher::Cipher.new 'DES3'
		cipher.decrypt
		cipher.key = Acubens::Application.config.membership_secret_token

		iv = Digest::SHA256.new
		iv.update params[:username].to_s
		cipher.iv = iv.hexdigest

		clearpswd = cipher.update pswd
		clearpswd << cipher.final

		if clearpswd == params[:password]
			session[:username] = params[:username]
			session[:login] = true
			respond_with { :status => "1" }, :location => nil
		else
			respond_with { :status => "0" }, :location => nil
		end

	end


	private

	def query_mokard(method, data)
		response = Client.call(method, message: data)
		method_response = (method.to_s + "_response").to_sym
		method_result = (method.to_s + "_result").to_sym
		return response.body[method_response][method_result]
	end

end
