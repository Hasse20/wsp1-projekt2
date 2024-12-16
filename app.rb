require 'sinatra/base'
require 'sqlite3'


class App < Sinatra::Base
  def db
    return @db if @db

    @db = SQLite3::Database.new("./fit5x.sqlite")
    @db.results_as_hash = true

    return @db
  end

  get '/' do
    erb(:index)
  end

  get '/index' do
    erb :index
  end

  get '/program' do
    @lifts = db.execute('SELECT * FROM lifts')
    erb(:program)
  end

  get '/program/new' do
    erb(:'lifts/new')
  end

  post '/program' do
    deadlift = params["deadlift"].to_f
    shoulderpress = params["shoulderpress"].to_f
    benchpress = params["benchpress"].to_f

    db.execute("INSERT INTO lifts (deadlift, shoulderpress, benchpress) VALUES (?, ?, ?)", [deadlift, shoulderpress, benchpress])

    id = db.execute("SELECT last_insert_rowid()").first["last_insert_rowid()"]
    redirect "/lifts/#{id}"
  end

  get '/lifts/:id' do |id|
    @lift = db.execute("SELECT * FROM lifts WHERE id = ?", id).first
    erb(:'lifts/show')
  end

  post '/lifts/:id/update' do |id|
    lift = db.execute("SELECT * FROM lifts WHERE id = ?", id).first

    updated_deadlift = lift["deadlift"] + 2.5
    updated_shoulderpress = lift["shoulderpress"] + 2.5
    updated_benchpress = lift["benchpress"] + 2.5

    db.execute("UPDATE lifts SET deadlift = ?, shoulderpress = ?, benchpress = ? WHERE id = ?", [updated_deadlift, updated_shoulderpress, updated_benchpress, id])

    redirect "/lifts/#{id}"
  end

  get '/program' do
    @lift = db.execute('SELECT * FROM lifts ORDER BY id DESC LIMIT 1').first
    erb(:program)
  end
end
