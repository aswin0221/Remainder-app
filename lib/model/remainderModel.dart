class RemainderModel{
  int? id;
  int? dateTime;
  String? title;
  String? description ;

  remainderMap() {
    var mapping = Map<String, dynamic>();
    mapping['title']=title;
    mapping['id'] = id ?? null;
    mapping['dateTime'] = dateTime!;
    mapping['description'] = description!;
    return mapping;
  }

}