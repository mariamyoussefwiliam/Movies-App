import 'package:flutter/material.dart';
import 'package:movie_task/cubit/movie_cubit.dart';
import 'package:movie_task/model/movies.dart';
import 'package:movie_task/modules/details_screen.dart';

Widget emptyPage({@required context,@required String image,@required String text}) => Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 1.8,
          decoration: BoxDecoration(
           // border: Border.all(color: Colors.redAccent, width: 5),

            shape: BoxShape.circle,

            image: DecorationImage(
             fit: BoxFit.fill,
              image: AssetImage(image),
            ),
          ),
        ),
        SizedBox(height: 50,),

        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,

            color: Colors.white,
          ),
        ),

      ],
    ),
  ),
);

Widget loadingIndicator() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: CircularProgressIndicator(backgroundColor: Colors.red,)),
  );
}


Widget MovieItem(listMovies,size,movieType,context)  {

  List<MoviesResults>list= listMovies.take(6).toList();
  if(movieType=="popular"&&MoviesCubit.get(context).popular.isEmpty)
    {

      list.forEach((element)async{
          await MoviesCubit.get(context).insertDatabase(tableName: 'popular', adult: element.adult, backdropPath:element.backdropPath, id: element.id, originalLanguage: element.originalLanguage,  posterPath:element.posterPath, releaseDate: element.releaseDate, video: element.video, voteAverage: element.voteAverage.toString(), voteCount: element.voteCount);


        });


    }
  else if(movieType=="top"&&MoviesCubit.get(context).top.isEmpty)
  {

    list.forEach((element)async{
      await MoviesCubit.get(context).insertDatabase(tableName: 'top', adult: element.adult, backdropPath:element.backdropPath, id: element.id, originalLanguage: element.originalLanguage,  posterPath:element.posterPath, releaseDate: element.releaseDate, video: element.video, voteAverage: element.voteAverage.toString(), voteCount: element.voteCount);


    });


  }
  else if(movieType=="now"&&MoviesCubit.get(context).now.isEmpty)
  {

    list.forEach((element)async{
      await MoviesCubit.get(context).insertDatabase(tableName: 'now', adult: element.adult, backdropPath:element.backdropPath, id: element.id, originalLanguage: element.originalLanguage,  posterPath:element.posterPath, releaseDate: element.releaseDate,  video: element.video, voteAverage: element.voteAverage.toString(), voteCount: element.voteCount);


    });


  }
  return Padding(
    padding: const EdgeInsets.all(8.0),

    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
            children: [


              SizedBox(height: 10.0),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: ((size.width / 2) / (size
                          .height / 2.3))
                  ),
                  itemCount: listMovies.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Description(
                                  name: listMovies[index].title,
                                  bannerurl:
                                  'https://image.tmdb.org/t/p/w500' +
                                      listMovies[index].backdropPath,
                                  posterurl:
                                  'https://image.tmdb.org/t/p/w500' +
                                      listMovies[index].posterPath,
                                  description: listMovies[index].overview,
                                  vote: listMovies[index].voteAverage
                                      .toString(),
                                  launch_on: listMovies[index].releaseDate,
                                )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              // height: (size.height/2),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    20.0),
                              ),
                              child: (listMovies[index].posterPath == null) ?
                              Image.asset(
                                'images/default movie poster.jpg',
                                width: double.infinity,
                                height: (size.height / 3.2),
                                fit: BoxFit.fill,
                              )
                                  : Image.network(
                                'https://image.tmdb.org/t/p/w500${listMovies[index]
                                    .posterPath.toString()}'
                                , width: double.infinity,
                                height: (size.height / 3.2),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    listMovies[index].title.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            )

                          ],),
                      ),
                    );
                  }
              ),



            ]
        ),
      ),
    ),
  );
}




