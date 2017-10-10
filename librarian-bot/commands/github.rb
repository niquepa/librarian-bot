module LibrarianBot
  module Commands
    class Github < SlackRubyBot::Commands::Base

      @github_client = LibrarianBot::Utils::GithubClient.new

      match /SIMS version in (?<environment>\w*)$/i do |client, data, match|
        #client.say(channel: data.channel, text: "The version deployed in *#{match[:environment].upcase}* is *#{git_user_name()}*")
        if @github_client.authenticated?
          env = match[:environment].upcase
          response = @github_client.version(env)
          client.say(channel: data.channel, text: "<@#{data.user}>, The version deployed in *#{env}* is *#{response}*")
        else
          client.say(channel: data.channel, text: "<@#{data.user}>, Fail... please review github token")
        end
      end

      match /SIMS latest release$/i do |client, data, match|
        if @github_client.authenticated?
          response = @github_client.last_release
          client.say(channel: data.channel, text: "<@#{data.user}>, The latest version deployed in *Production* is *#{response[:name]}* ")
        else
          client.say(channel: data.channel, text: "<@#{data.user}>, Fail... please review github token")
        end
      end

      help do
        title 'SIMS version in <prod|uat|qa>'
        desc 'Show the version deployed in the environment'
        long_desc 'command format: *SIMS version in <env>* where <env> is prod, uat or qa'
      end
      help do
        title 'SIMS latest release'
        desc 'Show the last published release on Github'
      end
      
    end
  end
end