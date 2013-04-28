class Admin::InvoicesController < ApplicationController
  before_filter :require_admin, except: [:show]

  def index
    @url_date = Date.new(params[:year].to_i, params[:month].to_i)
    @previous_month_start_date = @url_date - 1.month
    @total_fees = Order.total_monthly_fees(@previous_month_start_date)
    @stores = Store.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @orders = @invoice.store.orders
    if @invoice.store.admins.include?(current_user) || (current_user && current_user.platform_administrator)
      render 'show'
    else
      flash[:error] = "Sorry, you are not authorized to access this page."
      redirect_to root_url
    end
  end

  def update
    invoice = Invoice.find(params[:id])

    if invoice.update_attributes(params[:invoice])
      #  render :json => {:status => "success", :notice => "Successfully changed status of invoice."}
      flash.now[:alert] = "Successfully changed status of invoice."
    else
      flash.now[:error] = "Unable to mark invoice as paid"
    end
  end

  def pay
    @invoice = Invoice.find(params[:id])
    @fee     = params[:fee]
  end

  def submit_payment
    invoice = Invoice.find(params[:id])

    if invoice.update_attributes(params[:invoice])
      redirect_to admin_invoice_path(invoice), :notice => "Your invoice has been successfully paid."
    else
      render :pay, :notice => "We were unable to process your payment."
    end
  end

  def generate_invoices
    @stores = Store.all

    @stores.each do |store|
      orders = store.orders
      InvoiceService.create(orders)
      store.admins.each do |admin|
        UserMailer.delay.monthly_invoice(admin)
      end
    end

    redirect_to :back, :notice => "Your invoices have been created."
  end

  private

  def require_admin
    unless current_user && current_user.platform_administrator
      flash[:error] = "Sorry, you are not authorized to access this page."
      redirect_to root_url
    end
  end
end
