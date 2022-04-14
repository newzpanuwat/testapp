class Api::V1::CategoriesController < Api::ApiController
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.includes(:products).order('created_at ASC')
    render_ok(categories: @categories)
  end

  def show
    render_ok(category: @category)
  end

  def create
    category = Category.new(category_params)
    category.save ? render_created(category: category) : render_bad_request(message: errors_msg(category) )
  end

  def update
    @category.update(category_params) ? render_ok(category: @category) : render_bad_request(message: errors_msg(@category))
  end

  def destroy
    @category.destroy ? render_ok(message: 'Category deleted.') : render_bad_request(message: errors_msg(@category))
  end

  private

  def set_category
    @category = Category.includes(:products).find_by(id: params[:id])
    render_not_found unless @category
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
