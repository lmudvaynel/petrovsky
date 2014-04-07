var lines;

$(document).ready(function(){
  var lines = new Lines();
  var currentAnimation = 0;
  var animationInProgress = false;

  var callback = function () {
    animationInProgress = false;
  }

  animations = [
    // "Приветствие"
    function () {
      lines.changeBackgroundImageTo(0);
      lines.getByElement('greeting first')[0].animations.opacityTo(1, null, callback);
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
      thesisLine.animations.resize(3);
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
    function () {
      lines.getByElement('description comfort fifth')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      var thesisLine = lines.getByElement('description comfort thesisWord')[0];
      thesisLine.animations.resize(3);
      thesisLine.animations.opacityTo(0);
      var harmonyDescriptionLines = lines.getByElement('description comfort');
      for (var i in harmonyDescriptionLines) {
        harmonyDescriptionLines[i].animations.opacityTo(0);
      }
      lines.getByElement('thesis comfort')[0].animations.opacityTo(1, null, callback);
    },
    function () {
      lines.getByElement('thesis comfort')[0].animations.opacityTo(0, null, callback);
      document.getElementById('main_hidden_1').style.display='none';
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
        thesisesLines[thesisLine].animations.resize(3);
        thesisesLines[thesisLine].animations.opacityTo(0, null, thesisesCallback);
        thesisLine++;
      }, 100);
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
      var moveToLeft = parseFloat(lines.getByElement('conclusion introduction first')[0].element.css('left'));
      var animatedLines = [
        {
          line: lines.getByElement('thesises title')[0],
          moveToTop: parseFloat(lines.getByElement('conclusion introduction first')[0].element.css('top')),
        },
        {
          line: lines.getByElement('thesises first')[0],
          moveToTop: parseFloat(lines.getByElement('conclusion harmony first')[0].element.css('top')),
        },
        {
          line: lines.getByElement('thesises second')[0],
          moveToTop: parseFloat(lines.getByElement('conclusion liberty first')[0].element.css('top')),
        },
        {
          line: lines.getByElement('thesises third')[0],
          moveToTop: parseFloat(lines.getByElement('conclusion comfort first')[0].element.css('top')),
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
      document.getElementById('main_hidden_2').style.display='none';
      var conclusionLines = lines.getByElement('line conclusion');
      var showConclusionLineCallback = function (currentConclusionLine) {
        if (currentConclusionLine < conclusionLines.length) {
          conclusionLines[currentConclusionLine].animations.opacityTo(1, null, function () {
            showConclusionLineCallback(currentConclusionLine + 1);
          });
        } else {
          callback();
        }
      }
      showConclusionLineCallback(0);
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
});
