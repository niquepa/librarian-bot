require 'slack-ruby-bot'
require 'octokit'

class LibrarianBot < SlackRubyBot::Bot
  # command 'version' do |client, data, match|
  #   client.say(channel: data.channel, text: "Hi <@#{data.user}>, Sims version is ", gif: 'phone')
  #   client.say(channel: data.channel, text: "Debug - BOT:|#{match['bot']}|-COMMAND:|#{match['command']}|-EXPRESSION:|#{match['expression']}|")
  # end

  match /SIMS version in (?<environment>\w*)$/i do |client, data, match|
    #client.say(channel: data.channel, text: "The version deployed in *#{match[:environment].upcase}* is *#{git_user_name()}*")
    env = match[:environment].upcase
    client.say(channel: data.channel, text: "The version deployed in *#{env}* is *#{gist(env)}*")
  end

  match /SIMS latest release$/i do |client, data, match|
    response = latest_release
    client.say(channel: data.channel, text: "The latest version deployed in *Production* is *#{response[:name]}* ")
  end

  help do
    title 'Librarian Bot'
    desc 'This bot tells you what version of SIMS is deployed in a specific environment .'

    command 'SIMS version in <environment>?' do
      desc 'Tells you the SIMS version deployed in <environment>.'
    end
  end

  class << self
    def latest_release

      # Provide authentication credentials
      client = Octokit::Client.new(:access_token => "f876719598fbe3fae0b4c72719fe338830ae7319")

      response = client.latest_release('nycdot/sims')
      data = Hash.new
      data[:tag] = response['tag_name']
      data[:name] = response['name']
      data
      
    end

    def gist(environment = 'prod')
      client = Octokit::Client.new(:access_token => "f876719598fbe3fae0b4c72719fe338830ae7319")

      response = client.gist('64630625db05d7a80381e4b8cf3b019f')
      versions = response['files']['sims-versions.md']['content'].split(',')
      version = 'a'
      versions.each do |item|
        env, ver = item.split('=')
        if env.upcase == environment
          version = ver
        end
      end

      version
    end
  end

end

LibrarianBot.run