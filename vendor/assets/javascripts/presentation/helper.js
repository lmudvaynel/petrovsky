var Hash = {
  merge: function (oldHash, newHash) {
    var oldHashVal, newHashVal;
    var hash = {};
    for (var key in oldHash) {
      oldHashVal = oldHash[key];
      if (newHash[key] != undefined && newHash[key] != null && newHash[key] != NaN) {
        newHashVal = newHash[key];
        if (typeof(oldHashVal) === 'object') {
          if (typeof(newHashVal) === 'object') {
            hash[key] = this.merge(oldHashVal, newHashVal);
          } else {
            hash[key] = oldHashVal;
          }
        } else {
          hash[key] = newHashVal;
        }
      } else {
        hash[key] = oldHashVal;
      }
    }
    return hash;
  }
}
