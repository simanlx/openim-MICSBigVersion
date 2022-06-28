
class VoiceTimeUtil{

  static String transferSec(int sec) {
    int hour = (sec / 3600).floor();
    int min = (sec % 3600 / 60).floor();
    int second = sec % 60;
    if (hour == 0) {
      return  (min<10?"0$min":"$min")+":"+ (second<10?"0$second":"$second");
    }else{
      return  (hour<10?"0$hour":"$hour")+":"+(min<10?"0$min":"$min")+":"+ (second<10?"0$second":"$second");
    }

  }

}