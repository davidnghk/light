json.array!(@stocks) do |stock|
  json.extract! stock, :id, :ticker, :name, :last_price, :pricing_date, :return, :risk, :sharpe, :alpha
  json.url stock_url(stock, format: :json)
end
