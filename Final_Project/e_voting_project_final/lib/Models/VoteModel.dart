class VoteModel{

  String VoterName;
  String VoterID;
  String Start_time;

  VoteModel({this.VoterName,this.VoterID,this.Start_time});

  //data from server
  factory VoteModel.fromMap(map)
  {
    return VoteModel(

      VoterName: map['VoterName'],
      VoterID: map['VoterID'],
        Start_time: map['Start_time'],

    );
  }
// sending data to server
  Map<String, dynamic> toMap()
  {
    return
      {
        'VoterName': VoterName,
        'VoterID': VoterID,
        'Start_time': Start_time,

      };
  }
}
