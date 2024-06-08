defmodule HexatubeWeb.VideoController do
  use HexatubeWeb, :controller
  use PhoenixSwagger

  alias Hexatube.{Accounts, Content}

  action_fallback HexatubeWeb.FallbackController

  def swagger_definitions do
    %{
      Video: swagger_schema do
        title "Video data"
        description "video model info"
        properties do
          id :integer, "video id", required: true
          name :string, "video name", required: true
          category :string, "video category", required: true
          video :string, "video url", required: true
          preview :string, "video preview url", required: true
        end
      end,
    }
  end

  swagger_path :upload_video do
    description "Upload new video"
    produces "application/json"
    consumes "multipart/form-data"
    parameters do
      video :formData, :file, "video", required: true
      preview :formData, :file, "preview picture", required: true
      name :formData, :string, "video name", required: true
      category :formData, :string, "category", required: true
    end
    response 200, "Success", Schema.ref(:Video)
  end

  def upload_video(conn, params) do
    video_params = params["video"]
    preview_params = params["preview"]
    name = params["name"]
    category = params["category"]

    id = UUID.uuid4()
    basedir = Application.fetch_env!(:hexatube, :content_upload_dir)
    File.mkdir_p!(basedir)
    ext = Path.extname(video_params.filename)
    video_path = Path.join([basedir, "#{id}#{ext}"])
    File.cp(video_params.path, video_path)
    ext_p = Path.extname(preview_params.filename)
    preview_path = Path.join([basedir, "#{id}#{ext_p}"])
    File.cp(preview_params.path, preview_path)

    with {:ok, video} <- Content.create_video_without_user(%{
      name: name,
      category: category,
      path: Path.relative_to(video_path, basedir),
      preview_path: Path.relative_to(preview_path, basedir)
    }) do
      render(conn, :show, video: video)
    end
  end

  swagger_path :list do
    description "Videos list"
    produces "application/json"
    consumes "application/json"
    paging
    response 200, "Success"
  end

  def list(conn, _params) do
    render(conn, :empty)
  end
end