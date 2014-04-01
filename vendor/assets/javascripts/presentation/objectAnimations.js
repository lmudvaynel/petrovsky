function ObjectAnimations (object) {

  this.options = {
    frames: {
      symbol: 10,
    },
    durations: {
      opacity: 1000,
      move: 1000,
      resize: 200,
    }
  }

  this.init = function () {
    this.object = object;
    var animationOptions = this.object.animationOptions || {};
    this.options = Hash.merge(this.options, animationOptions);
  }

  this.opacityTo = function (resultOpacity, params, afterAnimationCallback) {

    params = params ? params : {};
    var wordFrom = params.wordFrom || 0;
    var wordTo = params.wordTo || this.object.words.length - 1;
    var words = this.object.element.find('.word');
    var symbols = $(words[wordFrom]).find('.symbol');
    for (var i = wordFrom; i < wordTo; i++) {
      symbols = symbols.add($(words[i + 1]).find('.symbol'));
    }
//    var symbols = this.object.element.find('.symbol');

    var symbol, dOpacity, durationOpacity = this.options.durations.opacity;
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
    var oldSize = this.getElementSize();
    var newSize = { width: scale * oldSize.width, height: scale * oldSize.height };
    var nextSize;
    var oldPosition;
    var framesInStep = parseInt(this.options.durations.resize / (newSize.height - oldSize.height));
    var frame = 0;

    var resizeInterval = setInterval(function () {
      frame++;
      if (frame % framesInStep === 0) {
        oldSize = objectAnimations.getElementSize();
        oldPosition = objectAnimations.getElementPosition();
        objectAnimations.object.element.height(oldSize.height + 2);
        objectAnimations.object.element.css({ fontSize: (oldSize.height + 2) + 'px' });
        nextSize = objectAnimations.getElementSize();
        objectAnimations.object.element.css({
          left: (oldPosition.left - (nextSize.width - oldSize.width)/2) + 'px',
          top: (oldPosition.top - (nextSize.height - oldSize.height)/2) + 'px',
        });
        if (objectAnimations.object.element.height() >= newSize.height) {
          clearInterval(resizeInterval);
          objectAnimations.recalculateElementParameters();
          if (afterAnimationCallback) {
            afterAnimationCallback();
          }
        }
      }
    }, 0);

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
