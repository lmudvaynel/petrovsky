#= require jquery.ui.all
#= require images_preloader
#= require threejs/three.min
#= require threejs/renderers/CSS3DRenderer
#= require threejs/controls/OrbitControls

$.app.pages ||= {}
$.app.pages.shared ||= {}
$.app.pages.shared.floor_plans =
  container: $("#canvas-container")
  location:
    options: ['position', 'rotation']
    coords: ['x', 'y', 'z']
  params:
    container:
      size_in_percents:
        width:100 
        height:100
    scene:
      distance: 1000
      yz_angle: 3 * Math.PI / 8
    controls:
      blocked: false
    animation:
      speed: 10
      frames:
        camera: 50
        floor:
          to_preforeground: 50
          to_foreground: 50
          to_demonstration: 50
          to_above_the_scene: 50
          to_under_the_scene: 50
          to_center_of_scene: 50
          to_hidden: 50
      house:
        delay:
          to_scene: 200
          from_scene: 200
    floors:
      count: 6
      solid:
        size:
          width: 2171
          height: 613
        opacity:
          hide: 0
          show: 1
          speed: 1000
        gap: 100
      demonstration:
        size:
          width: 1024
          height: 270
        opacity:
          hide: 0
          show: 0.95
          speed: 1000
      plan:
        apartment:
          opacity:
            default: 0
            mouseover: 1
          mouseover:
            dz: 2
      number:
        positions:
          corners:
            1: [[0, 0], [1023, 0], [1023, 544], [0, 544]]
            2: [[0, 0], [1023, 0], [1023, 544], [0, 544]]
            3: [[0, 0], [1023, 0], [1023, 544], [0, 544]]
            4: [[0, 0], [1023, 0], [1023, 544], [0, 544]]
            5: [[0, 0], [1023, 0], [1023, 544], [0, 544]]
            6: [[0, 0], [1023, 0], [1023, 544], [0, 544]]
          current: 3
        change_position_delay: 200
        change_part_delay: 10
        size:
          number:
            width: 140
            height: 40
          container:
            width: 400
            height: 50
  house: {}
  showed_floor:
    floor: null
    number: null
  floor_demonstration: {}
  animated_objects: {}
  mode: 'house'

  change_mode_to: (new_mode) ->
    @.mode = new_mode

  objects_positions_is_equal: (first_object, second_object) ->
    for option in @.location.options
      for coord in @.location.coords
        return false if Math.abs(first_object[option][coord] - second_object[option][coord]) > 0.2
    true

  camera_position_start: ->
    position:
      x: 0
      y: @.params.scene.distance * Math.cos(@.params.scene.yz_angle)
      z: @.params.scene.distance * Math.sin(@.params.scene.yz_angle)
    rotation:
      x: - Math.cos(@.params.scene.yz_angle), y: 0, z: 0

  floor_position_center_of_scene: (floor_number) ->
    position:
      x: 0
      y: (floor_number - @.params.floors.count / 2) * @.params.floors.solid.gap
      z: 0
    rotation:
      x: - Math.PI / 2, y: 0, z: 0

  floor_position_above_the_scene: (floor_number) ->
    floor_position_above_the_scene = @.floor_position_center_of_scene(floor_number)
    floor_position_above_the_scene.position.y += @.params.scene.distance * 3
    floor_position_above_the_scene

  floor_position_under_the_scene: (floor_number) ->
    floor_position_under_the_scene = @.floor_position_center_of_scene(floor_number)
    floor_position_under_the_scene.position.y -= @.params.scene.distance * 3
    floor_position_under_the_scene

  floor_position_hidden: ->
    position:
      x: 0
      y: 0
      z: 0
    rotation:
      x: - Math.cos(@.params.scene.yz_angle) - Math.PI/2, y: 0, z: 0

  floor_position_preforeground: ->
    position:
      x: 0
      y: @.params.scene.distance / 4 * Math.cos(@.params.scene.yz_angle)
      z: @.params.scene.distance / 4 * Math.sin(@.params.scene.yz_angle)
    rotation:
      x: @.params.scene.yz_angle - Math.PI / 2, y: 0, z: 0

  floor_position_foreground: ->
    position:
      x: 0
      y: @.params.scene.distance / 2 * Math.cos(@.params.scene.yz_angle)
      z: @.params.scene.distance / 2 * Math.sin(@.params.scene.yz_angle)
    rotation:
      x: @.params.scene.yz_angle - Math.PI / 2, y: 0, z: 0

  floor_position_demonstration: ->
    position:
      x: -50
      y: 90
      z: 0
    rotation:
      x: -0.7968583470577033
      y: -0.032359877559829886
      z: -0.49741883681838395

  floor_demonstration_position_foreground: ->
    position:
      x: 0
      y: @.params.scene.distance / 4 * Math.cos(@.params.scene.yz_angle)
      z: @.params.scene.distance / 4 * Math.sin(@.params.scene.yz_angle)
    rotation:
      x: @.params.scene.yz_angle - Math.PI / 2, y: 0, z: 0

  init: ->
    @.init_container()
    @.init_camera()
    @.init_scene()
    @.init_renderer()
    @.init_controls()
    @.block_controls() # appended
    @.init_events()
    @.init_animation()
    @.init_animated_objects()

    @.init_house()
    @.house.add_to_scene()
