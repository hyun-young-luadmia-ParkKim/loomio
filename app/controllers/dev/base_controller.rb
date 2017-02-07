class Dev::BaseController < ApplicationController
  before_filter :ensure_not_production
  before_filter :cleanup_database

  def index
    @routes = self.class.action_methods.select do |action|
      /^(test_|setup_)/.match action
    end
    render 'dev/main/index', layout: false
  end

  def last_email
    @email = ActionMailer::Base.deliveries.last
    render template: 'dev/main/last_email', layout: false
  end

  private
  def ensure_not_production
    raise "Development and testing only" if Rails.env.production?
  end

  def cleanup_database
    User.delete_all
    Group.delete_all
    Membership.delete_all
    ActionMailer::Base.deliveries = []
  end
end