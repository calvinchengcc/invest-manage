class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/stats
  # GET /users/stats.json
  def stats
    @stats = {}
    @stats[:total_users] = User.count
    @stats[:total_admins] = User.admin.count
    @stats[:total_advisors] = User.advisor.count
    @stats[:average_principal] = Portfolio.average(:principal).round(2)
    @stats[:average_cash] = Portfolio.average(:cash).round(2)
    @stats[:min_principal] = Portfolio.minimum(:principal).round(2)
    @stats[:max_principal] = Portfolio.maximum(:principal).round(2)
  end

  # GET /users/1
  # GET /users/1.json
  # GET /users/1?show[]=companies
  # GET /users/1?show[]=companies&show[]=total-principal
  def show
    if params.has_key?('show')
      arr = Array.wrap(params[:show])
      arr.each do |val|
        case val
          when 'companies'
            @companies = companies_invested_in(@user)
          when 'total-principal'
            @total_principal = total_principal(@user)
        end
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def companies_invested_in(user)
    Stock.find_by_sql(['SELECT S.id, S.symbol, S.exchange_id, S.name
                        FROM users U
                        INNER JOIN portfolios P
                          ON U.id = P.owner_id
                        INNER JOIN holdings H
                          ON H.portfolio_id = P.id
                        INNER JOIN Stocks S
                          ON S.id = H.stock_id
                        WHERE U.id = ?',
                       user.id])
  end

  def total_principal(user)
    User.count_by_sql(['SELECT SUM(principal)
                        FROM users U
                        INNER JOIN portfolios P
                          ON U.id = P.owner_id
                        WHERE U.id = ?',
                      user.id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :role, :phone, :address_id)
  end
end
