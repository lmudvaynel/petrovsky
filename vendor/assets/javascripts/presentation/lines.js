function LinesAnimations (lines) {

  this.init = function () {
    this.lines = lines.elements;
  }

  this.opacityTo = function (resultOpacity, params, afterAnimationCallback) {
    var lines = this.lines;
    var showCallback = function (lineId) {
      if (lineId < lines.length) {
        lines[lineId].animations.opacityTo(resultOpacity, params, function () {
          showCallback(lineId + 1);
        });
      } else {
        if (afterAnimationCallback) {
          afterAnimationCallback();
        }
      }
    };
    showCallback(0);
  }

  this.init();

}

function Lines (options) {

  // Relative sizes
  this.size = {
    container: {
      width: 1,
      height: 1,
    },
    line: {
      height: 0.05,
      left: 0.05,
      top: 0.05,
    }
  }

  this.init = function () {
    this.elements = [];
    var size = options || {};
    this.size = Hash.merge(this.size, size);

    this.initContainer();
//    this.updateLinesElementsStyle();
    this.updateFontsSizes();
    this.initLines();
  }

  this.initContainer = function () {
    this.container = $('#animated-text-container');
    this.updateContainerSize();

    var lines = this;
    $(window).resize(function () {
      lines.updateContainerSize();
      lines.updateFontsSizes();
//      lines.updateLinesElementsSize();
    });
  }

  this.updateContainerSize = function () {
    var width = Math.round(this.size.container.width * window.innerWidth);
    var height = Math.round(this.size.container.height * window.innerHeight);
    this.container.width(width).height(height);
  }

  this.initLines = function () {
    var linesElements = this.container.find('.line');
    for (var i = 0; i < linesElements.length; i++) {
      this.elements.push(new Line($(linesElements[i])));
    }
  }

  this.updateLinesElementsStyle = function () {
//    this.updateLinesElementsSize();
//    this.updateLinesElementsPosition();
  }

  this.updateFontsSizes = function () {
    var linesElements = this.container.find('.line');
    for (var i = 0; i < linesElements.length; i++) {
      $(linesElements[i]).css('fontSize', $(linesElements[i]).height());
    }
  }

  this.updateLinesElementsSize = function () {
    var height = this.getLineHeight();
    var linesElements = this.container.find('.line');
    for (var i = 0; i < linesElements.length; i++) {
      $(linesElements[i]).css({
        height: (height.relative * 100) + '%',
        fontSize: height.pixels,
      });
    }
  }

  this.updateLinesElementsPosition = function () {
    var linesElements = this.container.find('.line');
    for (var i = 0; i < linesElements.length; i++) {
//      this.updateLinePosition($(linesElements[i]), i);
    }
  }

  this.updateLinePosition = function (lineElement, i) {
    var height = this.getLineHeight();
    var position = this.getLinePosition();
    lineElement.css({
      position: 'absolute',
      left: position.left,
      top: position.top + i * height.pixels,
    });
  }

  this.getLineHeight = function () {
    var height = { relative: this.size.line.height };
    height.pixels = this.container.height() * height.relative;
    return height;
  }

  this.getLinePosition = function () {
    return {
      left: this.container.width() * this.size.line.left,
      top: this.container.height() * this.size.line.top,
    }
  }

  this.copy = function (lineId, wordsStart, wordsEnd) {
    var start = wordsStart || 0, end = wordsEnd || this.elements[lineId].words.length;
    var text = this.elements[lineId].words.slice(start, end).map(function(word){ return word.word }).join(' ');

    var newElem = $('<div>', { class: 'line' }).text(text).appendTo(this.container);
    newElem.css({
      top: (100 * parseFloat(this.elements[lineId].element.css('top')) / this.container.height()) + '%'
    });
    var newLine = new Line(newElem);
    this.elements.push(newLine);

    this.updateFontsSizes();
//    this.updateLinesElementsSize();
//    this.updateLinePosition(newElem, lineId);

    return newLine;
  }

  this.getByElement = function (name) {
    var lines = [];
    var elements = this.container.find('.' + name.split(/\s|\./).join('.'));
    for (var i = 0; i < this.elements.length; i++) {
      if (elements.index(this.elements[i].element) !== -1) {
        lines.push(this.elements[i]);
      }
    }
    return lines;
  }

  this.changeBackgroundImageTo = function (backgroundId) {
/*
    var container = this.container;
    container.animate({ opacity: 0 }, 1000, "linear", function(){
      container.css('backgroundImage', 'url(images/presentation/' + name +')');
      container.animate({ opacity: 1 }, 1000);
    });
*/
    if (backgroundId > 0) {
      $('#animated-text-backgrounds .background-' + (backgroundId - 1)).animate({ opacity: 0 }, 1000);
    }
    $('#animated-text-backgrounds .background-' + backgroundId).animate({ opacity: 1 }, 1000);
//    this.container.css('backgroundImage', 'url(images/presentation/' + name +')');
  }

  this.init();

  this.animations = new LinesAnimations(this);

}
