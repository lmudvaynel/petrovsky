$.app.preload =
  image: (image_src) ->
    return if typeof document.body == 'undefined'
    try
      img = document.createElement "img"
      $(img).attr 'src', image_src
      $(img).css
        position: 'absolute'
        top: 0
        left: 0
        display: 'none'
      $('body').append $(img)
      img.onload = ->
        $(img).remove()
