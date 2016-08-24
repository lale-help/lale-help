module PageObject
  class Component
    class TabNav < PageObject::Component

      # keep me sorted alphabetically
      element :documents, 'a', text: /Documents/
      element :organizers, 'a', text: /Organizers/
      element :organizing, 'a', text: /Organizing/
      # a little hack to be able to add a load validation 
      # (this page object can be used for the volunteering and organizing tabs)
      element :organizing_active, 'a.selected', text: /Organizing/
      element :projects, 'a', text: /Projects/
      element :supplies, 'a', text: /Supplies/
      element :tasks, 'a', text: /Tasks/
      element :wg_documents, 'a', text: /Working Group Documents/

    end
  end
end