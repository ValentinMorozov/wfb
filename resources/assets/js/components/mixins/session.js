
var SessionVar = 
    {
    cssClasses: 
        { Width: {    '1': 'pure-u-1',    '1/1': 'pure-u-1-1',   '1/2': 'pure-u-1-2',   '1/3': 'pure-u-1-3',
                    '2/3': 'pure-u-2-3',  '1/4': 'pure-u-1-4',   '3/4': 'pure-u-3-4',   '1/5': 'pure-u-1-5',
                    '2/5': 'pure-u-2-5',  '3/5': 'pure-u-3-5',   '4/5': 'pure-u-4-5',   '5/5': 'pure-u-5-5',
                    '1/6': 'pure-u-1-6',  '5/6': 'pure-u-5-6',   '1/8': 'pure-u-1-8',   '3/8': 'pure-u-3-8',
                    '5/8': 'pure-u-5-8',  '7/8': 'pure-u-7-8',   '1/12': 'pure-u-1-12', '5/12': 'pure-u-5-12',
                   '7/12': 'pure-u-7-12','11/12': 'pure-u-11-12','1/24': 'pure-u-1-24', '2/24': 'pure-u-2-24',
                   '3/24': 'pure-u-3-24', '4/24': 'pure-u-4-24', '5/24': 'pure-u-5-24', '6/24': 'pure-u-6-24', 
                   '7/24': 'pure-u-7-24', '8/24': 'pure-u-8-24', '9/24': 'pure-u-9-24','10/24': 'pure-u-10-24',
                  '11/24': 'pure-u-11-24','12/24': 'pure-u-12-24','13/24': 'pure-u-13-24','14/24': 'pure-u-14-24',
                  '15/24': 'pure-u-15-24','16/24': 'pure-u-16-24','17/24': 'pure-u-17-24','18/24': 'pure-u-18-24',
                  '19/24': 'pure-u-19-24','20/24': 'pure-u-20-24','21/24': 'pure-u-21-24','22/24': 'pure-u-22-24',
                  '23/24': 'pure-u-23-24','24/24': 'pure-u-24-24'           
            }
        }
    };
/*----*/
export default {
  created: function () {
    this.$_sess = SessionVar;
    this.$_sess.Plants = {};
    var cssObj = this.$_sess.cssClasses;
    this.$_sess.cssClasses.cssWidth = function (n, k) {
          var part = n+'/'+k;
          return cssObj.Width[part];
        }
    this.$_sess.cssClasses.ToString = function(classes) {
          var res = '';
          for(var key in classes) {
              res = res + ' ' + classes[key];
          }
          return res;
      }
 /*     console.log('mixin-Root');*/
  }
};