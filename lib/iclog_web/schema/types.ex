defmodule IclogWeb.Schema.Types do
  use Absinthe.Schema.Notation

  scalar :i_s_o_datetime, name: "ISODatime" do
    parse (fn(value) ->
            case Timex.parse(value, "{ISO:Extended:Z}") do
              {:ok, val, _} -> {:ok, val}
              {:error, _} -> :error
            end
          end)

    serialize &Timex.format!(&1, "{ISO:Extended:Z}")
  end

  object :generic_pagination do
    field :page_number, non_null(:integer)
    field :page_size, non_null(:integer)
    field :total_pages, non_null(:integer)
    field :total_entries, non_null(:integer)
  end

  input_object :pagination do
    field :page, non_null(:integer)
    field :page_size, :integer
  end

  @desc "A generic comment"
  object :generic_comment do
    field :id, :id
    field :text, :string
    field :inserted_at, :i_s_o_datetime
    field :updated_at, :i_s_o_datetime
  end

  @desc "Params for objects which require generic comment"
  input_object :comment do
    field :text, non_null(:string)
  end
end