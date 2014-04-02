function Word (wordText, wordType) {

  this.init = function () {
    this.word = wordText || '';
    this.type = wordType || 'symbols';
    this.symbols = this.word.split('');
  }

  this.init();

}
