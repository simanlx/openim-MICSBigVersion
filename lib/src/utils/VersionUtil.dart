


class VersionUtil{

  //版本号规则  xx.xx.xx
  static bool canUpdate(String currentVersion,String latestVersion){
    try{
      var list1 = currentVersion.split(".");
      var list2 = latestVersion.split(".");
      if (list1.length != list2.length) {
        return false;
      }
      for(var i = 0;i<list2.length;i++){
          var current = list1[i];
          var latest = list2[i];
          if(int.parse(latest) > int.parse(current)){
            return true;
          }
      }
      return false;
    }catch(e){
      return false;
    }
  }


}