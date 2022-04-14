class ProductSerializer 
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :qty
end
