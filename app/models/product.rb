class Product < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :status
  belongs_to_active_hash :delivery_fee
  belongs_to_active_hash :shipping_method
  belongs_to :user, optional: true
  belongs_to :category
  belongs_to :brand
  accepts_nested_attributes_for :brand
  has_many :pictures, foreign_key: "product_id", dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true
  has_many :comments
  has_many :likes

  validates_associated :pictures
  validates :pictures, presence: { message: "してください"}
  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :status_id, presence: true
  validates :delivery_fee_id, presence: true
  validates :shipping_method_id, presence: true
  validates :prefecture, presence: true
  validates :date_of_ship_id, presence: true
  validates :sold_out, inclusion: { in: [true, false]}
  validates :price, numericality: { greater_than: 299, less_than: 10000000, message: "で入力してください"}

  include JpPrefecture
  jp_prefecture :prefecture, method_name: :pref

  def relateProducts(params)
    grandsonCategories = self.category.parent.parent.indirects
    results = []
    grandsonCategories.each do |category|
      category.products.each do |product|
        if product.id.to_i != params[:id].to_i
          results << product
        end
      end
    end
    return results
  end

  def self.search(search)
    return Product.all unless search
    Product.where('(name LIKE(?)) OR (description LIKE(?))', "%#{search}%", "%#{search}%")
  end
end
