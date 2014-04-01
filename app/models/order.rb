#encoding: utf-8

class Order
	extend Savon::Model

	client wsdl: "http://121.196.130.3/ECLGelnicWS/OfficialService.asmx?WSDL",
		namespace: "http://tempuri.org/",
		convert_request_keys_to: :camelcase,
		soap_version: 2,
		logger: Rails.logger

	operations :set_order


	def self.setorder(username, addr, product)
		self.query_800ts(:set_order, {
			"orderJson" => ActiveSupport::JSON.encode({
				"customerid" => username.to_s,
				"score" => product[:points],
				"ordertime" => DateTime.now(),
				"Receiver" => addr[:buyer_name].to_s,
				"ReceiverProvince" => addr[:province].to_s,
				"ReceiverCity" => addr[:city].to_s,
				"ReceiverDistrict" => addr[:district].to_s,
				"ReceiverAddress" => addr[:full_address].to_s,
				"ReceiverMobile" => addr[:buyer_contact1].to_s,
				"ReceiverTel" => addr[:buyer_contact2].to_s,
				"ReceiverPostCode" => addr[:zip_code].to_s,
				"item" => [{
					"ID" => product[:id],
					"SKU" => product[:sku],
					"quantity" => 1,
					"productName" => product[:product_name],
					"Score" => product[:points]
				}]
			})
		})
	end


	private

	def self.query_800ts(remote_method, remote_data)
		method_response = (remote_method.to_s + "_response").to_sym
		method_result = (remote_method.to_s + "_result").to_sym

		ret = send remote_method, message: remote_data
		ret.body[method_response][method_result]
	end

end
