#encoding: utf-8

class Order
	extend Savon::Model

	client wsdl: "http://210.13.83.245/GelnicWebServiceTest/OfficialService.asmx?WSDL",
		namespace: "http://tempuri.org/",
		convert_request_keys_to: :camelcase,
		soap_version: 2,
		logger: Rails.logger

	operations :set_order


	def self.setorder(username)
		self.query_800ts(:set_order, {
			"orderJson" => {
				"orderid" => 1,
				"customerid" => username.to_s,
				"score" => 1,
				"ordertime" => 1,
				"Receiver" => 1,
				"ReceiverProvince" => 1,
				"ReceiverCity" => 1,
				"ReceiverDistrict" => 1,
				"ReceiverAddress" => 1,
				"ReceiverMobile" => 1,
				"ReceiverTel" => 1,
				"ReceiverPostCode" => 1,
				"item" => 1
			}
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
