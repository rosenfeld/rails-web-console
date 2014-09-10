
// cookie command cache

CommandCache = (function() {
  
  var max_len = 4000;
  var cookie_name = 'command_history';

  function CommandCache() {
    if (cookie = getCookie(cookie_name)) {
      this.array = JSON.parse(cookie);
    } else {
      this.array = [];
    }
  }

  CommandCache.prototype.push = function(command) {
    this.array.push(command);
    while (this._size() > max_len) {
      this.array.shift();
    }
    setCookie(cookie_name, JSON.stringify(this.array));
  };

  CommandCache.prototype._size = function() {
    return JSON.stringify(this.array).length;
  }

  CommandCache.prototype.length = function() {
    return this.array.length;
  }

  CommandCache.prototype.get = function(index) {
    return this.array[index];
  };

  return CommandCache;

})();
