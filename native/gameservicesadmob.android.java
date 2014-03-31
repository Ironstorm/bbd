import com.google.android.gms.ads.*;

class BBGameServiceAdmob implements Runnable{

	static BBGameServiceAdmob _admob;
	
	int _adStyle;
	int _adLayout;
	boolean _adVisible;
	boolean _adValid = true;

	AdView _adView;
	
	static public BBGameServiceAdmob GetAdmob(){
		if( _admob == null ) {
			_admob = new BBGameServiceAdmob();
		}
		return _admob;
	}
	
	public void ShowAdView( int style,int layout ){
		_adStyle = style;
		_adLayout = layout;
		_adVisible = true;
		
		if( _adValid ){
			_adValid = false;
			BBAndroidGame.AndroidGame().GetGameView().post( this );
		}
	}
	
	public void HideAdView(){
		_adVisible = false;
		
		if( _adValid ){
			_adValid = false;
			BBAndroidGame.AndroidGame().GetGameView().post( this );
		}
	}
	
	public int AdViewWidth(){
		if(_adView != null) {
			return _adView.getWidth();
		} else {
			return 0;
		}
	}
	
	public int AdViewHeight(){
		if(_adView != null) {
			return _adView.getHeight();
		} else {
			return 0;
		}
	}
	
	private static void AddTestDev( String test_dev, AdRequest.Builder req ){
		if( test_dev.length() == 0 ) return;
		if( test_dev.equals( "TEST_EMULATOR" ) ) {
			test_dev = AdRequest.DEVICE_ID_EMULATOR;
		}
		req.addTestDevice( test_dev );
	}
	
	public void run(){
	
		_adValid = true;
		
		Activity activity=BBAndroidGame.AndroidGame().GetActivity();
		
		RelativeLayout parent=(RelativeLayout)activity.findViewById( R.id.mainLayout );
		
		if( _adView != null ){
			parent.removeView( _adView );
			_adView.destroy();
			_adView = null;
		}
		
		if( !_adVisible ) return;
		
		AdSize sz=AdSize.BANNER;
		switch( _adStyle ){
		case 2:sz=AdSize.SMART_BANNER;break;
		case 3:sz=AdSize.SMART_BANNER;break;
		}
		
		_adView=new AdView( activity );
        _adView.setAdSize(sz);
        _adView.setAdUnitId(MonkeyConfig.ADMOB_PUBLISHER_ID);
		 		
		RelativeLayout.LayoutParams params=new RelativeLayout.LayoutParams( RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT );
		
		int rule1=RelativeLayout.CENTER_HORIZONTAL,rule2=RelativeLayout.CENTER_VERTICAL;
		
		switch( _adLayout ){
		case 1:rule1=RelativeLayout.ALIGN_PARENT_TOP;rule2=RelativeLayout.ALIGN_PARENT_LEFT;break;
		case 2:rule1=RelativeLayout.ALIGN_PARENT_TOP;rule2=RelativeLayout.CENTER_HORIZONTAL;break;
		case 3:rule1=RelativeLayout.ALIGN_PARENT_TOP;rule2=RelativeLayout.ALIGN_PARENT_RIGHT;break;
		case 4:rule1=RelativeLayout.ALIGN_PARENT_BOTTOM;rule2=RelativeLayout.ALIGN_PARENT_LEFT;break;
		case 5:rule1=RelativeLayout.ALIGN_PARENT_BOTTOM;rule2=RelativeLayout.CENTER_HORIZONTAL;break;
		case 6:rule1=RelativeLayout.ALIGN_PARENT_BOTTOM;rule2=RelativeLayout.ALIGN_PARENT_RIGHT;break;
		}
		
		params.addRule( rule1 );
		params.addRule( rule2 );
		
		parent.addView( _adView,params );

		AdRequest.Builder req=new AdRequest.Builder();
		
		AddTestDev( MonkeyConfig.ADMOB_ANDROID_TEST_DEVICE1,req );
		AddTestDev( MonkeyConfig.ADMOB_ANDROID_TEST_DEVICE2,req );
		AddTestDev( MonkeyConfig.ADMOB_ANDROID_TEST_DEVICE3,req );
		AddTestDev( MonkeyConfig.ADMOB_ANDROID_TEST_DEVICE4,req );
		
		_adView.loadAd( req.build() );
	}
}
