require 'rails_helper'

RSpec.describe CalendarLeafCell, type: :cell do

  include RSpecHtmlMatchers

  context 'cell rendering' do
    
    let(:date) { Date.parse("2016-12-24") }

    context "without options" do
      let(:html) { cell(:calendar_leaf, date).call }

      it "renders month" do
        expect(html).to have_tag('.calendar-leaf .month', text: 'DEC')
      end

      it "renders week" do
        expect(html).to have_tag('.calendar-leaf .day_number', text: '24')
      end
      
      it "renders weekday" do
        expect(html).to have_tag('.calendar-leaf .day-of-week', text: 'Sat')
      end
    end

    context "with options" do
      let(:html) { cell(:calendar_leaf, date, class: 'task-date', data: {foo: 'bar'}).call.to_s }
      it "passes them through as attributes on the outer tag" do
        expect(html).to have_tag('.calendar-leaf.task-date[data-foo=bar]')
      end
    end

    context "with icon" do
      let(:html) { cell(:calendar_leaf, date, with_icon: :project).call }

      it "renders icon" do
        expect(html).to have_tag('.calendar-leaf .month', text: 'DEC')
        expect(html).to have_tag('.calendar-leaf .project-icon i')
      end
    end
  end

end
