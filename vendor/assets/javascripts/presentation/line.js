
function Line (lineElement) {
  this.init = function () {
    if (!lineElement) { return; }
    this.element = lineElement;
    this.container = $('#animated-text-container');
    this.text = lineElement.text() || '';
    this.symbols = this.text.match(/\S/g);
    this.letters = this.text.match(/[a-zA-Zа-яА-Я]/g);
    this.initWords();
    this.updateElement(this.text);
  }

  this.initWords = function () {
    var j;
    var words = this.text.match(/([a-zA-Zа-яА-Я]+)|(\S)|(\s+)/g);
    if (!words) { return; }
    this.words = [];
    var wordType;
    for (var i = 0; i < words.length; i++) {
      if (words[i][0] == ' ') {
        wordType = 'space';
      } else {
        wordType = words[i].search(/[a-zA-Zа-яА-Я]/g) === -1 ? 'symbols' : 'word';
      }
      this.words.push(new Word(words[i], wordType));
    }
  }

  this.updateElement = function () {
    var wrapper = $('<div>'), wordDiv_1,wordDiv_2,wordDiv_3,wordDiv_4, wordSpan, symbolSpan;
    var wordClass, wordNumber = 0;
    //var text=["PETROVSKY APART HOUSE КАЧЕСТВЕННО НОВЫЙ УНИКАЛЬНЫЙ ПРОДУКТ,",
    //          "ГАРМОНИЯ ЖИЗНИ В ВОЗМОЖНОСТИ УЕДИНЕНИЯ В СОБСТВЕННОМ ",
     //         "СВОБОДА ДЕЙСТВИЙ В ВЫБОРЕ ФУНКЦИОНАЛЬНО-ПЛАНИРОВОЧНЫХ РЕШЕНИЙ ",
     //         "КОМФОРТ С ИСПОЛЬЗОВАНИЕМ ЭКСКЛЮЗИВНЫХ ВОЗМОЖНОСТЕЙ"]
   // wordDiv_1=$('<a class="concl-link" href="/concept">');
   // wordDiv_2=$('<a class="concl-link" href="/gallery">');
   // wordDiv_3=$('<a class="concl-link" href="/floor_plans">');
  //  wordDiv_4=$('<a class="concl-link" href="/service">');
   // if (this.text==text[0]) {
   //   wrapper.append(wordDiv_1);
   // }
   // if (this.text==text[1]) {
   //   wrapper.append(wordDiv_2);
   // }
   // if (this.text==text[2]) {
   //   wrapper.append(wordDiv_3);
   // }
   // if (this.text==text[3]) {
    //  wrapper.append(wordDiv_4);
    //}
    for (var i = 0; i < this.words.length; i++) {
      wordSpan = $('<span>');
      wordSpan[0].dataset.type = this.words[i].type;

      if (this.words[i].type != 'space') {
        wordSpan.addClass('word');
        wordSpan[0].dataset.number = wordNumber;
        wordNumber++;
      }
      for (var j = 0; j < this.words[i].symbols.length; j++) {
        symbolSpan = $('<span>', { class: 'symbol' });
        symbolSpan.css('opacity', 0);
        symbolSpan.text(this.words[i].symbols[j]);
        wordSpan.append(symbolSpan);
      }
     // if (this.text==text[0])
     //   { wordDiv_1.append(wordSpan); }
     // else if (this.text==text[1])
     //   { wordDiv_2.append(wordSpan); }
     // else if (this.text==text[2])
     //    { wordDiv_3.append(wordSpan); }
     // else if (this.text==text[3])
      //  { wordDiv_4.append(wordSpan); }
     // else 
        {wrapper.append(wordSpan)}
    }
    this.element.html(wrapper.html());
  }

  this.opacityTo = function (opacity, params) {
    params = params ? params : {};
    var wordFrom = params.wordFrom || 0;
    var wordTo = params.wordTo || this.words.length - 1;
    var words = this.element.find('.word');
    var symbols = $(words[wordFrom]).find('.symbol');
    for (var i = wordFrom; i < wordTo; i++) {
      symbols = symbols.add($(words[i + 1]).find('.symbol'));
    }
//    var symbols = this.element.find('.symbol');
    for (var i = 0; i < symbols.length; i++) {
      $(symbols[i]).css('opacity', opacity);
    }
  }

  this.move = function (dLeft, dTop) {
    var elementPosition = this.element.position();
    this.element.css({
      left: elementPosition.left + dLeft,
      top: elementPosition.top + dTop
    });
    this.recalculateElementParameters();
  }

  this.moveTo = function (left, top) {
    var elementPosition = this.element.position();
    var dLeft = left - elementPosition.left;
    var dTop = top - elementPosition.top;
    this.move(dLeft, dTop);
  }

  this.resize = function (scale) {
    var oldPosition = this.element.position();
    var oldSize = { width: this.element.width(), height: this.element.height() };
    var newSize = { width: oldSize.width * scale, height: oldSize.height * scale };
    var dHeight = newSize.height - oldSize.height;
    this.element.height(newSize.height);
    this.element.css('fontSize', newSize.height);
    var newSize = { width: this.element.width(), height: this.element.height() };
    this.element.css({
      left: (oldPosition.left - (newSize.width - oldSize.width)/2) + 'px',
      top: (oldPosition.top - (newSize.height - oldSize.height)/2) + 'px'
    });
    this.recalculateElementParameters();
  }

  this.recalculateElementParameters = function () {
    var elementPosition = this.element.position();
    var elementSize = { width: this.element.width(), height: this.element.height() };
    var leftInPercents = (100 * elementPosition.left / this.container.width()) + '%';
    var topInPercents = (100 * elementPosition.top / this.container.height()) + '%';
    var widthInPercents = (100 * elementSize.width / this.container.width()) + '%';
    var heightInPercents = (100 * elementSize.height / this.container.height()) + '%';
    this.element.css({
      left: leftInPercents,
      top: topInPercents,
      width: widthInPercents,
      height: heightInPercents,
    });
  }
  this.init();

  this.animations = new ObjectAnimations(this);

}
