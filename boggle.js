(function() {
  var Board, DiceShaker, Display, LetterDice, Util, Word_builder, Word_entry, boggle;
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
    },
    shuffle_array: function(array) {
      return _.sortBy(array, Math.random);
    },
    random_char: function(s) {
      var i;
      i = Math.floor(Math.random() * s.length);
      return s.charAt(i);
    }
  };
  DiceShaker = {
    shake: function(num_squares, letter_dice) {
      var dice, numbers, _i, _results;
      if (num_squares !== letter_dice.length) {
        throw "unexpected number of dice";
      }
      numbers = (function() {
        _results = [];
        for (var _i = 0; 0 <= num_squares ? _i < num_squares : _i > num_squares; 0 <= num_squares ? _i += 1 : _i -= 1){ _results.push(_i); }
        return _results;
      }).apply(this, arguments);
      dice = Util.shuffle_array(numbers);
      return _.map(dice, function(die) {
        var letter;
        letter = Util.random_char(letter_dice[die]);
        if (letter === 'Q') {
          letter = 'QU';
        }
        return letter;
      });
    }
  };
  Board = function(display, size, letter_dice) {
    var dice, num_squares, self, shake_dice_onto_board;
    num_squares = size * size;
    dice = DiceShaker.shake(num_squares, letter_dice);
    shake_dice_onto_board = function() {
      var die, i, _len, _results;
      _results = [];
      for (i = 0, _len = dice.length; i < _len; i++) {
        die = dice[i];
        _results.push(display.place_die(i, die));
      }
      return _results;
    };
    shake_dice_onto_board();
    return self = {
      get_letter: function(i) {
        return dice[i];
      },
      for_all_squares: function(f) {
        var square, _results;
        _results = [];
        for (square = 0; (0 <= num_squares ? square < num_squares : square > num_squares); square += 1) {
          _results.push(f(square));
        }
        return _results;
      },
      is_adjacent: function(s1, s2) {
        var c1, c2, r1, r2;
        if (s1 === s2) {
          return false;
        }
        r1 = Math.floor(s1 / size);
        c1 = s1 % size;
        r2 = Math.floor(s2 / size);
        c2 = s2 % size;
        return (Math.abs(r1 - r2) <= 1) && (Math.abs(c1 - c2) <= 1);
      }
    };
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
          return callback(self.index(this));
        };
        return $("td").click(handler);
      },
      color: function(pos, color) {
        return self.square(pos).css("background", color);
      },
      word_entry: function() {
        var back_button, field, self, span;
        span = $("<span>");
        $("#boggle").append(span);
        field = $("<pre>");
        span.append(field);
        back_button = $("<input type='button'>");
        back_button.attr("value", "BACK");
        span.append(back_button);
        back_button.hide();
        return self = {
          field: {
            set: function(text) {
              return field.html(text);
            }
          },
          back_button: {
            hide: function() {
              return back_button.hide();
            },
            show: function() {
              return back_button.show();
            },
            on_click: function(f) {
              return back_button.click(f);
            }
          }
        };
      }
    };
  };
  Word_builder = function(board) {
    var self, square_indexes;
    square_indexes = [];
    return self = {
      add: function(i) {
        return square_indexes.push(i);
      },
      backspace: function() {
        return square_indexes.pop();
      },
      text: function() {
        return _.map(square_indexes, function(i) {
          return board.get_letter(i);
        }).join('');
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
        return board.is_adjacent(last_square, new_i);
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
  Word_entry = function(board, display) {
    var back_button, backspace, color_all_squares, field, on_click_letter, redraw, word, _ref;
    color_all_squares = function() {
      return board.for_all_squares(function(i) {
        return display.color(i, word.color(i));
      });
    };
    redraw = function() {
      var text;
      color_all_squares();
      text = word.text();
      field.set(text);
      if (text.length > 0) {
        return back_button.show();
      } else {
        return back_button.hide();
      }
    };
    on_click_letter = function(i) {
      if (!word.legal(i)) {
        alert("illegal square choice");
        return;
      }
      word.add(i);
      return redraw();
    };
    backspace = function() {
      word.backspace();
      return redraw();
    };
    word = Word_builder(board);
    _ref = display.word_entry(), field = _ref.field, back_button = _ref.back_button;
    display.on_click_square(on_click_letter);
    return back_button.on_click(backspace);
  };
  LetterDice = ["AAEEGN", "ELRTTY", "AOOTTW", "ABBJOO", "EHRTVW", "CIMOTU", "DISTTY", "EIOSST", "DELRVY", "ACHOPS", "HIMNQU", "EEINSU", "EEGHNW", "AFFKPS", "HLNNRZ", "DEILRX"];
  boggle = function() {
    var size;
    size = 4;
    return (function() {
      var board, display, entry;
      display = Display(size);
      board = Board(display, size, LetterDice);
      return entry = Word_entry(board, display);
    })();
  };
  jQuery(document).ready(function() {
    return boggle();
  });
}).call(this);
