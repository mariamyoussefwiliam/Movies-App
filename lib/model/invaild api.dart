
class InvalidApi
{
  String stutas;
  InvalidApi.fromJson(Map<String,dynamic> json)
  {
    stutas=json["status_message"];
  }


}