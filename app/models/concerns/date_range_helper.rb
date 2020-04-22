module DateRangeHelper
  extend ActiveSupport::Concern

  class_methods do
    def fetch_date_range(date)
      date = fetch_date(date)
      date.beginning_of_day..date.end_of_day
    end

    def fetch_date(date)
      begin
        Date.parse(date)
      rescue => exception
        Date.today
      end
    end
  end
end
