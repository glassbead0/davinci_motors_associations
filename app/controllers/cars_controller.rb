class CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy, :claim, :unclaim]


  def index
    @cars = Car.where(user_id: nil).paginate( page: params[:page], per_page: 20)
  end

  def new
    @car = Car.new
  end

  def edit
  end

  def show
  end

  def claim
    if current_user
      current_user.cars << @car
      redirect_to root_path, notice: "#{@car.make} #{@car.model} added to your inventory"
    end
  end

  def unclaim
    current_user.cars.delete(@car)
    redirect_to my_cars_path, notice: "You no longer own #{@car.make} #{@car.model}"

  end

  def mine
    @cars = Car.where(user_id: current_user.id).paginate( page: params[:page], per_page: 20)
  end

  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: 'Car was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @car = Car.new(car_params)
    creation_message = "#{@car.year} #{@car.make} #{@car.model} has been created."

    if @car.save
      redirect_to root_path, notice: creation_message
    end
  end

  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Car was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    def car_params
      params.require(:car).permit(:make, :model, :year, :price)
    end
end
