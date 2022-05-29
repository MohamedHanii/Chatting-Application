class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # List All Application
  def list
    HomeJob.perform_later
   render json: Application.all
  end

  # List a single Application
  def show 
    app = Application.find_by(token: params[:token])
    render json: app
  end


  skip_before_action :verify_authenticity_token
  #Create New Application
  def create 
    loop do
      @unique_identifier = SecureRandom.hex(5) # or whatever you chose like UUID tools
      break unless Application.exists?(:token => @unique_identifier)
    end
    app = Application.create(name: params[:name], token: @unique_identifier)
    render json: app
  end

  
  # Update Application
  def update
    app = Application.find_by(token: params[:token])
    app.name = params[:name]
    app.save
    render json: app
  end
  
  #Delete Application
  def delete
    app = Application.find_by(token: params[:token])
    app.destroy
    render json: app
  end


end
