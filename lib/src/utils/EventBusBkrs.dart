

typedef void EventCallback(arg);

class EventBusBkrs{


  EventBusBkrs._internal();

  static EventBusBkrs _singleton = EventBusBkrs._internal();

  factory EventBusBkrs() => _singleton;

  final _emap = Map<Object,List<EventCallback>?>();

  void on(eventName,EventCallback f){
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName]!.add(f);
  }


  void off(eventName,[EventCallback? f]){
    var list = _emap[eventName];
    if(eventName == null || list ==null) return;
    if (f==null) {
      _emap[eventName] = null;
    }else{
      list.remove(f);
    }
  }

  void emit(eventName,[arg]){
    var list = _emap[eventName];
    if(list == null) return;
    int len = list.length-1;
    for (int i = len; i >-1; --i) {
      list[i](arg);
    }
  }
}

var busBkrs = EventBusBkrs();