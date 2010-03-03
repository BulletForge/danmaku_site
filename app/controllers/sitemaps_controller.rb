class SitemapsController < ApplicationController
  def show
    respond_to  do |format|
      format.xml {}
    end
  end
end
