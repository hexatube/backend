defmodule HexatubeWeb.Router do
  use HexatubeWeb, :router

  import HexatubeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HexatubeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_current_user
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hexatube, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HexatubeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/login", HexatubeWeb do
    pipe_through [:api, :redirect_if_user_is_authenticated]

    post "/register", UserRegistrationController, :new_user
    post "/", UserRegistrationController, :login
  end

  scope "/login", HexatubeWeb do
    pipe_through [:api, :require_authenticated_user]

    get "/me", UserRegistrationController, :me
  end

  scope "/logout", HexatubeWeb do
    pipe_through [:api, :require_authenticated_user]

    post "/", UserRegistrationController, :logout
  end

  scope "/video", HexatubeWeb do
    pipe_through [:api, :require_authenticated_user]

    post "/upload", VideoController, :upload_video
  end

  scope "/video", HexatubeWeb do
    pipe_through :api

    get "/list", VideoController, :list
    get "/", VideoController, :get
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :hexatube, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      # cannot force to load it from Endpoint config (required to be compilation-time config)
      # because of ets not configured
      basePath: Application.fetch_env!(:hexatube, :base_api),
      info: %{
        version: "1.0",
        title: "Hexatube",
      }
    }
  end
end