#    @.house.animate_to_scene 0, =>
#      @.end_house_animate_to_scene()

  init_container: ->
#    @.container.css
#      width: window.innerWidth * @.params.container.size_in_percents.width / 100
#      height: window.innerHeight * @.params.container.size_in_percents.height / 100

  init_camera: ->
    aspect = @.container.innerWidth() / @.container.innerHeight()
    @.camera = new THREE.PerspectiveCamera(75, aspect, 1, 10000)
    for option in @.location.options
      for coord in @.location.coords
        @.camera[option][coord] = @.camera_position_start()[option][coord]

  init_scene: ->
    @.scene = new THREE.Scene()

  init_renderer: ->
    @.renderer = new THREE.CSS3DRenderer()
    @.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    @.container.append($(@.renderer.domElement))

  init_controls: ->
    @.controls = new THREE.OrbitControls(@.camera, @.renderer.domElement)
    @.controls.minDistance = @.params.scene.distance / 2
    @.controls.maxDistance = @.params.scene.distance * 2
    $(@.controls).on 'change', @.render

  valid_event_for: (mode, event) ->
    return false unless @.mode == mode
    return false if @.animated_objects.animated()
    event.preventDefault()
    true

  init_events: ->
    fp = $.app.pages.shared.floor_plans

    @.container.on 'resize', @.on_window_resize
    @.container.on 'click', '.show-floor', (event) ->
      return unless fp.valid_event_for 'house', event
      floor_number = parseInt $(@).text()
      fp.floor_element_on_click floor_number
    @.container.on 'mouseover', '.show-floor', @.floor_element_on_mouse_event
    @.container.on 'mouseout', '.show-floor', @.floor_element_on_mouse_event
    @.container.on 'mouseover', '.apartment-element', @.apartment_element_on_mouse_event
    @.container.on 'mouseout', '.apartment-element', @.apartment_element_on_mouse_event
    @.container.on 'click', '.apartment-element', @.apartment_element_on_click

    house_controls = $('#house-controls-container')
    house_controls.on 'click', '.back-to-house', (event) ->
      $('.fasad-wrap').show();
      $("#canvas-container").zIndex(10)
      return unless fp.valid_event_for 'floor-foreground', event
      fp.back_to_house_on_click()
    house_controls.on 'click', '.toggle-dimensions', fp.toggle_dimensions_on_click

    floors = $('#house-image-container')
    floors.on 'click', '.show-house-floor', (event) ->
      return unless fp.valid_event_for 'house', event
      floor_number = parseInt $(@).data('floorNumber')
      fp.show_house_floor_on_click floor_number

  init_animated_objects: ->
    fp = $.app.pages.shared.floor_plans
    @.animated_objects =
      objects: []
      get_by_name: (name) ->
        for object in @.objects
          return object if object.params.name == name
        return null
      set: (animated_object) ->
        if @.get_by_name(animated_object.params.name)
          @.get_by_name(animated_object.params.name).set animated_object.params
        else
          @.objects.push animated_object
      set_by_params: (name, callbacks = [], scene_objects = [], animated = false) ->
        if @.get_by_name(name)
          @.get_by_name(name).set
            name: name
            callbacks: callbacks
            scene_objects: scene_objects
            animated: animated
        else
          @.objects.push fp.init_animated_object(name, callbacks, scene_objects, animated)
      animate: ->
        return unless @.animated()
        fp.block_controls()
        object.animate() for object in @.objects
        fp.render()
      animated: (name = null) ->
        return @.get_by_name(name).params.animated if name && @.get_by_name(name)
        for object in @.objects
          return true if object.params.animated
        false

  init_animated_object: (name, callbacks = [], scene_objects = [], animated = false) ->
    fp = $.app.pages.shared.floor_plans
    callbacks = [callbacks] unless $.isArray callbacks
    scene_objects = [scene_objects] unless $.isArray scene_objects
    params:
      name: name
      callbacks: callbacks
      scene_objects: scene_objects
      animated: animated
    set: (params) ->
      @.params = $.extend @.params, params
    set_callbacks: (callbacks) ->
      callbacks = [callbacks] unless $.isArray callbacks
      for callback in callbacks
        @.params.callbacks.push callback unless callback in @.params.callbacks
    set_scene_objects: (scene_objects) ->
      scene_objects = [scene_objects] unless $.isArray scene_objects
      @.params.scene_objects.push scene_object for scene_object in scene_objects
    animation_start: ->
      @.params.animated = true
    animation_stop: ->
      callback() for callback in @.params.callbacks
      @.params =
        name: @.params.name
        callbacks: []
        scene_objects: []
        animated: false
    animate: ->
      return unless @.params.animated
      if @.params.scene_objects.length == 0
        @.animation_stop()
        return
      for scene_object, i in @.params.scene_objects
        continue unless scene_object
        for option in fp.location.options
          for coord in fp.location.coords
            scene_object.object[option][coord] += (scene_object.position_of_arrival[option][coord] - scene_object.object[option][coord]) / scene_object.frames
        scene_object.frames -= 1
        @.params.scene_objects.splice i, 1 if scene_object.frames == 0

  init_animation: ->
    setInterval =>
      @.animated_objects.animate()
    , @.params.animation.speed

  block_controls: ->
    console.log 'Controls blocked'
    return if @.params.controls.blocked

    @.controls.rotateSpeed = 0
    @.controls.noPan = true
    @.controls.noZoom = true

    @.params.controls.blocked = true

  unblock_controls_for_house: ->
    console.log 'Controls for house unblocked'
    return unless @.params.controls.blocked

    @.controls.rotateSpeed = 2
    @.controls.minPolarAngle = @.params.scene.yz_angle
    @.controls.maxPolarAngle = @.params.scene.yz_angle
    @.controls.minAzimuthalAngle = - Math.PI
    @.controls.maxAzimuthalAngle = Math.PI
    @.controls.noPan = true
    @.controls.noZoom = false

    @.params.controls.blocked = false

  unblock_controls_for_floor_foreground: ->
    console.log 'Controls for floor 01 unblocked'
    return unless @.params.controls.blocked

    @.controls.rotateSpeed = 1
    @.controls.minPolarAngle = 3 * Math.PI / 8
    @.controls.maxPolarAngle = 3 * Math.PI / 8 # 9 * Math.PI / 16
    @.controls.minAzimuthalAngle = 0 #- Math.PI / 16
    @.controls.maxAzimuthalAngle = 0 #Math.PI / 16
    @.controls.noPan = true
    @.controls.noZoom = false

    @.params.controls.blocked = false

  unblock_controls_for_floor_demonstration: ->
    console.log 'Controls for floor 02 unblocked'
    return unless @.params.controls.blocked

    @.controls.rotateSpeed = 0.2
    @.controls.minPolarAngle = 3 * Math.PI / 8
    @.controls.maxPolarAngle = 7 * Math.PI / 16
    @.controls.minAzimuthalAngle = - Math.PI / 32
    @.controls.maxAzimuthalAngle = Math.PI / 32
    @.controls.noPan = true
    @.controls.noZoom = false

    @.params.controls.blocked = false

  camera_on_start_position: ->
    @.objects_positions_is_equal(@.camera, @.camera_position_start())

  animate_camera_to_start: (callbacks = []) ->
    return if @.camera_on_start_position()
    animated_camera = @.animated_objects.get_by_name 'camera'
    animated_camera = @.init_animated_object 'camera' unless animated_camera
    animated_camera.set_scene_objects
      object: @.camera
      position_of_arrival: @.camera_position_start()
      frames: @.params.animation.frames.camera
    animated_camera.set_callbacks callbacks
    @.animated_objects.set animated_camera
    animated_camera.animation_start()

  init_house: (showed_floor = {}) ->
    fp = $.app.pages.shared.floor_plans
    @.house =
      floors: @.init_floors(showed_floor)
      floor: (floor_number) ->
        @.floors[floor_number - 1]
      add_to_scene: ->
        floor.add_to_scene() for floor in @.floors
      add_to_scene_by: (floor_number) ->
        for floor, i in @.floors
          floor.add_to_scene() unless i == floor_number - 1
      remove_from_scene_by: (floor_number) ->
        for floor, i in @.floors
          floor.remove_from_scene() unless i == floor_number - 1
      move_to: (position) ->
        floor.move_to(position) for floor in @.floors
      update_numbers_positions: ->
        @.floors[@.floors.length - 1].calculate_nearest_number_position()
        corner = 3 if fp.animated_objects.animated()
        floor.update_number_position(corner) for floor in @.floors
      set_delay_timeout_to_animations: (i, animations, direction, callbacks = []) ->
        setTimeout =>
          for floor_id, animation of animations
            @.floors[floor_id]["animate_to_#{animation}"]('house', callbacks)
        , i * fp.params.animation.house.delay[direction]
      animate_to_scene: (floor_number = 0, callbacks = []) ->
        floor_id = floor_number - 1
        length = Math.max floor_id, @.floors.length - floor_number
        for i in [1..length]
          animations = {}
          j = floor_id - i
          animations[j] = 'center_of_scene' if j >= 0 && j < floor_id
          j = floor_id + i
          animations[j] = 'center_of_scene' if j > floor_id && j < @.floors.length
          unless Object.keys(animations).length == 0
            @.set_delay_timeout_to_animations i, animations, 'to_scene', callbacks
      animate_from_scene: (floor_number, callbacks = []) ->
        floor_id = floor_number - 1
        length = Math.max floor_id, @.floors.length - floor_number
        for i in [0..length - 1]
          animations = {}
          j = floor_id - length + i
          animations[j] = 'under_the_scene' if j >= 0 && j < floor_id
          j = floor_id + length - i
          animations[j] = 'above_the_scene' if j > floor_id && j < @.floors.length
          unless Object.keys(animations).length == 0
            @.set_delay_timeout_to_animations i, animations, 'from_scene', callbacks

  init_floors: (showed_floor) ->
    floors = []
    for i in [1..@.params.floors.count]
      if showed_floor.floor
        floors.push @.init_floor(i, 'under_the_scene') if i < showed_floor.number
        floors.push showed_floor.floor if i == showed_floor.number
        floors.push @.init_floor(i, 'above_the_scene') if i > showed_floor.number
      else
        floors.push @.init_floor(i)
    floors

  init_floor: (floor_number, position = 'above_the_scene') ->
    fp = $.app.pages.shared.floor_plans
    object: @.init_floor_object(floor_number, position)
    object_types: ->
      Object.keys @.object
    add_to_scene: ->
      fp.scene.add object for object_type, object of @.object
    remove_from_scene: ->
      for object_type, object of @.object
        fp.scene.remove object
        if object_type == 'plan'
          object.remove apartment for apartment in object.getDescendants()
        else
    move_to: (position) ->
      floor_number = parseInt $(@.object.number.element).text()
      for option in fp.location.options
        for coord in fp.location.coords
          @.object.solid[option][coord] = fp["floor_position_#{position}"](floor_number)[option][coord]
    toggle_to_scene: (toggle, callback) ->
      for object_type, object of @.object
        if object_type == 'solid' then cb = callback else cb = null
        if object_type == 'plan'
          elements = object.getDescendants().map (apartment) -> apartment.element
        else
          elements = [object.element]
        for element in elements
          $(element).animate
            opacity: fp.params.floors.solid.opacity[toggle]
          , fp.params.floors.solid.opacity.speed, cb
    show_to_scene: (callback = null) ->
      @.toggle_to_scene 'show', callback
    hide_from_scene: (callback = null) ->
      @.toggle_to_scene 'hide', callback
    show_number: ->
      $(@.object.number.element).removeClass('hidden')
    hide_number: ->
      $(@.object.number.element).addClass('hidden')
    set_position_by: (other_floor) ->
      for object_type in @.object_types()
        for option in fp.location.options
          @.object[object_type][option] = other_floor.object[object_type][option].clone()
    calculate_number_corner_positions: (floor_number) ->
      floor =
        half_width: fp.params.floors.solid.size.width / 2
        half_height: fp.params.floors.solid.size.height / 2
      corner_positions = []
      for corner in [0..3]
        corner_position_by_params = fp.params.floors.number.positions.corners[floor_number][corner]
        corner_positions[corner] =
          x: @.object.solid.position.x - floor.half_width + corner_position_by_params[0]
          y: @.object.solid.position.y
          z: @.object.solid.position.z - floor.half_height + corner_position_by_params[1]
      corner_positions
    calculate_distance_to_corner_position: (corner_positions, corner) ->
      sqr = {}
      for coord in fp.location.coords
        sqr[coord] = Math.pow(corner_positions[corner][coord] - fp.camera.position[coord], 2)
      Math.sqrt sqr.x + sqr.y + sqr.z
    recalculate_current_corner: (corner_positions, current_corner) ->
      current_distance = @.calculate_distance_to_corner_position(corner_positions, current_corner)
      for corner_position, corner in corner_positions
        continue if corner == current_corner
        distance = @.calculate_distance_to_corner_position(corner_positions, corner)
        if distance < current_distance - fp.params.floors.number.change_position_delay
          current_distance = distance
          current_corner = corner
      current_corner
    update_plan_position: (floor_number) ->
      @.object.plan.rotation = @.object.solid.rotation.clone()
      @.object.plan.position = @.object.solid.position.clone()
      @.object.plan.position.y += 2
    calculate_nearest_number_position: ->
      floor_number = parseInt $(@.object.number.element).text()
      corner_positions = @.calculate_number_corner_positions(floor_number)
      current_corner = fp.params.floors.number.positions.current
      current_corner = @.recalculate_current_corner(corner_positions, current_corner)
      fp.params.floors.number.positions.current = current_corner
    update_number_position: (corner) ->
      @.object.number.rotation = fp.camera.rotation.clone()
      floor_number = parseInt $(@.object.number.element).text()
      current_corner = corner || fp.params.floors.number.positions.current
      for coord in fp.location.coords
        @.object.number.position[coord] = @.calculate_number_corner_positions(floor_number)[current_corner][coord]
    animate_to: (position, name = 'house', callbacks = []) ->
      floor_number = parseInt $(@.object.number.element).text()
      animated_floor = fp.animated_objects.get_by_name(name)
      unless animated_floor
        animated_floor = fp.init_animated_object name, callbacks
      for object_type, object of @.object
        animated_floor.set_scene_objects
          object: object
          position_of_arrival: fp["floor_position_#{position}"](floor_number)
          frames: fp.params.animation.frames.floor["to_#{position}"]
        animated_floor.set_callbacks callbacks
      fp.animated_objects.set animated_floor
      animated_floor.animation_start()
    animate_to_preforeground: (name = 'floor', callbacks = []) ->
      @.animate_to 'preforeground', name, callbacks
    animate_to_foreground: (name = 'floor', callbacks = []) ->
      @.animate_to 'foreground', name, callbacks
    animate_to_demonstration: (name = 'floor', callbacks = []) ->
      @.animate_to 'demonstration', name, callbacks
    animate_to_center_of_scene: (name = 'house', callbacks = []) ->
      @.animate_to 'center_of_scene', name, callbacks
    animate_to_above_the_scene: (name = 'house', callbacks = []) ->
      @.animate_to 'above_the_scene', name, callbacks
    animate_to_under_the_scene: (name = 'house', callbacks = []) ->
      @.animate_to 'under_the_scene', name, callbacks
    animate_to_hidden: (name = 'house', callbacks = []) ->
      @.animate_to 'hidden', name, callbacks

  init_floor_object: (floor_number, position) ->
    solid: @.init_solid_floor_object(floor_number, position)
    plan: @.init_plan_floor_object(floor_number, position)
    number: @.init_number_floor_object(floor_number)

  init_solid_floor_object: (floor_number, position) ->
    solid_floor_object = new THREE.CSS3DObject(@.init_solid_floor_dom_element(floor_number))
    for option in @.location.options
      for coord in @.location.coords
        solid_floor_object[option][coord] = @["floor_position_#{position}"](floor_number)[option][coord]
    solid_floor_object

  init_solid_floor_dom_element: (floor_number) ->
    solid_floor_element = $('<div/>', class: 'floor-element-'+floor_number)
    solid_floor_css =
      width: "#{@.params.floors.solid.size.width}px"
      height: "#{@.params.floors.solid.size.height}px"
      opacity: @.params.floors.solid.opacity.show
      'background-image': "url(/images/floor-#{floor_number}.png)"
    $(solid_floor_element).css(solid_floor_css).get(0)

  init_plan_floor_object: (floor_number, position) ->
    plan_floor_object = new THREE.Object3D()
    plan_floor_object.name = "plan-#{floor_number}"
    for apartment in @.apartments
      if apartment.floor_number == floor_number
        apartment_floor_object = @.init_apartnemt_floor_object(apartment, position)
        plan_floor_object.add apartment_floor_object
    plan_floor_object

  init_apartnemt_floor_object: (apartment, position) ->
    apartment_floor_object = new THREE.CSS3DObject(@.init_apartnemt_floor_dom_element(apartment))
    apartment_floor_object.name = "apartment-#{apartment.number}"
    apartment_floor_object.position.x = - @.params.floors.solid.size.width / 2 + apartment.size[0] / 2 + apartment.dx
    apartment_floor_object.position.y = @.params.floors.solid.size.height / 2 - apartment.size[1] / 2 - apartment.dy
    apartment_floor_object.position.z += @.params.floors.plan.apartment.mouseover.dz
    apartment_floor_object

  init_apartnemt_floor_dom_element: (apartment) ->
    apartnemt_floor_element = $('<div/>', class: 'apartment-element', num: apartment.id, id: 'apart-'+apartment.floor_number+'-'+apartment.number, 'data-selected': false)
    if apartment.sold_out
      apartnemt_floor_element.css
        'boxShadow': 'inset 0 0 400px black'
    else
      apartnemt_floor_element.css
        'cursor': 'pointer'
    $(apartnemt_floor_element).css
      width: "#{apartment.size[0]}px"
      height: "#{apartment.size[1]}px"
    apartnemt_floor_element.get(0)

  init_number_floor_object: (floor_number) ->
    floor_number_element = @.init_number_floor_dom_element(floor_number)
    floor_number_object = new THREE.CSS3DObject(floor_number_element)
    floor_number_object

  init_show_floor_link_dom_element: (floor_number) ->
    show_floor_link_element = $("<div/>", class: 'show-floor')
    show_floor_link_element.text("#{floor_number} этаж")
    show_floor_link_css =
      width: "#{@.params.floors.number.size.number.width}px"
      height: "#{@.params.floors.number.size.number.height}px"
    show_floor_link_element.css(show_floor_link_css)

  init_number_floor_arrow_dom_element: (arrow_direction) ->
    number_floor_arrow_element = $('<img/>', class: 'floor-number-arrow')
    number_floor_arrow_element.attr('src', "images/floor-number-#{arrow_direction}-arrow.png")
    number_floor_arrow_element

  init_number_floor_dom_element: (floor_number) ->
    number_floor_element = $('<div/>', class: 'floor-number')
    number_floor_left_element = $('<div/>', class: 'left')
    number_floor_element.append(number_floor_left_element)
    number_floor_left_element.append(@.init_show_floor_link_dom_element(floor_number))
    number_floor_left_element.append(@.init_number_floor_arrow_dom_element('right'))
    number_floor_right_element = $('<div/>', class: 'right')
    number_floor_element.append(number_floor_right_element)
    number_floor_right_element.append(@.init_number_floor_arrow_dom_element('left'))
    number_floor_right_element.append(@.init_show_floor_link_dom_element(floor_number))
    number_floor_css =
      width: "#{@.params.floors.number.size.container.width}px"
      height: "#{@.params.floors.number.size.container.height}px"
    number_floor_element.css(number_floor_css).get(0)

  hide_number_floor_part: (part, both = false) ->
    other_part = if part == 'left' then 'right' else 'left'
    $(".floor-number .#{part}").addClass('hidden')
    $(".floor-number .#{other_part}").removeClass('hidden') unless both

  init_floor_demonstration: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    @.floor_demonstration =
      object: @.init_floor_demonstration_object(floor_number)
      add_to_scene: ->
        fp.scene.add @.object
        $(@.object.element).animate
          'opacity': fp.params.floors.demonstration.opacity.show
        , fp.params.floors.demonstration.opacity.speed
      remove_from_scene: ->
        $(@.object.element).animate
          'opacity': fp.params.floors.demonstration.opacity.hide
        , fp.params.floors.demonstration.opacity.speed, =>
          fp.scene.remove @.object

  init_floor_demonstration_object: (floor_number) ->
    floor_demonstration_object = new THREE.CSS3DObject(@.init_floor_demonstration_dom_element(floor_number))
    for option in @.location.options
      for coord in @.location.coords
        floor_demonstration_object[option][coord] = @.floor_demonstration_position_foreground(floor_number)[option][coord]
    floor_demonstration_object

  init_floor_demonstration_dom_element: (floor_number) ->
    floor_demonstration_element = $('<div/>', class: 'floor-demonstration-element')
    floor_demonstration_css =
      width: "#{@.params.floors.demonstration.size.width}px"
      height: "#{@.params.floors.demonstration.size.height}px"
      opacity: @.params.floors.demonstration.opacity.hide
      'background-image': "url(/images/floor-demonstration-#{floor_number}.png)"
    $(floor_demonstration_element).css(floor_demonstration_css).get(0)

  on_window_resize: ->
    @.camera.aspect = @.container.innerWidth() / @.container.innerHeight()
    @.camera.updateProjectionMatrix()
    @.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    @.render()

  floor_element_on_click: (floor_number) ->
