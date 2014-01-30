#= require threejs/three.min
#= require threejs/renderers/CSS3DRenderer
#= require threejs/controls/OrbitControls

$.app.pages ||= {}
$.app.pages.shared ||= {}
$.app.pages.shared.floor_plans =
  floors_params:
    count: 4
    size:
      width: 800
      height: 600
    opacity: 0.5
  floors: []
  container: $("#canvas-container")

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
    @.camera.position.z = 1000
    @.camera.position.y = 1000

  init_scene: ->
    @.scene = new THREE.Scene()

  init_axes: ->
    fp = $.app.pages.shared.floor_plans
    ox = document.createElement('div')
    oy = document.createElement('div')
    oz = document.createElement('div')
    ox_css =
      width: "1000px"
      height: "10px"
      'background-color': "#ff0000"
    oy_css =
      width: "1000px"
      height: "10px"
      'background-color': "#00ff00"
    oz_css =
      width: "1000px"
      height: "10px"
      'background-color': "#0000ff"
    $(ox).css ox_css
    $(oy).css oy_css
    $(oz).css oz_css

    ox_object = new THREE.CSS3DObject(ox)
    ox_object.position.x += 500
    oy_object = new THREE.CSS3DObject(oy)
    oy_object.position.y += 500
    oy_object.rotation.z += Math.PI / 2
    oz_object = new THREE.CSS3DObject(oz)
    oz_object.position.z += 500
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
    @.controls.minDistance = 500
    @.controls.maxDistance = 2000
    @.controls.minPolarAngle = Math.PI / 4
    @.controls.maxPolarAngle = Math.PI / 4
    @.controls.noPan = true
    $(@.controls).on 'change', @.render

  init_events: ->
    @.container.on('resize', @.on_window_resize, false)

  on_window_resize: ->
    fp = $.app.pages.shared.floor_plans
    fp.camera.aspect = @.container.innerWidth() / @.container.innerHeight()
    fp.camera.updateProjectionMatrix()
    fp.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    fp.render()

  animate: ->
    fp = $.app.pages.shared.floor_plans
    requestAnimationFrame(fp.animate)
    fp.controls.update()

  render: ->
    fp = $.app.pages.shared.floor_plans
    fp.renderer.render(fp.scene, fp.camera)

  init_floor: (floor_number) ->
    fp = $.app.pages.shared.floor_plans
    floor_element = document.createElement('div')
    floor_css =
      width: "#{@.floors_params.size.width}px"
      height: "#{@.floors_params.size.height}px"
      opacity: @.floors_params.opacity
      'background-image': "url(/assets/floor#{floor_number}.png)"
    $(floor_element).addClass('floor-element').css floor_css

    floor_object = new THREE.CSS3DObject(floor_element)
    floor_object.position.y = Math.round((floor_number - @.floors_params.count / 2) * 100)
    floor_object.rotation.x = 3 * Math.PI / 2

    fp.scene.add(floor_object)

    floor_object

  init_floors: ->
    @.floors.push @.init_floor(i) for i in [1..@.floors_params.count]

$.app.pages.shared.floor_plans.init()
$.app.pages.shared.floor_plans.init_floors()
$.app.pages.shared.floor_plans.animate()
