class Admin::InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
    @stores = Store.all
  end

  def show
  end

  def update
    invoice = Invoice.find(params[:id])

    if invoice.update_attributes(params[:invoice])
      #  render :json => {:status => "success", :notice => "Successfully changed status of invoice."}
      flash.now[:notice] = "Successfully changed status of invoice."
    else
      flash.now[:error] = "Unable to mark invoice as paid"
    end
  end

  def generate_invoices
    @stores = Store.all

    @stores.each do |store|
      orders = store.orders
      InvoiceService.create(orders)
    end

    redirect_to admin_invoices_path, :notice => "Your invoices have been created."
  end
end
