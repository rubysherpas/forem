module Forem
  class ForumsController < ApplicationController
    def index
      @forums = Forem::Forum.all
    end
  end
end