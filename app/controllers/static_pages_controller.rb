class StaticPagesController < ApplicationController
  def home
    render text: "Does this work Again?"
  end

  def help
  end
end
