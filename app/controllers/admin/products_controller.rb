class Admin::ProductsController < AdminController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end


  def new
    @product = Product.new
  end


  def edit
  end

  def create
    @product = Product.new

      begin
        product_service(@product).process(params[:product][:title], params[:product][:text], params[:product][:price], params[:product][:category_id])
        redirect_to [:admin, @product]
      rescue ProductService::ProductError
        flash.now[:notice]=  'Something went wrong'
        render 'new' 
      rescue ProductService::TitleEmpty
        flash.now[:notice]=  'Title is empty'
        render 'new'
      rescue ProductService::TextNotValid
        flash.now[:notice]= 'Text is empty or too short'
        render 'new'
      rescue ProductService::PriceNotValid
        flash.now[:notice]=  'Price is empty or below 0'
        render 'new'
      rescue ProductService::CategoryNotValid
        flash.now[:notice]= 'Category is empty'
        render 'new'
      end
    

  end


  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [:admin,@product], notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :text, :price, :category_id)
    end

    def product_service(product)
      ProductService.new(product)
    end
end
