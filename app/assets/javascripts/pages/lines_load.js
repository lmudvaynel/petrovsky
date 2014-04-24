var lines;
if ( $.cookie("timer")==undefined) {$.cookie("timer",1500);}
if ( $.cookie("number")==undefined) {$.cookie("number",0);}
var number = $.cookie("number");
var timer = $.cookie("timer");

$( document ).ready(start_animation(number,timer));
function reset_animation(){
  $.cookie('number',0);
  $.cookie('timer',1500);
}
function start_animation(number,timer){
  var lines = new Lines();
  var currentAnimation = number;
  var animationInProgress = false;
  document.getElementById('main_hidden_3').style.opacity='0';
  var callback = function () {
    animationInProgress = false;
  }
  setTimeout(function(){
  animations = [
    // "Приветствие"
    function () {
      $.cookie("number",27);
      $.cookie("timer",1);
      lines.changeBackgroundImageTo(0);
      $('#main').animate({ opacity: 0 }, 1000);
       setTimeout(function(){
      lines.getByElement('greeting first')[0].animations.opacityTo(1, null, callback);},500);
    },
    function () {
      lines.getByElement('greeting second')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('greeting third')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('greeting fourth')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('greeting fifth')[0].animations.opacityTo(1, null, callback);
    },
    function () {
//      var thesisLine = lines.getByElement('description greeting thesisWord')[0];
//      thesisLine.animations.resize(2);
//      thesisLine.animations.opacityTo(0);
      var harmonyDescriptionLines = lines.getByElement('description greeting');
      for (var i in harmonyDescriptionLines) {
        harmonyDescriptionLines[i].animations.opacityTo(0);
      }
      lines.getByElement('greeting title')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('greeting title')[0].animations.opacityTo(0, null, callback);
    },

    // Первый тезис: ГАРМОНИЯ
    function () {
      lines.changeBackgroundImageTo(1);
//      lines.getByElement('greeting title')[0].animations.opacityTo(0);
//      lines.getByElement('greeting title')[0].opacityTo(0);
//      lines.getByElement('thesis harmony')[0].opacityTo(1, { wordFrom: 0, wordTo: 2 });
//      lines.getByElement('thesis harmony')[0].animations.opacityTo(0, { wordFrom: 0, wordTo: 2 });
      lines.getByElement('description harmony first')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description harmony second')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description harmony third')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description harmony fourth')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      var thesisLine = lines.getByElement('description harmony thesisWord')[0];
      thesisLine.animations.resize(2);
      thesisLine.animations.opacityTo(0);
      var harmonyDescriptionLines = lines.getByElement('description harmony');
      for (var i in harmonyDescriptionLines) {
        harmonyDescriptionLines[i].animations.opacityTo(0);
      }
      lines.getByElement('thesis harmony')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('thesis harmony')[0].animations.opacityTo(0, null, callback);
    },

    // Второй тезис: СВОБОДА
    function () {
      lines.changeBackgroundImageTo(2);
//      lines.getByElement('thesis harmony')[0].opacityTo(0);
//      lines.getByElement('thesis liberty')[0].opacityTo(1, { wordFrom: 0, wordTo: 2 });
//      lines.getByElement('thesis liberty')[0].animations.opacityTo(0, { wordFrom: 0, wordTo: 2 });
      lines.getByElement('description liberty first')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description liberty second')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description liberty third')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      var thesisLine = lines.getByElement('description liberty thesisWord')[0];
      thesisLine.animations.resize(2);
      thesisLine.animations.opacityTo(0);
      var harmonyDescriptionLines = lines.getByElement('description liberty');
      for (var i in harmonyDescriptionLines) {
        harmonyDescriptionLines[i].animations.opacityTo(0);
      }
      lines.getByElement('thesis liberty')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('thesis liberty')[0].animations.opacityTo(0, null, callback);
    },

    // Третий тезис: КОМФОРТ
    function () {
      lines.changeBackgroundImageTo(3);
//      lines.getByElement('thesis liberty')[0].opacityTo(0);
//      lines.getByElement('thesis comfort')[0].opacityTo(1, { wordFrom: 0, wordTo: 2 });
//      lines.getByElement('thesis comfort')[0].animations.opacityTo(0, { wordFrom: 0, wordTo: 2 });
      lines.getByElement('description comfort first')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description comfort second')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description comfort third')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('description comfort fourth')[0].animations.opacityTo(1, null, callback);
    },
//  function () {
//    lines.getByElement('description comfort fifth')[0].animations.opacityTo(1, null, callback);
//  },
    function () {
      var thesisLine = lines.getByElement('description comfort thesisWord')[0];
      thesisLine.animations.resize(2);
      thesisLine.animations.opacityTo(0);
      var harmonyDescriptionLines = lines.getByElement('description comfort');
      for (var i in harmonyDescriptionLines) {
        harmonyDescriptionLines[i].animations.opacityTo(0);
      }
      lines.getByElement('thesis comfort')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      setTimeout(function(){document.getElementById('main_hidden_1').style.display='none';}, 1000)
      lines.getByElement('thesis comfort')[0].animations.opacityTo(0, null, callback);
    },
    // Все тезисы
    function () {
      lines.changeBackgroundImageTo(4);
      lines.getByElement('thesises title')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('thesises first')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('thesises second')[0].animations.opacityTo(1, null, callback);
    },
    /*function () {
      lines.getByElement('thesises third')[0].animations.opacityTo(1, null, callback);
    },*/
    function () {
      var thesisesLines = lines.getByElement('thesises');
      var thesisLine = 0;
      var thesisesCallback = function () {};
      var thesisesInterval = setInterval(function () {
        if (thesisLine >= thesisesLines.length - 1) {
          clearInterval(thesisesInterval);
          thesisesCallback = callback;
        }
        thesisesLines[thesisLine].animations.resize(2, thesisesCallback);
        thesisesLines[thesisLine].animations.opacityTo(0);
        thesisLine++;
      }, 100);
      document.getElementById('main_hidden_3').style.opacity='1';
      document.getElementById('main_hidden_3').style.cursor='pointer';
      document.getElementById('main_hidden_3').style.pointerEvents='auto';
    },
/*
    function () {
      lines.getByElement('thesises title')[0].animations.resize(3);
      lines.getByElement('thesises title')[0].animations.opacityTo(0, null, callback);
    },
    function () {
      lines.getByElement('thesises first')[0].animations.resize(3);
      lines.getByElement('thesises first')[0].animations.opacityTo(0, null, callback);
    },
    function () {
      lines.getByElement('thesises second')[0].animations.resize(3);
      lines.getByElement('thesises second')[0].animations.opacityTo(0, null, callback);
    },
    function () {
      lines.getByElement('thesises third')[0].animations.resize(3);
      lines.getByElement('thesises third')[0].animations.opacityTo(0, null, callback);
    },
*/
/*
    function () {
      var moveToLeft = parseFloat(lines.getByElement('introduction introduction first')[0].element.css('left'));
      var animatedLines = [
        {
          line: lines.getByElement('thesises title')[0],
          moveToTop: parseFloat(lines.getByElement('introduction introduction first')[0].element.css('top')),
        },
        {
          line: lines.getByElement('thesises first')[0],
          moveToTop: parseFloat(lines.getByElement('introduction harmony first')[0].element.css('top')),
        },
        {
          line: lines.getByElement('thesises second')[0],
          moveToTop: parseFloat(lines.getByElement('introduction liberty first')[0].element.css('top')),
        },
        {
          line: lines.getByElement('thesises third')[0],
          moveToTop: parseFloat(lines.getByElement('introduction comfort first')[0].element.css('top')),
        },
      ];
      var animatedLine, lineCallback = function () {};
      afterMovingCallback = function () {
        for (var i = 0; i < animatedLines.length; i++) {
          animatedLine = animatedLines[i];
          animatedLine.line.element.addClass('moved');
        }
        callback();
      }
      for (var i = 0; i < animatedLines.length; i++) {
        if (i === animatedLines.length - 1) {
          lineCallback = afterMovingCallback;
        }
        animatedLine = animatedLines[i];
        animatedLine.line.animations.resize(0.5, true, function () {
          animatedLine.line.element.addClass('resized');
        });
        animatedLine.line.animations.moveTo(moveToLeft, animatedLine.moveToTop, lineCallback);
      }
    },
*/

    // Заключение
    function () {
      lines.changeBackgroundImageTo(5);
      $('.sale-wrapper').animate({ opacity: 1}, 5000);
      lines.getByElement('line conclusion introduction first')[0].animations.opacityTo(1, null);
      lines.getByElement('line conclusion introduction second')[0].animations.opacityTo(1, null);
      lines.getByElement('line conclusion introduction third')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('conclusion harmony first')[0].animations.opacityTo(1, null);
      lines.getByElement('conclusion harmony second')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('conclusion liberty first')[0].animations.opacityTo(1, null);
      lines.getByElement('conclusion liberty second')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('line conclusion comfort first')[0].animations.opacityTo(1, null);
      lines.getByElement('line conclusion comfort second')[0].animations.opacityTo(1, null);
      lines.getByElement('line conclusion comfort third')[0].animations.opacityTo(1, null, callback);
    },
  ];

  animationsInterval = setInterval(function () {
    if (!animationInProgress) {
      animationInProgress = true;
      animations[currentAnimation]();
      currentAnimation++;
      if (currentAnimation > animations.length - 1) {
        clearInterval(animationsInterval);
      }
    }
  }, 1);
/*
  lines = new Lines({ line: { top: 0.7 } });
  lines.animations.opacityTo(1, function () {
    var firstWordLine = lines.copy(0, 0, 1);
    firstWordLine.opacityTo(1);

    lines.elements[0].animations.opacityTo(0);
    lines.elements[1].animations.opacityTo(0)
    firstWordLine.animations.resize(4);
    firstWordLine.animations.opacityTo(0, function () {
      firstWordLine.resize(1/4);
      firstWordLine.moveTo(300, 100);
      firstWordLine.animations.opacityTo(1);
    });
  });
*/
}, timer);
};

