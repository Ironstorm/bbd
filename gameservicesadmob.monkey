#Rem
	Title:        GameServicesAdmob
	Description:  Integrates Admob from Play Game Services to MonkeyX.
				  Based on brl.admob.
	
	Author:       Dominik Kollon
	Contact:      d.kollon@blackbird-design.de
	
	Repository:   https://github.com/Ironstorm/bbd
	
	License:      MIT
#End

#If TARGET<>"android"
#Error "The GameServiceAdmob module is only available on the android target"
#End

#If TARGET="android"

#LIBS+="${CD}/native/src/google-play-services.jar"
Import "native/gameservicesadmob.android.java"

#ANDROID_MANIFEST_APPLICATION+="<activity android:name=~qcom.google.android.gms.ads.AdActivity~q android:configChanges=~qkeyboard|keyboardHidden|orientation|screenLayout|uiMode|screenSize|smallestScreenSize~q />"

#End

Extern

Class Admob Extends Null = "BBGameServiceAdmob"

	Function GetAdmob:Admob()
	
	Method ShowAdView:Void( style:Int,layout:Int )
	
	Method HideAdView:Void()
	
	Method AdViewWidth:Int()
	
	Method AdViewHeight:Int()
	
End
