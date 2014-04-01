#Rem
	Title:        GameServices
	Description:  Integrates Play Game Services to MonkeyX
	
	Author:       Dominik Kollon
	Contact:      d.kollon@blackbird-design.de
	
	Repository:   https://github.com/Ironstorm/bbd
	
	License:      MIT
#End

#If TARGET="android"
	Import "native/src/com/google/example/games/basegameutils/GameHelper.java"
	Import "native/src/com/google/example/games/basegameutils/GameHelperUtils.java"
	Import "native/gameservices.android.java"
	#LIBS+="${CD}/native/src/google-play-services.jar"
	
	#ANDROID_MANIFEST_MAIN+="<uses-permission android:name=~qcom.google.android.providers.gsf.permission.READ_GSERVICES~q/>"
	
	#ANDROID_MANIFEST_APPLICATION+="<meta-data android:name=~qcom.google.android.gms.appstate.APP_ID~q android:value=~q@string/app_id~q />"
	#ANDROID_MANIFEST_APPLICATION+="<meta-data android:name=~qcom.google.android.gms.games.APP_ID~q android:value=~q@string/app_id~q />"
	#ANDROID_MANIFEST_APPLICATION+="<meta-data android:name=~qcom.google.android.gms.version~q android:value=~q@integer/google_play_services_version~q />"
	#ANDROID_MANIFEST_APPLICATION+="<meta-data android:name=~qcom.google.android.maps.v2.API_KEY~q android:value=~qAIzaSyBMLX87Ygin7lfZUSIUfHnckVnWe1cyKNI~q/>"
#Else
	#Error "Google Play Game Services currently only available for android"
#Endif

Extern

Class GameService Extends Null="BBGameService"
	Method submitHighscore:Void(id:String, points:Int)
	Method beginUserSignIn:Void()
	Method isLoggedIn:Bool()
	Method signOut:Void()
	Method setMaxUserSignIns:Void(count:Int)
	Method showLeaderBoard:Void(id:String)
	Method unlockAchievement:Void(id:String)
	Method revealAchievement:Void(id:String)
	Method incrementAchievement:Void(id:String, steps:Int)
	Method showAchievements:Void()
End