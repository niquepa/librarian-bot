require 'sinatra/base'

module LibrarianBot
  class Web < Sinatra::Base
    get '/' do
      'Stuff...'
    end
  end
end