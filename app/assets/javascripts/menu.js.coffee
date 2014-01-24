#= require jquery
$.app.menu =
  init: ->
    $(".menu").on "mouseover", ".page-elem", $.app.menu.show
    $(".menu").on "mouseout", ".page-elem", $.app.menu.hide_all
    $.app.menu.hide_all()

  show: ->
    $(@).find(".submenu").show()

  hide_all: ->
    $(".submenu").hide()

$(document).ready ->
  $.app.menu.init()
