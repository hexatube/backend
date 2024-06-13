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
			type: video.type,
		}
	end

	def empty(_) do
		%{}
	end

	def type_error(%{video: video_type, allowed: allowed}) do
		%{
			error: "provided video type (#{video_type}) not allowed, use: #{to_string_sep(allowed)}"
		}
	end

	def type_error(%{preview: preview_type, allowed: allowed}) do
		%{
			error: "provided preview type (#{preview_type}) not allowed, use: #{to_string_sep(allowed)}"
		}
	end

	defp to_string_sep(lst) do
		Enum.reduce(lst, fn x, acc -> "#{acc}, #{x}" end)
	end
end