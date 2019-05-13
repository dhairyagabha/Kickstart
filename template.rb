require "fileutils"
require "shellwords"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("kickstart-"))
    at_exit {FileUtils.remove_entry(tempdir)}
    git clone: [
        "--quiet",
        "https://github.com/dhairyagabha/Kickstart.git",
        tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{kickstart/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) {git checkout: branch}
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails::VERSION::STRING)
end

def rails_5?
  Gem::Requirement.new(">= 5.2.0", "< 6.0.0.beta1").satisfied_by? rails_version
end

def rails_6?
  Gem::Requirement.new(">= 6.0.0.beta1", "< 7").satisfied_by? rails_version
end

def add_gems
  # gem 'administrate', github: "excid3/administrate", branch: "zeitwerk"
  # gem 'bootstrap', '~> 4.3', '>= 4.3.1'
  #
  #  Authentication and User Management
  gem 'devise', '~> 4.6', '>= 4.6.1'
  gem 'devise_invitable', '~> 2.0.0'
  gem 'devise_masquerade', '~> 0.6.2'
  # gem 'devise-bootstrapped', github: 'excid3/devise-bootstrapped', branch: 'bootstrap4'

  gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'

  gem 'friendly_id', '~> 5.2', '>= 5.2.5'

  gem 'gravatar_image_tag', github: 'mdeering/gravatar_image_tag'

  gem 'mini_magick', '~> 4.9', '>= 4.9.2'

  gem 'name_of_person', '~> 1.1'

  gem 'omniauth-facebook', '~> 5.0'
  gem 'omniauth-github', '~> 1.3'
  gem 'omniauth-twitter', '~> 1.4'
  gem 'sidekiq', '~> 5.2', '>= 5.2.5'
  gem 'sitemap_generator', '~> 6.0', '>= 6.0.1'
  gem 'whenever', require: false

  if rails_5?
    gsub_file "Gemfile", /gem 'sqlite3'/, "gem 'sqlite3', '~> 1.3.0'"
    gem 'webpacker', '~> 4.0.1'
  end
end

def set_essentials
  gsub_file "Gemfile", /# gem 'image_processing', '~> 1.2'/, "gem 'image_processing', '~> 1.2'"
  rails_command "action_text:install"
  rails_command "active_storage:install"
end

def set_application_name
  # Add Application Name to Config
  if rails_5?
    environment "config.application_name = Rails.application.class.parent_name"
  else
    environment "config.application_name = Rails.application.class.module_parent_name"
  end

  # Announce the user where he can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'
  route "root to: 'home#index'"

  # Devise notices are installed via Bootstrap
  # generate "devise:views:bootstrapped"
  generate "devise:views"

  # Add Devise Authenticated user scope
  authenticated_content = <<-RUBY
    authenticated :user do
      # Add your authenticated route alternates here
      # root to: 'controller#action', as: 'logged_in_root'
    end
  RUBY
  insert_into_file "config/routes.rb", "#{authenticated_content}\n\n", after: "Rails.application.routes.draw do\n"

  # Create Devise User
  generate :devise, "User",
           "first_name",
           "last_name",
           "announcements_last_read_at:datetime",
           "admin:boolean"


  # Set admin default to false
  in_root do
    migration = Dir.glob("db/migrate/*").max_by {|f| File.mtime(f)}
    gsub_file migration, /:admin/, ":admin, default: false"
    gsub_file migration, /# t./, "t."
    gsub_file migration, /# add/, "add"
  end

  generate "devise_invitable:install"
  generate "devise_invitable:views"
  generate :devise_invitable, "User"

  if Gem::Requirement.new("> 5.2").satisfied_by? rails_version
    gsub_file "config/initializers/devise.rb",
              /  # config.secret_key = .+/,
              "  config.secret_key = Rails.application.credentials.secret_key_base"
  end

  # Add Devise masqueradable to users
  inject_into_file("app/models/user.rb", "omniauthable, :masqueradable, :confirmable, :trackable, :lockable, :", after: "devise :")
end

def initiate_api

end

def add_webpack
  # Rails 6+ comes with webpacker by default, so we can skip this step
  return if rails_6?

  # Our application layout already includes the javascript_pack_tag,
  # so we don't need to inject it
  rails_command 'webpacker:install'
end

def add_javascript
  run "yarn add expose-loader jquery popper.js bootstrap data-confirm-modal local-time"

  if rails_5?
    run "yarn add turbolinks @rails/actioncable@pre @rails/actiontext@pre @rails/activestorage@pre @rails/ujs@pre"
  end

  content = <<-JS
