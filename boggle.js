(function() {
  var Display, Util, Word_builder, boggle;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  Util = {
    build_table_from_2d_cell_array: function(array_2d) {
      var row, table, td, tr, _i, _j, _len, _len2;
      table = $("<table border=1>");
      for (_i = 0, _len = array_2d.length; _i < _len; _i++) {
        row = array_2d[_i];
        tr = $("<tr>");
        for (_j = 0, _len2 = row.length; _j < _len2; _j++) {
          td = row[_j];
          tr.append(td);
        }
        table.append(tr);
      }
      return table;
    }
  };
  Display = function(size) {
    var self;
    (function() {
      var table, table_data;
      table_data = function() {
        var _i, _results;
        return _.map((function() {
          _results = [];
          for (var _i = 0; 0 <= size ? _i < size : _i > size; 0 <= size ? _i += 1 : _i -= 1){ _results.push(_i); }
          return _results;
        }).apply(this, arguments), function(row) {
          var _i, _results;
          return _.map((function() {
            _results = [];
            for (var _i = 0; 0 <= size ? _i < size : _i > size; 0 <= size ? _i += 1 : _i -= 1){ _results.push(_i); }
            return _results;
          }).apply(this, arguments), function(col) {
            var n;
            n = row * size + col;
            return $("<td>").attr("id", "pos" + n).css("height", "30px").css("width", "30px");
          });
        });
      };
      table = Util.build_table_from_2d_cell_array(table_data());
      return $("#boggle").append(table);
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
          var i;
          i = self.index(this);
          return callback(i, $(this));
        };
        return $("td").click(handler);
      },
      color: function(pos, color) {
        return self.square(pos).css("background", color);
      }
    };
  };
  Word_builder = function(is_adjacent) {
    var self, square_indexes;
    square_indexes = [];
    return self = {
      add: function(i) {
        return square_indexes.push(i);
      },
      already_used: function(i) {
        return __indexOf.call(square_indexes, i) >= 0;
      },
      in_reach: function(new_i) {
        var last_square;
        if (square_indexes.length === 0) {
          return true;
        }
        last_square = self.last_square_selected();
        return is_adjacent(last_square, new_i);
      },
      legal: function(new_i) {
        return self.in_reach(new_i) && !self.already_used(new_i);
      },
      last_square_selected: function() {
        if (square_indexes.length === 0) {
          return;
        }
        return square_indexes[square_indexes.length - 1];
      },
      color: function(i) {
        if (i === self.last_square_selected()) {
          return "lightgreen";
        }
        if (self.already_used(i)) {
          return "lightblue";
        }
        if (self.in_reach(i)) {
          return "white";
        }
        return "red";
      }
    };
  };
  boggle = function() {
    var for_all_squares, is_adjacent, num_squares, size, word_entry;
    size = 4;
    num_squares = size * size;
    word_entry = function(display, is_adjacent) {
      var color_all_squares, field, field_builder, word;
      field_builder = function() {
        var field;
        field = $("<pre>");
        $("#boggle").append(field);
        return field;
      };
      color_all_squares = function() {
        return for_all_squares(function(i) {
          return display.color(i, word.color(i));
        });
      };
      word = Word_builder(is_adjacent);
      field = field_builder();
      return display.on_click_square(function(i, square) {
        if (!word.legal(i)) {
          alert("illegal square choice");
          return;
        }
        word.add(i);
        color_all_squares();
        return field.append("_" + square.html());
      });
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
    for_all_squares = function(f) {
      var square, _results;
      _results = [];
      for (square = 0; (0 <= num_squares ? square < num_squares : square > num_squares); square += 1) {
        _results.push(f(square));
      }
      return _results;
    };
    return (function() {
      var display, entry, shake_dice_onto_board;
      display = Display(size);
      entry = word_entry(display, is_adjacent);
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
          _results2.push(display.place_die(i, dice[i]));
        }
        return _results2;
      };
      return shake_dice_onto_board();
    })();
  };
  jQuery(document).ready(function() {
    return boggle();
  });
}).call(this);
