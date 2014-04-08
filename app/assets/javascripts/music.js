var flag;
$$r(function() {
  $$i({
    create:'script',
    attribute: {
      'type':'text/javascript',
      'src':'http://nagon.net/modules/NRMSLib/NRMSLib.js'
    },
    insert:$$().body,
    onready:function() {
      flag =($.cookie('cookie_name'));
      if ((flag=="true")||(flag==undefined)) {
        modules.sound.start({'music':'http://sfmv.ru/music/3.mp3'});
        $('#mp3button').addClass('play_music');
      }
      $$e.add($$('mp3button'),'click',playmp3rand);//добавляю событие кнопке после загрузки скрипта
     
    }
  });
});

var playmp3rand = function (event) {
  //запукаю случайную музыку
  if ((flag=="true")||(flag==undefined)){
    modules.sound.stop();//останавливаю если что то уже играет
    $('#mp3button').removeClass('play_music')
    flag="false";
  } else {
    flag="true";
    modules.sound.start({'music':'http://sfmv.ru/music/3.mp3'});
    $('#mp3button').addClass('play_music')
  }
  ($.cookie('cookie_name', flag));
  $$('sound_s_el_m').$$('width','1px').$$('height','1px').$$('overflow','hidden');//эти параметры трогать не нужно
}