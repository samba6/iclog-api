defmodule IclogWeb.Feature.ObservationDetailTest do
  @moduledoc false

  use Iclog.FeatureCase

  alias Iclog.Observable.Observation

  @comment_control_name "edit-observation-comment"
  @inserted_at_control_name "edit-observation-inserted-at"

  @submit_btn_name "edit-observation-submit-btn"
  @reset_btn_name "edit-observation-reset-btn"

  @show_edit_icon_id "detail-observation-show-edit-display"
  @show_detail_icon_id "detail-observation-show-detail-display"

  @tag :integration
  # @tag :no_headless
  test "Edit observation", _meta do
    %Observation{
      id: id_,
      comment: comment,
      inserted_at: inserted_at_
    } = insert(:observation, comment: "comm")

    navigate_to "/#/observations/#{id_}"

    {inserted_at, inserted_at_str}= timex_ecto_date_to_local_tz_formatted inserted_at_

    comment_regex = Regex.compile! ".*#{comment}.*"
    inserted_at_regex = Regex.compile! ".*#{inserted_at_str}.*"

    # Comment is visible in page
    assert wait_for_condition(
      true,
      fn() ->
        visible_in_page?(comment_regex)
      end,
      []
    )

    # Inserted at datetime is visible on page
    assert visible_in_page?(inserted_at_regex)

    # When show edit icon is clicked
    click {:id, @show_edit_icon_id}

    # show detail icon becomes visible
    find_element :id, @show_detail_icon_id

    # show edit icon becomes invisible
    refute element?(:id, @show_edit_icon_id)

    # submit and reset buttons are disabled
    submit_btn = find_element(:name, @submit_btn_name)
    refute element_enabled?(submit_btn)

    reset_btn = find_element(:name, @reset_btn_name)
    refute element_enabled?(reset_btn)

    # comment field contains the comment
    comment_control = find_element :name, @comment_control_name
    assert attribute_value(comment_control, "value") == comment

    # inserted_at field contains the inserted_at
    inserted_at_control = find_element :name, @inserted_at_control_name
    assert attribute_value(inserted_at_control, "value") == inserted_at_str

    # When comment comment control is edited so comment changes
    updated_comment = "#{comment}-updated"
    fill_field comment_control, updated_comment

    assert_btns_enabled submit_btn, reset_btn

    # but when comment field value is changed to original comment
    fill_field comment_control, ""
    type_text comment, 5

    # submit_btn and reset_btn are disabled
    refute_btns_enabled submit_btn, reset_btn

    # when inserted_at_control is focused
    click inserted_at_control

    # datepicker is revealed
    assert wait_for_condition(true, fn() ->
      element? :class, "elm-input-datepickerDialog"
    end)

    # when a new date is selected
    inserted_at_updated = Timex.shift inserted_at, days: 1
    datetime_picker_select_date inserted_at_updated.day, comment_control

    # inserted at textbox contains selected date
    inserted_at_updated_str = inserted_at_updated
    |> Timex.format!(datetime_format_str())

    assert attribute_value(inserted_at_control, "value") == inserted_at_updated_str

    assert_btns_enabled submit_btn, reset_btn

    # when inserted at textbox is changed to original date
    click inserted_at_control
    datetime_picker_select_date inserted_at.day, comment_control

    refute_btns_enabled submit_btn, reset_btn

    # when the form controls are filled with updated data
    fill_field comment_control, ""
    type_text updated_comment
    click inserted_at_control
    datetime_picker_select_date inserted_at_updated.day, comment_control

    # and submit_btn is clicked
    click submit_btn

    # observation is updated
    assert wait_for_condition(
      true,
      fn() ->
        case Repo.get(Observation, id_) do
          nil ->
            false
          obs ->
            {_, date} = timex_ecto_date_to_local_tz_formatted obs.inserted_at
            obs.comment == updated_comment && date == inserted_at_updated_str
        end
      end
    )

    # A message informing user of successful update is visible on page
    assert visible_in_page?(~r/.*Update success!.*/)

    # show detail icon becomes invisible
    refute element?(:id, @show_detail_icon_id)

    # show edit icon becomes visible
    assert element?(:id, @show_edit_icon_id)
  end

  defp assert_btns_enabled(submit_btn, reset_btn) do
    # submit_btn and reset btns are enabled
    assert element_enabled?(submit_btn)
    assert element_enabled?(reset_btn)
  end

  defp refute_btns_enabled(submit_btn, reset_btn) do
    # submit_btn and reset btns are enabled
    refute element_enabled?(submit_btn)
    refute element_enabled?(reset_btn)
  end
end