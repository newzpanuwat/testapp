class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

   devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         jwt_revocation_strategy: JwtDenylist

   validates :email, uniqueness: true, presence: true
   validates :password, presence: true, :on => :create, length: { in: 8..256 }
   validates :password_confirmation, presence: true, :on => :create
    
end
