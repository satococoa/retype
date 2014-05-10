# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  if $('#page_template').length > 0
    $('#page_template').change ->
      if @value isnt ''
        insert_default_data @value

insert_default_data = (template) ->
  $page_data = $('#page_data')
  if $page_data.val() is ''
    name = template.replace(/^(.*?)\..*/, "$1")
    default_data = $page_data.data('default')
    $page_data.val(default_data[name])
