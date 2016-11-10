namespace :bonds do
  desc "import bonds data from flat file"
  task import: :environment do
    require 'csv'

    Bond.transaction do
      puts "reading bonds"
      # This is a temporary path for the CSV; just wanted to get things up and running, will replace once ETL process more clearly defined
      bonds = CSV.read("#{Rails.root}/tmp/bonds.csv")
      columns = [:charge_id, :amount]
      Bond.import columns, bonds, validate: false
      puts "bonds imported"
    end
  end
end
