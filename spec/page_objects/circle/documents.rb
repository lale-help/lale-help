module PageObject
  module Circle
    class Documents < PageObject::Page

      set_url '/circles/{circle_id}/documents{?as}'

      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'

      sections :circle_documents, '.tab.circle-documents' do
        element :name, 'td:nth-child(1)'
      end

      # wg == working_group
      sections :wg_documents, '.tab.working-group-documents' do
        element :working_group_name, 'td:nth-child(1)'
        element :name, 'td:nth-child(2)'
      end


      def has_circle_document?(document)
        has_document?(circle_documents, document)
      end

      def has_wg_document?(document)
        has_document?(wg_documents, document)
      end

      private

      def has_document?(documents, document_to_find)
        documents.any? do |document_row|
          document_row.name.text == document_to_find.name
        end
      end

    end
  end
end