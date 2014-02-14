$.app.preload =
  ready: (images, callback) ->
    container = $('<div/>', id: 'preloading_container', class: 'hidden')
    container.attr 'data-images-loaded', 0
    $('body').append container
    @.init_image_elem container, image for image in images
    @.ready_interval = setInterval =>
      if parseInt(container.attr('data-images-loaded')) == images.length
        clearInterval @.ready_interval
        callback()
    , 1

  init_image_elem: (container, image) ->
    img = $('<img/>', src: image)
    container.append $(img)
    $(img).load ->
      container.attr 'data-images-loaded', parseInt(container.attr('data-images-loaded')) + 1
