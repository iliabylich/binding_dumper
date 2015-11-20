class UsersController < ApplicationController
  def index
    render json: some_helper_method
  end

  def some_helper_method
    @users = User.all.to_a
    some_proc = proc { 1 + 1 }
    raise 'oh'
    []
  end
end