const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Rails: '@rails/ujs'
}))
  JS

  insert_into_file 'config/webpack/environment.js', content + "\n", before: "module.exports = environment"
end

def copy_templates
  remove_file "app/assets/stylesheets/application.css"

  copy_file "Procfile"
  copy_file "Procfile.dev"
  copy_file ".foreman"

  directory "app", force: true
  directory "config", force: true
  directory "lib", force: true

  route "get '/terms', to: 'home#terms'"
  route "get '/privacy', to: 'home#privacy'"
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
                   "require 'sidekiq/web'\n\n",
                   before: "Rails.application.routes.draw do"

  content = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY
  insert_into_file "config/routes.rb", "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_announcements
  generate "model Announcement announcement_type:string name:string published_at:datetime"
  route "resources :announcements, only: [:index]"
end

def add_notifications
  generate "model Notification recipient_id:bigint actor_id:bigint read_at:datetime action:string notifiable_id:bigint notifiable_type:string"
  route "resources :notifications, only: [:index]"
end

def add_guides
  generate "model guides/video name:string description:text video_link:string"
  guides_content = <<-RUBY
    namespace :guides do
      resources :videos
    end
  RUBY
  insert_into_file "config/routes.rb", "#Guides Routes \n#{guides_content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_administrate
  generate "administrate:install"

  gsub_file "app/dashboards/announcement_dashboard.rb",
            /announcement_type: Field::String/,
            "announcement_type: Field::Select.with_options(collection: Announcement::TYPES)"

  gsub_file "app/dashboards/user_dashboard.rb",
            /email: Field::String/,
            "email: Field::String,\n    password: Field::String.with_options(searchable: false)"

  gsub_file "app/dashboards/user_dashboard.rb",
            /FORM_ATTRIBUTES = \[/,
            "FORM_ATTRIBUTES = [\n    :password,"

  gsub_file "app/controllers/admin/application_controller.rb",
            /# TODO Add authentication logic here\./,
            "redirect_to '/', alert: 'Not authorized.' unless user_signed_in? && current_user.admin?"

  environment do
    <<-RUBY
    # Expose our application's helpers to Administrate
    config.to_prepare do
      Administrate::ApplicationController.helper #{@app_name.camelize}::Application.helpers
    end
    RUBY
  end
end

def add_admin
  admin_content = <<-RUBY
    namespace :admin do
      resources :guides
      namespace :guides do
        resources :videos
      end
      resources :announcements
      resource :dashboard
      root to: "announcements#index"
    end
  RUBY
  insert_into_file "config/routes.rb", "#Admin Routes \n#{admin_content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_multiple_authentication
  insert_into_file "config/routes.rb",
                   ', controllers: { omniauth_callbacks: "users/omniauth_callbacks" }',
                   after: "  devise_for :users"

  generate "model Service user:references provider uid access_token access_token_secret refresh_token expires_at:datetime auth:text"

  template = "" "
    env_creds = Rails.application.credentials[Rails.env.to_sym] || {}
    %i{ facebook twitter github }.each do |provider|
      if options = env_creds[provider]
        config.omniauth provider, options[:app_id], options[:app_secret], options.fetch(:options, {})
      end
    end
    " "".strip

  insert_into_file "config/initializers/devise.rb", "  " + template + "\n\n",
                   before: "  # ==> Warden configuration"
end

def add_whenever
  run "wheneverize ."
end

def add_friendly_id
  generate "friendly_id"

  insert_into_file(
      Dir["db/migrate/**/*friendly_id_slugs.rb"].first,
      "[5.2]",
      after: "ActiveRecord::Migration"
  )
end

def stop_spring
  run "spring stop"
end

def add_sitemap
  rails_command "sitemap:install"
end

def add_database_credentials
  insert_into_file(
      Dir["config/database.yml"].first,
      "username: development\npassword: typepassword",
      after: "pool: <%= ENV.fetch(\"RAILS_MAX_THREADS\") { 5 } %>\n"
  )
end

# Main setup
add_template_repository_to_source_path

add_gems

after_bundle do
  set_essentials
  set_application_name
  stop_spring
  add_users
  add_webpack
  add_javascript
  add_announcements
  add_guides
  add_admin
  # add_notifications #Add to users model before enabling "  has_many :notifications, foreign_key: :recipient_id"
  add_multiple_authentication
  add_sidekiq
  add_friendly_id

  copy_templates
  add_whenever
  add_sitemap

  add_database_credentials

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  # Migrations must be done before this
  # add_administrate

  # Commit everything to git
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

  say
  say "Kickstart app successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "cd #{app_name} - Switch to your new app's directory."
  say "foreman start - Run Rails, sidekiq, and webpack-dev-server."
  say
end
