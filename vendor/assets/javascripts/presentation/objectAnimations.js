function ObjectAnimations (object) {
  
 $.cookie("number")==17 ? speed=1 : speed=1000;

  this.options = {
    frames: {
      symbol: 10,
    },
    durations: {
      opacity: speed,
      move: 1000,
      resize: 100,
    },
    speed: {
      resize: 2,
    },
  }

  this.init = function () {
    this.object = object;
    var animationOptions = this.object.animationOptions || {};
    this.options = Hash.merge(this.options, animationOptions);
  }

  this.opacityTo = function (resultOpacity, params, afterAnimationCallback, duration) {

    params = params ? params : {};
    var wordFrom = params.wordFrom || 0;
    var wordTo = params.wordTo || this.object.words.length - 1;
    var words = this.object.element.find('.word');
    var symbols = $(words[wordFrom]).find('.symbol');
    for (var i = wordFrom; i < wordTo; i++) {
      symbols = symbols.add($(words[i + 1]).find('.symbol'));
    }
//    var symbols = this.object.element.find('.symbol');

    var symbol, dOpacity, durationOpacity = duration || this.options.durations.opacity;
    var animatedSymbol = 0;
    var callback = function () {};
    var showInterval = setInterval(function () {
      if (animatedSymbol >= symbols.length - 1) {
        callback = afterAnimationCallback;
        clearInterval(showInterval);
      }
      symbol = $(symbols[animatedSymbol]);
      dOpacity = resultOpacity - parseFloat(symbol.css('opacity'));
      symbol.animate({
        opacity: '+=' + dOpacity
      }, durationOpacity, callback);
      animatedSymbol++;
    }, this.options.frames.symbol);

/*
    var opacityInc = 1 / this.options.frames.opacity;
    var symbolFrames = this.options.frames.symbol;
    var symbols = this.line.element.find('.symbol');
    var symbol, opacity;
    var i = 0;
    var animatedSymbolsCount = 0;
    // Animation start
    var showInterval = setInterval(function () {
      if (i % symbolFrames === 0) {
        animatedSymbolsCount += 1;
      }
      i++;
      for (var j = 0; j < animatedSymbolsCount; j++) {
        symbol = $(symbols[j]);
        opacity = parseFloat(symbol.css('opacity'));
        opacityInc = resultOpacity - opacity < 0 ? -Math.abs(opacityInc) : Math.abs(opacityInc);
        if (Math.abs(resultOpacity - opacity) >= Math.abs(opacityInc)) {
          symbol.css('opacity', opacity + opacityInc);
        } else {
          if (j === symbols.length - 1) {
            clearInterval(showInterval);
            if (afterAnimationCallback) {
              afterAnimationCallback();
            }
          }
        }
      }
    }, 1);
*/
  }

  this.move = function (dLeft, dTop, afterAnimationCallback) {
    var objectAnimations = this;
    this.object.element.animate({
      left: '+=' + dLeft + 'px',
      top: '+=' + dTop + 'px',
    }, this.options.durations.move, function () {
/*
      var elementPosition = objectAnimations.getElementPosition();
      var leftInPercents = (100 * elementPosition.left / objectAnimations.object.container.width()) + '%';
      var topInPercents = (100 * elementPosition.top / objectAnimations.object.container.height()) + '%';
      $(objectAnimations.object.element).css({ left: leftInPercents, top: topInPercents });
*/
      objectAnimations.recalculateElementParameters();
      if (afterAnimationCallback) {
        afterAnimationCallback();
      }
    });
  }

  this.moveTo = function (left, top, afterAnimationCallback) {
    var elementPosition = this.getElementPosition();
    var dLeft = left - elementPosition.left;
    var dTop = top - elementPosition.top;
    this.move(dLeft, dTop, afterAnimationCallback);
  }

  this.resize = function (scale, afterAnimationCallback) {

    var objectAnimations = this;
    var element = objectAnimations.object.element;
    var size = { current: this.getElementSize() };
    size.start = size.current;
    size.end = { width: scale * size.start.width, height: scale * size.start.height };
    var position = {};
    var resizeSign = size.end.height - size.start.height < 0 ? -1 : 1;
    var dHeightSpeed = this.options.speed.resize;
    var dh = resizeSign * dHeightSpeed * 2;
    var dWidth, dHeight;
    var frames = Math.round((size.end.height - size.start.height)/dh);
    
//    console.log(dh, frames, size);
    
    var resizeInterval = setInterval(function () {
      frames--;
      if (frames < 0) {
        clearInterval(resizeInterval);
//        objectAnimations.recalculateElementParameters();
        if (afterAnimationCallback) {
          afterAnimationCallback();
        }
      }
      size.prev = objectAnimations.getElementSize();
      position.prev = objectAnimations.getElementPosition();
//      console.log(element.attr('class'), '; before: ', element.position().left, element.position().top, element.width(), element.height(), element.css('fontSize'));
      element.css({
        height: (size.prev.height + dh) + 'px',
        fontSize: (size.prev.height + dh) + 'px',
      });
      size.next = objectAnimations.getElementSize();
      dWidth = (size.next.width - size.prev.width)/2;
      dHeight = (size.next.height - size.prev.height)/2;
      element.css({
        left: (position.prev.left - dWidth) + 'px',
        top: (position.prev.top - dHeight) + 'px',
      });
//      console.log(element.attr('class'), '; after: ', element.position().left, element.position().top, element.width(), element.height(), element.css('fontSize'));
    }, 1);

/*
    var objectAnimations = this;
    var oldSize = this.getElementSize();
    var newSize = { width: scale * oldSize.width, height: scale * oldSize.height };
    var nextSize;
    var oldPosition;
    var framesInStep = Math.abs(parseInt(2 * (this.options.durations.resize/(newSize.height - oldSize.height))));
    var resizeSign = newSize.height - oldSize.height >= 0 ? 1 : -1;
    var resizeShift = withoutShift ? 0 : 1;
    var frame = 0;

    var resizeInterval = setInterval(function () {
      frame++;
      if (frame > objectAnimations.options.durations.resize) {
        clearInterval(resizeInterval);
        objectAnimations.recalculateElementParameters();
        if (afterAnimationCallback) {
          afterAnimationCallback();
        }
      }
      if (frame % framesInStep === 0) {
        oldSize = objectAnimations.getElementSize();
        oldPosition = objectAnimations.getElementPosition();
        objectAnimations.object.element.height(oldSize.height + resizeSign * 2);
        objectAnimations.object.element.css({ fontSize: (oldSize.height + resizeSign * 2) + 'px' });
        nextSize = objectAnimations.getElementSize();
        objectAnimations.object.element.css({
          left: (oldPosition.left - resizeShift * (nextSize.width - oldSize.width)/2) + 'px',
          top: (oldPosition.top - resizeShift * (nextSize.height - oldSize.height)/2) + 'px',
        });
      }
    }, 0);
*/

/*
    var oldWidth = this.object.element.width(), oldHeight = this.object.element.height();
    var newWidth = scale * oldWidth, newHeight = scale * oldHeight;
    var dLeft = (oldWidth - newWidth)/2, dTop = (oldHeight - newHeight)/2;
    this.object.element.animate({
      left: '+=' + dLeft + 'px',
      top: '+=' + dTop + 'px',
      height: newHeight + 'px',
      fontSize: newHeight + 'px',
    }, this.options.durations.move, afterAnimationCallback);
*/
  }

  this.getElementPosition = function () {
    return {
      left: this.object.element.position().left,
      top: this.object.element.position().top,
    }
  }

  this.getElementSize = function () {
    return {
      width: this.object.element.width(),
      height: this.object.element.height(),
    }
  }

  this.recalculateElementParameters = function () {
    this.object.recalculateElementParameters();
  }

  this.init();

}
