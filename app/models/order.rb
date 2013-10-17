#encoding: utf-8

class Order
	Extend Savon::Model

	client wsdl: "http://210.13.83.245/GelnicWebServiceTest/OfficialService.asmx?WSDL",
		namespace: "http://tempuri.org/",
		convert_request_keys_to: :camelcase,
		soap_version: 2,
		logger: Rails.logger

	operations :set_order


	def self.setorder(username)
		self.query_800ts(:set_order, {
			"orderJson" => {
				"orderid" =>,
				"customerid" => username.to_s,
				"score" =>,
				"ordertime" =>,
				"Receiver" =>,
				"ReceiverProvince" =>,
				"ReceiverCity" =>,
				"ReceiverDistrict" =>,
				"ReceiverAddress" =>,
				"ReceiverMobile" =>,
				"ReceiverTel" =>,
				"ReceiverPostCode" =>,
				"item" =>
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
