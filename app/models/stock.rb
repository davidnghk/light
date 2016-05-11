class Stock < ActiveRecord::Base
  has_many :children, :class_name => "Stock", :foreign_key => :parent_id
  belongs_to :parent, :class_name => "Stock", :foreign_key => :parent_id
  
  has_many :stock_prices
     
  def self.search(search)
    where("return IS NOT NULL AND (ticker LIKE? OR name LIKE ?)", "#{search}%", "%#{search}%")
  end   
     
  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end 
  
  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless looked_up_stock.name
    
    new_Stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.name,
                      last_price: looked_up_stock.last_trade_price_only)
    new_Stock
  end
   
  def self.refresh_price 
    Stock.all.each do |v|
      s.last_price  = StockQuote::Stock.quote(s.ticker).last_trade_price_only
      s.save
    end
  end
  
  def self.get_price_history(ticker_symbol)
    @s=Stock.find_by_ticker(ticker_symbol)
    StockPrice.where("stock_id = ?", @s.id).delete_all

    begin
      history = StockQuote::Stock.history(ticker_symbol, Date.today-1.years, Date.today)
      first_record = true
      history.each do |sqh|
        if first_record == true
          @s.last_price = sqh.close
          @s.pricing_date = sqh.date
          first_record = false
        end
        sp = StockPrice.new
        sp.stock_id = @s.id
        sp.trade_date = sqh.date
        # sp.volume = sqh.volume
        sp.open = sqh.open
        sp.high = sqh.high
        sp.low  = sqh.low
        sp.close = sqh.close
        sp.adj_close = sqh.adj_close
        sp.save
      end
    rescue StandardError
      history = nil
    end
    @s.save
end 

def self.calc_stats(ticker_symbol)  
    @s=Stock.find_by_ticker(ticker_symbol)
    prev_adj_close = -1 
    return_sum = 0.0
    @s.stock_prices.sort_by { |m| m[:trade_date] }.each do |row|
      if prev_adj_close > 0 
         row.return = (row.adj_close - prev_adj_close) / prev_adj_close
         return_sum = return_sum + Math.log(1+row.return)
      end
      prev_adj_close = row.adj_close
      row.save
    end   

    stock_price = @s.stock_prices.where("return is NOT NULL").extend(DescriptiveStatistics)
    @s.no_of_prices = stock_price.number(&:return)
    if @s.no_of_prices > 20
      @s.return = Math.exp(return_sum) - 1
      @s.risk = stock_price.standard_deviation(&:return) * Math.sqrt(250) 
      @s.alpha = 0
      # @s.beta = 1.0
      if @s.parent_id
        @i = @s.parent
        @s.alpha = @s.return - ( @s.risk * (@i.return-0.02)/@i.risk ) - 0.02
      else
        alpha = 0 
      end 
      @s.sharpe = (@s.return - 0.02)/@s.risk
    else
      @s.return = nil
      @s.risk = nil
      @s.alpha = nil 
      @s.sharpe = nil 
     end
      @s.save     
   
  end  
  
  def self.benchmark(ticker_symbol)  
    require 'statsample'
    
    @a=Stock.find_by_ticker(ticker_symbol)
    @b=Stock.where(" id = 395" )
    
    @x = @a.StockPrice.order(:trade_date)
    @y = @b.StockPrice.order(:trade_date)
    
    ss_analysis("Statsample::Bivariate.correlation_matrix") do 
      ds=data_frame(@x, @y)
      cm=cor(ds) 
      summary(cm)
    end
   
  end 
  
  def self.get_prices
    stk = Stock.where(" parent_id is NULL ")
    stk.each do |row|
      get_price_history(row.ticker)
      calc_stats(row.ticker)
    end 
    stk = Stock.where(" parent_id is NOT NULL ")
    stk.each do |row|
      get_price_history(row.ticker)
      calc_stats(row.ticker)
    end      
  end   
  
  def self.set_index
    @v = Stock.where(id = 395)
    @s.parent_id = nil
    @s.save     
  end 
end
