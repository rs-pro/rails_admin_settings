class HomeController < ApplicationController
  def index
    @site_title = Settings.site_title
    @announcement = Settings.announcement
    @footer = Settings.ns('footer').copyright
  end
end
