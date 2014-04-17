function mp3_start (){
  if (($.cookie("mp3_play") == 1)||($.cookie("mp3_play") == undefined)) 
    {var _mp3 = soundManager.getSoundById('aSound');
    _mp3.stop();
    $('#mp3button').removeClass('play_music');
    $.cookie("mp3_play",0);}
  else 
    {var _mp3 = soundManager.getSoundById('aSound');
    _mp3.setPosition(parseInt($.cookie('mp3')));
    _mp3.play();
    $.cookie("mp3_play",1)
    $('#mp3button').addClass('play_music');}
}
  $(document).ready(function(){
    soundManager.setup({
    url: 'swf/',
    onready: function() {
      var mySound = soundManager.createSound({
        id:  'aSound',
        url: 'music/pertovsky_ah.mp3',
        autoLoad: true,
        position: $.cookie('mp3'),
        loops: 100,
        whileplaying: function() {
          $.cookie('mp3', this.position);
        },
        onload: function() {
          if(($.cookie("mp3_play") == 1)||($.cookie("mp3_play") == undefined)) {
          var _mp3 = soundManager.getSoundById('aSound');
              _mp3.setPosition(parseInt($.cookie('mp3')));
              _mp3.play();
            }
        },
        volume: 10
      });
    }
  });
    if(($.cookie("mp3_play") == 1)||($.cookie("mp3_play") == undefined))
      {$('#mp3button').addClass('play_music');}
    else
      {$('#mp3button').removeClass('play_music');}
  });
