require 'spec_helper'

describe LineItemsController do

  let(:product) { Product.create(:name => "Test") }
  let(:cart) { Cart.create }

  def valid_attributes
    { product_id: product.id, cart_id: cart.id }
  end

  describe "POST create" do
    let(:product) {stub(:product, id: 1)}
    let(:line_item) {stub(:line_item, save: true)}

    before (:each) do
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/'
      Product.should_receive(:find)
    end

    describe "with valid params" do
      it "creates a new LineItem" do
        Cart.any_instance.should_receive(:add_product).and_return(line_item)  
        post :create, {product_id: product.id, cart_id: cart.id}
        #expect(response).to redirect_to(@request.env['HTTP_REFERER'])
      end

      it "assigns a newly created line_item as @line_item" do
        post :create, {product_id: product.id}
        assigns(:line_item).should be_a(LineItem)
        assigns(:line_item).should be_persisted
      end

      it "redirects to the created line_item" do
        post :create, {product_id: product.id}
        response.should redirect_to("http://localhost:3000/")
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved line_item as @line_item" do
        LineItem.any_instance.stub(:save).and_return(false)
        post :create, { "product_id" => product.id }
        assigns(:line_item).should be_a_new(LineItem)
      end

      it "re-renders the 'new' template" do
        LineItem.any_instance.stub(:save).and_return(false)
        post :create, { "product_id" => product.id }
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested line_item" do
      line_item = LineItem.create!(product_id: product.id, cart_id: cart.id)
      expect {
        delete :destroy, {:id => line_item.to_param}
      }.to change(LineItem, :count).by(-1)
    end
  end

  describe "PUT commands" do
    before (:each) do
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/'
    end

    describe "quantity" do
      it "increases quantity" do
        cart.add_product(product)
        expect{
          put :increase, :id => 1
        }.to change{cart.line_items.first.quantity}.by(1)
      end

      it "decreases quantity" do
        cart.add_product(product, 3)
        expect{
          put :decrease, :id => 1
        }.to change{cart.line_items.first.quantity}.by(-1)
      end

      it "deletes quantity" do
        cart.add_product(product,1)
        put :decrease, :id => 1
        expect(cart.line_items.count).to eq(0)
      end
    end
  end
end
