class VideoModel{
 late int id;
 late String url;
 late String thumbnail;
 late num duration;
 late String userName;
 late String userProfile;

 VideoModel.fromJson(Map<String,dynamic>json){
   id = json['id'];
   url = json['video_files'].first["link"];
   thumbnail = json['image'];
   duration = json['duration'];
   userName = json['user']['name'];
   userProfile = json['user']['url'];
 }

}