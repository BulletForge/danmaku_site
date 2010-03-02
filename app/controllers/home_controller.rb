class HomeController < ApplicationController
  def show
    @featured_project = Project.featured
  end
end