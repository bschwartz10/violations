require 'csv'

class FileLoader

  def self.load_csv(violations_csv)
    ViolationRepo.new(CSV.open violations_csv, headers: true, header_converters: :symbol)
  end

end

class ViolationRepo
  attr_reader :violations_data

  def initialize(violations_data)
    @violations_data = violations_data
  end

  def violations
    violations_data.map do |row|
      Violation.new(row)
    end
  end

  def sort_violation_dates
    violations.sort_by do |violation|
      violation.violation_date
    end
  end

  def violation_counts_and_dates_per_type
    grouped_by_violations = sort_violation_dates.group_by do |violation|
      violation.violation_type
    end
    grouped_by_violations.map do |kind, violation|
      "#{kind}'s".ljust(49) + "| #{violation.count}".ljust(6) + "| #{violation.first.violation_date} |" + " #{violation.last.violation_date} |"
    end
  end
end

class Violation
  attr_reader :violation_type, :violation_date

  def initialize(violation)
    @violation_type = violation[:violation_type]
    @violation_date = violation[:violation_date]
  end
end

violations_csv = "./violations_data.csv"
violations_repo = FileLoader.load_csv(violations_csv)
puts "                   Types                         |Count|    Earliest Date    |    Lastest Date     |"
puts violations_repo.violation_counts_and_dates_per_type
