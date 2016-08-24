#
# This is a method for translating ActiveRecord enum values.
#
# 1. Add translations like in this example
# 
# en:
# activerecord:
#   attributes:
#     user:
#       statuses:
#         active: "Active"
#         pending: "Pending"
#         archived: "Archived"
# 
# 2. then you can do
# 
# User.human_enum_name(:status, :pending)
# => "Pending"
# 
# taken from: http://stackoverflow.com/a/36335591
# 
# FIXME monkeypatching Rails is so 1999.
# Move this to ApplicationRecord when upgrading to Rails 5.
# 
class ActiveRecord::Base
  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
end