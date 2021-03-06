defmodule Iclog.ObservableTest do
    use Iclog.DataCase

    alias Iclog.Observable.Meal

    @now Timex.now()

    @meal "rice"

    @updated_meal "potato"

    @invalid_attrs %{
      meal: nil,
      time: nil
    }

    test "list/0 returns all meals" do
      meal = normalize(insert :meal)
      assert (Meal.list() |> List.first() |> normalize()) == meal
    end

    test "get!/1 returns the meal with given id" do
      meal = insert :meal
      assert normalize(Meal.get!(meal.id)) == normalize(meal)
    end

    test "get/1 returns the meal with given id and associated comments" do
      meal = normalize(insert :meal)
      comments = MealCommentFactory.create :comment, meal: meal

      meal_ = normalize(Meal.get meal.id)
      assert meal_ == %{meal | comments: [comments]}
    end

    test "get/1 with wrong meal id returns nil" do
      assert nil == Meal.get(0)
    end

    test "create/1 with valid data creates a meal" do
      assert {:ok, %Meal{} = meal} = Meal.create(%{meal: @meal, time: @now})
      assert meal.meal == @meal
      assert meal.time == @now
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meal.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the meal" do
      updated_time = Timex.shift @now, days: 1
      meal_ = insert :meal, time: @now
      meal = %{meal_ | comments: []}
      assert {:ok, meal} = Meal.update(meal, %{meal: @updated_meal, time: updated_time})
      assert %Meal{} = meal
      assert meal.meal ==  @updated_meal
      assert meal.time == updated_time
    end

    test "update/2 with invalid data returns error changeset" do
      meal = insert :meal
      assert {:error, %Ecto.Changeset{}} = Meal.update(meal, @invalid_attrs)
      assert normalize(meal) == normalize(Meal.get!(meal.id))
    end

    test "delete/1 deletes the meal" do
      meal = insert :meal
      assert {:ok, %Meal{}} = Meal.delete(meal)
      assert_raise Ecto.NoResultsError, fn -> Meal.get!(meal.id) end
    end

    test "change/1 returns a meal changeset" do
      assert %Ecto.Changeset{} = Meal.change(insert :meal)
    end

    defp normalize(%Meal{time: time} = meal) do
      %{meal | time: normalize_time(time)}
    end

end
