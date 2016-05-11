# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'AMEX.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  v = Stock.new
  v.ticker = row['Symbol']
  v.name = row['Name']
  v.parent_id = 395
  v.save
  puts "#{v.ticker}, #{v.name} saved"
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'index.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  v = Stock.new
  v.id = 395
  v.ticker = row['Symbol']
  v.name = row['Name']
  v.save
  puts "#{v.ticker}, #{v.name} saved"
end
