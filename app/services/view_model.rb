require 'cell/translation'

# a simple wrapper around cells to hide the implementation and contain common stuff
class ViewModel < Cell::ViewModel

  include ActionView::Helpers::TranslationHelper
  include Cell::Translation

  def t(key, options = {})
    if key.starts_with?('.')
      scope  = ['cells']
      scope << self.class.to_s.split('::').map { |s| s.underscore.gsub('_cell', '') }
      options = {scope: scope.join('.')}.merge(options)
    end
    I18n.t(key, options)
  end
end