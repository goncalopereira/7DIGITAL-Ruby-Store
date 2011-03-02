
$(document).ready(function(){

	var playItem = 0;

	var myPlayList = [
		{name:"Tempered Song",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-01-Tempered-song.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-01-Tempered-song.ogg"},
		{name:"Hidden",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-02-Hidden.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-02-Hidden.ogg"},
		{name:"Lentement",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-03-Lentement.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-03-Lentement.ogg"},
		{name:"Lismore",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-04-Lismore.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-04-Lismore.ogg"},
		{name:"The Separation",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-05-The-separation.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-05-The-separation.ogg"},
		{name:"Beside Me",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-06-Beside-me.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-06-Beside-me.ogg"},
		{name:"Bubble",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-07-Bubble.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-07-Bubble.ogg"},
		{name:"Stirring of a Fool",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-08-Stirring-of-a-fool.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-08-Stirring-of-a-fool.ogg"},
		{name:"Partir",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-09-Partir.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-09-Partir.ogg"},
		{name:"Thin Ice",mp3:"http://www.miaowmusic.com/audio/mp3/Miaow-10-Thin-ice.mp3",ogg:"http://www.miaowmusic.com/audio/ogg/Miaow-10-Thin-ice.ogg"}
	];

	// Local copy of jQuery selectors, for performance.
	var jpPlayTime = $("#jplayer_play_time");
	var jpTotalTime = $("#jplayer_total_time");

	$("#jquery_jplayer").jPlayer({
		ready: function() {
			displayPlayList();
			playListInit(true); // Parameter is a boolean for autoplay.
		},
		oggSupport: true
	})
	.jPlayer("onProgressChange", function(loadPercent, playedPercentRelative, playedPercentAbsolute, playedTime, totalTime) {
		jpPlayTime.text($.jPlayer.convertTime(playedTime));
		jpTotalTime.text($.jPlayer.convertTime(totalTime));
	})
	.jPlayer("onSoundComplete", function() {
		playListNext();
	});

	$("#jplayer_previous").click( function() {
		playListPrev();
		$(this).blur();
		return false;
	});

	$("#jplayer_next").click( function() {
		playListNext();
		$(this).blur();
		return false;
	});

	function displayPlayList() {
		$("#jplayer_playlist ul").empty();
		for (i=0; i < myPlayList.length; i++) {
			var listItem = (i == myPlayList.length-1) ? "<li class='jplayer_playlist_item_last'>" : "<li>";
			listItem += "<a href='#' id='jplayer_playlist_item_"+i+"' tabindex='1'>"+ myPlayList[i].name +"</a></li>";
			$("#jplayer_playlist ul").append(listItem);
			$("#jplayer_playlist_item_"+i).data( "index", i ).click( function() {
				var index = $(this).data("index");
				if (playItem != index) {
					playListChange( index );
				} else {
					$("#jquery_jplayer").jPlayer("play");
				}
				$(this).blur();
				return false;
			});
		}
	}

	function playListInit(autoplay) {
		if(autoplay) {
			playListChange( playItem );
		} else {
			playListConfig( playItem );
		}
	}

	function playListConfig( index ) {
		$("#jplayer_playlist_item_"+playItem).removeClass("jplayer_playlist_current").parent().removeClass("jplayer_playlist_current");
		$("#jplayer_playlist_item_"+index).addClass("jplayer_playlist_current").parent().addClass("jplayer_playlist_current");
		playItem = index;
		$("#jquery_jplayer").jPlayer("setFile", myPlayList[playItem].mp3, myPlayList[playItem].ogg);
	}

	function playListChange( index ) {
		playListConfig( index );
		$("#jquery_jplayer").jPlayer("play");
	}

	function playListNext() {
		var index = (playItem+1 < myPlayList.length) ? playItem+1 : 0;
		playListChange( index );
	}

	function playListPrev() {
		var index = (playItem-1 >= 0) ? playItem-1 : myPlayList.length-1;
		playListChange( index );
	}
});