#    $(@.house.floors[floor_number - 1].object.solid.element).css boxShadow: 'none'
    @.house.animate_from_scene floor_number, =>
      @.animate_showed_floor_to_foreground(floor_number)

  show_house_floor_on_click: (floor_number) ->
#    $(@.house.floors[floor_number - 1].object.solid.element).css boxShadow: 'none'
    $("#canvas-container").zIndex(800)
    $('.fasad-wrap').hide();
    @.animate_house_floor_to_foreground(floor_number)

  floor_element_on_mouse_event: (event) ->
    fp = $.app.pages.shared.floor_plans
    return unless fp.valid_event_for 'house', event
    floor_number = parseInt $(@).text()
    floor_element = $(fp.house.floors[floor_number - 1].object.solid.element)
    if event.type == 'mouseover'
#      box_shadow = "inset 0 0 #{Math.round((floor_element.width() + floor_element.height()))}px gold"
    else
#      box_shadow = 'none'
#    floor_element.css boxShadow: box_shadow

  animate_showed_floor_to_foreground: (floor_number) ->
    @.showed_floor.floor = @.house.floor(floor_number)
    @.showed_floor.floor.hide_number()
    @.showed_floor.number = floor_number

    @.animate_camera_to_start()
    @.showed_floor.floor.animate_to_preforeground 'floor-preforeground', =>
      setTimeout =>
        @.showed_floor.floor.animate_to_foreground 'floor', =>
          @.house.remove_from_scene_by(@.showed_floor.number)
          @.unblock_controls_for_floor_foreground()
          @.toggle_controls_container 'show'
          @.change_mode_to 'floor-foreground'
      , 100

  animate_house_floor_to_foreground: (floor_number) ->
    @.toggle_house_image_controls_container('hide')
    @.showed_floor.floor = @.house.floor(floor_number)
    @.showed_floor.floor.hide_number()
    @.showed_floor.number = floor_number
    @.showed_floor.floor.object.solid.position.set(0, 0, 0)
    @.showed_floor.floor.object.solid.rotation = @.camera.rotation.clone()
    @.showed_floor.floor.object.solid.rotation.x -= Math.PI / 2;

    @.showed_floor.floor.animate_to_preforeground 'floor-preforeground', =>
      setTimeout =>
        @.showed_floor.floor.animate_to_foreground 'floor', =>
          @.house.remove_from_scene_by(@.showed_floor.number)
          @.unblock_controls_for_floor_foreground()
          @.toggle_house_controls_container 'show'
          @.change_mode_to 'floor-foreground'
      , 100

  back_to_house_on_click: ->
    @.toggle_house_controls_container 'hide'
    @.animate_camera_to_start()
    @.showed_floor.floor.animate_to_hidden 'floor', =>
      @.showed_floor.floor.show_number()
      @.init_house @.showed_floor
      @.house.add_to_scene_by(@.showed_floor.number)
      @.house.move_to('above_the_scene');
      @.clear_showed_floor()
      @.change_mode_to 'house'
      @.toggle_house_image_controls_container('show')

  back_to_house_floors_on_click: ->
    @.toggle_controls_container 'hide'
    @.animate_camera_to_start()
    @.showed_floor.floor.animate_to_center_of_scene 'floor', =>
      @.showed_floor.floor.show_number()
      @.init_house @.showed_floor
      @.house.add_to_scene_by(@.showed_floor.number)
      @.house.animate_to_scene @.showed_floor.number, =>
        @.end_house_animate_to_scene()
        @.clear_showed_floor()
        @.change_mode_to 'house'

  toggle_house_controls_container: (position) ->
    if position == 'show' then action = 'remove' else action = 'add'
    $('#house-controls-container')["#{action}Class"]('hidden')

  toggle_house_image_controls_container: (position) ->
    if position == 'show' then visibility = "visible" else visibility = "hidden"
    $('#house-image-container').css("visibility", visibility)

  end_house_animate_to_scene: ->
    @.unblock_controls_for_house()

  toggle_dimensions_on_click: (event) ->
    fp = $.app.pages.shared.floor_plans
    if $(@).data('toggle-direction') == 'to-3d'
      return unless fp.valid_event_for 'floor-foreground', event
      $('.back-to-house').addClass('hidden')
      fp.animate_camera_to_start()
      fp.showed_floor.floor.animate_to_demonstration 'floor', =>
        fp.init_floor_demonstration(fp.showed_floor.number)
        fp.floor_demonstration.add_to_scene()
        fp.showed_floor.floor.hide_from_scene()
        fp.unblock_controls_for_floor_demonstration()

        $(@).text('Показать в 2D').data('toggle-direction', 'to-2d')
        fp.change_mode_to 'floor-demonstration'
    else
      return unless fp.valid_event_for 'floor-demonstration', event
      fp.animate_camera_to_start()
      fp.floor_demonstration.remove_from_scene()
      fp.showed_floor.floor.show_to_scene =>
        fp.showed_floor.floor.animate_to_foreground 'floor', =>
          fp.unblock_controls_for_floor_foreground()

          $(@).text('Показать в 3D').data('toggle-direction', 'to-3d')
          fp.change_mode_to 'floor-foreground'
          $('.back-to-house').removeClass('hidden')

  clear_showed_floor: ->
    @.showed_floor =
      floor: null
      number: null

  get_apartment_by_id: (id) ->
    for apartment in @.apartments
      if apartment.id == id
        return apartment

  apartment_element_on_mouse_event: (event) ->
    return # !!!
    fp = $.app.pages.shared.floor_plans
    return unless fp.valid_event_for 'floor-foreground', event
    return unless fp.showed_floor.floor
    apartment = fp.get_apartment_by_id parseInt($(@).attr('id'))
    if event.type == 'mouseover'
      if $(@).data('selected') then return else $(@).data('selected', true)
      if apartment.sold_out then shadow_color = 'red' else shadow_color = 'green'
      shadow = "inset 0 0 #{Math.round((apartment.size[0] + apartment.size[1]) / 4)}px gray"# #{shadow_color}"
      $(@).css
