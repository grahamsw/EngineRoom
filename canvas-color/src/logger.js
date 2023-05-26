

class Logger {
  static log(owner, log=true){
    var label = owner.constructor.name;
    var ret = function(msg, tag = ''){
      if (log){
        var t = tag === ''? '' : ', ' + tag;
        console.log(label  + t + ':');
        console.log(msg);
      }
    }
    return ret;
  }
}

export default Logger;
