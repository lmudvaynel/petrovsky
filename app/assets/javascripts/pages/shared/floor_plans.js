//= require threejs/three.min
//= require threejs/renderers/CSS3DRenderer
//= require threejs/controls/OrbitControls
//= require images_preloader

// Класс в основном нужен для инициализации и доступа к основным
// объектам плагина three.js, типа камеры, сцены и так далее.
function Three (container) {

  this.distanceToCamera = 750;

  // Общий инициализирующий метод
  this.init = function (container) {
    this.initContainer(container);
    this.initCamera();
    this.initScene();
    this.initRenderer();
    this.initControls();
  };

  // Контейнер, в котором содержится сцена
  this.initContainer = function (container) {
    this.container = container;
  };

  this.initCamera = function () {
    var aspect = this.container.width() / this.container.height();
    
    this.camera = new THREE.PerspectiveCamera(75, aspect, 1, 10000);
    this.camera.position.z = this.distanceToCamera;
  };

  this.initScene = function () {
    this.scene = new THREE.Scene();
  };

  this.initRenderer = function () {
    // Подключаемый рендерер для отрисовки html на плоскостях в пространстве
    this.renderer = new THREE.CSS3DRenderer();
    this.renderer.setSize(this.container.width(), this.container.height());
    this.container.append($(this.renderer.domElement));
  };

  // Подключаемые контролы для управления сценой посредством мыши
  this.initControls = function () {
    var three = this;
    
    this.controls = new THREE.OrbitControls(this.camera, this.renderer.domElement);
    // Запрещено вращение, перемещение, зум ограничен
    this.controls.rotateSpeed = 0;
    this.controls.noPan = true;
    this.controls.minDistance = this.distanceToCamera / 2;
    this.controls.maxDistance = this.distanceToCamera * 2;
    
    // При активном действии сцена перерисовывается
    $(this.controls).on('change', function () { three.render(); });
  };

  this.render = function () {
    this.renderer.render(this.scene, this.camera);
  };

  // При создании объекта посредством команды "new Three(container)"
  // будет тут же запущен основной инициализирующий метод
  this.init(container);

}

// Класс, отвечающий за анимацию объектов из three
// В каждый момент времени происходит очередной шаг анимации
// (если, конечно, она запущена) и все объекты сцены из списка
// elements за этот шаг, если они находятся в состоянии анимирования
// смещаются или вращаются посредством метода step
function Animation (three) {

  this.init = function (three) {
    // elements - в этом списке находятся все элементы сцены,
    // которые на данный момент либо ожидают своей анимации,
    // либо находятся в состоянии движения-вращения
    this.elements = [];
    this.three = three;
  };

  // Добавление в очередь нового объекта сцены, подлежащего анимированию
  // timeBeforeStart - количество интервалов времени, после которого начнётся
  // анимирование данного объекта
  // duration - количество интервалов времени, в течение которых будет
  // происходить анимирование объекта
  // object - объект сцены из three.scene, подлежащий анимированию
  // place - конечное положение, которое должен принять анимируемый объект,
  // состоящее из трёх координат для позиции и трёх углов для вращения
  // callback - метод, вызываемый по окончании анимации данного объекта
  this.add = function (timeBeforeStart, duration, object, place, callback) {
    this.elements.push([timeBeforeStart, duration, object, place, callback]);
  };

  // Метод, запускающий анимацию
  this.start = function () {
    var animation = this;
    
    this.interval = setInterval(function () {
      animation.step();
    }, 0);
  };

  // Метод, останавливающий анимацию
  this.stop = function () {
    clearInterval(this.interval);
  };

  // Шаг анимации, выполняется после каждого прошедшего момента времени,
  // начиная с запуска анимации
  this.step = function () {
    var element;
    
    for (var i = 0; i < this.elements.length; i++) {
      element = this.elements[i];
      if (!element) continue;
      // element[0] - количество оставшихся фреймов анимации до её начала
      if (element[0] > 0) {
        element[0]--;
      } else {
        // element[1] - количество оставшихся фреймов анимации до её конца,
        // когда она уже началась. Они уменьшаются до тех пор, пока значение
        // не станет нулевым - тогда анимация прекратится и объект сцены
        // будет удалён из списка elements
        if (element[1] > 0) {
          // вызов анимирующего объект метода
          this.animate(element[1], element[2], element[3]);
          element[1]--;
        } else {
          // вызов метода, происходящего по окончании анимации
          if (element[4]) element[4]();
          // удаление из списка объекта, анимация которого завершена
          this.elements.splice(i, 1);
        }
      }
    }
    
    // Каждый момент времени помимо шага анимации обновляется состояние
    // контролов, управляющих сценой через мышь и происходит перерисовка сцены
    this.three.controls.update();
    this.three.render();
  };

  // Метод, осуществляющий перемещение и вращение объекта сцены
  this.animate = function (duration, object, place) {
    var attitudes = ['position', 'rotation'];
    var coordinates = ['x', 'y', 'z'];
    
    attitudes.forEach(function (a) {
      if (!place[a]) return;
      coordinates.forEach(function (c) {
        if (typeof(place[a][c]) != 'number') return;
        object[a][c] += (place[a][c] - object[a][c]) / duration;
      });
    });
  };

  // Метод, говорящий о том, есть ли на сцене в данный момент
  // времени анимируемые объекты
  this.goes = function () {
    if (this.elements.length > 0) {
      return true;
    } else {
      return false;
    }
  };

  this.init(three);

}

