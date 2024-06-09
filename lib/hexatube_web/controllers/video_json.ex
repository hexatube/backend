defmodule HexatubeWeb.VideoJSON do
	alias Hexatube.Content.Video

	def show(%{videos: videos}) do
		%{videos: for(video <- videos, do: data(video))}
	end

	def show(%{video: video}) do
		data(video)
	end

	defp data(%Video{} = video) do
		%{
			id: video.id,
			name: video.name,
			category: video.category,
			video: HexatubeWeb.Endpoint.path("/content/#{video.path}"),
			preview: HexatubeWeb.Endpoint.path("/content/#{video.preview_path}"),
		}
	end

	def empty(_) do
		%{}
	end
end