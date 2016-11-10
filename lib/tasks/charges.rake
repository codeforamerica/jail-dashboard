namespace :charges do
  desc "import charges data from flat file"
  task import: :environment do
    require 'csv'

    Charge.transaction do
      puts "reading charges"
      # This is a temporary path for the CSV; just wanted to get things up and running, will replace once ETL process more clearly defined
      charges = CSV.read("#{Rails.root}/tmp/charges.csv")
      columns = [:jms_id, :booking_id, :description, :code, :category, :court_case_number]
      Charge.import columns, charges, validate: false
      puts "charges imported"
    end
  end
end
