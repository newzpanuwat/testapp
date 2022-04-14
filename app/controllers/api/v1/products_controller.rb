class Api::V1::ProductsController < Api::ApiController
  before_action :set_category, only: [:show, :update, :destroy]
  before_action :order_product, only: [:index, :all]

  def index
    @products = @product_ordered.where(category_id: params[:category_id])
    render_ok(products: @products)
  end

  def show
    render_ok(product: @product)
  end

  def create
    product = Product.new(product_params)
    product.save ? render_created(product: product) : render_bad_request(message: errors_msg(product) )
  end

  def update
    @product.update(product_params) ? render_ok(product: @product) : render_bad_request(message: errors_msg(@product))
  end

  def destroy
    @product.destroy ? render_ok(message: 'Product deleted.') : render_bad_request(message: errors_msg(@product))
  end

  def all
   render_ok(products: @product_ordered)
  end

  private

  def order_product
    @product_ordered = Product.includes(:category).order('created_at ASC')
  end

  def set_category
    @product = Product.includes(:category).find_by(id: params[:id])
    render_not_found unless @product
  end

  def product_params
    params.require(:product).permit(:name, :qty, :category_id)
  end

end
