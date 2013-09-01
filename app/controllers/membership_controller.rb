#encoding: utf-8
require 'digest/sha2'
require 'json'

class MembershipController < ApplicationController

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

		resp = resp[:verfied_mobile_by_sms_response][:verfied_mobile_by_sms_result]
		if not refinery_user?
			resp.delete :return_value
		end
		render :json => resp.to_json
	end

	private

	def query_mokard(method, data)
		response = Client.call(method, message: data)
		return response.body
	end

end
