json.array!(@stock_prices) do |stock_price|
  json.extract! stock_price, :id, :trade_date, :open, :volume, :high, :low, :close, :adj_close, :return, :stock_id
  json.url stock_price_url(stock_price, format: :json)
end
