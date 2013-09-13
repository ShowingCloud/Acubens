#encoding: utf-8
require 'digest/sha2'
require 'openssl/cipher'
require 'base64'
require 'json'

class MembershipController < ApplicationController

	respond_to :json, :xml, :html

	before_filter :checklogin, :except => [:verifymobile, :register, :login, :logout, :getusers, :getdict]

	Client = Savon.client do
		wsdl "http://www.mokard.com/WSV26Test/PointRequest.asmx?WSDL"
		namespace "http://tempuri.org/"
		convert_request_keys_to :camelcase
		soap_version 2
		logger Rails.logger
	end

	Channel = "Gelnic"
	Merchant = "1591"

	Columns = { :subscription => "column1", :postal => "column2", :phone => "column3", :weibo => "column4",
			:wechat => "column5", :taobao => "column6", :yihao => "column7", :email => "column8", :password => "column9"}


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
		iv.update params[:mobile].to_s
		cipher.iv = iv.hexdigest

		result = cipher.update params[:password].slice(0, 23)
		result << cipher.final
		pswd = Base64.strict_encode64 result

		resp = query_mokard(:regist, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => params[:mobile].to_s,
			:pass_word => pswd,
			:mobile => params[:mobile].to_s,
			:verification_code => params[:verification].to_s,
			:user_info => {
				"email" => params[:email].to_s,
				"passwordMD5" => pswd,
				Columns[:email] => params[:email].to_s,
				Columns[:password] => pswd
			}
		})

		if resp[:status] == "1"
			session[:username] = params[:mobile]
			session[:login] = true

#			fillinfo = query_mokard(:update_user_info, {
#				:merchant_no => Merchant,
#				:channel => Channel,
#				:user_name => session[:username].to_s,
#				:user_info => {
#					Columns[:email] => params[:email].to_s,
#					Columns[:password] => pswd
#				}
#			})

#			resp[:fillinfo] = fillinfo
			resp[:username] = session[:username].to_s
			resp[:status] = "2"
		else
			resp[:status] = "3"
		end

		respond_with resp, :location => nil
	end


	def login
		session[:username] = nil
		session[:login] = nil

		if not simple_captcha_valid?
			respond_with ret = { :status => "2" }, :location => nil and return
		end

		resp = query_mokard(:get_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => params[:username].to_s
		})

		if not resp
			respond_with ret = { :status => "0", :description => "No such user" }, :location => nil and return
		end

		pswd = resp[:return_value][Columns[:password]]
		pswd = Base64.strict_decode64 pswd

		cipher = OpenSSL::Cipher::Cipher.new 'DES3'
		cipher.decrypt
		cipher.key = Acubens::Application.config.membership_secret_token

		iv = Digest::SHA256.new
		iv.update params[:username].to_s
		cipher.iv = iv.hexdigest

		clearpswd = cipher.update pswd rescue nil
		clearpswd << cipher.final rescue nil

		hash = Digest::SHA256.new
		hash.update clearpswd
		hash.update params[:captcha].to_s

		if hash.hexdigest == params[:password]
			session[:username] = params[:username]
			session[:nickname] = resp[:return_value][:nick_name]
			session[:gender] = resp[:return_value][:gender_id]
			session[:login] = true
			respond_with ret = { :status => "1" }, :location => nil
		else
			respond_with ret = { :status => "0", :hash => hash.hexdigest, :pswd => params[:password],
					   :clear => clearpswd, :resp => resp, :description => "Wrong password" }, :location => nil
		end
	end


	def logout
		session[:username] = nil
		session[:login] = nil

		redirect_to '/'
	end


	def changepsw
		cipher = OpenSSL::Cipher::Cipher.new 'DES3'
		cipher.encrypt
		cipher.key = Acubens::Application.config.membership_secret_token

		iv = Digest::SHA256.new
		iv.update session[:username].to_s
		cipher.iv = iv.hexdigest

		result = cipher.update params[:password].slice(0, 23)
		result << cipher.final
		pswd = Base64.strict_encode64 result

		resp = query_mokard(:update_user_pwd, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => session[:username].to_s,
			:new_password => pswd,
			:code => params[:verification].to_s,
		})

		respond_with resp, :location => nil
	end


	def fillinfo
		resp = query_mokard(:update_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => session[:username].to_s,
			:user_info => {
				"nickName" => params[:fullname].to_s,
				"mobile" => session[:username].to_s,
				"genderID" => params[:gender].to_s,
				"birthdayDT" => params[:birthdate].to_s,
				Columns[:subscription] => params[:subscription].to_s,
				Columns[:phone] => params[:phone].to_s,
				Columns[:weibo] => params[:weibo].to_s,
				Columns[:wechat] => params[:wechat].to_s
			}
		})

		resp[:username] = session[:username].to_s

		respond_with resp, :location => nil
	end


	def getinfo
		resp = query_mokard(:get_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => session[:username].to_s
		})

		respond_with resp, :location => nil
	end


	def getaddr
		resp = query_mokard(:get_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => session[:username].to_s,
			:address_id => params[:id].to_s
		})

		respond_with resp, :location => nil
	end


	def addaddr
		resp = query_mokard(:insert_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => session[:username].to_s,
			:my_user_address => {
				"id" => params[:id].to_s,
				"buyerName" => params[:name].to_s,
				"buyerContact1" => params[:mobile].to_s,
				"buyerContact2" => params[:phone].to_s,
				"fullAddress" => params[:address].to_s,
				"zipCode" => params[:zipcode].to_s,
				"province" => params[:province].to_s,
				"city" => params[:city].to_s,
				"district" => params[:district].to_s
			}
		})

		respond_with resp, :location => nil
	end


	def updateaddr
		resp = query_mokard(:update_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => session[:username].to_s,
			:my_user_address => {
				"id" => params[:id].to_s,
				"buyerName" => params[:name].to_s,
				"buyerContact1" => params[:mobile].to_s,
				"buyerContact2" => params[:phone].to_s,
				"fullAddress" => params[:address].to_s,
				"zipCode" => params[:zipcode].to_s,
				"province" => params[:province].to_s,
				"city" => params[:city].to_s,
				"district" => params[:district].to_s
			}
		})

		respond_with resp, :location => nil
	end


	def deladdr
		resp = query_mokard(:delete_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => session[:username].to_s,
			:address_id => params[:id].to_s
		})

		respond_with resp, :location => nil
	end


	def getpoint
		resp = query_mokard(:get_points, {
			:merchant_no => Merchant,
			:channel => Channel,
			:username => session[:username].to_s,
			:type => params[:type].to_s
		})

		respond_with resp, :location => nil
	end


	def getusers
#		if not refinery_user?
#			respond_with ret = { :status => "0" }, :location => nil and return
#		end

		resp = query_mokard(:get_user_info_list, {
			:merchant_no => Merchant
		})

		respond_with resp, :location => nil
	end


	def getdict
		resp = query_mokard(:get_dictionary_all, {
			:type => params[:type].to_s
		})

		respond_with resp, :location => nil
	end


	private

	def query_mokard(method, data)
		response = Client.call(method, message: data)
		method_response = (method.to_s + "_response").to_sym
		method_result = (method.to_s + "_result").to_sym
		return response.body[method_response][method_result]
	end


	def checklogin
#		if not session[:login] or not session[:username]
#			respond_with ret = { :status => "0" }, :location => nil and return
#		end
		session[:username] = "13333367890"
	end

end
