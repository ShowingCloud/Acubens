#encoding: utf-8
require 'json'
require 'digest/md5'

class OrderController < ApplicationController

	respond_to :json, :xml

	before_filter :checklogin, :checkcaptcha, :only => :setorder


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
			product_points = product[:points].to_i

			points = Membership.getpoint(session[:username], 1)[:value].to_i
			points -= PendingOrder.where(username: session[:username]).sum('points').to_i
		rescue
			respond_with ret = { :status => -1 }, :location => nil and return
		end

		if points < product_points
			respond_with ret = { :status => 0 }, :location => nil and return
		end

		resp = Order.setorder session[:username], addr, product

		if resp
			@pending_order = PendingOrder.new
			@pending_order.orderid = resp
			@pending_order.username = session[:username].to_s
			@pending_order.points = product_points
			@pending_order.save

			respond_with ret = { :status => resp }, :location => nil and return
		else
			respond_with ret = { :status => -2 }, :location => nil and return
		end
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
