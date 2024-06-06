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
    pipe_through :api

    post "/register", UserRegistrationController, :new_user
    # post "/", UserSessionController, :login
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :hexatube, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Hexatube",
        basePath: Application.fetch_env!(:hexatube, :base_api),
        servers: [
          %{url: "https://hexatube.fun/api"},
          %{url: "http://localhost:4000"},
        ]
      }
    }
  end
end
