class ProductService
  class ProductError < StandardError; end
  class TitleEmpty < StandardError; end
  class TextNotValid < StandardError; end
  class PriceNotValid < StandardError; end
  class CategoryNotValid < StandardError; end

  attr_reader :product

  def initialize(product)
    @product = product
  end

  def process(title, text, price, category_id)
    raise TitleEmpty.new if title.empty?
    raise TextNotValid.new if text.empty? or text.length < 5
    raise PriceNotValid.new if price.empty? or (price.to_f < 0)
    raise CategoryNotValid.new if category_id.empty?

    begin
      @product = Product.new(title:title, text:text, price:price, category_id:category_id)

      @product.save!
      return @product
      

    rescue 
      raise ProductError.new $!.message
    end
  end
end