// Класс для создания объекта этажа (вместе с апартаментами) и работы с ним
function FloorPlan (three, animation, floorNumber) {

  // Размеры этажа и скорости его перемещения во время анимаций
  this.size = { width: 2320, height: 1210 };
  this.speed = {
    rotation: { show: 200, hide: 100 },
    moving: { show: 200, hide: 50 },
  };

  this.init = function (three, animation, floorNumber) {
    this.three = three;
    this.animation = animation;
    this.floorNumber = floorNumber;
    
    this.initFloorObject();
    this.initApartments();
    this.initObject();
  };

  // Инициализация объекта самого плана этажа
  this.initFloorObject = function () {
    this.initFloorElement();
    this.floorObject = new THREE.CSS3DObject(this.floorElement.get(0));
  };

  this.initFloorElement = function () {
    this.floorElement = $('<div/>').addClass('floor-element')
                                   .addClass('floor-' + this.floorNumber);
  };

  // Инициализация объектов для апартаментов данного этажа
  this.initApartments = function () {
    var floorPlan = this;
    // Список объектов класса Apartment - апартаментов этажа
    this.apartments = [];
    
    // Выбираем апартаменты, относящиеся к текущему этажу
    $.app.apartments.filter(function (apartment) {
      return apartment.floor_number === floorPlan.floorNumber;
    }).forEach(function (apartmentProperties) {
      // Инициализируем объект для каждого апартамента
      floorPlan.initApartment(apartmentProperties);
    });
  };

  this.initApartment = function (apartmentProperties) {
    var apartment = new Apartment(this, apartmentProperties);
    
    this.apartments.push(apartment);
  };

  // Инициализация общего объекта-контейнера, содержащего внутри себя
  // как объект общего плана этажа, так и все объекты его апартаментов
  this.initObject = function () {
    var floorPlan = this;
    
    this.object = new THREE.Object3D();
    // Добавляем план этажа
    this.object.add(this.floorObject);
    // Добавляем его апартаменты
    this.apartments.forEach(function (apartment) {
      floorPlan.object.add(apartment.object);
    });
    // Поворачиваем весь объект в пространстве, 
    // чтобы его не было видно при текущем положении камеры
    this.object.rotation.x = -Math.PI/2;
  };

  // Добавление общего объекта, хранящего в себе этаж и апартаменты на сцену
  this.addToScene = function () {
    this.three.scene.add(this.object);
  };

  // Удаление общего объекта, хранящего в себе этаж и апартаменты со сцены
  this.removeFromScene = function () {
    var floorPlan = this;
    
    this.object.getDescendants().forEach(function (object) {
      floorPlan.object.remove(object);
    });
    this.three.scene.remove(this.object);
  };

  // Вызов анимации для появления этажа на сцене
  this.show = function (callback) {
    // Через 0 фреймов (сразу) этаж начинает поворачиваться
    this.animation.add(0, this.speed.rotation.show, this.object, {
      rotation: { x: 0, y: 0, z: 0 }
    });
    // Через то количество фреймов, за которые он повернётся
    // начинаем новую анимацию - выезд этажа вперёд, к экрану
    this.animation.add(this.speed.rotation.show, this.speed.moving.show, this.object, {
      position: { x: 0, y: 0, z: 500 }
    }, callback);
  };

  // Вызов анимации для исчезания этажа со сцены (аналогично предыдущему)
  this.hide = function (callback) {
    this.animation.add(0, this.speed.moving.hide, this.object, {
      position: { x: 0, y: 0, z: 0 }
    });
    this.animation.add(this.speed.moving.hide, this.speed.rotation.hide, this.object, {
      rotation: { x: - Math.PI / 2, y: 0, z: 0 }
    }, callback);
  };

  this.init(three, animation, floorNumber);

}

