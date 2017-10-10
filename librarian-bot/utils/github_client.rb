module LibrarianBot
  module Utils
    class GithubClient

      def initialize
        @client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
        @userName = ENV['GITHUB_USER'].freeze
        @repoName = ENV['GITHUB_REPO'].freeze
        @gistName = ENV['GIST_NAME'].freeze
        @gistId   = ENV['GIST_ID'].freeze
        #@client = Octokit::Client.new(:access_token => "cf8b1cf9e0beea1b7cd95080300fa55791b097af")
      end

      def authenticated?
        @client.user_authenticated?
      end

      def repositories(userName = @userName)
        repos = @client.repositories(userName)
        list_repositories(repos)
      end

      def last_release(repoName = @repoName, userName = @userName)
        response = @client.latest_release("#{userName}/#{repoName}")
        data = Hash.new
        #data[:tag] = response['tag_name']
        data[:name] = response['name']
        data
      end

      def version(environment = 'PROD')
        version = ''
        gistContent().each do |item|
          env, ver = item.split('=')
          if env.upcase == environment
            version = ver
          end
        end
        version
      end

      private
      def list_repositories(repositories)
        list = repositories.map do |r|
          language = r[:language].nil? ? '' : " | Language: #{r[:language]}"
          "<#{r[:html_url]}|#{r[:name]}>#{language} | Forks: #{r[:forks]} | Watchers: #{r[:watchers]}"
        end
        list.join("\n")
      end

      def gistContent(gistId = @gistId, gistName = @gistName)
        response = @client.gist(gistId)
        response['files']["#{gistName}"]['content'].split(',')
      end

    end
  end
end