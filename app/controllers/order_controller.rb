#encoding: utf-8
require 'json'
require 'digest/md5'

class OrderController < ApplicationController

	respond_to :json, :xml

#	before_filter :checklogin, :checkcaptcha, :only => :setorder

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
		addr = Membership.getanaddr session[:username]

		begin
			product = Membership.getpointredeemproducts[:return_value][:points_redeem_product]
			product = product.find { |item| item[:id] == params[:id] }

			points = Membership.getpoint(session[:username], 1)[:value].to_i
			points -= PendingOrder.where(username: session[:username]).sum('points').to_i
		rescue
			respond_with ret = { :status => -1 }, :location => nil and return
		end

		if points < product[:points].to_i
			respond_with ret = { :status => 0 }, :location => nil and return
		end

		resp = Order.setorder session[:username], addr, product

		if resp
			@pending_order = PendingOrder.new
			@pending_order.orderid = resp
			@pending_order.username = session[:username].to_s
			@pending_order.points = product[:points].to_i
			@pending_order.save
		end

		respond_with ret = { :status => resp }, :location => nil and return
	end


	def updateorder
		md5 = Digest::MD5.new
		md5.update params[:orderid] if params[:orderid]

		if not md5.hexdigest == params[:orderid_md5]
			respond_with ret = { :status => 2 }, :location => nil and return
		else
			@pending_order = PendingOrder.find :first, :conditions => { :orderid => params[:orderid_md5] }

			if not @pending_order
				respond_with ret = { :status => 0 }, :location => nil and return
			end

			@pending_order.destroy
			respond_with ret = { :status => 1, :info => @pending_order }, :location => nil
		end
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
