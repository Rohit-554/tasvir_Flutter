import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasvir/colors/AppColors.dart';
import 'package:tasvir/data/remote/ApiService.dart';
import 'package:tasvir/models/remote/CuratedImages.dart';
import 'package:tasvir/models/remote/videos/Video.dart';
import 'package:tasvir/models/remote/videos/Videos.dart';
import 'package:tasvir/widgets/DownloadingDialog.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 1;
  bool isDownloading = false;
  late VideoPlayerController _controller;
  final List<Future<void>> _initializeVideoPlayerFuture = [];
  final List<VideoPlayerController> _videoControllers = [];
  final List<bool> _isVideoPlaying = [];
  final List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            // Set the splash color to transparent
            highlightColor:
                Colors.transparent, // Set the highlight color to transparent
          ),
          child: Scaffold(
            appBar: appBar(),
            body: TabBarView(
              children: <Widget>[
                getPhotos(),
                getVideos(),
              ],
            ),
          ),
        ));
  }

  Column getPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(),
        Expanded(
          child: FutureBuilder<CuratedImages>(
              future: ApiService().getImages(currentPage),
              builder: (context, snapshot) {
                print('entermessage');
                if (!snapshot.hasData) {
                  print("empty");
                  return const Center(child: CircularProgressIndicator());
                } else {
                  print("not empty");
                  log('snapshotData ${snapshot.data}');
                  return displayImages(snapshot);
                }
              }),
        )
      ],
    );
  }

  Column getVideos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(),
        Expanded(
          child: FutureBuilder<Videos>(
              future: ApiService().getVideos(currentPage),
              builder: (context, snapshot) {
                print('entermessage');
                if (!snapshot.hasData) {
                  print("empty");
                  return const Center(child: CircularProgressIndicator());
                } else {
                  print("not empty");
                  log('snapshotData ${snapshot.data?.videos}');
                  return displayVideos(snapshot);
                }
              }),
        )
      ],
    );
  }

  ListView displayVideos(AsyncSnapshot<Videos> snapshot) {
    if (_videoControllers.isEmpty) {

      //reset the controllers

      for (int i = 0; i < snapshot.data!.videos.length; i++) {
        var videoUrl = snapshot.data!.videos[i].videoFiles[0].link;
        _videoControllers.add(VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
        ));
        _initializeVideoPlayerFuture.add(_videoControllers[i].initialize());
        _isVideoPlaying.add(false);
        // _videoControllers[i].setLooping(true);
      }
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data?.totalResults,
      itemBuilder: (BuildContext context, int index) {
        if(snapshot.data?.videos[index].height==1080 || snapshot.data?.videos[index].width==1920){
          //create a new list
          _videos.add(snapshot.data!.videos[index]);
          // _videoControllers[index].addListener(() {
          //   if (_videoControllers[index].value.position >= _videoControllers[index].value.duration) {
          //     setState(() {
          //       _videoControllers[index].seekTo(Duration.zero); // Seek back to the beginning
          //       _isVideoPlaying[index] = false; // Pause the video
          //     });
          //   }
          // });

          log("length of video list"+_videos.length.toString());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      // Replace this with the icon you want to use for the profile
                      size: 24,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      snapshot.data!.videos[index].user.name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // The preview image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        snapshot.data!.videos[index].image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 240, // Set the height of the preview image here
                      ),
                    ),
                    // The video player
                    AnimatedOpacity(
                      opacity: _isVideoPlaying[index] ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture[index],
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: 16 / 9, // Set a fixed aspect ratio (16:9 is common for videos)
                                child: VideoPlayer(_videoControllers[index]),
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                    // Play button
                    Positioned.fill(
                      child: Center(
                        child: IconButton(
                          icon: _isVideoPlaying[index]
                              ? const SizedBox.shrink()
                              : const Icon(Icons.play_arrow, color: Colors.white, size: 48),
                          onPressed: () {
                            setState(() {
                              if (_videoControllers[index].value.isPlaying) {
                                _videoControllers[index].pause();
                              } else {
                                _videoControllers[index].play();
                              }
                              _isVideoPlaying[index] = !_isVideoPlaying[index];
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        else{
          return Container();
        }
      },
    );
    //   SizedBox(
    //   child: ListView.builder(
    //     scrollDirection: Axis.vertical,
    //     itemCount: snapshot.data?.totalResults,
    //     itemBuilder: (BuildContext context, int index) {
    //       return SizedBox(
    //         height: 600,
    //         child: Column(
    //           children: [
    //             Container(
    //               height: 40,
    //               width: double.infinity,
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 // Vertically center the icon and text
    //                 children: [
    //                   const Icon(
    //                     Icons.account_circle,
    //                     // Replace this with the icon you want to use for the profile
    //                     size: 24,
    //                     color: Colors.black,
    //                   ),
    //                   const SizedBox(width: 8),
    //                   // Add some spacing between the icon and the text
    //                   Text(
    //                     snapshot.data!.videos[index].user.name,
    //                     textAlign: TextAlign.start,
    //                     style: GoogleFonts.poppins(
    //                       fontSize: 16,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Card(
    //               elevation: 4,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: Stack(
    //                 children: [
    //                   ClipRRect(
    //                     borderRadius: BorderRadius.circular(10),
    //                     child:FutureBuilder(
    //                       future: _initializeVideoPlayerFuture[index],
    //                       builder: (context, snapshot) {
    //
    //                         if (snapshot.connectionState == ConnectionState.done) {
    //                           // If the VideoPlayerController has finished initialization, use
    //                           // the data it provides to limit the aspect ratio of the video.
    //                           return AspectRatio(
    //                             aspectRatio: _videoControllers[index].value.aspectRatio,
    //                             // Use the VideoPlayer widget to display the video.
    //                             child: VideoPlayer(_videoControllers[index]),
    //                           );
    //                         } else {
    //                           // If the VideoPlayerController is still initializing, show a
    //                           // loading spinner.
    //                           return const Center(child: CircularProgressIndicator());
    //                         }
    //                       },
    //                     )
    //                   ),
    //                   Positioned(
    //                       bottom: 8,
    //                       left: 8,
    //                       child:Container(
    //                         decoration: BoxDecoration(
    //                           color: Colors.black.withOpacity(0.5),
    //                           borderRadius: BorderRadius.circular(10),
    //                         ),
    //                         child:
    //                         IconButton(
    //                           icon: _isVideoPlaying[index]
    //                               ? const Icon(Icons.pause, color: Colors.white, size: 24)
    //                               : const Icon(Icons.play_arrow, color: Colors.white, size: 24),
    //                           onPressed: () {
    //                             setState(() {
    //                               if (_videoControllers[index].value.isPlaying) {
    //                                 _videoControllers[index].pause();
    //                               } else {
    //                                 _videoControllers[index].play();
    //                               }
    //                               _isVideoPlaying[index] = !_isVideoPlaying[index];
    //                             });
    //                           },
    //                         ),
    //                       )
    //                   ),
    //
    //                   //download section
    //                   Positioned(
    //                       bottom: 8,
    //                       right: 8,
    //                       child: Container(
    //                         decoration: BoxDecoration(
    //                           color: Colors.black.withOpacity(0.5),
    //                           borderRadius: BorderRadius.circular(10),
    //                         ),
    //                         child: IconButton(
    //                           icon: isDownloading
    //                               ? const Icon(
    //                                   Icons.download,
    //                                   color: Colors.white,
    //                                   size: 24,
    //                                 )
    //                               : const Icon(
    //                                   Icons.downloading,
    //                                   color: Colors.white,
    //                                   size: 24,
    //                                 ),
    //                           onPressed: () {
    //                             isDownloading = true;
    //                             Icons.downloading;
    //                             String url = snapshot
    //                                 .data!.videos[index].videoFiles[0].link;
    //                             String fileName =
    //                                 snapshot.data!.videos[index].user.name;
    //                             showDialog(
    //                                 context: context,
    //                                 builder: (context) =>
    //                                     DownloadingDialog(url, fileName));
    //                           },
    //                         ),
    //                       ))
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  SizedBox displayImages(AsyncSnapshot<CuratedImages> snapshot) {
    return SizedBox(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data?.totalResults,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 600,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Vertically center the icon and text
                    children: [
                      const Icon(
                        Icons.account_circle,
                        // Replace this with the icon you want to use for the profile
                        size: 24,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      // Add some spacing between the icon and the text
                      Text(
                        snapshot.data!.photos[index].photographer,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          snapshot.data!.photos[index].src.large2X,
                          height: 540,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Icon(
                                snapshot.data!.photos[index].liked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: snapshot.data!.photos[index].liked
                                    ? Colors.red
                                    : Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  // Toggle the 'liked' state of the photo
                                  snapshot.data!.photos[index].liked =
                                      !snapshot.data!.photos[index].liked;
                                });
                              },
                            ),
                          )),

                      //download section
                      Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: isDownloading
                                  ? const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : const Icon(
                                      Icons.downloading,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                              onPressed: () {
                                isDownloading = true;
                                Icons.downloading;
                                String url =
                                    snapshot.data!.photos[index].src.original;
                                String fileName =
                                    snapshot.data!.photos[index].id.toString();
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        DownloadingDialog(url, fileName));
                              },
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void loadNextPage() {
    setState(() {
      currentPage++; // Increment the page number.
    });
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.5,
      shadowColor: Theme.of(context).shadowColor,
      title: Text('Tasvir'),
      backgroundColor: appBarColor,
      scrolledUnderElevation: 0.0,
      bottom: TabBar(
          indicatorColor: Colors.red,
          indicator: const BoxDecoration(
            border: Border(bottom: BorderSide(color: themeColor, width: 2.0)),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.black,
          labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.rubik().fontFamily),
          tabs: const <Widget>[
            Tab(
              text: 'Photos',
            ),
            Tab(
              text: 'Videos',
            ),
          ]),
    );
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
