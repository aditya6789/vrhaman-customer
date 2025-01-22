-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.PaymentsClient
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.Wallet
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.WalletUtils
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
-keep class com.razorpay.** { *; }
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }

# Keep Google Play Services Auth classes
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-dontwarn com.google.android.gms.auth.api.credentials.**

# Keep annotations
-keepattributes *Annotation*

-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
