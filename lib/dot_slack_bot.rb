require "dot_slack_bot/version"

module DotSlackBot < SlackRubyBot::Bot


  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  # class PongBot < SlackRubyBot::Bot
  #   command 'ping' do |client, data, match|
  #     client.say(text: 'pong', channel: data.channel)
  #   end
  # end

  # PongBot.run
end
