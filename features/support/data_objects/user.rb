class User < Checks
  attr_reader :id
  attr_reader :name
  attr_reader :username
  attr_reader :email
  attr_reader :address
  attr_reader :posts
  @posts = []


  def initialize (user_data)
    @id = user_data['id']
    @name = user_data['name']
    @username = user_data['username']
    @email = user_data['email']
    @address = user_data['address']
  end

  def set_user_posts(posts)
    @posts = posts
  end

  def has_products?
    @product_types.length > 0
  end

  def has_correct_data_types?
    @id.is_a?(Integer) &&
        @ref.is_a?(String) &&
        @name.is_a?(String) &&
        @image_url.is_a?(String) &&
        @product_types.is_a?(Array)
  end
end