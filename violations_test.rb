gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative 'violations'
require 'csv'

class ViolationsTest < Minitest::Test

  def test_it_returns_a_csv_object
    assert_instance_of ViolationRepo, FileLoader.load_csv("./violations_data.csv")
  end

  def test_it_returns_an_array_of_violation_objects
    violations_csv = "./violations_data.csv"
    violations_repo = FileLoader.load_csv(violations_csv)

    assert_instance_of Violation, violations_repo.violations.first
  end

  def test_violation_has_a_violation_type_and_date_method
    violations_csv = "./violations_data.csv"
    violations_repo = FileLoader.load_csv(violations_csv)
    violation = violations_repo.violations.first
    assert_equal "Refuse Accumulation", violation.violation_type
    assert_equal "2012-01-03 00:00:00", violation.violation_date
  end

  def test_sort_violation_dates
    violations_csv = "./violations_data.csv"
    violations_repo = FileLoader.load_csv(violations_csv)

    assert_equal "2012-01-03 00:00:00", violations_repo.sort_violation_dates.first.violation_date
  end

  def test_earliest_violation_date_per_type
    violations_csv = "./violations_data.csv"
    violations_repo = FileLoader.load_csv(violations_csv)

    assert_equal "Unsanitary conditions, not specified's earliest violation date was 2012-01-03 00:00:00", violations_repo.earliest_violation_per_type.first
  end

end
