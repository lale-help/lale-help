class Sponsor < ActiveRecord::Base
  
  validates :name, presence: true
  validates :url, url: { allow_blank: true }

  has_many :sponsorships
end
