#= require threejs/three.min
#= require threejs/renderers/CSS3DRenderer
#= require threejs/controls/OrbitControls

$.app.pages ||= {}
$.app.pages.shared ||= {}
$.app.pages.shared.floor_plans =
  container: $("#canvas-container")
  scene_params:
    distance: 1000
    yz_angle: 3 * Math.PI / 8
  animation:
    frames:
      camera: 50
    speed: 30
  floors_params:
    count: 6
    size:
      width: 1023
      height: 544
    opacity: 0.7
    gap: 100
  floors_numbers_params:
    font_size_px: 40
  house: null
  animated_objects: []

  camera_position_start: ->
    position:
      x: 0
      y: @.scene_params.distance * Math.cos(@.scene_params.yz_angle)
      z: @.scene_params.distance * Math.sin(@.scene_params.yz_angle)
    rotation:
      x: 0, y: 0, z: 0

  floor_solid_position_start: (floor_number) ->
    position:
      x: 0
      y: (floor_number - @.floors_params.count / 2) * @.floors_params.gap + @.scene_params.distance * 2
      z: 0
    rotation:
      x: - Math.PI / 2, y: 0, z: 0

  floor_solid_position_center: (floor_number) ->
    position:
      x: 0
      y: (floor_number - @.floors_params.count / 2) * @.floors_params.gap
      z: 0
    rotation:
      x: - Math.PI / 2, y: 0, z: 0

  floor_solid_position_foreground: ->
    position:
      x: 0
      y: @.scene_params.distance / 4 * Math.cos(@.scene_params.yz_angle)
      z: @.scene_params.distance / 4 * Math.sin(@.scene_params.yz_angle)
    rotation:
      x: @.scene_params.yz_angle - Math.PI / 2, y: 0, z: 0

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
    @.controls.minDistance = @.scene_params.distance / 2
    @.controls.maxDistance = @.scene_params.distance * 2
    @.controls.minPolarAngle = @.scene_params.yz_angle
    @.controls.maxPolarAngle = @.scene_params.yz_angle
    @.controls.noPan = true
    $(@.controls).on 'change', @.render

  init_events: ->
    @.container.on 'resize', @.on_window_resize
    @.container.on 'click', 'a.show-floor', @.floor_element_on_click

  init_animation: ->
    fp = $.app.pages.shared.floor_plans
    setInterval ->
      if fp.animated_objects.length > 0
        fp.animation_step_for_object(i) for object, i in fp.animated_objects
        fp.render()
    , fp.animation.speed

  animation_step_for_object: (i) ->
    fp = $.app.pages.shared.floor_plans
    animated_object = fp.animated_objects[i]
    return unless animated_object
    for option in ['position', 'rotation']
      for coord in ['x', 'y', 'z']
        animated_object.object[option][coord] -= (animated_object.object[option][coord] - animated_object.final[option][coord]) / animated_object.frames
    animated_object.frames -= 1
    fp.animated_objects.splice(i, 1) if animated_object.frames == 0

  animate_camera_to_start: ->
    fp = $.app.pages.shared.floor_plans
    fp.animated_objects.push
      object: fp.camera
      final: fp.camera_position_start()
      frames: fp.animation.frames.camera

  init_axes: ->
    fp = $.app.pages.shared.floor_plans
    ox = document.createElement('div')
    oy = document.createElement('div')
    oz = document.createElement('div')
    ox_css =
      width: "#{@.scene_params.distance}px"
      height: "#{Math.round(@.scene_params.distance / 100)}px"
      'background-color': "#ff0000"
    oy_css =
      width: "#{@.scene_params.distance}px"
      height: "#{Math.round(@.scene_params.distance / 100)}px"
      'background-color': "#00ff00"
    oz_css =
      width: "#{@.scene_params.distance}px"
      height: "#{Math.round(@.scene_params.distance / 100)}px"
      'background-color': "#0000ff"
    $(ox).css ox_css
    $(oy).css oy_css
    $(oz).css oz_css

    ox_object = new THREE.CSS3DObject(ox)
    ox_object.position.x += Math.round(@.scene_params.distance / 2)
    oy_object = new THREE.CSS3DObject(oy)
    oy_object.position.y += Math.round(@.scene_params.distance / 2)
    oy_object.rotation.z += Math.PI / 2
    oz_object = new THREE.CSS3DObject(oz)
    oz_object.position.z += Math.round(@.scene_params.distance / 2)
    oz_object.rotation.y += Math.PI / 2

    fp.scene.add(ox_object)
    fp.scene.add(oy_object)
    fp.scene.add(oz_object)

  on_window_resize: ->
    fp = $.app.pages.shared.floor_plans
    fp.camera.aspect = @.container.innerWidth() / @.container.innerHeight()
    fp.camera.updateProjectionMatrix()
    fp.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    fp.render()

  floor_element_on_click: (event) ->
    event.preventDefault()
    fp = $.app.pages.shared.floor_plans
    floor_number = parseInt $(@).closest('.floor-element').data('floor-number')
    fp.show_floor floor_number

  animate: ->
    fp = $.app.pages.shared.floor_plans
    requestAnimationFrame(fp.animate)
    fp.controls.update()

  render: ->
    fp = $.app.pages.shared.floor_plans
    for floor, i in fp.house.floors
      floor.update_number_rotation()
    fp.renderer.render(fp.scene, fp.camera)

  init_number_floor_dom_element: (floor_number) ->
    number_floor_element = document.createElement('div')
    number_floor_css =
      width: "#{3 * @.floors_numbers_params.font_size_px}px"
      height: "#{@.floors_numbers_params.font_size_px}px"
      'font-size': "#{@.floors_numbers_params.font_size_px}px"
    $(number_floor_element).text(floor_number).css number_floor_css
    number_floor_element

  init_solid_floor_show_link_dom_element: ->
    link = document.createElement('a')
    $(link).addClass('show-floor').attr('href', '#').text('SHOW')

  init_solid_floor_dom_element: (floor_number) ->
    solid_floor_element = document.createElement('div')
    solid_floor_css =
      width: "#{@.floors_params.size.width}px"
      height: "#{@.floors_params.size.height}px"
      opacity: @.floors_params.opacity
      'background-image': "url(/assets/floor#{floor_number}.png)"
    $(solid_floor_element).addClass('floor-element').css solid_floor_css
    $(solid_floor_element).data 'floor-number', floor_number
    $(solid_floor_element).append @.init_solid_floor_show_link_dom_element
    solid_floor_element

  init_number_floor_object: (floor_object, floor_number) ->
    floor_number_element = @.init_number_floor_dom_element(floor_number)
    floor_number_object = new THREE.CSS3DObject(floor_number_element)
    for coord in ['x', 'y', 'z']
      floor_number_object.position[coord] = @.floor_solid_position_start(floor_number).position[coord]
    floor_number_object.position.y += @.floors_numbers_params.font_size_px / 2
    floor_number_object

  init_solid_floor_object: (floor_number) ->
    solid_floor_object = new THREE.CSS3DObject(@.init_solid_floor_dom_element(floor_number))
    for option in ['position', 'rotation']
      for coord in ['x', 'y', 'z']
        solid_floor_object[option][coord] = @.floor_solid_position_start(floor_number)[option][coord]
    solid_floor_object

  init_floor_object: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    solid_floor_object = fp.init_solid_floor_object(floor_number)
    number_floor_object = fp.init_number_floor_object(solid_floor_object, floor_number)
    floor_object =
      solid: solid_floor_object
      number: number_floor_object
    floor_object

  init_floor: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    animate_to_foreground_frames: 40
    animate_to_start_frames: 40
    animate_to_center_frames: 40
    object: fp.init_floor_object(floor_number)
    get_object_by_type: (object_type) ->
      @.object[object_type]
    add_to_scene_all_objects_of_types: (object_types) ->
      object_types = [object_types] unless $.type(object_types) == 'array'
      fp.scene.add @.get_object_by_type(object_type) for object_type in object_types
    add_to_scene_solid_with_number: ->
      @.add_to_scene_all_objects_of_types ['solid', 'number']
    add_to_scene_solid: ->
      @.add_to_scene_all_objects_of_types 'solid'
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
          final: fp["floor_#{object_type}_position_#{position}"](floor_number)
          frames: @["animate_to_#{position}_frames"]
    animate_to_foreground: ->
      @.animate_to 'foreground', 'solid'
    animate_to_center: ->
      floor_number = @.object.number.element.textContent
      fp.animated_objects.push
        object: @.object.solid
        final: fp.floor_solid_position_center(floor_number)
        frames: @.animate_to_center_frames
      fp.animated_objects.push
        object: @.object.number
        final: fp.floor_solid_position_center(floor_number)
        frames: @.animate_to_center_frames
    animate_to_start: ->
      floor_number = @.object.number.element.textContent
      fp.animated_objects.push
        object: @.object.solid
        final: fp.floor_solid_position_start(floor_number)
        frames: @.animate_to_start_frames
      fp.animated_objects.push
        object: @.object.number
        final: fp.floor_solid_position_start(floor_number)
        frames: @.animate_to_start_frames

  init_floors: ->
    fp = $.app.pages.shared.floor_plans
    floors = []
    floors.push fp.init_floor(i) for i in [1..fp.floors_params.count]
    floors

  init_house: ->
    fp = $.app.pages.shared.floor_plans
    fp.house =
      animation:
        delay: 300
      floors: fp.init_floors()
      floor: (floor_number) ->
        @.floors[floor_number - 1]
      add_to_scene: ->
        floor.add_to_scene_solid_with_number() for floor in @.floors
      set_delay_timeout_to_animate: (floor, called_animation, i) ->
        setTimeout ->
          floor[called_animation]()
        , i * @.animation.delay
      animate_to_scene: ->
        for floor, i in @.floors
          @.set_delay_timeout_to_animate(floor, 'animate_to_center', i)
      animate_from_scene: ->
        for floor, i in @.floors
          @.set_delay_timeout_to_animate(floor, 'animate_to_start', i)

  show_floor: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    floor_object = fp.init_floor(floor_number)
    floor_object.set_position_by fp.house.floor(floor_number)
    floor_object.add_to_scene_solid()

    floor_object.animate_to_foreground()
    fp.house.animate_from_scene()
    fp.animate_camera_to_start()

$.app.pages.shared.floor_plans.init()
$.app.pages.shared.floor_plans.animate()
