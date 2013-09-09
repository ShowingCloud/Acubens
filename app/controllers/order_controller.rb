#encoding: utf-8
require 'json'

class OrderController < ApplicationController

	respond_to :json, :xml

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
	end


	private

	def query_800ts(method, data)
		response = Client.call(method, message: data)
		method_response = (method.to_s + "_response").to_sym
		method_result = (method.to_s + "_result").to_sym
		return response.body[method_response][method_result]
	end

end
