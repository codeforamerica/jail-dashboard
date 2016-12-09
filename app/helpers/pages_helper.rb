module PagesHelper
  def present_percent(count, total)
    percent_as_decimal = if total.zero?
                           0
                         else
                           count.to_f / total.to_f * 100
                         end

    number_to_percentage(percent_as_decimal, precision: 1)
  end
end
