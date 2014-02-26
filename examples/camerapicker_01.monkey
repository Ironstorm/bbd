#Rem
	Title:        CameraPicker example 1 - Open camera and load it in monkey
	Description:  Open camera and load it into monkey. 
	
	Author:       Dominik Kollon
	Contact:      d.kollon@blackbird-design.de
	
	Repository:   https://github.com/Ironstorm/bbd
	
	License:      MIT
#End

Import bbd.camerapicker
Import mojo

Function Main()
	New MyApp
End

Class MyApp Extends App Implements IOnCameraPickComplete
	
	Field camerapicker:CameraPicker
	Field myimage:Image
	
	Method OnCreate()
		camerapicker = New CameraPicker
		camerapicker.SetScaleType(2)															' Scale the image to fit in width and height
		camerapicker.SetImageSize(DeviceWidth(), DeviceHeight())								' Scale image to the devices resolution
		SetUpdateRate(60)
	End
	
	Method OnUpdate()
		UpdateAsyncEvents
		
		If TouchDown() Then
			If camerapicker.HasCamera() Then camerapicker.OpenCameraPickerAsync("test", Self)	' Check if device has camera, if so open the camera
		EndIf
	End
	
	Method OnRender()
		
	End
	
	Method OnCameraPickComplete:Void(result:String)
		If result <> "" Then
			myimage = LoadImage(result)
		EndIf
	End
	
End