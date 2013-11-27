class ProductsController < ApplicationController
	def new
		@product = Product.new
	end

	def create
  		@product = Product.new

      begin
        product_service(@product).process(params[:product][:title], params[:product][:text], params[:product][:price], params[:product][:category_id])
        redirect_to @product
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

	def show
  		@product = Product.find(params[:id])
	end

	def index
  		@products = Product.all
	end

	def edit
  		@product = Product.find(params[:id])
	end

	def update
  		@product = Product.find(params[:id])
 
  		if @product.update(params[:product].permit(:title, :text, :price, :category_id))
    		redirect_to @product
  		else
    		render 'edit'
  		end
	end

	def destroy
  		@product = Product.find(params[:id])
  		@product.destroy
 
  		redirect_to products_path
	end
 
 	

	private
 		def product_params
    		params.require(:product).permit(:title, :text, :price, :category_id)
  		end

    def product_service(product)
      ProductService.new(product)
    end
  

end
