(function($) {

    function Filter (el, opts) {
        this.initOpts = function(opts, type) {
            if (type != undefined)
                this.type = type
            else if (opts == undefined) {
                this.type = 'all';
            } else if (typeof(opts) == 'string') {
                this.type = opts;
            } else if (typeof(opts) == 'object') {
                this.type = opts.type;
            } else {
                return false;
            }

            if (this['f' + this.type] == undefined) {
                return false;
            }

            return true;
        }

        this.initEl = function($el) {
            if (this.el.prop('tagName').toLowerCase() != 'input') return;

            that = this;

            this.el.on('keypress', {type: that.type}, function(e) {
                if (e.ctrlKey !== true ){
                    return that.onKeyDown(e.data.type, e);
                }

            });

            this.el.on('keydown', {type: that.type}, function(e) {
                if (e.ctrlKey == true && e.data.type == "number"){
                    self = this;
                    setTimeout(function() {
                        self.value = self.value.replace(/\D/g, '');
                    }, 0);
                }
                if (e.ctrlKey == true && e.data.type == "name"){
                    self = this;
                    setTimeout(function(){
                        self.value = self.value.replace();
                    }, 0);
                }
            });


        };

        this.onKeyDown = function(type, event) {
            var key = (event.which) ? event.which : event.keyCode;
            return key < 47 ? true : this.filter(type, key);
        };

        this.filter = function(type, key) {
            return this['f' + type](key);
        };

        /* filters */

        this.ftext = function(key) {
            return /^[a-zA-Zа-яА-Я]$/.test(this._char(key))
        },

            this.fname = function(key) {
                return /^[a-zA-Zа-яА-Я-]$/.test(this._char(key))
            },

            this.flatin = function(key) {
                return /^[a-zA-Z]$/.test(this._char(key))
            },

            this.femail = function(key) {
                return /^[a-zA-Z0-9!#@$%&'*+-\/=?^_`~.]$/.test(this._char(key))
            },

            this.fnumber = function(key) {
                return /^[0-9]$/.test(this._char(key))
            },

            this.fphone = function(key) {
                return /^[0-9-+]$/.test(this._char(key))
            },

            this.fall = function(key) {
                return true;
            },

            this.fdate = function(key) {
                return /\d{2}\/\d{2}\/\d{4}/.test(this._char(key))
            },

            /* helpers */

            this._char = function(key) {
                return String.fromCharCode(key);
            };

        this.__construct = function(that, el, opts) {
            that.el = el;
            res = that.initOpts(opts, el.attr('data-filter-type'))
            if (res) {
                that.initEl()
            } else {
                console.error("Undefined");
            }
        }(this, el, opts);


    }


    $.fn.inputFilter = function(opts) {
        window.filters = [];
        return this.each(function() {
            window.filters.push (new Filter(jQuery(this), opts));
        });
    };
})(jQuery);