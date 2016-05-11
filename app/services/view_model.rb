require 'cell/translation'

# a simple wrapper around cells to hide the implementation and contain common stuff
class ViewModel < Cell::ViewModel

  include ActionView::Helpers::TranslationHelper
  include Cell::Translation

  def t(key, options = {})
    if key.starts_with?('.')
      scope  = ['cells']
      scope << self.class.to_s.split('::').map { |s| s.underscore.gsub('_cell', '') }
      I18n.t(key, {scope: scope.join('.')}.merge(options))
    else
      I18n.t(key, options)
    end
  end
  # end superclass stuff
end