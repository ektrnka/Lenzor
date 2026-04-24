# Flutter Local Notifications - исправление "Missing type parameter"
# Gson требует сохранения generic-типов при R8/ProGuard

-keepattributes Signature
-keepattributes InnerClasses
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes Exceptions

# Gson - критично для сериализации запланированных уведомлений
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keep class com.google.gson.reflect.TypeToken { *; }

# Flutter Local Notifications - полная защита от обфускации
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keepclassmembers class com.dexterous.flutterlocalnotifications.** { *; }

# Модели с @SerializedName
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
