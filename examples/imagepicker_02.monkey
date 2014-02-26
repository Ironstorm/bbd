#Rem
	Title:        ImagePicker example 2 - Load picked image asynchronous
	Description:  Pick an image of the gallery and load it into monkey asynchronous.
	
	Author:       Dominik Kollon
	Contact:      d.kollon@blackbird-design.de
	
	Repository:   https://github.com/Ironstorm/bbd
	
	License:      MIT
#End

Import bbd.imagepicker
Import mojo

Function Main()
	New MyApp
End

Class MyApp Extends App Implements IOnImagePickComplete, IOnLoadImageComplete
	Field imagepicker:ImagePicker
	Field myimage:Image
	Field imagename:String = "test"
	
	Method OnCreate()
		imagepicker = New ImagePicker
		imagepicker.SetImageSize(DeviceWidth(), DeviceHeight()) 				' The returned image will be scaled to the device-resolution
		imagepicker.SetScaleType(2) 											' Scale image to fit in width and height
		SetUpdateRate(60)
	End
	
	Method OnUpdate()
		UpdateAsyncEvents
		
		If TouchHit() Then imagepicker.OpenImagePickerAsync(imagename, Self)	' Opens the gallery - result will be saved in monkey://external/test.jpg
	End
	
	Method OnRender()
		Cls()
		
		If myimage <> Null Then
			DrawImage(myimage, 0, 0)
		EndIf
		
		DrawText("Tap on the screen to open ImagePicker", 10, 10)
	End
	
	Method OnImagePickComplete:Void(result:String)
		If result.Contains(imagename)
			LoadImageAsync(result, 1, Image.DefaultFlags, Self)					' Loads the image asynchronous
		EndIf
	End
	
	Method OnLoadImageComplete:Void( image:Image,path:String,source:IAsyncEventSource )
		If path.Contains(imagename) Then
			myimage = image
		EndIf
	End
	
End