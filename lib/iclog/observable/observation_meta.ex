defmodule Iclog.Observable.ObservationMeta do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Iclog.Repo
  alias Iclog.Observable.ObservationMeta
  alias Iclog.Observable.Observation


  schema "observation_metas" do
    field :intro, :string
    field :title, :string
    has_many :observations, Observation

    timestamps()
  end

  @doc false
  def changeset(%ObservationMeta{} = observation_meta, attrs) do
    observation_meta
    |> cast(attrs, [:title, :intro])
    |> validate_required([:title, :intro])
  end

  @doc """
  Returns the list of observation_metas.

  ## Examples

      iex> list()
      [%ObservationMeta{}, ...]

  """
  def list do
    Repo.all(ObservationMeta)
  end

  @doc """
  Gets a single observation_meta.

  Raises `Ecto.NoResultsError` if the Observation meta does not exist.

  ## Examples

      iex> get!(123)
      %ObservationMeta{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(ObservationMeta, id)

  @doc """
  Creates a observation_meta.

  ## Examples

      iex> create(%{field: value})
      {:ok, %ObservationMeta{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %ObservationMeta{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a observation_meta.

  ## Examples

      iex> update(observation_meta, %{field: new_value})
      {:ok, %ObservationMeta{}}

      iex> update(observation_meta, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%ObservationMeta{} = observation_meta, attrs) do
    observation_meta
    |> changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ObservationMeta.

  ## Examples

      iex> delete(observation_meta)
      {:ok, %ObservationMeta{}}

      iex> delete(observation_meta)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%ObservationMeta{} = observation_meta) do
    Repo.delete(observation_meta)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking observation_meta changes.

  ## Examples

      iex> change(observation_meta)
      %Ecto.Changeset{source: %ObservationMeta{}}

  """
  def change(%ObservationMeta{} = observation_meta) do
    changeset(observation_meta, %{})
  end
end