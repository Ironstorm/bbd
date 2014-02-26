
import android.database.Cursor;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;

class BBImagePicker extends ActivityDelegate {
	Activity _activity;
	boolean _running;
	int _result=-1;
	String imagePath;
	int _reqCode;
	int scaleType;
    int height = 128;
	int width = 128;
	String path = "";
	String imagename;
	Bitmap scaledbitmap = null;
	File file;
	
	class ImagePickerThread extends Thread{
		
		ImagePickerThread(){
			_running=true;	
		}
		
		public void run(){
			//Intent i = new Intent(Intent.ACTION_PICK);
			Intent i = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
			//Intent i = new Intent("android.media.action.IMAGE_CAPTURE");
			i.setType("image/*");
            _activity.startActivityForResult(i, _reqCode);
		}
	}
	
	@Override	
	public void onActivityResult( int requestCode,int resultCode,Intent data ){
		super.onActivityResult(requestCode, resultCode, data);
		
		if( requestCode!=_reqCode ) return;
		
		if (resultCode == _activity.RESULT_OK && null != data) {
            Uri imageUri = data.getData();
            Bitmap bitmap = null;
			try {
            	bitmap = MediaStore.Images.Media.getBitmap(_activity.getContentResolver(), imageUri);
            } catch (FileNotFoundException e) {
            	// TODO Auto-generated catch block
            	e.printStackTrace();
           	} catch (IOException e) {
            	// TODO Auto-generated catch block
                e.printStackTrace();
           	}
			
			int scaledWidth = width;
			int scaledHeight = height;
			
			switch(scaleType){ 
        		case 1:
					scaledWidth = width;
					scaledHeight = height;
					break;
				case 2:
					scaledWidth = width;
					scaledHeight = (int)(bitmap.getHeight() / ((float)bitmap.getWidth() / scaledWidth));
					
					if(scaledHeight > height) {
						scaledHeight = height;
						scaledWidth = (int)(bitmap.getWidth() / ((float)bitmap.getHeight() / scaledHeight));
					}
					break;
				case 3:
					scaledWidth = width;
					scaledHeight = (int)(bitmap.getHeight() / ((float)bitmap.getWidth() / scaledWidth));
					break;
				case 4:
					scaledHeight = height;
					scaledWidth = (int)(bitmap.getWidth() / ((float)bitmap.getHeight() / scaledHeight));
					break;
				case 5:
					if(bitmap.getWidth() > bitmap.getHeight()) {
						scaledWidth = width;
						scaledHeight = (int)(bitmap.getHeight() / ((float)bitmap.getWidth() / scaledWidth));
						break;
					} else {
						scaledHeight = height;
						scaledWidth = (int)(bitmap.getWidth() / ((float)bitmap.getHeight() / scaledHeight));
						break;
					}
				case 6:
					if(bitmap.getWidth() < bitmap.getHeight()) {
						scaledWidth = width;
						scaledHeight = (int)(bitmap.getHeight() / ((float)bitmap.getWidth() / scaledWidth));
						break;
					} else {
						scaledHeight = height;
						scaledWidth = (int)(bitmap.getWidth() / ((float)bitmap.getHeight() / scaledHeight));
						break;
					}
			}
			
			File f=Environment.getExternalStorageDirectory();
			if( f!=null ) {
				path = f+"/" + imagename + ".jpg";
			}
			file = new File( path );
			
			try {
                if(file.exists() == false) {
                    file.getParentFile().mkdirs();
                    file.createNewFile();
                }

            } catch (IOException e) {
                android.util.Log.e("Monkey", "Could not create file.", e);
            }
			
			try {
         		FileOutputStream out = new FileOutputStream(file);
				android.util.Log.i("[Monkey]", "ScaleType: " + scaleType);
				if(scaleType == 0) {
					bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
					android.util.Log.i("[Monkey]", "Save original Bitmap.");
				} else {
					Bitmap scaledbitmap = Bitmap.createScaledBitmap(bitmap, scaledWidth, scaledHeight, true);
					scaledbitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
					android.util.Log.i("[Monkey]", "Save scaled Bitmap.");
	            }
				
			} catch (IOException e) {
                android.util.Log.e("[Monkey]", "Could not save scaled image.", e);
            }
        }
		if (resultCode == _activity.RESULT_CANCELED) {
			imagePath = "";
		}
		_running=false;
	}
	
	public BBImagePicker(){

		_activity=BBAndroidGame.AndroidGame().GetActivity();
		
	}
	
	public void OpenImagePickerAsync( String _imagename ){
		
		ImagePickerThread thread=new ImagePickerThread();
		
		_result=0;
		imagename=_imagename;
		_running=true;

		thread.start();
		
		BBAndroidGame.AndroidGame().AddActivityDelegate( this );
		
		_reqCode=BBAndroidGame.AndroidGame().AllocateActivityResultRequestCode();
	}
	
	public boolean IsRunning(){

		return _running;
	}
	
	public String GetResult(){

		return "monkey://external/" + imagename + ".jpg";
	
	}
	
	public void setImageSize(int _width, int _height){
		width = _width;
		height = _height;
	}
	
	public void setScaleType(int _type){
		scaleType = _type;
	}
		
}