class App < Sinatra::Base

    get '/index' do
        erb(:"index")
    end
    get '/program' do
        erb(:"program")
    end

        # Funktion för att prata med databasen
    # Exempel på användning: db.execute('SELECT * FROM fruits')
    def db
        return @db if @db

        @db = SQLite3::Database.new("db/lifts.sqlite")
        @db.results_as_hash = true

        return @db
      end

      # Routen gör en redirect till '/lifts'
      get '/' do
          redirect('/lifts')
      end

      #Routen hämtar alla övningar i databasen
      get '/lifts' do
        @lifts = db.execute('SELECT * FROM lifts')
        p @lifts
        erb(:"lifts/index")
      end

      # Routen visar ett formulär för att spara ett nytt lyft till databasen.
      get '/lifts/new' do
        erb(:"lifts/new")
      end

      # Routen sparar ett lyft till databasen och gör en redirect till '/lifts'.
      post '/lifts' do
        p params
        name = params["fruit_name"]
        description = params["fruit_description"]

        db.execute("INSERT INTO fruits (name, description) VALUES(?,?)", [name, description])

        redirect("/fruits")
      end

      # Routen visar all info (från databasen) om en frukt
      get '/fruits/:id' do | id |
        @fruit = db.execute('SELECT * FROM fruits WHERE id=?',id).first
        erb(:"fruits/show")
      end

      # Routen tar bort frukten med id
      post '/fruits/:id/delete' do | id |
        db.execute("DELETE FROM fruits WHERE id =?", id)
        redirect("/fruits")
      end

      # Routen visar ett formulär på edit.erb för att ändra frukten med id
      get '/fruits/:id/edit' do | id |
        # todo: Hämta info (från databasen) om frukten med id

        # todo: Visa infon i fruits/edit.erb
      end

      # Routen sparar ändringarna från formuläret
      post "/fruits/:id/update" do | id |
        # todo: Läs name & category från formuläret

        # todo: Kör SQL för att uppdatera datan från formuläret

        # todo: Redirect till /fruits
      end

  end
end
