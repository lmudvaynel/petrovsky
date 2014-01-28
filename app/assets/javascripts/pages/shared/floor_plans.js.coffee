#= require threejs/three.min
#= require threejs/renderers/CSS3DRenderer
#= require threejs/controls/OrbitControls

$.app.pages ||= {}
$.app.pages.shared ||= {}
$.app.pages.shared.floor_plans =
  container: $("#canvas-container")
  init: ->
    @.init_camera()
    @.init_scene()
    @.init_renderer()
    @.init_controls()
    @.init_events()

  init_camera: ->
    aspect = @.container.innerWidth() / @.container.innerHeight()
    @.camera = new THREE.PerspectiveCamera(75, aspect, 1, 10000)
    @.camera.position.z = 500
    @.camera.position.y = 500

  init_scene: ->
    @.scene = new THREE.Scene()

  init_renderer: ->
    @.renderer = new THREE.CSS3DRenderer()
    @.renderer.setSize(@.container.innerWidth(), @.container.innerHeight())
    @.container.append($(@.renderer.domElement))

  init_controls: ->
    @.controls = new THREE.OrbitControls(@.camera, @.renderer.domElement)
    @.controls.rotateSpeed = 1
    @.controls.minDistance = 500
    @.controls.maxDistance = 5000
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

  init_floor: ->
    fp = $.app.pages.shared.floor_plans
    floor_element = document.createElement('div')
    $(floor_element).addClass('floor-element')
                    .css width: '100px', height: '100px', 'background-color': '#00ff00'

    floor_object = new THREE.CSS3DObject(floor_element)
    floor_object.rotation.x = Math.PI / 2

    fp.scene.add(floor_object)

    floor_object

$.app.pages.shared.floor_plans.init()
$.app.pages.shared.floor_plans.init_floor()
$.app.pages.shared.floor_plans.animate()
