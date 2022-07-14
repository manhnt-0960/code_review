class SlackWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  sidekiq_options retry: 3

  def perform params
    @slack_log ||= Logger.new("#{Rails.root}/log/slack_log.log")
    params = params.with_indifferent_access

    return unless params["room_slack_id"]

    Slack.configure.token = ENV["SLACK_API_TOKEN"]
    client = Slack::Web::Client.new

    post_slack_message params
  end

  private

  attr_reader :client, :room

  def post_slack_message params
    client.chat_postMessage link_names: 1, channel: params["room_slack_id"], text: template(params), as_user: true
  rescue StandardError
    @slack_log.error("Slack error")
    false
  end

  def template params
    case params[:state]
    when "open"
      "<@#{params[:slack_id]}>
        Your pull request no. ##{params[:number]} has been opened (clap)
        #{params[:url]}

        #{params[:message]}"
    when "ready"
      "<@#{params[:slack_id]}>
        Your pull request no. ##{params[:number]} is ready. Good luck to you!
        #{params[:url]}

        #{params[:message]}"
    when "reviewing"
      "<@#{params[:slack_id]}>
        Your pull request no. ##{params[:number]} is under reviewing by #{params[:reviewer]}
        #{params[:url]}

        #{params[:message]}"
    when "commented"
      "<@#{params[:slack_id]}>
        Your pull request no. ##{params[:number]} has been commented
        #{params[:url]}

        #{params[:message]}"
    when "conflicted"
      "<@#{params[:slack_id]}>
        Your pull request no. ##{params[:number]} is conflicted :o
        #{params[:url]}

        #{params[:message]}"
    when "merged"
      "<@#{params[:slack_id]}>
        Your pull request no. ##{params[:number]} has been merged
        --> Please update your redmine ticket!
        #{params[:url]}

        #{params[:message]}"
    when "closed"
      "<@#{params[:slack_id]}>
        Your pull request no. ##{params[:number]} has been closed
        #{params[:url]}

        #{params[:message]}"
    end
  end
end
