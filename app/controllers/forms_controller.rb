class FormsController < ApplicationController

  before_action :find_form, only: [:show, :edit, :update, :destroy]
  helper_method :current_or_guest_user
  before_action :current_or_guest_user

  def show
  # Calculate costs and display outputs 
    @tax_income = @form.tax_income(@form['income'])
    # @form.neighborhood_cost
    @healthcare_cost = @form.healthcare_cost(@form['healthcare'])
    @personal_savings =  @form.personal_savings(@form['income'], @form['savings'])
    # @dining_cost = @form.dining_cost(@form.dining_out_low, @form.dining_out_medium, @form.dining_out_high)
    @dining_cost = @form.dining_cost(@form["dining_out_low"], @form["dining_out_medium"], @form["dining_out_high"]) 
    # @form.cabs_cost
    @cabs_cost = @form.cabs_cost(@form['cabs'])
    @transportation_cost = @form.transportation_cost(@form['mass_transit_trips'])
    # @form.driving_cost
    # @form.travel_cost
    # @form.gym_cost #golds-gym prices: 499.99
    # @form.recreation_cost
    # @form.shopping_cost
    # @form.total_cost
    @total_cost = @dining_cost + @transportation_cost + @cabs_cost # - @savings
    @user = current_or_guest_user
  end

  def new
    @form = current_or_guest_user.forms.new 
    @neighborhoods = Neighborhood.where(state: "DC").order(:name)
    @health_options = @form.healthcare_options
    # @form.savings_options
    # @form.eating_out_options
    # @form.cabs_options
    # @form.public_transportation_options = @form.transportation_cost
    # @form.driving_options
    # @form.travel_options
    # @form.gym_options
    # @form.recreation_options
    # @form.shopping_options
  end

  def create
    @user = current_or_guest_user
    @form = @user.forms.new(forms_params)
    cooking_cost = 5
    @groceries = (21 - @form["dining_out_low"] + @form["dining_out_medium"] + @form["dining_out_high"]) * cooking_cost
    if @form.save
      @form.update(neighborhood_id: params[:neighborhood], groceries: @groceries)
      @user.update(form_id: @form.id)
      # @form_to_save = @form 
      redirect_to @form
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @form.update(forms_params)
      redirect_to @form
    else
      render :edit
    end
  end

  def destroy # If the user chooses not to save her form
  end

  private

    def forms_params
      params.require(:form).permit(
        :income, 
        :neighborhood,
        :healthcare,
        :savings,
        :dining_out_low,
        :dining_out_medium,
        :dining_out_high,
        :driving_trips,
        :car_trip_duration,
        :mass_transit_trips,
        :groceries,
        :cabs,
        :recreation,
        :shopping
      )
    end

    def find_form
      @form = Form.find(params[:id])
    end

end
