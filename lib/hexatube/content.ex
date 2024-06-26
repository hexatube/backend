defmodule Hexatube.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Hexatube.Repo

  alias Hexatube.Content.Video

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Repo.all(Video)
    |> Repo.preload(:ratings)
  end

  def get_videos_paging(query, category, page, page_size) do
    ecto_query =
      from(v in Video)

    ecto_query =
      ecto_query
      |> eq_category(category)
      |> ilike_query(query)

    total = Repo.one(from v in ecto_query, select: count())

    videos =
      ecto_query
      |> page_offset(page, page_size)
      |> preload_ratings()
      |> Repo.all()

    {videos, total}
  end

  defp preload_ratings(q) do
    from v in q, preload: :ratings
  end

  defp eq_category(q, nil), do: q

  defp eq_category(q, cat) do
    from v in q,
      where: v.category == ^cat
  end

  defp ilike_query(q, nil), do: q

  defp ilike_query(q, query) do
    from v in q,
      where: like(v.name, ^("%" <> query <> "%"))
  end

  defp page_offset(q, page, page_size)
       when page > 0 and page_size > 0 do
    from v in q,
      limit: ^page_size,
      offset: ^((page - 1) * page_size)
  end

  defp page_offset(q, _, _) do
    q
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id) do
    Repo.get!(Video, id)
    |> Repo.preload(:ratings)
  end

  def get_video(id) do
    Repo.get(Video, id)
    |> Repo.preload(:ratings)
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(user, attrs \\ %{}) do
    %Video{user_id: user.id}
    |> Video.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:ratings, [])
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{data: %Video{}}

  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end

  alias Hexatube.Content.Rating
  alias Hexatube.Accounts.User

  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings()
      [%Rating{}, ...]

  """
  def list_ratings do
    Repo.all(Rating)
  end

  @doc """
  Gets a single rating.

  Raises `Ecto.NoResultsError` if the Rating does not exist.

  ## Examples

      iex> get_rating!(123)
      %Rating{}

      iex> get_rating!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rating!(id), do: Repo.get!(Rating, id)

  @doc """
  Creates a rating.

  ## Examples

      iex> create_rating(%{field: value})
      {:ok, %Rating{}}

      iex> create_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rating(%User{id: user_id}, %Video{id: video_id}, attrs \\ %{}) do
    create_rating_id(user_id, video_id, attrs)
  end

  def create_rating_id(user_id, video_id, attrs \\ %{}) do
    %Rating{user_id: user_id, video_id: video_id}
    |> Rating.changeset(attrs)
    |> Ecto.Changeset.foreign_key_constraint(:video_id)
    |> Repo.insert()
  end


  @doc """
  Updates a rating.

  ## Examples

      iex> update_rating(rating, %{field: new_value})
      {:ok, %Rating{}}

      iex> update_rating(rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rating.

  ## Examples

      iex> delete_rating(rating)
      {:ok, %Rating{}}

      iex> delete_rating(rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.

  ## Examples

      iex> change_rating(rating)
      %Ecto.Changeset{data: %Rating{}}

  """
  def change_rating(%Rating{} = rating, attrs \\ %{}) do
    Rating.changeset(rating, attrs)
  end

  def upsert_rating(user_id, video_id, like) do
    Repo.get_by(Rating, [user_id: user_id, video_id: video_id])
    |> case do
      nil ->
        create_rating_id(user_id, video_id, %{like: like})
      rating ->
        update_rating(rating, %{like: like})
    end
  end
end