// Класс для создания объекта апартамента, который определяется
// этажом (floorPlan) и свойствами апартамента (apartmentProperties),
// которые берутся из свойств, передаваемых из контроллера - $.app.apartments
function Apartment (floorPlan, apartmentProperties) {

  this.init = function (floorPlan, apartmentProperties) {
    this.floorPlan = floorPlan;
    this.properties = apartmentProperties;
    
    this.initObject();
  };

  // Инициализация объекта апартамента
  this.initObject = function () {
    // Вектор, на который будет смещён апартамент относительно начала координат
    var shiftVector = this.getShiftVector();
    
    this.initElement();
    this.object = new THREE.CSS3DObject(this.element.get(0));
    // Сдвигаем апартамент на его позицию
    this.object.position.add(shiftVector);
  };

  // Вектор сдвига апартамента определяется с учётом размеров
  // этажа (floorPlan.size), размеров апартамента (properties.size)
  // и сдвига апартамента относительно верхнего левого угла этажа
  // (его позиция хранится в properties.dx и properties.dy)
  this.getShiftVector = function () {
    var dx = -this.floorPlan.size.width/2 +
              this.properties.size[0]/2 +
              this.properties.dx;
    var dy =  this.floorPlan.size.height/2 -
              this.properties.size[1]/2 -
              this.properties.dy;
    
    return new THREE.Vector3(dx, dy, 0);
  };

  this.initElement = function () {
    // По id однозначно можно определять и находить данный апартамент
    var id = 'apart-' + this.properties.floor_number + '-' + this.properties.number;
    // "-sold" если апартамент уже продан
    var sold = this.properties.sold_out ? '-sold' : '';
    var css = {
      'background-image': 'url(/uploads/apartment/image/' +
                          this.properties.floor_number + '-' + 
                          this.properties.number + sold + '.png)',
      cursor: 'pointer',
      width: this.properties.size[0] + 'px',
      height: this.properties.size[1] + 'px',
    };
    
    this.element = $('<div/>').attr('id', id).addClass('apartment-element').css(css);
  };

  this.init(floorPlan, apartmentProperties);

}

