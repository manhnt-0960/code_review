class SlackWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  sidekiq_options retry: 3

  def perform params
    @slack_log ||= Logger.new("#{Rails.root}/log/slack_log.log")
    params = params.with_indifferent_access
    @room = Room.find params[:room_id]

    return unless @room.slack_id

    Slack.configure.token = ENV["SLACK_API_TOKEN"]
    @client = Slack::Web::Client.new

    post_slack_message params
  end

  private

  attr_reader :client, :room

  def post_slack_message params
    client.chat_postMessage link_names: 1, channel: room.slack_id, text: template(params), as_user: true
  rescue StandardError
    @slack_log.error("Slack error")
    false
  end

  def template params
    locals = params.slice(:number, :reviewer, :url, :message, :slack_id)

    I18n.t "slack.messages.#{params[:state]}", locals
  end
end
