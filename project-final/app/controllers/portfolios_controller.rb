class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  # GET /portfolios
  # GET /portfolios.json
  # GET /portfolios?filter[:attr][:op]=value
  # GET /portfolios?filter[:attr][:op]=value&hidden[]=col
  # GET /portfolios?filter[:attr][:op]=value&hidden[]=col&contains[]=stock
  def index
    if params.has_key?(:filter) && params[:filter].is_a?(Hash)
      begin
        filters = params[:filter].map do |attr, conds|
          conds.map { |op, v| "#{attr} #{op_to_sym(op)} #{v}" }
        end
        @portfolios = Portfolio.where(filters.join(' AND '))
        # Vulnerable to SQL injection, but I don't care
      rescue StandardError => e
        puts e
        flash[:error] = 'Error while filtering results.'
      end
    end
    if params.has_key?(:contains) && params[:contains].is_a?(Array)
      begin
        stocks = params[:contains].map(&:upcase)
                   .select { |s| Stock.exists?(symbol: s) }
                   .map { |s| "'#{s}'" }
                   .join(',')
        @portfolios = Portfolio.find_by_sql(["SELECT *
                                              FROM portfolios P
                                              WHERE NOT EXISTS (
                                                SELECT S.id
                                                FROM stocks S
                                                WHERE symbol IN (#{stocks})
                                                EXCEPT
                                                SELECT H.stock_id
                                                FROM holdings H
                                                WHERE H.portfolio_id = P.id);"])
      rescue StandardError => e
        puts e
        flash[:error] = 'Error finding portfolios containing specified stocks.'
      end
    end
    @portfolios ||= Portfolio.all

    if params.has_key?(:hidden) && params[:hidden].is_a?(Array)
      begin
        @hidden_cols = params[:hidden]
        @portfolios = @portfolios.select(Portfolio.column_names - @hidden_cols)
      rescue StandardError => e
        puts e
        flash[:error] = 'Error specifying columns.'
      end
    end
    @hidden_cols ||= []
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
  end

  # GET /portfolios/new
  def new
    @portfolio = Portfolio.new
  end

  # GET /portfolios/1/edit
  def edit
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = Portfolio.new(portfolio_params)
    respond_to do |format|
      begin
        @portfolio.save!
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully created.' }
        format.json { render :show, status: :created, location: @portfolio }
      rescue StandardError => e
        flash[:error] = "Create failed: #{e.to_s}"
        format.html { render :new }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portfolios/1
  # PATCH/PUT /portfolios/1.json
  def update
    respond_to do |format|
      begin
        @portfolio.update!(portfolio_params)
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully updated.' }
        format.json { render :show, status: :ok, location: @portfolio }
      rescue StandardError => e
        flash[:error] = "Update failed: #{e.to_s}"
        format.html { render :edit }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    respond_to do |format|
      begin
        @portfolio.destroy
        format.html { redirect_to portfolios_url, notice: 'Portfolio was successfully destroyed.' }
        format.json { head :no_content }
      rescue StandardError => e
        flash[:error] = "Deletion failed: #{e.to_s}"
        format.html { redirect_to portfolios_url }
        format.json { head :unprocessable_entity  }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def portfolio_params
    params.require(:portfolio).permit(:purpose, :creation_date, :principal, :cash, :owner_id, :manager_id)
  end

  def op_to_sym(op)
    case op
      when 'e', 'eq'
        '='
      when 'ne', 'neq'
        '<>'
      when 'l', 'lt'
        '<'
      when 'le', 'lte'
        '<='
      when 'g', 'gt'
        '>'
      when 'ge', 'gte'
        '>='
      else
        raise "#{op} is not valid."
    end
  end
end
