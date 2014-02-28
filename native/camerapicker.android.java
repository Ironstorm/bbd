
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.content.pm.PackageManager;

class BBCameraPicker extends ActivityDelegate {
	Activity _activity;
	boolean _running;
	boolean deleteLastPhoto = false;
	int _result=-1;
	int _reqCode;
    int height = 128;
	int width = 128;
	int scaleType = 0;
	String imagename;
	String path = "";
	Bitmap scaledphoto = null;
	File file;
	
	class CameraPickerThread extends Thread{
		
		CameraPickerThread(){
			_running=true;	
		}
		
		public void run(){
			Intent i = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
			
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
			
			Uri imageFileUri = Uri.fromFile(file);
			i.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, imageFileUri);
			
			android.util.Log.i("[Monkey]", "Start camera.");
            _activity.startActivityForResult(i, _reqCode);
		}
	}
	
	@Override	
	public void onActivityResult( int requestCode,int resultCode,Intent data ){
		super.onActivityResult(requestCode, resultCode, data);
		if( requestCode!=_reqCode ) return;
		
		if (resultCode == _activity.RESULT_OK && scaleType != 0) {
            
			Bitmap photo = BitmapFactory.decodeFile(path);
			
			int scaledWidth = width;
			int scaledHeight = height;
			
			switch(scaleType){ 
        		case 1:
					scaledWidth = width;
					scaledHeight = height;
					break;
				case 2:
					scaledWidth = width;
					scaledHeight = (int)(photo.getHeight() / ((float)photo.getWidth() / scaledWidth));
					
					if(scaledHeight > height) {
						scaledHeight = height;
						scaledWidth = (int)(photo.getWidth() / ((float)photo.getHeight() / scaledHeight));
					}
					break;
				case 3:
					scaledWidth = width;
					scaledHeight = (int)(photo.getHeight() / ((float)photo.getWidth() / scaledWidth));
					break;
				case 4:
					scaledHeight = height;
					scaledWidth = (int)(photo.getWidth() / ((float)photo.getHeight() / scaledHeight));
					break;
				case 5:
					if(photo.getWidth() > photo.getHeight()) {
						scaledWidth = width;
						scaledHeight = (int)(photo.getHeight() / ((float)photo.getWidth() / scaledWidth));
						break;
					} else {
						scaledHeight = height;
						scaledWidth = (int)(photo.getWidth() / ((float)photo.getHeight() / scaledHeight));
						break;
					}
				case 6:
					if(photo.getWidth() < photo.getHeight()) {
						scaledWidth = width;
						scaledHeight = (int)(photo.getHeight() / ((float)photo.getWidth() / scaledWidth));
						break;
					} else {
						scaledHeight = height;
						scaledWidth = (int)(photo.getWidth() / ((float)photo.getHeight() / scaledHeight));
						break;
					}
			}
			
			try {
         		FileOutputStream out = new FileOutputStream(file);
				
				scaledphoto = Bitmap.createScaledBitmap(photo, scaledWidth, scaledHeight, true);
				scaledphoto.compress(Bitmap.CompressFormat.JPEG, 90, out);
				
				if(deleteLastPhoto == true) {
					removeImage(getLastImageId());
				}
				
			} catch (IOException e) {
                android.util.Log.e("[Monkey]", "Could not save scaled image.", e);
            }
			
        }
		_running=false;
	}
	
	public BBCameraPicker(){

		_activity=BBAndroidGame.AndroidGame().GetActivity();
		
	}
	
	public void OpenCameraPickerAsync( String _imagename){
		
		CameraPickerThread thread=new CameraPickerThread();
		
		_result=-1;
		imagename=_imagename;
		_running=true;

		thread.start();
		
		BBAndroidGame.AndroidGame().AddActivityDelegate( this );
		_reqCode=BBAndroidGame.AndroidGame().AllocateActivityResultRequestCode();
	}
	
	public void setImageSize(int _width, int _height){
		width = _width;
		height = _height;
	}
	
	public void setScaleType(int _type){
		scaleType = _type;
	}
	
	public void setDeleteLastPhoto(boolean _bool){
		deleteLastPhoto = _bool;
	}
	
	public boolean IsRunning(){

		return _running;
	}
	
	public String GetResult(){

		return "monkey://external/" + imagename + ".jpg";
	}
	
	public Boolean HasCamera(){
		PackageManager pm = _activity.getPackageManager();

		if (pm.hasSystemFeature(PackageManager.FEATURE_CAMERA) || pm.hasSystemFeature(PackageManager.FEATURE_CAMERA_FRONT)) {
			return true;
		}
		return false;
	}
	
	private int getLastImageId(){
    	final String[] imageColumns = { MediaStore.Images.Media._ID, MediaStore.Images.Media.DATA };
    	final String imageOrderBy = MediaStore.Images.Media._ID+" DESC";
    	Cursor imageCursor = _activity.managedQuery(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, imageColumns, null, null, imageOrderBy);
    	if(imageCursor.moveToFirst()){
        	int id = imageCursor.getInt(imageCursor.getColumnIndex(MediaStore.Images.Media._ID));
        	String fullPath = imageCursor.getString(imageCursor.getColumnIndex(MediaStore.Images.Media.DATA));
        	imageCursor.close();
        	return id;
    	}else{
        	return 0;
    	}
	}
	
	private void removeImage(int id) {
		ContentResolver lastimage = _activity.getContentResolver();
		lastimage.delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, MediaStore.Images.Media._ID + "=?", new String[]{ Long.toString(id) } );
	}
		
}