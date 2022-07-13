Dir[Rails.root.join("lib", "rails_admin", "*.rb")].each{|file| require file}

RailsAdmin.config do |config|
  config.parent_controller = ApplicationController.name

  config.authorize_with do
    redirect_to main_app.root_path,
      flash: {danger: "Access Denied"} unless current_user.admin?
  end

  config.navigation_static_links = {
    "Sidekiq": "/sidekiq"
  }

  config.actions do
    dashboard
    reset_merged
    index
    new
    bulk_delete
    show
    edit
    delete
  end

  config.total_columns_width = 1000

  config.model User.name do
    list do
      field :id
      field :name
      field :login
      field :email
      field :role
      field :slack_id
      field :merged
      field :room
      field :admin
    end

    edit do
      field :id
      field :avatar
      field :name
      field :login
      field :email
      field :role
      field :slack_id
      field :room
      field :admin
    end
  end

  config.model Room.name do
    edit do
      field :id
      field :name
      field :slack_id
      field :description
    end
  end

  config.model PullRequest.name do
    list do
      field :id
      field :title
      field :full_name
      field :number
      field :user
      field :state
      field :current_reviewer
      field :created_at
      field :updated_at
    end
  end

  config.model Repository.name do
    edit do
      field :id
      field :full_name
    end
  end
end
