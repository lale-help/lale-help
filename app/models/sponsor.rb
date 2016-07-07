class Sponsor < ActiveRecord::Base
  
  validates :name, presence: true
  validates :url, url: { allow_blank: true }

  has_many :sponsorships, dependent: :destroy

  # temp placeholder for the view
  def logo_url
    "https://placeholdit.imgix.net/~text?txtsize=36&bg=ffffff&txtclr=000000&txt=#{name}&w=125&h=125&fm=jpg&txttrack=0"
  end
end
