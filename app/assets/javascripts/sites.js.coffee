# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  if $('#site_deploy_type_s3').length > 0
    toggle_deploy_columns()
    $('#site_deploy_type_s3').change ->
      toggle_deploy_columns()
    $('#site_deploy_type_ftp').change ->
      toggle_deploy_columns()

toggle_deploy_columns = ->
  if $('#site_deploy_type_s3').is(':checked')
    $('#ftp-columns').hide()
    $('#s3-columns').show()
  else
    $('#s3-columns').hide()
    $('#ftp-columns').show()
