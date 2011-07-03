(function() {
  var boggle;
  boggle = function() {
    var b, board, is_adjacent, num_squares, shake_dice_onto_board, size, touch_all_squares;
    size = 5;
    num_squares = size * size;
    board = function() {
      var self, table_data;
      table_data = function() {
        return _.map([0, 1, 2, 3, 4], function(row) {
          return _.map([0, 1, 2, 3, 4], function(col) {
            var n;
            n = row * size + col;
            return $("<td>").attr("id", "pos" + n);
          });
        });
      };
      (function() {
        var row, table, td, tr, _i, _j, _len, _len2, _ref;
        table = $("<table border=1>");
        _ref = table_data();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          tr = $("<tr>");
          for (_j = 0, _len2 = row.length; _j < _len2; _j++) {
            td = row[_j];
            tr.append(td);
          }
          table.append(tr);
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
