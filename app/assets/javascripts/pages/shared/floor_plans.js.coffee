#= require threejs/three.min
#= require threejs/renderers/CSS3DRenderer
#= require threejs/controls/OrbitControls

$.app.pages ||= {}
$.app.pages.shared ||= {}
$.app.pages.shared.floor_plans =
  container: $("#canvas-container")
  params:
    scene:
      distance: 1000
      yz_angle: 3 * Math.PI / 8
    animation:
      speed: 30
      frames:
        camera: 40
        floor:
          to_foreground: 40
          to_start: 40
          to_center: 40
      house:
        delay: 300
    floors:
      count: 6
      solid:
        size:
          width: 1023
          height: 544
        opacity: 0.7
        gap: 100
      number:
        font_size:
          px: 40
  house: {}
  showed_floor: {}
  animated_objects: []

  camera_position_start: ->
    position:
      x: 0
      y: @.params.scene.distance * Math.cos(@.params.scene.yz_angle)
      z: @.params.scene.distance * Math.sin(@.params.scene.yz_angle)
    rotation:
      x: 0, y: 0, z: 0

  floor_position_start: (floor_type, floor_number) ->
    position_y = (floor_number - @.params.floors.count / 2) * @.params.floors.solid.gap + @.params.scene.distance * 2
    position_y += @.params.floors.number.font_size.px / 2 if floor_type == 'number'
    position:
      x: 0, y: position_y, z: 0
    rotation:
      x: - Math.PI / 2, y: 0, z: 0

  floor_position_center: (floor_type, floor_number) ->
    position_y = (floor_number - @.params.floors.count / 2) * @.params.floors.solid.gap
    position_y += @.params.floors.number.font_size.px / 2 if floor_type == 'number'
    position:
      x: 0, y: position_y, z: 0
    rotation:
      x: - Math.PI / 2, y: 0, z: 0

  floor_position_foreground: ->
    position:
      x: 0
      y: @.params.scene.distance / 4 * Math.cos(@.params.scene.yz_angle)
      z: @.params.scene.distance / 4 * Math.sin(@.params.scene.yz_angle)
    rotation:
      x: @.params.scene.yz_angle - Math.PI / 2, y: 0, z: 0

  init: ->
    @.init_camera()
    @.init_scene()
    @.init_renderer()
    @.init_controls()
    @.init_events()
    @.init_animation()

    @.init_house()
    @.house.add_to_scene()
    @.house.animate_to_scene()

  init_camera: ->
    aspect = @.container.innerWidth() / @.container.innerHeight()
    @.camera = new THREE.PerspectiveCamera(75, aspect, 1, 10000)
    for option in ['position', 'rotation']
      for coord in ['x', 'y', 'z']
        @.camera[option][coord] = @.camera_position_start()[option][coord]

  init_scene: ->
    @.scene = new THREE.Scene()

  init_renderer: ->
    @.renderer = new THREE.CSS3DRenderer()
    @.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    @.container.append($(@.renderer.domElement))

  init_controls: ->
    @.controls = new THREE.OrbitControls(@.camera, @.renderer.domElement)
    @.controls.rotateSpeed = 1
    @.controls.minDistance = @.params.scene.distance / 2
    @.controls.maxDistance = @.params.scene.distance * 2
    @.controls.minPolarAngle = @.params.scene.yz_angle
    @.controls.maxPolarAngle = @.params.scene.yz_angle
    @.controls.noPan = true
    $(@.controls).on 'change', @.render

  init_events: ->
    @.container.on 'resize', @.on_window_resize
    @.container.on 'click', 'a.show-floor', (event) ->
      event.preventDefault()
      floor_number = parseInt $(@).closest('.floor-element').data('floor-number')
      $.app.pages.shared.floor_plans.floor_element_on_click floor_number

    controls = $('#controls-container')
    controls.on 'click', 'a#back-to-house', (event) ->
      event.preventDefault()
      $.app.pages.shared.floor_plans.back_to_house_on_click()

  init_animation: ->
    setInterval =>
      if @.animated_objects.length > 0
        @.animation_step_for_object(i) for object, i in @.animated_objects
        @.render()
    , @.params.animation.speed

  animation_step_for_object: (i) ->
    animated_object = @.animated_objects[i]
    return unless animated_object
    for option in ['position', 'rotation']
      for coord in ['x', 'y', 'z']
        animated_object.object[option][coord] -= (animated_object.object[option][coord] - animated_object.final[option][coord]) / animated_object.frames
    animated_object.frames -= 1
    @.animated_objects.splice(i, 1) if animated_object.frames == 0

  animate_camera_to_start: ->
    @.animated_objects.push
      object: @.camera
      final: @.camera_position_start()
      frames: @.params.animation.frames.camera

  do_it_after_animation: (callback) ->
    @.waiting_end_of_animation = setInterval =>
      @.call_after_animation callback
    , @.params.animation.speed

  call_after_animation: (callback) ->
    unless @.animated_objects.length > 0
      clearInterval @.waiting_end_of_animation
      callback()

  init_house: ->
    @.house =
      floors: @.init_floors()
      floor: (floor_number) ->
        @.floors[floor_number - 1]
      add_to_scene: ->
        floor.add_to_scene_solid_with_number() for floor in @.floors
      set_delay_timeout_to_animate: (floor, called_animation, i) =>
        setTimeout =>
          floor[called_animation]()
        , i * @.params.animation.house.delay
      animate_to_scene: ->
        for floor, i in @.floors
          @.set_delay_timeout_to_animate(floor, 'animate_to_center', i)
      animate_from_scene: ->
        for floor, i in @.floors.slice(0).reverse()
          @.set_delay_timeout_to_animate(floor, 'animate_to_start', i)

  init_floors: ->
    floors = []
    floors.push @.init_floor(i) for i in [1..@.params.floors.count]
    floors

  init_floor: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    object: @.init_floor_object(floor_number)
    get_object_by_type: (object_type) ->
      @.object[object_type]
    add_to_scene_all_objects_of_types: (object_types) ->
      object_types = [object_types] unless $.type(object_types) == 'array'
      fp.scene.add @.get_object_by_type(object_type) for object_type in object_types
    remove_from_scene_all_objects_of_types: (object_types) ->
      object_types = [object_types] unless $.type(object_types) == 'array'
      fp.scene.remove @.get_object_by_type(object_type) for object_type in object_types
    add_to_scene_solid_with_number: ->
      @.add_to_scene_all_objects_of_types ['solid', 'number']
    add_to_scene_solid: ->
      @.add_to_scene_all_objects_of_types 'solid'
    remove_from_scene_solid: ->
      @.remove_from_scene_all_objects_of_types 'solid'
    set_position_by: (other_floor) ->
      for object_type in ['solid', 'number']
        for option in ['position', 'rotation']
          @.object[object_type][option] = other_floor.object[object_type][option].clone()
    update_number_rotation: ->
      @.object.number.rotation = fp.camera.rotation
    animate_to: (position, object_types) ->
      object_types = [object_types] unless $.type(object_types) == 'array'
      floor_number = @.object.number.element.textContent
      for object_type in object_types
        fp.animated_objects.push
          object: @.object[object_type]
          final: fp["floor_position_#{position}"](object_type, floor_number)
          frames: fp.params.animation.frames.floor["to_#{position}"]
    animate_to_foreground: ->
      @.animate_to 'foreground', 'solid'
    animate_to_center: ->
      @.animate_to 'center', ['solid', 'number']
    animate_to_start: ->
      @.animate_to 'start', ['solid', 'number']

  init_floor_object: (floor_number) ->
    solid_floor_object = @.init_solid_floor_object(floor_number)
    number_floor_object = @.init_number_floor_object(solid_floor_object, floor_number)
    solid: solid_floor_object
    number: number_floor_object

  init_solid_floor_object: (floor_number) ->
    solid_floor_object = new THREE.CSS3DObject(@.init_solid_floor_dom_element(floor_number))
    for option in ['position', 'rotation']
      for coord in ['x', 'y', 'z']
        solid_floor_object[option][coord] = @.floor_position_start('solid', floor_number)[option][coord]
    solid_floor_object

  init_solid_floor_dom_element: (floor_number) ->
    solid_floor_element = document.createElement('div')
    solid_floor_css =
      width: "#{@.params.floors.solid.size.width}px"
      height: "#{@.params.floors.solid.size.height}px"
      opacity: @.params.floors.solid.opacity
      'background-image': "url(/assets/floor#{floor_number}.png)"
    $(solid_floor_element).addClass('floor-element').css solid_floor_css
    $(solid_floor_element).data 'floor-number', floor_number
    $(solid_floor_element).append @.init_solid_floor_show_link_dom_element
    solid_floor_element

  init_solid_floor_show_link_dom_element: ->
    link = document.createElement('a')
    $(link).addClass('show-floor').attr('href', '#').text('SHOW')

  init_number_floor_object: (floor_object, floor_number) ->
    floor_number_element = @.init_number_floor_dom_element(floor_number)
    floor_number_object = new THREE.CSS3DObject(floor_number_element)
    for coord in ['x', 'y', 'z']
      floor_number_object.position[coord] = @.floor_position_start('number', floor_number).position[coord]
    floor_number_object

  init_number_floor_dom_element: (floor_number) ->
    number_floor_element = document.createElement('div')
    number_floor_css =
      width: "#{3 * @.params.floors.number.font_size.px}px"
      height: "#{@.params.floors.number.font_size.px}px"
      'font-size': "#{@.params.floors.number.font_size.px}px"
    $(number_floor_element).text(floor_number).css number_floor_css
    number_floor_element

  on_window_resize: ->
    @.camera.aspect = @.container.innerWidth() / @.container.innerHeight()
    @.camera.updateProjectionMatrix()
    @.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    @.render()

  floor_element_on_click: (floor_number) ->
    @.showed_floor.solid = @.init_floor(floor_number)
    @.showed_floor.solid.set_position_by @.house.floor(floor_number)
    @.showed_floor.solid.add_to_scene_solid()

    @.showed_floor.solid.animate_to_foreground()
    @.house.animate_from_scene()
    @.animate_camera_to_start()

    @.do_it_after_animation @.end_show_floor_element_animation

  end_show_floor_element_animation: ->
    $('#back-to-house').removeClass 'hidden'

  back_to_house_on_click: ->
    @.showed_floor.solid.animate_to_center()
    @.house.animate_to_scene()
    @.animate_camera_to_start()

    @.do_it_after_animation @.end_back_to_house_animation

  end_back_to_house_animation: ->
    $('#back-to-house').addClass 'hidden'
    $.app.pages.shared.floor_plans.showed_floor.solid.remove_from_scene_solid()

  animate: ->
    fp = $.app.pages.shared.floor_plans
    requestAnimationFrame(fp.animate)
    fp.controls.update()

  render: ->
    fp = $.app.pages.shared.floor_plans
    for floor, i in fp.house.floors
      floor.update_number_rotation()
    fp.renderer.render(fp.scene, fp.camera)

$.app.pages.shared.floor_plans.init()
$.app.pages.shared.floor_plans.animate()
