require 'SReq'

class CardanoApi
  BASE_CARDANO_URL = "https://cardanoscan.io/".freeze
  CARDANO_TX_URL = SReq::create_url(BASE_CARDANO_URL, "transaction/{{id}}").freeze
  class << self
    def get_tx(id)
      SReq::GET(CARDANO_TX_URL, {"id" => id}).body
    end
  end
end

puts CardanoApi.get_tx("6bdaa18f2088402ee19056dcaf61a799aed9fd696544651b9199aa75faafe4e8")