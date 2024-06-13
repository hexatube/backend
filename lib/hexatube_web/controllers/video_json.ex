defmodule HexatubeWeb.VideoJSON do
	alias Hexatube.Content.Video
	alias HexatubeWeb.Endpoint

	def with_paging(%{videos: videos, paging: paging, total: total}) do
		v = Map.put(show(%{videos: videos}), :paging, paging)
		Map.put(v, :total, total)
	end

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
			video: Endpoint.url() <> Endpoint.path("/content/#{video.path}"),
			preview: Endpoint.url() <> Endpoint.path("/content/#{video.preview_path}"),
		}
	end

	def empty(_) do
		%{}
	end
end