require 'sqlite3'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS lifts')
  end

  def self.create_tables
    db.execute('CREATE TABLE lifts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                deadlift FLOAT,
                shoulderpress FLOAT,
                benchpress FLOAT)')
  end
  def self.populate_tables
    db.execute('INSERT INTO lifts (deadlift, shoulderpress, benchpress) VALUES (40, 20, 30)')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/fit5x.sqlite')
    @db.results_as_hash = true
    @db
  end
end



Seeder.seed!
