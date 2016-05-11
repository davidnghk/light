class StocksController < ApplicationController
  helper_method :sort_column, :sort_direction
  layout '_base'
  before_action :set_stock, only: [:show, :edit, :update, :destroy]


  def chart
    if params[:search]
      @stocks = Stock.where("parent_id is NOT NULL").search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page])
    else
      @stocks = Stock.where("return is not null and parent_id is NOT NULL ").order(sort_column + " " + sort_direction).paginate(:page => params[:page])
    end
  end

  def search
    if params[:stock]
      @stock = Vehicle.find_by_ticker(params[:stock])
      @stock ||= Vehicle.new_from_lookup(params[:stock])
    end

    if @stock
      # render json: @stock
      render partial: 'lookup'
    else
      render status: :not_found, nothing: true
    end
  end

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all.paginate(:page => params[:page])
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    def sort_column
      Stock.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:ticker, :name, :price, :pricing_date, :return, :risk, :sharpe, :alpha)
    end
end
