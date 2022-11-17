class PredictionModeldata {
  late final List<PredictionData> data;

  PredictionModeldata({required this.data});

  PredictionModeldata.fromJson(Map<String, dynamic> json, this.data) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new PredictionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class PredictionData {
  late final String homeTeam;
  late final double stadiumCapacity;
  late final String awayTeam;
  late final int id;
  late final double fieldLength;
  late final String market;
  late final String competitionName;
  late final double fieldWidth;
  late final String prediction;
  late final String competitionCluster;
  late final double homeStrength;
  late final String status;
  late final String federation;
  late final double awayStrength;
  late final bool isExpired;
  late final String season;
  late final String result;
  late final String startDate;
  late final String lastUpdateAt;
  late final double distanceBetweenTeams;
  late final Probabilities probabilities;
  late final Probabilities odds;

  PredictionData(
      {required this.homeTeam,
      required this.stadiumCapacity,
      required this.awayTeam,
      required this.id,
      required this.fieldLength,
      required this.market,
      required this.competitionName,
      required this.fieldWidth,
      required this.prediction,
      required this.competitionCluster,
      required this.homeStrength,
      required this.status,
      required this.federation,
      required this.awayStrength,
      required this.isExpired,
      required this.season,
      required this.result,
      required this.startDate,
      required this.lastUpdateAt,
      required this.distanceBetweenTeams,
      required this.probabilities,
      required this.odds});

  PredictionData.fromJson(Map<String, dynamic> json) {
    homeTeam = json['home_team'];
    stadiumCapacity = json['stadium_capacity'] ?? 0;
    awayTeam = json['away_team'];
    id = json['id'];
    fieldLength = json['field_length'] ?? 0;
    market = json['market'];
    competitionName = json['competition_name'];
    fieldWidth = json['field_width'] ?? 0;
    prediction = json['prediction'];
    competitionCluster = json['competition_cluster'];
    homeStrength = json['home_strength'] ?? 0;
    status = json['status'];
    federation = json['federation'];
    awayStrength = json['away_strength'] ?? 0;
    isExpired = json['is_expired'];
    season = json['season'];
    result = json['result'];
    startDate = json['start_date'];
    lastUpdateAt = json['last_update_at'];
    distanceBetweenTeams = json['distance_between_teams'] ?? 0;
    probabilities = (json['probabilities'] != null
        ? new Probabilities.fromJson(json['probabilities'])
        : null)!;
    odds = (json['odds'] != null
        ? new Probabilities.fromJson(json['odds'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_team'] = this.homeTeam;
    data['stadium_capacity'] = this.stadiumCapacity;
    data['away_team'] = this.awayTeam;
    data['id'] = this.id;
    data['field_length'] = this.fieldLength;
    data['market'] = this.market;
    data['competition_name'] = this.competitionName;
    data['field_width'] = this.fieldWidth;
    data['prediction'] = this.prediction;
    data['competition_cluster'] = this.competitionCluster;
    data['home_strength'] = this.homeStrength;
    data['status'] = this.status;
    data['federation'] = this.federation;
    data['away_strength'] = this.awayStrength;
    data['is_expired'] = this.isExpired;
    data['season'] = this.season;
    data['result'] = this.result;
    data['start_date'] = this.startDate;
    data['last_update_at'] = this.lastUpdateAt;
    data['distance_between_teams'] = this.distanceBetweenTeams;
    if (this.probabilities != null) {
      data['probabilities'] = this.probabilities.toJson();
    }
    if (this.odds != null) {
      data['odds'] = this.odds.toJson();
    }
    return data;
  }

  String getPredictions() {
    switch (this.prediction) {
      case "1":
        return this.odds.d1.toString();
      case "2":
        return this.odds.d2.toString();
      case "12":
        return this.odds.d12.toString();
      case "X":
        return this.odds.x.toString();
      case "1X":
        return this.odds.d1X.toString();
      case "X2":
        return this.odds.x2.toString();
      case "yes":
        return this.odds.yes.toString();
      case "no":
        return this.odds.no.toString();
      default:
        return "N/A";
    }
  }
}

class Probabilities {
  late final double d1;
  late final double d2;
  late final double d12;
  late final double x;
  late final double d1X;
  late final double x2;
  late final double yes;
  late final double no;

  Probabilities(
      {required this.d1,
      required this.d2,
      required this.d12,
      required this.x,
      required this.d1X,
      required this.x2,
      required this.yes,
      required this.no});

  Probabilities.fromJson(Map<String, dynamic> json) {
    d1 = json['1'] ?? 0;
    d2 = json['2'] ?? 0;
    d12 = json['12'] ?? 0;
    x = json['X'] ?? 0;
    d1X = json['1X'] ?? 0;
    x2 = json['X2'] ?? 0;
    yes = json['yes'] ?? 0;
    no = json['no'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.d1;
    data['2'] = this.d2;
    data['12'] = this.d12;
    data['X'] = this.x;
    data['1X'] = this.d1X;
    data['X2'] = this.x2;
    data['yes'] = this.yes;
    data['no'] = this.no;
    return data;
  }
}