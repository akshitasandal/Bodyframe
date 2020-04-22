class TrainerController < ApplicationController
  include Swagger::Blocks
  before_action :authenticate_user!
end
