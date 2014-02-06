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
    scene:
      distance: 1000
      yz_angle: 3 * Math.PI / 8
    controls:
      blocked: false
    animation:
      speed: 10
      frames:
        camera: 100
        floor:
          to_foreground: 100
          to_start: 40
          to_center: 50
      house:
        delay:
          to_start: 200
          to_center: 300
    floors:
      count: 6
      solid:
        size:
          width: 1023
          height: 544
        opacity: 0.75
        gap: 100
      number:
        positions:
          1: corners: [[0, 0], [1023, 0], [1023, 544], [0, 544]], current: 3
          2: corners: [[0, 0], [1023, 0], [1023, 544], [0, 544]], current: 3
          3: corners: [[0, 0], [1023, 0], [1023, 544], [0, 544]], current: 3
          4: corners: [[0, 0], [1023, 0], [1023, 544], [0, 544]], current: 3
          5: corners: [[0, 0], [1023, 0], [1023, 544], [0, 544]], current: 3
          6: corners: [[0, 0], [1023, 0], [1023, 544], [0, 544]], current: 3
        change_position_delay: 200
        font_size:
          px: 50
  house: {}
  showed_floor:
    floor: null
    number: null
  animated_objects: []

  camera_position_start: ->
    position:
      x: 0
      y: @.params.scene.distance * Math.cos(@.params.scene.yz_angle)
      z: @.params.scene.distance * Math.sin(@.params.scene.yz_angle)
    rotation:
      x: - Math.cos(@.params.scene.yz_angle), y: 0, z: 0

  floor_position_start: (floor_number) ->
    position:
      x: 0
      y: (floor_number - @.params.floors.count / 2) * @.params.floors.solid.gap + @.params.scene.distance * 2
      z: 0
    rotation:
      x: - Math.PI / 2, y: 0, z: 0

  floor_position_center: (floor_number) ->
    position:
      x: 0
      y: (floor_number - @.params.floors.count / 2) * @.params.floors.solid.gap
      z: 0
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

  init_events: ->
    @.container.on 'resize', @.on_window_resize
    @.container.on 'click', 'a.show-floor', (event) ->
      event.preventDefault()
      floor_number = parseInt $(@).text()
      $.app.pages.shared.floor_plans.floor_element_on_click floor_number

    controls = $('#controls-container')
    controls.on 'click', 'a#back-to-house', (event) ->
      event.preventDefault()
      $.app.pages.shared.floor_plans.back_to_house_on_click()

  init_animation: ->
    setInterval =>
      if @.goes_an_animation()
        @.block_controls()
        @.animation_step_for_object(i) for object, i in @.animated_objects
        @.render()
    , @.params.animation.speed

  block_controls: ->
    return if @.params.controls.blocked

    @.controls.rotateSpeed = 0
    @.controls.noPan = true
    @.controls.noZoom = true

    @.params.controls.blocked = true

  unblock_controls_for_house: ->
    return unless @.params.controls.blocked

    @.controls.rotateSpeed = 1
    @.controls.minPolarAngle = @.params.scene.yz_angle
    @.controls.maxPolarAngle = @.params.scene.yz_angle
    @.controls.noPan = true
    @.controls.noZoom = false

    @.params.controls.blocked = false

  unblock_controls_for_floor: ->
    return unless @.params.controls.blocked

    @.controls.rotateSpeed = 1
    @.controls.minPolarAngle = 0
    @.controls.maxPolarAngle = 2 * Math.PI
    @.controls.noPan = true
    @.controls.noZoom = false

    @.params.controls.blocked = false

  animation_step_for_object: (i) ->
    animated_object = @.animated_objects[i]
    return unless animated_object
    for option in @.location.options
      for coord in @.location.coords
        animated_object.object[option][coord] += (animated_object.final[option][coord] - animated_object.object[option][coord]) / animated_object.frames
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
    unless @.goes_an_animation()
      clearInterval @.waiting_end_of_animation
      callback()

  goes_an_animation: ->
    @.animated_objects.length > 0

  init_house: ->
    fp = $.app.pages.shared.floor_plans
    @.house =
      floors: @.init_floors()
      floor: (floor_number) ->
        @.floors[floor_number - 1]
      add_to_scene: ->
        floor.add_to_scene_solid_with_number() for floor in @.floors
      remove_from_scene: ->
        floor.remove_from_scene() for floor in @.floors
      set_delay_timeout_to_animate: (floor, animation_direction, i) =>
        setTimeout =>
          floor["animate_#{animation_direction}"]()
        , i * @.params.animation.house.delay[animation_direction]
      animate_to_scene: ->
        for floor, i in @.floors
          @.set_delay_timeout_to_animate(floor, 'to_center', i)
        fp.do_it_after_animation fp.end_house_animate_to_scene
      animate_from_scene: ->
        for floor, i in @.floors.slice(0).reverse()
          @.set_delay_timeout_to_animate(floor, 'to_start', i)

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
    remove_from_scene: ->
      @.remove_from_scene_all_objects_of_types ['solid', 'number']
    set_position_by: (other_floor) ->
      for object_type in ['solid', 'number']
        for option in ['position', 'rotation']
          @.object[object_type][option] = other_floor.object[object_type][option].clone()
    calculate_number_corner_positions: (floor_number) ->
      floor =
        half_width: fp.params.floors.solid.size.width / 2
        half_height: fp.params.floors.solid.size.height / 2
      corner_positions = []
      for corner in [0..3]
        corner_position_by_params = fp.params.floors.number.positions[floor_number].corners[corner]
        corner_positions[corner] =
          x: @.object.solid.position.x - floor.half_width + corner_position_by_params[0]
          y: @.object.solid.position.y + fp.params.floors.number.font_size.px / 2
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
    update_number_position: (floor_number) ->
      @.object.number.rotation = fp.camera.rotation
      corner_positions = @.calculate_number_corner_positions(floor_number)
      current_corner = fp.params.floors.number.positions[floor_number].current
      current_corner = @.recalculate_current_corner(corner_positions, current_corner)
      fp.params.floors.number.positions[floor_number].current = current_corner
      for coord in fp.location.coords
        @.object.number.position[coord] = corner_positions[current_corner][coord]
    animate_to: (position, object_types) ->
      object_types = [object_types] unless $.type(object_types) == 'array'
      floor_number = @.object.number.element.textContent
      for object_type in object_types
        fp.animated_objects.push
          object: @.object[object_type]
          final: fp["floor_position_#{position}"](floor_number)
          frames: fp.params.animation.frames.floor["to_#{position}"]
    animate_to_foreground: ->
      @.animate_to 'foreground', 'solid'
      fp.do_it_after_animation fp.end_floor_animate_to_foreground
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
    for option in @.location.options
      for coord in @.location.coords
        solid_floor_object[option][coord] = @.floor_position_start(floor_number)[option][coord]
    solid_floor_object

  init_solid_floor_dom_element: (floor_number) ->
    solid_floor_element = document.createElement('div')
    solid_floor_css =
      width: "#{@.params.floors.solid.size.width}px"
      height: "#{@.params.floors.solid.size.height}px"
      opacity: @.params.floors.solid.opacity
      'background-image': "url(/images/floor#{floor_number}.png)"
    $(solid_floor_element).addClass('floor-element').css solid_floor_css
    solid_floor_element

  init_number_floor_object: (floor_object, floor_number) ->
    floor_number_element = @.init_number_floor_dom_element(floor_number)
    floor_number_object = new THREE.CSS3DObject(floor_number_element)
    for coord in @.location.coords
      floor_number_object.position[coord] = @.floor_position_start(floor_number).position[coord]
    floor_number_object

  init_number_floor_dom_element: (floor_number) ->
    number_floor_element = document.createElement('a')
    number_floor_css =
      width: "#{@.params.floors.number.font_size.px}px"
      height: "#{@.params.floors.number.font_size.px}px"
      'font-size': "#{@.params.floors.number.font_size.px}px"
    $(number_floor_element).attr('href', '#').addClass('show-floor')
    $(number_floor_element).text(floor_number).css number_floor_css
    number_floor_element

  on_window_resize: ->
    @.camera.aspect = @.container.innerWidth() / @.container.innerHeight()
    @.camera.updateProjectionMatrix()
    @.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    @.render()

  floor_element_on_click: (floor_number) ->
    @.showed_floor.floor = @.init_floor(floor_number)
    @.showed_floor.floor.set_position_by @.house.floor(floor_number)
    @.showed_floor.floor.add_to_scene_solid()
    @.showed_floor.number = floor_number

    @.showed_floor.floor.animate_to_foreground()
    @.house.animate_from_scene()
    @.animate_camera_to_start()

  end_floor_animate_to_foreground: ->
    fp = $.app.pages.shared.floor_plans
    fp.house.remove_from_scene()
    fp.unblock_controls_for_floor()

    $('#back-to-house').removeClass 'hidden'

  back_to_house_on_click: ->
    @.init_house()
    @.house.add_to_scene()

    @.showed_floor.floor.animate_to_center()
    @.house.animate_to_scene()
    @.animate_camera_to_start()

  end_house_animate_to_scene: ->
    fp = $.app.pages.shared.floor_plans
    fp.remove_showed_floor() if fp.showed_floor.floor
    fp.unblock_controls_for_house()

    $('#back-to-house').addClass 'hidden'

  remove_showed_floor: ->
    return unless @.showed_floor.floor
    @.showed_floor.floor.remove_from_scene_solid()
    @.showed_floor =
      floor: null
      number: null

  fix_camera_rotation_before_render: ->
    if @.goes_an_animation()
      for coord in @.location.coords
        @.camera.rotation[coord] = @.camera_position_start().rotation[coord]

  update_number_positions_before_render: ->
    floor.update_number_position(i + 1) for floor, i in @.house.floors

  remove_showed_floor_before_it_coincides_with_house: ->
    return unless @.showed_floor.floor
    floor = @.house.floors[@.showed_floor.number - 1]
    if @.floors_position_is_coincides(floor, @.showed_floor.floor)
      @.remove_showed_floor()
      return

  floors_position_is_coincides: (one_floor, other_floor) ->
    for option in @.location.options
      for coord in @.location.coords
        return false unless one_floor.object.solid[option][coord] == other_floor.object.solid[option][coord]
    true

  animate: ->
    fp = $.app.pages.shared.floor_plans
    requestAnimationFrame(fp.animate)
    fp.controls.update()

  render: ->
    fp = $.app.pages.shared.floor_plans
    fp.fix_camera_rotation_before_render()
    fp.update_number_positions_before_render()
    fp.remove_showed_floor_before_it_coincides_with_house()
    fp.renderer.render(fp.scene, fp.camera)

$.app.pages.shared.floor_plans.init()
$.app.pages.shared.floor_plans.animate()
