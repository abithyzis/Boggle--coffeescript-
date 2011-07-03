(function() {
  var boggle;
  boggle = function() {
    var b, board, is_adjacent, num_squares, shake_dice_onto_board, size, touch_all_squares;
    size = 5;
    num_squares = size * size;
    board = function() {
      var self;
      (function() {
        var i, j, n, table, td, tr;
        table = $("<table border=1>");
        n = 0;
        for (i = 0; i < 5; i += 1) {
          tr = $("<tr>");
          table.append(tr);
          for (j = 0; j < 5; j += 1) {
            td = $("<td>x" + i + "," + j + "," + n + "</td>");
            td.attr("id", "pos" + n);
            n += 1;
            tr.append(td);
          }
        }
        return $("#board").append(table);
      })();
      return self = {
        square: function(i) {
          return $("#pos" + i);
        },
        index: function(element) {
          var id;
          id = $(element).attr("id");
          return parseInt(id.match(/\d+/)[0]);
        },
        place_die: function(i, value) {
          return self.square(i).html(value);
        },
        on_click_square: function(callback) {
          var handler;
          handler = function() {
            return callback(self.index(this));
          };
          return $("td").click(handler);
        },
        highlight: function(pos) {
          return self.square(pos).css("background", "green");
        },
        lowlight: function(pos) {
          return self.square(pos).css("background", "white");
        }
      };
    };
    is_adjacent = function(s1, s2) {
      var c1, c2, r1, r2;
      if (s1 === s2) {
        return false;
      }
      r1 = Math.floor(s1 / size);
      c1 = s1 % size;
      r2 = Math.floor(s2 / size);
      c2 = s2 % size;
      return (Math.abs(r1 - r2) <= 1) && (Math.abs(c1 - c2) <= 1);
    };
    touch_all_squares = function(f, on_handler, off_handler) {
      var square, _results;
      console.log("in touch_all_squares");
      _results = [];
      for (square = 0; (0 <= num_squares ? square < num_squares : square > num_squares); square += 1) {
        _results.push(f(square) ? on_handler(square) : off_handler(square));
      }
      return _results;
    };
    b = board();
    b.on_click_square(function(square) {
      var f;
      f = function(i) {
        return is_adjacent(i, square);
      };
      return touch_all_squares(f, b.highlight, b.lowlight);
    });
    shake_dice_onto_board = function() {
      var dice, i, numbers, _i, _results, _results2;
      numbers = (function() {
        _results = [];
        for (var _i = 0; 0 <= num_squares ? _i < num_squares : _i > num_squares; 0 <= num_squares ? _i += 1 : _i -= 1){ _results.push(_i); }
        return _results;
      }).apply(this, arguments);
      dice = _.sortBy(numbers, Math.random);
      _results2 = [];
      for (i = 0; (0 <= num_squares ? i < num_squares : i > num_squares); i += 1) {
        _results2.push(b.place_die(i, dice[i]));
      }
      return _results2;
    };
    return shake_dice_onto_board();
  };
  jQuery(document).ready(function() {
    return boggle();
  });
}).call(this);
