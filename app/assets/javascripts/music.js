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
    var winLoc = window.location.toString();    

if (winLoc.match(/flash9/i)) {

  soundManager.setup({
    preferFlash: true,
    flashVersion: 9
  });

  if (winLoc.match(/highperformance/i)) {
    soundManager.setup({
      useHighPerformance: true
    });

  }

} else if (winLoc.match(/flash8/i)) {

  soundManager.setup({
    preferFlash: true,
    flashVersion: 8
  });

}
    soundManager.setup({
    url: 'swf/',
    useFlashBlock: false,
    html5PollingInterval: (winLoc.match(/html5PollingInterval/i) ? 20 : null),
    debugMode: true,
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
