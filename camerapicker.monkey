#Rem
	Title:        CameraPicker
	Description:  A class to pick an image from the devices camera
	
	Author:       Dominik Kollon
	Contact:      d.kollon@blackbird-design.de
	
	Repository:   http://code.google.com/p/fantomengine/
	
	License:      MIT
#End

Import brl.asyncevent

#If TARGET="android"
Import "native/camerapicker.android.java"
#ANDROID_MANIFEST_MAIN+="<uses-permission android:name=~qandroid.permission.CAMERA~q />"
#Else
#Error "CameraPicker not implemented for your target"
#Endif

#Rem
header:The class [b]CameraPicker[/b] provides the necessary methods to capture an image from the devices camera. 
#End

Extern Private

Class BBCameraPicker
Private
	Method OpenCameraPickerAsync:Void(_imgpath:String)
	Method setImageSize:Void(_width:Int, _height:Int)
	Method setScaleType:Void(_type:Int)
	Method setDeleteLastPhoto:Void(_bool:Bool)
	Method IsRunning:Bool()
	Method GetResult:String()
	Method HasCamera:Bool()
End

Public

#Rem
summary:The interface which will be called when the camera returns a result.
#End
Interface IOnCameraPickComplete
#Rem
summary:OnCameraPickComplete will be called when the user takes a picture or pressed the back button
Returns an empty string if the user pressed the back button, else the path to the taken picture in monkey style (i.e. monkey://external/image.jpg).
#End
	Method OnCameraPickComplete:Void(result:String)
End

'***************************************
#Rem
summary:The class CameraPicker provide the necassary methods to capture an image from the devices camera. Such as image capture, scale, gallery delete and more.
#End
Class CameraPicker Implements IAsyncEventSource
'#DOCOFF#
	Field imageWidth:Int = 128
	Field imageHeight:Int = 128
	Field scaleType:Int = 0 ' 0 = no scale | 1 = scale width and height | 2 = fit image in width and height | 3 = height relative to width | 4 = width relative to height | 5 = long side | 6 = short side
	Field deleteLastPhoto:Bool = False
	
	Method New()
		_picker = New BBCameraPicker
	End
	
'#DOCON#
#Rem
summary:Starts the camera
Starts the camera. The result will be catch in "OnCameraPickComplete". 
#End	
	Method OpenCameraPickerAsync:Void(imageName:String, onComplete:IOnCameraPickComplete)
		If _state = 2 Then
			Print "CameraPicker already open!"
			Return
		EndIf
		
		_onOpen=onComplete
		_state=2
		
		AddAsyncEventSource Self

		_picker.OpenCameraPickerAsync(imageName)
	End
	
	'-----------------------------------------------------------------------------
#Rem
summary:Set the size of the scaled image.
If you set the scale mode higher than 0 (no scale), you have to set the resolution of the scaled image.
This overload of "SetImageSize()" is commonly used in combination with scale mode 1 or 2. 
#End	
	Method SetImageSize:Void(_width:Int, _height:Int)
		imageWidth = _width
		imageHeight = _height
		_picker.setImageSize(imageWidth, imageHeight)
	End

	'-----------------------------------------------------------------------------
#Rem
summary:Set the size of the scaled image.
If you set the scale mode higher than 0 (no scale), you have to set the resolution of the scaled image.
This overload of "SetImageSize()" is commonly used in combination with any scale mode higher than 2. 
#End	
	Method SetImageSize:Void(_size:Int)
		imageWidth = _size
		imageHeight = _size
		_picker.setImageSize(imageWidth, imageHeight)
	End
	
	'-----------------------------------------------------------------------------
#Rem
summary:Define how the captured image will be scaled.
Instead of using the full resolution of a camera it would be better to scale the captured image. Monkey cant handle such big images.
CameraPicker supports many different scale modes. 
[b]Scale modes[/b]

Those ScaleModes are supported:
[list][*]0 = No scale (caution! Image could be to big to handle by monkey!)
[*]1 = Scale by width and height set with SetImageSize()
[*]2 = Scale the image to fit in width and height
[*]3 = Scale height relative to width
[*]4 = Scale width relative to height
[*]5 = Scale long side
[*]6 = Scale small side[/list]
#End
	Method SetScaleType:Void(type:Int)
		If scaleType < 0 or scaleType > 5 Then Error("ScaleType " + type + " isn't supported!")
		scaleType = type
		_picker.setScaleType(scaleType)
	End

	'-----------------------------------------------------------------------------
#Rem
summary:Define if the gallery image should be deleted.
When the user takes a picture with the camera, android stores a duplicate image in the users gallery. While CameraPicker stores the image in the external app folder.
If you dont want to display a duplicate image in the users gallery, set this to true. CameraPicker will delete it after saved it to the external app folder.
#End	
	Method DeleteGalleryImage:Void(_bool:Bool = False)
		deleteLastPhoto = _bool
		_picker.setDeleteLastPhoto(deleteLastPhoto)
	End
	
	'-----------------------------------------------------------------------------
#Rem
summary:Returns true if the device has a camera
#End	
	Method HasCamera:Bool()
		Return _picker.HasCamera()
	End
'#DOCOFF#	
	Private
	
	Field _state:Int
	Field _picker:BBCameraPicker
	
	Field _onOpen:IOnCameraPickComplete
	
	Method UpdateAsyncEvents:Void()
		If _picker.IsRunning() Return
		
		RemoveAsyncEventSource Self
		
		Local result:= _picker.GetResult()
		
		Select _state
		Case 2
			
			If result = 0
				_state=1
			Else
				_state=-1
			End
			
			Local onOpen:=_onOpen
			_onOpen = Null
			onOpen.OnCameraPickComplete(result)
			
		Default
		
			Error "INTERNAL ERROR"
			
		End
		
	End
'#DOCON#	
End


#Rem
footer:[quote]Copyright (c) 2013-2014 Dominik Kollon[/quote]
#End
