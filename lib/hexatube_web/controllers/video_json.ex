defmodule HexatubeWeb.VideoJSON do
	alias Hexatube.Content.Video

	def show(%{video: video}) do
		data(video)
	end

	defp data(%Video{} = video) do
		%{
			id: video.id,
			name: video.name,
			category: video.category,
			video: video.path,
			preview: video.preview_path
		}
	end

	def empty(_) do
		%{}
	end
end