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
          video :string, "video relative url", required: true
          preview :string, "video preview relative url", required: true
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

  @mime_types_video [
    "video/mp4",
    "video/webm",
    "video/quicktime"
  ]

  @mime_types_preview [
    "image/png",
    "image/gif",
    "image/jpeg",
    "image/webp"
  ]

  # todo: refactor
  def upload_video(conn, params) do
    video_params = params["video"]
    preview_params = params["preview"]
    name = params["name"]
    category = params["category"]

    with :ok <- allowed_type(video_params.content_type, @mime_types_video, :video),
         :ok <- allowed_type(preview_params.content_type, @mime_types_preview, :preview),
         {:ok, video} <- copy_and_create_video(name, category, video_params, preview_params) do
        render(conn, :show, video: video)
    else
      {:error, t, typ} ->
        if typ == :preview do
          render(conn, :type_error, preview: t, allowed: @mime_types_preview)
        else
          render(conn, :type_error, video: t, allowed: @mime_types_video)
        end
      e -> e
    end
  end

  defp copy_and_create_video(name, category, video_params, preview_params) do
    id = UUID.uuid4()
    basedir = Application.fetch_env!(:hexatube, :content_upload_dir)
    File.mkdir_p!(basedir)
    ext = Path.extname(video_params.filename)
    video_path = Path.join([basedir, "#{id}#{ext}"])
    File.cp(video_params.path, video_path)
    ext_p = Path.extname(preview_params.filename)
    preview_path = Path.join([basedir, "#{id}#{ext_p}"])
    File.cp(preview_params.path, preview_path)

    Content.create_video_without_user(%{
      name: name,
      category: category,
      path: Path.relative_to(video_path, basedir),
      preview_path: Path.relative_to(preview_path, basedir)
    }) 
  end

  defp allowed_type(t, l, typ) do
    if t in l do
      :ok
    else
      {:error, t, typ}
    end
  end

  swagger_path :list do
    description "Videos list"
    produces "application/json"
    consumes "application/json"
    paging
    parameters do
      category :query, :string, "category id"
      query :query, :string, "search query"
    end
    response 200, "Success"
  end

  def list(conn, params) do
    {page_size, _} = Integer.parse(params["page_size"] || "10")
    {page, _} = Integer.parse(params["page"] || "1")
    query = params["query"] || nil
    category = params["category"] || nil
    {videos, total} = Content.get_videos_paging(query, category, page, page_size)
    render(conn, :with_paging, videos: videos, total: total, paging: %{page_size: page_size, page: page})
  end

  swagger_path :get do
    description "Get video"
    produces "application/json"
    parameters do
      id :query, :integer, "video id"
    end
    response 200, "Success"
    response 404, "Not found"
  end

  def get(conn, %{"id" => id}) do
    {id, _} = Integer.parse(id)
    case Content.get_video(id) do
      nil -> {:error, :not_found}
      video ->
        render(conn, :show, video: video)
    end
  end

  def get(conn, %{}) do
    {:error, :not_found}
  end
end