# SReq
simple composable api requests for ruby

### Example 

* Can run test using SReq::test

>		BASE_URL = "https://cardanoscan.io/"
>		CARDANO_TX_URL = SReq::create_url(base_url, "transaction/{{id}}", ["name", "age"])
>		# generates "https://cardanoscan.io/transaction/{{id}}?name={{name}}&age={{age}}"

>		SReq::GET(CARDANO_TX_URL, {"id" => "0x1234", "name" => "abc", "age" = 23}).body
>		# makes api call to "https://cardanoscan.io/transaction/0x1234?name=Oswald&age=23"
	
