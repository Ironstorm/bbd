#Rem
	Title:        ImagePicker
	Description:  A class to pick an image from the devices gallery
	
	Author:       Dominik Kollon
	Contact:      d.kollon@blackbird-design.de
	
	Repository:   https://github.com/Ironstorm/bbd
	
	License:      MIT
#End

Import brl.asyncevent

#If TARGET="android"
Import "native/imagepicker.android.java"
#Else
#Error "ImagePicker not implemented for your target"
#Endif

#Rem
header:The class [b]ImagePicker[/b] provides the necessary methods to load an image from the devices image gallery. 
#End

Extern Private

Class BBImagePicker
Private
	Method OpenImagePickerAsync:Void(_imgpath:String)
	Method IsRunning:Bool()
	Method GetResult:String()
	Method setImageSize:Void(_width:Int, _height:Int)
	Method setScaleType:Void(_type:Int)
End

Public

#Rem
summary:The interface which will be called when the user choose an image or pressed the back button.
#End
Interface IOnImagePickComplete
#Rem
summary:OnImagePickComplete will be called when the user choose an image or pressed the back button.
Returns an empty string if the user pressed the back button, else the path to the taken picture in monkey style (i.e. monkey://external/image.jpg).
#End
	Method OnImagePickComplete:Void(result:String)
End

'***************************************
#Rem
summary:The class ImagePicker provide the necassary methods to load an image from the devices image gallery.
#End
Class ImagePicker Implements IAsyncEventSource
	Field imageWidth:Int = 128
	Field imageHeight:Int = 128
	Field scaleType:Int = 0 ' 0 = no scale | 1 = scale width and height | 2 = fit image in width and height | 3 = height relative to width | 4 = width relative to height | 5 = long side | 6 = short side
	
	Method New()
		_picker = New BBImagePicker
	End
	
'#DOCON#
#Rem
summary:Opens the image gallery
Opens the image gallery. The result will be catch in "OnImagePickComplete". 
#End	
	Method OpenImagePickerAsync:Void(imageName:String, onComplete:IOnImagePickComplete)
		If _state = 2 Then
			Print "ImagePicker already open!"
			Return
		EndIf

		_onOpen=onComplete
		_state=2
		
		AddAsyncEventSource Self

		_picker.OpenImagePickerAsync(imageName)
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

	
	Private
	
	Field _state:Int
	Field _picker:BBImagePicker
	
	Field _onOpen:IOnImagePickComplete
	
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
			_onOpen=Null
			onOpen.OnImagePickComplete(result)
			
		Default
		
			Error "INTERNAL ERROR"
			
		End
		
	End
'#DOCON#	
End


#Rem
footer:[quote]Copyright (c) 2013-2014 Dominik Kollon[/quote]
#End