#        boxShadow: shadow
        opacity: fp.params.floors.plan.apartment.opacity.mouseover
      sign_dz = 1
    else
      if $(@).data('selected') then $(@).data('selected', false) else return
      $(@).css
#        boxShadow: 'none'
        opacity: fp.params.floors.plan.apartment.opacity.default
      sign_dz = -1
    plan_object = fp.scene.getObjectByName("plan-#{apartment.floor_number}")
    object = plan_object.getObjectByName("apartment-#{apartment.number}")
#    object.position.z += sign_dz * fp.params.floors.plan.apartment.mouseover.dz if object
    fp.render()

  apartment_element_on_click: (event) ->
    fp = $.app.pages.shared.floor_plans
    return unless fp.valid_event_for 'floor-foreground', event
    return unless fp.showed_floor.floor
    apartment = fp.get_apartment_by_id parseInt($(@).attr('num'))
    $('.floor-number').text(apartment.floor_number);
    $('.apart-number').text(apartment.number);
    $('.apart-price').text(apartment.price);
    $('.apart-area').text(apartment.area);
    return if apartment.sold_out
    $(".buy-wrapper").show();
    return false;

  update_plans_positions_before_render: ->
    floor.update_plan_position(i + 1) for floor, i in @.house.floors

  update_number_showed_parts: ->
    floor_number_element = $('.floor-number').last()[0]
    return unless floor_number_element
    floor_number_element_position = $(floor_number_element).position().left + $(floor_number_element).width() / 2
    if @.animated_objects.animated() || @.mode != 'house'
      @.hide_number_floor_part(part, true) for part in ['left', 'right']
    else
      if floor_number_element_position > @.container.width() / 2 + @.params.floors.number.change_part_delay
        @.hide_number_floor_part 'left'
      else if floor_number_element_position < @.container.width() / 2 - @.params.floors.number.change_part_delay
        @.hide_number_floor_part 'right'

  animate: ->
    fp = $.app.pages.shared.floor_plans
    requestAnimationFrame(fp.animate)
    fp.controls.update()

  render: ->
    fp = $.app.pages.shared.floor_plans
    fp.update_plans_positions_before_render()
    fp.house.update_numbers_positions()
    fp.update_number_showed_parts()
    fp.renderer.render(fp.scene, fp.camera)

$(document).ready ->
  fp = $.app.pages.shared.floor_plans
  images = []
  for floor_number in [1..fp.params.floors.count]
    images.push "/images/floor-#{floor_number}.png"
    images.push "/images/floor-demonstration-#{floor_number}.png"
  for apartment in fp.apartments
    images.push "/uploads/apartment/image/#{apartment.image}"
  $.app.preload.ready images, ->
    fp.init()
    fp.animate()
