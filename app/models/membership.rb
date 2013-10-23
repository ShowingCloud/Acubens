#encoding: utf-8
require 'digest/sha2'
require 'openssl/cipher'
require 'base64'

class Membership
	extend Savon::Model

	client wsdl: "http://www.mokard.com/WSV26/PointRequest.asmx?WSDL",
		namespace: "http://tempuri.org/",
		convert_request_keys_to: :camelcase,
		soap_version: 2,
		logger: Rails.logger

	operations :verfied_mobile_by_sms, :regist, :get_user_info, :update_user_pwd,
		:update_user_info, :get_user_address, :insert_user_address, :update_user_address, 
		:delete_user_address, :gelnic_questionnaire_add_point, :get_points,
	   	:getpointsproduct_list, :get_points_redeem_product_list, :get_user_info_list,
		:get_dictionary_all, :get_point_list_data_and_order

	Channel = "Gelnic"
	Merchant = "1591"

	Columns = { :subscription => "column1", :postal => "column2", :phone => "column3", :weibo => "column4",
			:wechat => "column5", :taobao => "column6", :yihao => "column7", :email => "column8",
			:password => "column9", :dictionary => "column10" }


	def self.verifymobile(mobile)
		self.query_mokard(:verfied_mobile_by_sms, {
			:mobile => mobile.to_s
		})
	end


	def self.register(mobile, password, verification, email)
		cipher = OpenSSL::Cipher::Cipher.new 'DES3'
		cipher.encrypt
		cipher.key = Acubens::Application.config.membership_secret_token

		iv = Digest::SHA256.new
		iv.update mobile
		cipher.iv = iv.hexdigest

		result = cipher.update password.slice(0, 23)
		result << cipher.final
		pswd = Base64.strict_encode64 result

		self.query_mokard(:regist, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => mobile.to_s,
			:pass_word => pswd.to_s,
			:mobile => mobile.to_s,
			:verification_code => verification.to_s,
			:user_info => {
				"email" => email.to_s,
				"passwordMD5" => pswd.to_s,
				Columns[:email] => email.to_s,
				Columns[:password] => pswd.to_s
			}
		}).merge({ :password => pswd })
	end


	def self.login(username, password, captcha)
		resp = self.query_mokard(:get_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s
		})

		if not resp or not resp[:return_value]
			return { :status => 0, :description => "No such user" }
		end

		begin
			pswd = resp[:return_value][Columns[:password].to_sym]
			pswd = Base64.strict_decode64 pswd

			cipher = OpenSSL::Cipher::Cipher.new 'DES3'
			cipher.decrypt
			cipher.key = Acubens::Application.config.membership_secret_token

			iv = Digest::SHA256.new
			iv.update username
			cipher.iv = iv.hexdigest

			clearpswd = cipher.update pswd
			clearpswd << cipher.final

			hash = Digest::SHA256.new
			hash.update clearpswd
			hash.update captcha

		rescue
			Rails.logger.error $!.backtrace
			hash = Digest::SHA256.new
		end

		if hash.hexdigest == password
			return { :status => 1, :resp => resp }
		else
			return { :status => 0, :description => "Wrong password" }
		end
	end


	def self.changepsw(mobile, password, verification)
		cipher = OpenSSL::Cipher::Cipher.new 'DES3'
		cipher.encrypt
		cipher.key = Acubens::Application.config.membership_secret_token

		iv = Digest::SHA256.new
		iv.update mobile
		cipher.iv = iv.hexdigest

		result = cipher.update password
		result << cipher.final
		pswd = Base64.strict_encode64 result

		self.query_mokard(:update_user_pwd, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => mobile.to_s,
			:new_password => pswd.to_s,
			:code => verification.to_s
		}).merge({ :password => pswd })
	end


	def self.updateinfo(username, info = {})
		self.query_mokard(:update_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s,
			:user_info => {
				"email" => info[:email].to_s,
				"passwordMD5" => info[:password].to_s,
				"nichName" => info[:fullname].to_s,
				"genderID" => info[:gender].to_s,
				"birthdateDT" => info[:birthdate].to_s,
				Columns[:email] => info[:email].to_s,
				Columns[:password] => info[:password].to_s,
				Columns[:subscription] => info[:subscription].to_s,
				Columns[:phone] => info[:phone].to_s,
				Columns[:weibo] => info[:weibo].to_s,
				Columns[:wechat] => info[:wechat].to_s
			}.reject { |k, v| v.blank? }
		})
	end


	def self.getinfo(username)
		self.query_mokard(:get_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s
		})
	end


	def self.getaddr(username, id)
		self.query_mokard(:get_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username,
			:address_id => id == nil ? "-1" : id.to_s
		})
	end


	def self.addaddr(username, id, name, mobile, phone, address, zipcode,
					 province, city, district)
		self.query_mokard(:insert_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s,
			:my_user_address => {
				"id" => id.to_s,
				"buyerName" => name.to_s,
				"buyerContact1" => mobile.to_s,
				"buyerContact2" => phone.to_s,
				"fullAddress" => address.to_s,
				"zipCode" => zipcode.to_s,
				"province" => province.to_s,
				"city" => city.to_s,
				"district" => district.to_s
			}
		})
	end


	def self.updateaddr(username, id, name, mobile, phone, address, zipcode,
						province, city, district)
		self.query_mokard(:update_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s,
			:my_user_address => {
				"id" => id.to_s,
				"buyerName" => name.to_s,
				"buyerContact1" => mobile.to_s,
				"buyerContact2" => phone.to_s,
				"fullAddress" => address.to_s,
				"zipCode" => zipcode.to_s,
				"province" => province.to_s,
				"city" => city.to_s,
				"district" => district.to_s
			}
		})
	end


	def self.deladdr(username, id)
		self.query_mokard(:delete_user_address, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s,
			:address_id => id.to_s
		})
	end


	def self.getdefaddr(username)
		{ :status => 1, :defaddr => self.getfromdict(username, :defaddr) }
	end


	def self.setdefaddr(username, id)
		self.settodict username, :defaddr, id.to_i
		{ :status => 1 }
	end


	def self.getanaddr(username)
		addr = self.getaddr username, self.getdefaddr(username)[:defaddr]

		if addr[:status] != "1"
			addr = self.getaddr username, "-1"
		end

		if addr[:status] == "1"
			addr = addr[:return_value][:user_address]
			if addr.class == Array
				addr = addr[0]
			end
		end

		addr
	end


	def self.questionnaire(username)
		self.query_mokard(:gelnic_questionnaire_add_point, {
				"merchantNo" => Merchant,
				"channel" => Channel,
				"userName" => username.to_s
			})
	end


	def self.getpoint(username, type)
		self.query_mokard(:get_points, {
			"merchantNo" => Merchant,
			"channel" => Channel,
			"username" => username.to_s,
			"type" => type.to_s
		})
	end


	def self.getpointproducts
		self.query_mokard(:getpointsproduct_list, {
			:merchant_no => Merchant,
			:currentpage => 1,
			:eachpagecount => 100
		})
	end


	def self.getpointredeemproducts
		self.query_mokard(:get_points_redeem_product_list, {
			:merchant_no => Merchant,
			:currentpage => 1,
			:eachpagecount => 100
		})
	end


	def self.getpointlist(username, type)
		self.query_mokard(:get_point_list_data_and_order, {
			"merchantno" => Merchant,
			"channel" => Channel,
			"username" => username.to_s,
			:point_status => type.to_s,
			:point_type => 5,
			:currentpage => 1,
			:eachpagecount => 100
		})
	end


	def self.getusers
		self.query_mokard(:get_user_info_list, {
			:merchant_no => Merchant
		})
	end


	def self.getdict(type)
		self.query_mokard(:get_dictionary_all, {
			:type => type.to_s
		})
	end


	def self.getfromdict(username, method)
		resp = self.query_mokard(:get_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s
		})

		if method == :all
			begin
				resp = eval resp[:return_value][Columns[:dictionary].to_sym]
			rescue
				resp = {}
			end
		else
			begin
				resp = eval resp[:return_value][Columns[:dictionary].to_sym]
				resp = resp[method]
			rescue
				resp = nil
			end
		end

		resp
	end


	def self.settodict(username, method, value)
		dictionary = self.getfromdict username, :all

		if dictionary == nil
			dictionary = {}
		end

		dictionary[method] = value

		self.query_mokard(:update_user_info, {
			:merchant_no => Merchant,
			:channel => Channel,
			:user_name => username.to_s,
			:user_info => {
				Columns[:dictionary] => dictionary.to_s
			}
		})
	end


	private

	def self.query_mokard(remote_method, remote_data)
		method_response = (remote_method.to_s + "_response").to_sym
		method_result = (remote_method.to_s + "_result").to_sym

		ret = send remote_method, message: remote_data
		ret.body[method_response][method_result]
	end

end
