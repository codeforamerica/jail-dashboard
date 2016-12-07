module PagesHelper
  def present_percent(count, total)
    percent_as_decimal = count.to_f / total.to_f * 100
    number_to_percentage(percent_as_decimal, precision: 1)
  end
end
