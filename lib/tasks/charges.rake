namespace :charges do
  desc "import charges data from flat file"
  task import: :environment do
    require 'csv'

    Charge.transaction do
      puts "reading charges"
      # This is a temporary path for the CSV; just wanted to get things up and running, will replace once ETL process more clearly defined
      charges = CSV.read("#{Rails.root}/tmp/charges.csv")
      columns = [:jms_charge_id, :booking_id, :description, :code, :category, :court_case_number, :bond_amount]
      Charge.import columns, charges, validate: false
      puts "charges imported"
    end
  end

  desc 'generate charges'
  task :generate, [:count] => [:environment] do |_, args|
    count = (args[:count] || 10).to_i

    puts "Generating #{count} charges for last #{count} bookings"
    Charge.transaction do
      bookings = Booking.order(:created_at).last(count)

      codes = ['42215','23301','02620','13162','10000','10060','52197','22061','02760','02668','02648','01600','49012','12002','00803','02304','38010','10993','00822','10001','49041','25019','42054','01402','09150','02617','02906','13201','13242','10002']
      descriptions = ['DRUGS','THEFT','DUI','ASSAULT','GENERAL FELONY','KIDNAPPING','WEAPONS','BURGLARY','DV PROTECTIVE ORDER','PROBATION/PAROLE VIOLATION','CONTEMPT OF COURT','PROSTITUTION','FUGITIVE ESCAPE','ROBBERY','MENACING','ALCOHOL','FLAGRANT NON SUPPORT','RAPE','TERRORISTIC THREATS','OTHER','HINDERING/INTIMIDATING','FORGERY','FRAUD','NON-SUPPORT','MURDER','TRAFFIC','WARRANT','CHILD ENDANGERMENT','STALKING','TRESPASSING']

      count.times do |index|
        booking_date_time = Faker::Time.between(6.days.ago, DateTime.now)
        Charge.create!(
          jms_charge_id: Faker::Code.ean,
          booking_id: bookings[index],
          code: codes[rand(0..29)],
          description: descriptions[rand(0..29)],
          category: ['MISDEMEANOR','FELONY','VIOLATION','ORDINANCE','NON-CRIMINAL'].sample,
          court_case_number: Faker::Number.hexadecimal(8),
          bond_amount: ['', 0.00, 100.00, 150.00, 250.00, 500.00, 750.00, 1000.00, 5000.00, 10000.00].sample
        )
      end
    end

    puts "Successfully generated #{count} charges"
  end
end