// Буквально контролирует всё происходящее. Инициализирует в нужном порядке
// и в нужные моменты объекты предыдущих классов, вешает обработчики событий
function Controller () {

  // Инициализация объекта three, создание и запуск анимирующего объекта,
  // инициализация обработчиков различных событий
  this.init = function () {
    this.container = $('#canvas-container');
    this.three = new Three(this.container);
    this.animation = new Animation(this.three);
    
    this.animation.start();
    
    this.initEvents();
  };

  this.initEvents = function () {
    var controller = this;
    
    // Перерисовка сцены при изменении размеров окна
    $(window).on('resize', function () {
      controller.windowOnResizeEvent();
    });
    // Вызывает этаж по нажатию на его номер
    $('#house-image-container').on('click', '.show-house-floor', function (event) {
      controller.showHouseFloorClickEvent(event);
    });
    // Возвращаемся к списку этажей
    $('#house-controls-container').on('click', '.back-to-house', function (event) {
      controller.backToHouseClickEvent(event);
    });
    // Наведение и убирание курсора с апартаментов
    this.container.on('mouseover', '.apartment-element', function (event) {
      controller.apartmentElementMouseEvent(event);
    });
    this.container.on('mouseout', '.apartment-element', function (event) {
      controller.apartmentElementMouseEvent(event);
    });
    // Заказ апартаментов
    this.container.on('click', '.apartment-element', function (event) {
      controller.apartmentElementClickEvent(event);
    });
  };

  // Лучше не трогать, вроде бы работает
  this.windowOnResizeEvent = function () {
    var aspect = this.container.width() / this.container.height();
    
    this.three.camera.aspect = aspect;
    this.three.camera.updateProjectionMatrix();
    this.three.renderer.setSize(this.container.width(), this.container.height());
    this.three.render();
  };

  this.showHouseFloorClickEvent = function (event) {
    var element = event.target;
    var floorNumber = parseInt($(element).data('floorNumber'));
    
    // Проверяем, не происходит ли в данный момент какая-нибудь анимация
    // объектов сцены. Если да - уходим из события
    if (this.animation.goes()) return;
    event.preventDefault();
    this.container.css('z-index', 1000);
    $('#house-image-container').hide();
    
    // Создаём объект этажа
    this.floorPlan = new FloorPlan(this.three, this.animation, floorNumber);
    // Размещаем объект этажа на сцене
    this.floorPlan.addToScene();
    // Запускаем анимацию выдвижения этажа в центр экрана
    this.floorPlan.show(function () {
      $('#house-controls-container').show();
    });
  };

  this.backToHouseClickEvent = function (event) {
    var element = event.target;
    var controller = this;
    
    // Ничего не делаем во время анимации
    if (this.animation.goes()) return;
    event.preventDefault();
    this.container.css('z-index', 10);
    $('#house-controls-container').hide();
    
    this.floorPlan.hide(function () {
      // Убираем объект этажа со сцены
      controller.floorPlan.removeFromScene();
      // Очищаем более ненужный параметр, хранивший убранный этаж
      controller.floorPlan = null;
      $('#house-image-container').show();
    });
  };

  this.apartmentElementMouseEvent = function (event) {
    var element = event.target;

    if (this.animation.goes()) return;
    event.preventDefault();
    
    // По типу события определяем, анимировать ли апартамент до прозрачного
    // состояния или наоборот, в зависимости от положения мыши
    switch (event.type) {
      case 'mouseover':
        $(element).animate({ opacity: 1 }, 100);
        break;
      case 'mouseout':
        $(element).animate({ opacity: 0 }, 100);
        break;
    }
  };

  // Эту чехарду кто-то до меня написал, она вроде бы пашет, вот и здорово
  this.apartmentElementClickEvent = function (event) {
    var element = event.target;
    var apartmentProperties = this.findApartmentPropertiesById($(element).attr('id'));
    
    if (this.animation.goes()) return;
    event.preventDefault();
    
    $('.floor-number').text(apartmentProperties.floor_number);
    $('.apart-number').text(apartmentProperties.number);
    $('.apart-price').text(apartmentProperties.price);
    $('.apart-area').text(apartmentProperties.area);
    if (apartmentProperties.floor_number === 1) {
      $('.apart_type').text('Помещение');
      $('.sold').text('о');
      $('.apart-type-call').text('проекте PETROVSKY APART HOUSE');
    } else {
      $('.apart_type').text('Апартаменты');
      $('.sold').text('ы');
      $('.apart-type-call').text('свободных апартаментах');
    }
    if (apartmentProperties.sold_out) {
      $('.apart-sold').text('проданы');
      $('.buy-wrapper-sold').show();
    } else {
      $('.apart-sold').text('');
      $('.buy-wrapper').show();
    }
  };

  // Поиск свойств апартамента в $.app.apartments через id его DOM-элемента
  this.findApartmentPropertiesById = function (apartmentId) {
    var properties = apartmentId.split('-').splice(1, 2).map(function (element) {
      return parseInt(element);
    });
    return $.app.apartments.filter(function (apartment) {
      return  apartment.floor_number === properties[0] &&
              apartment.number === properties[1]
    })[0];
  };

  this.init();
  this.three.render();

}

// Запускается сразу после окончания svg-анимации на странице
$.app.svgLoaded = function () {
  var attributes = [
    { class: "floor bg-item", id: "floor-1" },
    { class: "floor bg-item", id: "floor-2" },
    { class: "floor bg-item", id: "floor-3" },
    { class: "floor bg-item", id: "floor-4" },
    { class: "floor bg-item", id: "floor-5" },
    { class: "floor bg-item", id: "floor-6" },
    { class: "floor-2 bg-item", id: "inset-floor-1" },
    { class: "floor-2 bg-item", id: "inset-floor-2" },
    { class: "floor-2 bg-item", id: "inset-floor-3" },
    { class: "floor-2 bg-item", id: "inset-floor-4" },
    { class: "floor-2 bg-item", id: "inset-floor-5" },
    { class: "floor-2 bg-item", id: "inset-floor-6" },
  ];
  var divs = [];
  
  attributes.forEach(function (attrs) {
    divs.push($('<div>').addClass(attrs.class).attr('id', attrs.id));
  });
  $('.fasad-bg-wrap').append(divs);
  
  $.app.preloadFloorPlansImages();
};

// Предзагрузка картинок
$.app.preloadFloorPlansImages = function () {
  var images = [];
  for (var i = 1; i <= 6; i++) {
    images.push('/images/floor-' + i + '.png');
  }
  $.app.apartments.forEach(function (apartment) {
    images.push('/uploads/apartment/image/' + apartment.image);
  });
  $.app.preload.ready(images, function () {
    // Когда изображения этажей и апартаментов загружены -
    // инициализируется данный скрипт
    var controller = new Controller();
  });
};
