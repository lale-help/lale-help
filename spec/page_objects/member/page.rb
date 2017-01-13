module PageObject
  module Member
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/members/{member_id}{?as}'

      include HasItemDetailsTable

      element :headline, '.member-header .title'
      # this relies on the fact that the image is added with a style="background-image..." attribute.
      # if the user hasn't uploaded an image, there'll be no style attribute.
      element :profile_image, '.member-header .user-icon[style]'

      element :block_button, '.button-secondary', text: "Block"
      element :unblock_button, '.button-secondary', text: "Unblock"

    end
  end
end