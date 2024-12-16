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
    db.execute(<<-SQL)
      CREATE TABLE lifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deadlift FLOAT NOT NULL,
        shoulderpress FLOAT NOT NULL,
        benchpress FLOAT NOT NULL
      )
    SQL
  end

  def self.populate_tables
    db.execute(<<-SQL, [40.0, 20.0, 30.0])
      INSERT INTO lifts (deadlift, shoulderpress, benchpress)
      VALUES (?, ?, ?)
    SQL
  end

  private

  def self.db
    @db ||= SQLite3::Database.new('./fit5x.sqlite').tap do |db|
      db.results_as_hash = true
    end
  end
end

Seeder.seed!
