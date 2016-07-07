class Sponsor < ActiveRecord::Base
  
  validates :name, presence: true, uniqueness: true
  validates :url, url: { allow_blank: true }

  has_many :sponsorships, dependent: :destroy
  has_one :image, class_name: FileUpload, as: :uploadable, dependent: :destroy

end
