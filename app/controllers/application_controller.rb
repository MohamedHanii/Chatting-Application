class ApplicationController < ActionController::Base
  before_action :set_app, only: [:show,:update, :destroy]

  # list all applications
  #GET /api/v1/applications
  def list
    apps = Application.all
    json_render(apps)
  end

  #Show specific application
  #GET /api/v1/applications/:token
  def show 
    json_render(@app)
  end

  #Create Application
  #POST /api/v1/applications
  def create 
    # Create Token
    loop do
      @unique_identifier = SecureRandom.hex(8)
      break unless Application.exists?(:token => @unique_identifier)
    end
    
    app = Application.create(name: params[:name], token: @unique_identifier)
    json_render(app)
  end

  #Update Application with Token
  #PUT /api/v1/applications/:token
  def update
    if @app
      @app.name = params[:name]
      @app.save
    end
    json_render(@app)
  end
  
  # Delete Application with Token
  #DELETE /api/v1/applications/:token
  def destroy
    if @app
      @app.destroy
    end
    json_render(@app)
  end

  private 

  def set_app 
    @app = Application.find_by(token: params[:token]) || 'Token not found'
  end

  def json_render(reply)
    render json: reply.as_json(:except => :id)
  end


  
end
