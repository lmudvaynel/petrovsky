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
  floors_params:
    count: 4
    size:
      width: 800
      height: 600
    opacity: 0.5
  floors_numbers_params:
    font_size_px: 40
  floors: []
  floors_numbers: []

  init: ->
    @.init_camera()
    @.init_scene()
    @.init_renderer()
    @.init_controls()
    @.init_events()
    # @.init_axes()

  init_camera: ->
    aspect = @.container.innerWidth() / @.container.innerHeight()
    @.camera = new THREE.PerspectiveCamera(75, aspect, 1, 10000)
    @.camera.position.y = @.scene_params.distance * Math.cos(@.scene_params.yz_angle)
    @.camera.position.z = @.scene_params.distance * Math.sin(@.scene_params.yz_angle)

  init_scene: ->
    @.scene = new THREE.Scene()

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

  init_renderer: ->
    @.renderer = new THREE.CSS3DRenderer()
    @.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    @.container.append($(@.renderer.domElement))

  init_controls: ->
    @.controls = new THREE.OrbitControls(@.camera, @.renderer.domElement)
    @.controls.rotateSpeed = 1
    @.controls.minDistance = Math.round(@.scene_params.distance / 2)
    @.controls.maxDistance = @.scene_params.distance * 2
    @.controls.minPolarAngle = @.scene_params.yz_angle
    @.controls.maxPolarAngle = @.scene_params.yz_angle
    @.controls.noPan = true
    $(@.controls).on 'change', @.render

  init_events: ->
    @.container.on 'resize', @.on_window_resize
    # mouseup и click не подходят, трудно отследить когда идёт перемещение, а когда клик на этаж
    @.container.on 'mouseup', '.floor-element', @.floor_element_on_click

  on_window_resize: ->
    fp = $.app.pages.shared.floor_plans
    fp.camera.aspect = @.container.innerWidth() / @.container.innerHeight()
    fp.camera.updateProjectionMatrix()
    fp.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    fp.render()

  floor_element_on_click: ->
    fp = $.app.pages.shared.floor_plans
    floor_number = parseInt $(@).data('floor-number')
    fp.show_floor floor_number

  animate: ->
    fp = $.app.pages.shared.floor_plans
    requestAnimationFrame(fp.animate)
    fp.controls.update()

  render: ->
    fp = $.app.pages.shared.floor_plans
    floor_number.rotation = fp.camera.rotation for floor_number in fp.floors_numbers
    fp.renderer.render(fp.scene, fp.camera)

  init_floor_number_dom_element: (floor_number) ->
    floor_number_element = document.createElement('div')
    floor_number_css =
      width: "#{3 * @.floors_numbers_params.font_size_px}px"
      height: "#{@.floors_numbers_params.font_size_px}px"
      'font-size': "#{@.floors_numbers_params.font_size_px}px"
    $(floor_number_element).text(floor_number).css floor_number_css
    floor_number_element

  init_floor_dom_element: (floor_number) ->
    floor_element = document.createElement('div')
    floor_css =
      width: "#{@.floors_params.size.width}px"
      height: "#{@.floors_params.size.height}px"
      opacity: @.floors_params.opacity
      'background-image': "url(/assets/floor#{floor_number}.png)"
    $(floor_element).addClass('floor-element').css floor_css
    $(floor_element).data 'floor-number', floor_number
    floor_element

  init_floor_number_object: (floor_object, floor_number) ->
    floor_number_element = @.init_floor_number_dom_element(floor_number)
    floor_number_object = new THREE.CSS3DObject(floor_number_element)
    floor_number_dy = Math.round(@.floors_numbers_params.font_size_px / 2)
    floor_number_object.position.y = floor_object.position.y + floor_number_dy
    floor_number_object

  init_floor_object: (floor_number) ->
    floor_object = new THREE.CSS3DObject(@.init_floor_dom_element(floor_number))
    floor_object.position.y = Math.round((floor_number - @.floors_params.count / 2) * 100)
    floor_object.rotation.x = 3 * Math.PI / 2
    floor_object

  init_floor: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    floor_object = @.init_floor_object(floor_number)
    fp.scene.add(floor_object)
    @.floors.push floor_object
    floor_number_object = @.init_floor_number_object(floor_object, floor_number)
    fp.scene.add(floor_number_object)
    @.floors_numbers.push floor_number_object

  init_floors: ->
    @.init_floor(i) for i in [1..@.floors_params.count]

  show_floor: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    floor_object = fp.init_floor_object(floor_number)
    fp.scene.add floor_object
    for i in [1..20]
      setTimeout ->
        fp.animate_show_floor(floor_object, floor_number)
      , i * 20

  animate_show_floor: (floor_object, floor_number) ->
    fp = $.app.pages.shared.floor_plans
    floor_object.position.x -= floor_object.position.x / 20
    floor_object.position.y -= (floor_object.position.y - Math.round((floor_number - @.floors_params.count / 2) * 20)) / 20
    floor_object.position.z -= floor_object.position.z / 20
    floor_object.rotation.x -= (floor_object.rotation.x - 3 * Math.PI / 2) / 20
    floor_object.rotation.y -= floor_object.rotation.y / 20
    floor_object.rotation.z -= floor_object.rotation.z / 20
    fp.render()

$.app.pages.shared.floor_plans.init()
$.app.pages.shared.floor_plans.init_floors()
$.app.pages.shared.floor_plans.animate()
