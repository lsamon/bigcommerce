# frozen_string_literal: true

# Customers Controller
class CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.includes(:orders).find(params[:id])
    @lifetime_value = @customer.orders.sum(:subtotal_inc_tax)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Could not find customer with id #{params[:id]}"
    redirect_to customers_path
  end
end
