class Movie {
  Movie({
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });  

  final bool? adult;
  final String? backdropPath;
  final int? id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final num? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final num? voteAverage;
  final num? voteCount;

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult : json['adult'],
      backdropPath : json['backdrop_path'],
      id : json['id'],
      originalLanguage : json['original_language'],
      originalTitle : json['original_title'],
      overview : json['overview'],
      popularity : json['popularity'],
      posterPath : json['poster_path'] == null ? null :"https://image.tmdb.org/t/p/w500${json['poster_path']}",
      releaseDate : json['release_date'],
      title : json['title'],
      video : json['video'],
      voteAverage : json['vote_average'],
      voteCount : json['vote_count'],
    );
  }
}

class MovieDetail {
  const MovieDetail({
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.releaseDate,
    required this.status,
    required this.posterPath,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  final int? id;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final String? status;
  final String? title;
  final bool? video;
  final num? voteAverage;
  final num? voteCount;
  
  factory MovieDetail.fromJson(Map<String, dynamic> json) => MovieDetail(
    id : json['id'],
    originalTitle : json['original_title'],
    overview : json['overview'],
    releaseDate : json['release_date'],
    status : json['status'],
    title : json['title'],
    posterPath : json['poster_path'],
    video : json['video'],
    voteAverage : json['vote_average'],
    voteCount : json['vote_count'],
  );
  
  Map<String,dynamic> toJson() => {
    "id" : id, 
    "original_title" : originalTitle, 
    "overview" : overview, 
    "release_date" : releaseDate, 
    "status" : status, 
    "title" : title, 
    "poster_path" : posterPath,
    "video" : video, 
    "vote_average" : voteAverage, 
    "vote_count" : voteCount, 
  };

  @override
  String toString() {
    return """
      id : $id
      originalTitle : $originalTitle
      overview : $overview
      releaseDate : $releaseDate
      status : $status
      title : $title
      posterPath : $posterPath
      video : $video
      voteAverage : $voteAverage
      voteCount : $voteCount
    """;
  }
}