require 'faker'

class Sponsor < ActiveRecord::Base
  
  validates :name, presence: true
  validates :url, url: { allow_blank: true }

  has_many :sponsorships

  # temp placeholder for the view
  def logo_url
    Faker::Placeholdit.image("190x190", 'jpg', 'ffffff', '000', name)
  end
end
